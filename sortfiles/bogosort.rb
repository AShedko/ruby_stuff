def bogosort!(list)
  list.shuffle! until sorted?(list)
  list
end

def sorted?(list)
  list.each_cons(2).all?{|a,b| a <= b}
end
