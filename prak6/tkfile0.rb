require "./TkDraw"

size = ARGV.size > 0 ? ARGV.shift.to_i : 200
TkDraw.create(size, size, "Fractals") 

a, b = -1.0, 0.0
s = 3.0
p = size
t = Time.now
TkDraw.clean

for m in 1 .. p
  c1 = a - s/2 + m*s/p
  for n in 1 .. p
    c2 = b - s/2 + n*s/p
    c = Complex(c1, c2)
    z1 = Complex(0,0)
    r = 0
    i = 1
    while i < 20 && r < 4 
      i += 1
      z1 = z1*z1 + c
      z  = z1
      r = z.abs2
    end
    color = (3000*i%0xffffff).to_s(16) 
    TkDraw.point(m, n,"##{'0'*(6-color.size)}#{color}") 
  end
end
Tk.mainloop
