class Neet
  def initialize
    @values = []
  end

  def add_value(int)
      @values << int
  end

  def remove_value(int)
    @values.delete_at(@values.index(int) || @values.length)
  end

  def get_random
    @values.sample
  end

  def values
    @values
  end

end

bob = Neet.new

bob.add_value(67)
p bob.values
bob.add_value(67)
p bob.values
bob.add_value(3)
bob.add_value(4)
bob.add_value(4)
p bob.values
bob.add_value(67)
p bob.values

puts bob
puts bob.get_random
puts bob.values

puts bob.remove_value(4)
p bob.values
