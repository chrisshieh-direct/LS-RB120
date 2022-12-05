arr = []

File.readlines('aocdata.txt').each do |line|
  temp = []
  temp << line[0]
  temp << line[2]
  arr << temp
end

score = 0

arr.each do |subarr|
  him = subarr[0]
  me = subarr[1]

  case him
  when 'A'
    case me
    when 'X' # lose scissors
      score += 3
    when 'Y' # draw rock
      score += 4
    when 'Z' # win paper
      score += 8
    end
  when 'B'
    case me
    when 'X' # lose rock
      score += 1
    when 'Y' # draw paper
      score += 5
    when 'Z' # win scissors
      score += 9
    end
  when 'C'
    case me
    when 'X' # lose paper
      score += 2
    when 'Y' # draw scissors
      score += 6
    when 'Z' # win rock
      score += 7
    end
  end
end

p score
