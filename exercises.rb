class Human  # Problem received from Raul Romero
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def show
    a = local_variables.select do |e|
      binding.local_variable_get(e).object_id == self.object_id
    end
    p a
  end

  def +(other)
    name + other.name
  end

  def equal?(other)
    self.class == other.class
  end
end

gilles = Human.new("gilles")
anna = Human.new("gilles")

anna.show

puts anna.equal?(gilles) #should output true #
puts anna + gilles # should output annagilles
