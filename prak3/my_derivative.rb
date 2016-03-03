def main
  print "t= ";
  t = gets.to_i
  polynomial,derivative, derivative1=0,0,0
  begin
    while true
      print "a-> "
      a = readline.to_i
      derivative1 = t * derivative1 + 2 * derivative
      derivative = t * derivative + polynomial
      polynomial = t * polynomial + a
      puts "P''(t) = #{derivative1}"
    end
    rescue EOFError
      puts "\n"
  end
end

main
