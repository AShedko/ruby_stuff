require 'csv'

def main
  # strs=File.open( 'file.csv', 'r' ).readlines
  # strs.shift
  # m=0
  # name=""
  # strs.each do |str|
  #   data = str.gsub!('"','').split(',')
  #   # puts "#{data[6].gsub!(/\n/,'')} => #{data[0].to_f/data[2].to_i}"
  #   x= data[0].to_f/data[2].to_i
  #   name,m = data[6],x if x > m
  # end
  # print name
  # CSV.foreach("file.csv") do |row|
  #   p row[6]+(row[1].to_f+row[0])/
  # end

end

main
