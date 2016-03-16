# p$<.map{:to_i}[1..-1].inject{|a,e|a=(abs(e)+e)/2}
s=0
gets.to_i.times{a=gets.to_i;s+=a if a>0}
p s
