# Z - is a polynoom value on the each step, d - is a value of polynoom derivative on the each step
# The coefficients are entered in the order of descending powers
z,d,t,a = 0,0,0,0
print "t -> "
t = gets.to_i
begin
  while true
    print "a -> "
    a = readline.to_i # To handle exception
    d*=t
    d+=z
    z*=t
    z+=a
    puts "P'(t) = #{d}"
  end
  rescue EOFError
    puts "\n"
end
