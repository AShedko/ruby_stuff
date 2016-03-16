n=gets.to_i
$<.read.reverse_each{|s|s.reverse.split.each{|o|puts (o+" ")*n}}
