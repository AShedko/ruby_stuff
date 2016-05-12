#!/usr/bin/env ruby
require_relative './polyedr'
require_relative '../common/tk_drawer'
TkDrawer.create
%w(ccc mytest mytest0 mytest1 cube box king).each do |name|
# %w(mytest mytest0 mytest1).each do |name|
  puts '============================================================='
  puts "Начало работы с полиэдром '#{name}'"
  start_time = Time.now
  p = Polyedr.new("../data/#{name}.geom")
  p.draw
  puts "Изображение полиэдра '#{name}' заняло #{Time.now - start_time} сек."
  print "Сумма периметров граней специального вида: #{p.sum}\n"
  print 'Hit "Return" to continue -> '
  gets
end
