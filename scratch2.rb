class Activity
  HELLO_CONTENT = "hi this is from Activity"

  def bob
    self
  end

  def self.greeting
    p self
  end
end

class Sport < Activity
  HELLO_CONTENT = "hi this is a constant from the class Sport"

  attr_reader :name

  def Sport.name
    "My name is #{self}"
  end

  def hello
    puts HELLO_CONTENT
  end

  def play
    "#{bob.name} and #{bob.greeting}"
  end

  def greeting
    "#{bob.name} and #{bob.class.greeting}"
  end
end

class Basketball < Sport
  HELLO_CONTENT = "hi this is from Basketball"

  def initialize(name = nil)
    @name = name
  end

  def greeting
    "Hello"
  end
end

puts Sport.name
puts Basketball.name

bob = Basketball.new("Bob")

bob.hello

puts bob.greeting
