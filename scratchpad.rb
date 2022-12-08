module Flyable
  def fly
    "I can fly!"
  end
end

module Sociable
  def social
    "I am a social creature."
  end
end

module Predatory
  def hunt(prey)
    "I hunt #{prey}."
  end
end

class Animal
  @@total_animals_created = 0

  def initialize
    @weight = assign_weight
    @body_temperature = 'warm-blooded'
    @@total_animals_created += 1
    @animal_id = @@total_animals_created
  end

  def to_s
    <<~HEREDOC
    ========================
    species: #{self.class}
    animal id: #{animal_id}
    weight: #{weight}
    diet: #{diet}
    body temp: #{body_temperature}
    ========================
    HEREDOC
  end

  private

  attr_reader :animal_id, :weight, :diet, :body_temperature

  def assign_weight
    case self
    when Zebra
      upper = 990
      lower = 770
    when Tiger
      upper = 680
      lower = 200
    when Koala
      upper = 30
      lower = 10
    when Hawk
      upper = 15
      lower = 12
    when Parrot
      upper = 3
      lower = 1
    end
    calc_weight(upper, lower)
  end

  def calc_weight(upper, lower)
    rand(lower..upper)
  end
end

class Zebra < Animal
  include Sociable

  def initialize
    super
    @diet = 'vegetation'
  end
end

class Hawk < Animal
  include Flyable
  include Predatory

  def initialize
    super
    @diet = 'meat'
  end
end

class Tiger < Animal
  include Predatory

  def initialize
    super
    @diet = 'meat'
  end
end

class Koala < Animal
  def initialize
    super
    @diet = 'vegetation'
  end
end

class Parrot < Animal
  include Flyable
  include Sociable

  def initialize
    super
    @diet = 'vegetation'
  end
end

zeb = Zebra.new
hok = Hawk.new
tig = Tiger.new
koa = Koala.new
par = Parrot.new

puts zeb
puts hok
puts tig
puts koa
puts par

p par.fly
p zeb.social
p tig.hunt('smurfs')
