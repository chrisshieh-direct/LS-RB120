stacks = { 1 => ['F', 'C', 'J', 'P', 'H', 'T', 'W'],
           2 => ['G','R','V','F','Z','J','B','H'],
           3 => ['H','P','T','R'],
           4 => ['Z','S','N','P','H','T'],
           5 => ['N','V','F','Z','H','J','C','D'],
           6 => ['P','M','G','F','W','D','Z'],
           7 => ['M','V','Z','W','S','J','D','P'],
           8 => ['N','D','S'],
           9 => ['D','Z','S','F','M'] }

instructions = []

File.readlines('aocdata.txt').each do |line|
   instructions << line.scan(/\d+/)
end

diagram = File.new('aocdata.txt').read

levels = diagram.split("\n").map do |level|
  sub_level = []
  index = 1
  counter = 4
  while index < level.length do
    sub_level << level[index]
    index += counter
  end
  sub_level
end

levels = levels[0..-2]

p levels

instructions.each do |subarr|
  quantity = subarr[0]
  source_stack = subarr[1]
  target_stack = subarr[2]

  # PART ONE
  quantity.times do
    stacks[target_stack] << stacks[source_stack].pop
  end

  # PART TWO
  buffer = []

  quantity.times do
    buffer << stacks[source_stack].pop
  end

  quantity.times do
    stacks[target_stack] << buffer.pop
  end
end
