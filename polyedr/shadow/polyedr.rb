require_relative '../common/polyedr'

# Одномерный отрезок
class Segment
  # начало и конец отрезка (числа)
  attr_reader :beg, :fin
  def initialize(b, f)
    @beg, @fin = b, f
  end
  # отрезок вырожден?
  def degenerate?
    @beg >= @fin
  end
  # пересечение с отрезком
  def intersect!(other)
    @beg = other.beg if other.beg > @beg
    @fin = other.fin if other.fin < @fin
    self
  end
  # разность отрезков
  def subtraction(other)
    [Segment.new(@beg, @fin < other.beg ? @fin : other.beg),
     Segment.new(@beg > other.fin ? @beg : other.fin, @fin)]
  end
end

# Ребро полиэдра
class Edge
  # Начало и конец стандартного одномерного отрезка
  SBEG = 0.0; SFIN = 1.0
  # начало и конец ребра (точки в R3), список "просветов"
  attr_reader :beg, :fin, :gaps
  def initialize(b, f)
    @beg, @fin, @gaps = b, f, [Segment.new(SBEG, SFIN)]
  end
  # учёт тени от одной грани
  def shadow(facet)
    return if facet.vertical?
    # нахождение одномерной тени на ребре
    shade = Segment.new(SBEG, SFIN)
    facet.vertexes.zip(facet.v_normals) do |arr|
     shade.intersect!(intersect_edge_with_normal(arr[0], arr[1]))
      return if shade.degenerate?
    end
    shade.intersect!(intersect_edge_with_normal(facet.vertexes[0], facet.h_normal))
    return if shade.degenerate?
    # преобразование списка "просветов", если тень невырождена
    @gaps = @gaps.map do |s|
      s.subtraction(shade)
    end.flatten.delete_if(&:degenerate?)
  end
  # преобразование одномерных координат в трёхмерные
  def r3(t)
    @beg*(SFIN-t) + @fin*t
  end

  def compl_visible?
    return false if @gaps.empty?
    @gaps[0].beg==0&&@gaps[0].fin==1
  end

  def invisible?
    @gaps.empty?
  end
  def eql?(other)
    @beg==other.beg&&@fin==other.fin
  end

  def to_s
    "(#{[beg.x,beg.y]};#{[fin.x,fin.y]})"
  end

  private
  # пересечение ребра с полупространством, задаваемым точкой (a)
  # на плоскости и вектором внешней нормали (n) к ней
  def intersect_edge_with_normal(a, n)
    f0, f1 = n.dot(@beg - a), n.dot(@fin - a)
    return Segment.new(SFIN, SBEG) if f0 >= 0.0 and f1 >= 0.0
    return Segment.new(SBEG, SFIN) if f0 < 0.0 and f1 < 0.0
    x = - f0 / (f1 - f0)
    f0 < 0.0 ? Segment.new(SBEG, x) : Segment.new(x, SFIN)
  end
end

# Грань полиэдра
class Facet
  attr_accessor :edges
  # "вертикальна" ли грань?
  def vertical?
    h_normal.dot(Polyedr::V) == 0.0
  end
  # нормаль к "горизонтальному" полупространству
  def h_normal
    n = (@vertexes[1]-@vertexes[0]).cross(@vertexes[2]-@vertexes[0])
    n.dot(Polyedr::V) < 0.0 ? n*(-1.0) : n
  end
  # нормали к "вертикальным" полупространствам, причём k-я из них
  # является нормалью к гране, которая содержит ребро, соединяющее
  # вершины с индексами k-1 и k
  def v_normals
    (0...@vertexes.size).map do |k|
      n = (@vertexes[k] - @vertexes[k-1]).cross(Polyedr::V)
      n.dot(@vertexes[k-1] - center) < 0.0 ? n*(-1.0) : n
    end
  end

  # Принаадлежит ли ребро грани
  def fac_edge?(e)
    @vertexes.include?(e.beg)&&@vertexes.include?(e.fin)
  end

  # Периметр грани
  def perimeter
    @edges.inject(0){|s,edge|s+=edge.beg.dist_pr(edge.fin)}
  end

  # Грань частично видимая
  def part_vis?
    return false if !@edges
    pr1,pr2 = true, true
    trtab = @edges.map{|edge| [edge.compl_visible?,edge.invisible?]}
    trtab.each{|x|pr1&&=x[0];pr2&&=x[1]}
    !(pr1||pr2)
  end

  # центр грани вне единичного квадрата
  def outside_sqr?(alpha,beta,gamma,c)
    cent = center
    cent = cent.rz(-gamma).ry(-beta).rz(-alpha)*(1/c)
    (cent.x>0.5||cent.x<-0.5)&&(cent.y>0.5||cent.y<-0.5)
  end

  # центр грани
  def center
    @vertexes.inject(R3.new(0.0,0.0,0.0)){|s,v| s+v}*(1.0/@vertexes.size)
  end
end

# Полиэдр
class Polyedr
  attr_reader :sum
  # вектор проектирования
  V = R3.new(0.0,0.0,1.0)

  # Убираем дубликаты рёбер
  def edges_uniq
    edges = {}
    @edges.each do |e|
      if edges[[e.beg, e.fin]].nil? && edges[[e.fin, e.beg]].nil?
        edges[[e.beg, e.fin]] = e
      end
    end
    @edges = edges.values
  end

  def draw
    TkDrawer.clean
    edges_uniq
    edges.each do |e|
      facets.each{|f| e.shadow(f)}
      e.gaps.each{|s| TkDrawer.draw_line(e.r3(s.beg), e.r3(s.fin))}
    end
    facets.each{|f| edges.each{|e| f.edges<<e if f.fac_edge?(e)}}
    @sum = facets.inject(0) do |s,f|
      if f.part_vis? && f.outside_sqr?(@alpha,@beta,@gamma,@c)
        TkDrawer.draw_point(f.center)
        sleep(0.1)
        s += f.perimeter
      else
        s
      end
    end
    @sum /= @c
  end
end
