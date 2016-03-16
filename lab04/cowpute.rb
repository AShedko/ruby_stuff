def div(a,b)
  b/b.abs * (a.to_f/b.abs).floor
end

def mod(a,b)
  a - b.abs*(a.to_f/b.abs).floor
end

s=""
n=gets.to_i
loop do
  break if n==0
  p "#{n}  #{div(n,-2)}  #{mod(n,-2)}"
  s+=mod(n,-2).to_s
  n=div(n,-2)
end
p s.reverse
