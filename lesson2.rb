class Box
  attr_accessor :name, :clay, :year

  def initialize
    @name = "boo"
    @clay = "yes"
    @color = "black"
  end
end

red = Box.new

p red.name, red.clay, red.year

if red.year == nil
  red.year = 1973
  puts "We added it"
end

p red.name, red.clay, red.year
