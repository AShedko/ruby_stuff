require_relative "./r2point"
require_relative "./deq"
require 'set'

# Абстрактная фигура
class Figure
  def perimeter; 0.0 end
  def area;      0.0 end
  def angles;      0 end
  def distance;  0.0 end
  @@angles=0
  @@rect=0
end

# "Hульугольник"
class Void < Figure
  def initialize(x0=nil,y0=nil,x1=nil,y1=nil)
    if $0["run"] == "run"|| x0 != nil
      if x0==nil
        puts "Введите координаты прямоугольника ах ау bx by через пробел\n"
        x0,y0,x1,y1 = gets.split.map(&:to_f)
      end
      @@rect = [R2Point.new(x0,y0),R2Point.new(x1,y1)]
    end
  end

  def add(p)
    Point.new(p)
  end
end

# "Одноугольник"
class Point < Figure
  def initialize(p)
    @p = p
  end
  def add(q)
    @p == q ? self : Segment.new(@p, q)
  end
  def distance
    @p.distance_rect(@p,@@rect[0],@@rect[1])
  end
end

# "Двуугольник"
class Segment < Figure
  def initialize(p, q)
    @p, @q = p, q
  end
  def perimeter
    2.0 * @p.dist(@q)
  end
  def angles
    2
  end
  def distance
    @p.distance_rect(@q,@@rect[0],@@rect[1])
  end
  def add(r)
    if R2Point.triangle?(@p, @q, r)
      return Polygon.new(@p, @q, r)
    end
    return Segment.new(@p, r) if @q.inside?(@p, r)
    return Segment.new(r, @q) if @p.inside?(r, @q)
    self
  end
end

# Многоугольник
class Polygon < Figure
  attr_reader :points, :perimeter, :area

  def initialize(a, b, c)
    @points = Deq.new
    @points.push_first(b)
    if b.light?(a,c)
      @points.push_first(a)
      @points.push_last(c)
    else
      @points.push_last(a)
      @points.push_first(c)
    end
    # Считаем углы
    @@angles = Set.new
    @@angles.add(a) if a.ac_angle?(b, c)
    @@angles.add(c) if c.ac_angle?(b, a)
    @@angles.add(b) if b.ac_angle?(c, a)
    # считаем расстояние
    if @@rect != 0
      @@center = (@@rect[0] + @@rect[1])*(0.5)
      if !@@center.in_triangle?(a,b,c)
        @@distance = [a.distance_rect(b,@@rect[0],@@rect[1]),
                    b.distance_rect(c,@@rect[0],@@rect[1]),
                    c.distance_rect(a,@@rect[0],@@rect[1])
                    ].min
      else
        @@distance = 0
      end
    end
    @perimeter = a.dist(b) + b.dist(c) + c.dist(a)
    @area      = R2Point.area(a, b, c).abs

    def angles
      @@angles.size
    end

    def distance
      @@distance
    end
  end

  # добавление новой точки
  def add(t)

    # поиск освещённого ребра
    @points.size.times do
      break if t.light?(@points.last, @points.first)
      @points.push_last(@points.pop_first)
    end

    # хотя бы одно освещённое ребро есть
    if t.light?(@points.last, @points.first)

      # учёт удаления ребра, соединяющего конец и начало дека
      @perimeter -= @points.first.dist(@points.last)
      @area      += R2Point.area(t, @points.last, @points.first).abs

      # удаление освещённых рёбер из начала дека
      p = @points.pop_first
      while t.light?(p, @points.first)
        @perimeter -= p.dist(@points.first)
        @area      += R2Point.area(t, p, @points.first).abs
        @@angles.delete(p)
        p = @points.pop_first
      end
      @points.push_first(p)

      # удаление освещённых рёбер из конца дека
      p = @points.pop_last
      while t.light?(@points.last, p)
        @perimeter -= p.dist(@points.last)
        @area      += R2Point.area(t, p, @points.last).abs
        @@angles.delete(p)
        p = @points.pop_last
      end
      @points.push_last(p)

      # добавление двух новых рёбер
      @perimeter += t.dist(@points.first) + t.dist(@points.last)
      a=@points.pop_last
      b=@points.pop_first
      if @@rect != 0
        if @@distance != 0
          if @@center.light?(a,t)||@@center.light?(t,b)||@@center.light?(b,a)
            @@distance = [@@distance,t.distance_rect(a,@@rect[0],@@rect[1]),
                          t.distance_rect(b,@@rect[0],@@rect[1])].min
          else
            @@distance = 0
          end
        end
      end
      # Учёт добавляемых углов
      @@angles.add(t) if t.ac_angle?(a, b)
      if @points.size == 0
        a.ac_angle?(b, t) ? @@angles.add(a) : @@angles.delete(a)
        b.ac_angle?(t, a) ? @@angles.add(b) : @@angles.delete(b)
      else
        a.ac_angle?(t, @points.last) ? @@angles.add(a) : @@angles.delete(a)
        b.ac_angle?(t, @points.first) ? @@angles.add(b) : @@angles.delete(b)
      end
      @points.push_last(a)
      @points.push_first(b)
      @points.push_first(t)
    end

    self
  end
end
