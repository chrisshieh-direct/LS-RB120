arr = []

File.readlines('aocdata.txt').each do |line|
  arr << line.to_i
end

current = 0
fourth = 0

medalwinners = [0, 0, 0]

arr.each do |cal|
  if cal == 0
    fourth = current
    current = 0
    next
  end

  if fourth > medalwinners[0]
    medalwinners.shift
    medalwinners << fourth
    medalwinners.sort!
    fourth = 0
  end

  current = current + cal
end

p medalwinners.reduce(:+)
