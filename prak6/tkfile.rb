require "./TkDraw"
def x(x)
  20*x + 40
end

def y(y)
  -20*y + 560
end

class R2Point
  attr_reader :x, :y

  # конструктор
  def initialize(x=0, y=0)
    @x, @y = x.to_f, y.to_f
  end

  def to_s
    "(#{@x},#{@y})"
  end

end

class Segment
  attr_reader :ptop,:pbottom

  def initialize(p1,p2)
    if p1.class==p2.class && p1.class=="R2Point"
    @ptop,@pbottom = p1,p2.sort
  end

end

TkDraw.create(600, 600, "Watefalls")
TkDraw.clean

x1, x2 = -2, 28
xe1, xe2 = x(x1), x(x2)

y1, y2 = 0, 0
ye1, ye2 = y(y1), y(y2)

x3, x4, y3, y4 = 0, 0, -2, 28
xe3, xe4, ye3, ye4 = x(x3), x(x4),  y(y3), y(y4)

TkDraw.line(xe1, ye1, xe2, ye2, "grey")
TkDraw.line(xe3, ye3, xe4, ye4, "grey")

gets.to_i.times{
  x1,y1,x2,y2 = gets.split.map{|x| x.to_i}
  xe3, xe4, ye3, ye4 = x(x1), x(x2),  y(y1), y(y2)
  TkDraw.line(xe3, ye3, xe4, ye4, "green")
}
gets.to_i.times{
  x1,y1 = gets.split.map{|x| x.to_i}
  x1,y1 = x(x1),y(y1)
  TkDraw.oval(x1-5,y1-5,x1+5,y1+5)
}

Tk.mainloop
