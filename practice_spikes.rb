module Runner
  def run; end
end

class Referee
  include Runner
  attr_reader :color

  def initialize
    @color = 'black'
  end

  def whistle; end
end

class Player
  include Runner
  attr_reader :color

  def initialize
    @color = 'blue'
  end

  def shoot; end
end

class Attacker < Player
end

class Midfielder < Player
  def pass; end
end

class Defender < Player
  def block; end
end

class Goalkeeper < Player
  def initialize
    @color = 'white with blue stripes'
  end
end

ref = Referee.new
puts ref.color

goal = Goalkeeper.new
puts goal.color

mid = Midfielder.new
puts mid.color
p mid.methods

puts Defender.ancestors
