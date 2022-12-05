# arr = ["vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg",
#        "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn", "ttgJtRGJQctTZtZT", "CrZsJsPPZsGzwwsLwLmpwMDw"]
arr = []
File.readlines('aocdata.txt').each do |line|
   arr << line
end

counter = 0
secondarr = []

until counter >= arr.length
  temp = arr[counter, 3]
  common = temp[0].chars & temp[1].chars & temp[2].chars
  secondarr << common.first
  counter += 3
end

secondarr.map! do |e|
  if e.downcase == e
    e.ord - 96
  else
    e.ord - 38
  end
end

p secondarr.reduce(:+)
