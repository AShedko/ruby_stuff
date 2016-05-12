#!/usr/bin/env ruby
require_relative './polyedr'
require_relative '../common/tk_drawer'
TkDrawer.create
# %w(ccc mytest cube box king cow).each do |name|
%w(mytest mytest0).each do |name|
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
