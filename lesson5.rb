class Computer
end

class Human
end

bob = Human.new

bob_class = bob.class

if bob_class == Human
  puts "He's human"
end
