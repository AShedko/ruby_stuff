require "./TkDraw"
def x_scr(x)
  20*x + 40
end

def y_scr(y)
  -20*y + 560
end

class R2Point
  attr_reader :x, :y

  # конструктор
  def initialize(x, y)
    @x, @y = x, y
  end

  def intersect?(line)
    ((self.x<line.top.x)&&(self.x>line.bottom.x))||((self.x<line.bottom.x)&&(self.x>line.top.x))
  end

  def intersect(line)
    (self.x-line.top.x)*(line.bottom.y-line.top.y)/(line.bottom.x-line.top.x)+line.top.y
  end

  def draw(colour)
    TkDraw.oval(x_scr(@x)-1, y_scr(@y)+1, x_scr(@x)+1, y_scr(@y)-1,colour,5)
  end

end

class Segment

  attr_reader :top, :bottom

  def initialize(p1, p2)
    if p1.y > p2.y
      @top, @bottom = p1, p2
    else
      @top, @bottom = p2, p1
    end
  end

  def draw(colour)
    TkDraw.line(x_scr(@top.x), y_scr(@top.y), x_scr(@bottom.x), y_scr(@bottom.y), colour)
  end

  def in_strip(point)
    (point.x < @top.x && point.x > @bottom.x) || (point.x > @top.x && point.x < @bottom.x)
  end

  def dist(point)
    (@top.x-@bottom.x)*point.x+(@top.y-@bottom.y)*point.y+@bottom*(@top.x-@bottom.x)-(@top.y-@bottom.y)
  end

end

TkDraw.create(600, 600, "Watefalls")
TkDraw.clean

x1, x2 = -2, 28
xe1, xe2 =x_scr(x1),x_scr(x2)

y1, y2 = 0, 0
ye1, ye2 =y_scr(y1),y_scr(y2)

x3, x4, y3, y4 = 0, 0, -2, 28
xe3, xe4, ye3, ye4 =x_scr(x3),x_scr(x4), y_scr(y3),y_scr(y4)

TkDraw.line(xe1, ye1, xe2, ye2, "grey")
TkDraw.line(xe3, ye3, xe4, ye4, "grey")

n=gets.to_i
segments=[Segment.new(R2Point.new(xe1, ye1),R2Point.new(xe2, ye2))]
n.times{
  pnts=gets.split.map(&:to_f)
  line=Segment.new(R2Point.new(pnts[0], pnts[1]), R2Point.new(pnts[2], pnts[3]))
  segments<<line
  line.draw("green")
}

points=[]
n=gets.to_i
n.times{
  pnts=gets.split.map(&:to_f)
  point=R2Point.new(pnts[0], pnts[1])
  points<<point
  point.draw("blue")
}

print "uwk"

points.each{|point|
  while pnt.y>0
    psegs = segments.select{|s| s.in_strip(point)}
    psegs.sort!{|s1,s2|
      point.intersect(seg2)<=>point.intersect(seg1)
    }
    pnt=R2Point.new(point.x,point.intersect(psegs[0]))
    Segment.new(point,pnt).draw('blue')
    Segment.new(pnt,psegs[0].bottom).draw('blue')
    pnt=psegs[0].bottom
    print "uwk"
  end
}

Tk.mainloop
