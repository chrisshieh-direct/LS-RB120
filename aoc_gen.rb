arr = []

File.readlines('aocdata.txt').each do |line|
  arr << line.chomp.split('x')
end

arr.each do |subarr|
  subarr.map! { |x| x.to_i }
end

length_ribbon = arr.map do |subarr|
  subarr.sort!
  subarr[0] + subarr[0] + subarr[1] + subarr[1]
end.reduce(:+)

length_bow = arr.map do |subarr|
  subarr.sort!
  subarr[0] * subarr[1] * subarr[2]
end.reduce(:+)

p length_bow + length_ribbon
