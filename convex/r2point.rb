# Точка (Point) на плоскости (R2)
class R2Point
  attr_reader :x, :y

  # конструктор
  def initialize(x = input("x"), y = input("y"))
    @x, @y = x, y
  end

  def distance_rect(endp,a,b)
 # Алгоритм описан на странице 333 журнала
 # Advances in Spatial and Temporal Databases:
 # 9th International Symposium, SSTD 2005, Angra Dos Reis
 # Brazil, August 22-24, 2005, Proceedings
    a,b = R2Point.new([a.x,b.x].min,[a.y,b.y].min),R2Point.new([a.x,b.x].max,[a.y,b.y].max)
    rect = [a,R2Point.new(a.x,b.y),b,R2Point.new(b.x,a.y)]
    return self.pdist(a,b,rect) if endp == self
    return 0 if self.intersect_rect(endp,a,b)
    # Вычисление положения конца отрезка
    t1=self.x<=>(a.x+b.x)/2
    t2=self.y<=>(a.y+b.y)/2
    p1 = D[[(t1+t1.abs)/2, (t2+t2.abs)/2]]
    u1=endp.x<=>(a.x+b.x)/2
    u2=endp.y<=>(a.y+b.y)/2
    p2 = D[[(u1+u1.abs)/2, (u2+u2.abs)/2]]
    # Соотношение между концами отрезка
    case (p1 - p2)%4
      #  Концы отрезка в одной четверти
    when 0
      return [self.dist_segm(rect[(p1-1)%4],rect[p1]),
              endp.dist_segm(rect[(p1-1)%4],rect[p1]),
              self.dist_segm(rect[(p1+1)%4],rect[p1]),
              endp.dist_segm(rect[(p1+1)%4],rect[p1]),
              rect[p1].dist_segm(self,endp)].min
    when 1, 3 #Концы отрезка в соседних четвертях
      return [self.dist(rect[p1]),endp.dist(rect[p2]),
              rect[p1].dist_segm(self,endp),
              rect[p2].dist_segm(self,endp),
              endp.dist_segm(rect[p1],rect[p2])
            ].min
    # Концы отрезка в противоположных четвертях
    when 2
      return [rect[p1-1].dist_segm(self, endp),
              rect[p2-1].dist_segm(self, endp)
            ].min
    end
  end

  def pdist(a,b,rect)
    t1=@x<=>(a.x+b.x)/2
    t2=@y<=>(a.y+b.y)/2
    p1 = D[[(t1+t1.abs)/2, (t2+t2.abs)/2]]
    return 0 if self.inside?(a,b)
    [self.dist_segm(rect[(p1-1)%4],rect[p1]),
    self.dist_segm(rect[(p1+1)%4],rect[p1]),
    self.dist(rect[p1])].min
  end

  def intersect_rect(endp,a,b)
    # Liang, Y.D., and Barsky, B., "A New Concept and Method for Line Clipping",
    # ACM Transactions on Graphics, 3(1):1-22, January 1984.
    l,r = endp,self
    # p l,r
    dx, dy = r.x - l.x, r.y - l.y
    q = [l.x-a.x,b.x-l.x,l.y-a.y,b.y-l.y]
    p = [-dx,dx,-dy,dy]
    d1,d2=[],[]
    (0..3).each {|i|
      if p[i]==0
        return false if q[i]<0
      else
        p[i]<0 ? d1<<q[i]/p[i] : d2<<q[i]/p[i]
      end
    }
    !((d1<<0).max>(d2<<1).min)
  end

  # площадь треугольника (метод класса)
  def R2Point.area(a, b, c)
    0.5*((a.x-c.x)*(b.y-c.y)-(a.y-c.y)*(b.x-c.x))
  end

  #Угол в данной точке острый?
  def ac_angle?(a,b)
    #(0--1] -acute, [-1--0] -obtuse or straight
    a = (a.x-@x)*(b.x-@x)+(a.y-@y)*(b.y-@y) <=> 0
    (a+a.abs)/2==1
  end

  # лежат ли точки на одной прямой? (метод класса)
  def R2Point.triangle?(a, b, c)
    area(a, b, c) != 0.0
  end

  # расстояние до другой точки
  def dist(other)
    Math.sqrt((other.x-@x)**2 + (other.y-@y)**2)
  end

  def in_triangle?(p1,p2,p3)
    d=((p2.y-p3.y)*(p1.x-p3.x)+(p3.x-p2.x)*(p1.y-p3.y))
    lambd1 = ((p2.y-p3.y)*(@x-p3.x)+(p3.x-p2.x)*(@y-p3.y))/d
    lambd2 = ((p3.y-p1.y)*(@x-p3.x)+(p1.x-p3.x)*(@y-p3.y))/d
    lambd3 = 1 - lambd1 - lambd2
    eps = (10**-15).to_f
    lambd1>eps&&lambd2>eps&&lambd3>eps
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def dist_segm(a,b)
    l = a.dist(b)
    return self.dist(a) if l==0
    t = [0, [1, (self+(a*(-1))).dot(b+(a*(-1)))/(l*l)].min].max
    proj = a + (b + (a * (-1))) * t
    # p proj
    self.dist(proj)
  end

  def dot(other)
    @x*other.x+@y*other.y
  end

  def + (other)
    R2Point.new(@x + other.x, @y + other.y)
  end

  def * (scalar)
    R2Point.new(@x * scalar, @y * scalar)
  end

  # лежит ли точка внутри "стандартного" прямоугольника?
  def inside?(a, b)
    ((a.x <= @x and @x <= b.x) or
     (a.x >= @x and @x >= b.x)) and
      ((a.y <= @y and @y <= b.y) or
       (a.y >= @y and @y >= b.y))
  end

  # освещено ли из данной точки ребро (a,b)?
  def light?(a, b)
    s = R2Point.area(a, b, self)

    s < 0.0 or (s == 0.0 and !inside?(a, b))
  end

  # совпадает ли точка с другой?
  def == (other)
    @x == other.x and @y == other.y
  end

  private
  D = {[0,0] => 0, # таблица перевода ближайшей
       [1,0] => 3, # к концу отрезка вершины прямоугольника
       [0,1] => 1,
       [1,1] => 2
  }

  def input(prompt)
    print "#{prompt} -> "
    readline.to_f
  end
end


def between?(x,a,b)
  x<b&&x>a||x<a&&x>b
end
