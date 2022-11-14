# class Vehicle
#   attr_accessor :color, :current_speed, :engine_on, :name
#   attr_reader :year, :make, :units

#   @@units = 0

#   def initialize(year, color, make)
#     @@units += 1
#     @year = year
#     @color = color
#     @make = make
#     @current_speed = 0
#     @engine_on = false
#   end

#   def speed_up(increase)
#     @current_speed += increase
#   end

#   def brake(decrease)
#     @current_speed -= decrease
#   end

#   def shut_off(bool)
#     @current_speed = 0
#     @engine_on = false
#   end

#   def to_s
#     puts "The year is #{year} and the color is #{color}."
#   end

#   def spray_paint(str)
#     @color = str
#   end

#   def self.gas(x, y)
#     puts "#{y / x} miles per gallon of gas"
#   end

#   def self.howmany
#     puts "#{@@units} okay"
#   end

#   def age
#     "Your #{self.make} is #{years_old} years old."
#   end

#   private

#   def years_old
#     Time.now.year - year
#   end
# end

# module Cargo
#   def LIIIIIFFFFFFT
#     puts "The cargo door is open."
#   end
# end

# class MyCar < Vehicle
#   NUMBER_OF_DOORS = 4
# end

# class MyTruck < Vehicle
#   include Cargo
#   NUMBER_OF_DOORS = 2
# end

# buick = MyCar.new(1973, "Black", "Skyhawk")
# buick2 = MyCar.new(1973, "Black", "Skyhawk")
# buick3 = MyCar.new(1973, "Black", "Skyhawk")
# buick4 = MyCar.new(1973, "Black", "Skyhawk")

# buick.spray_paint("REDDDD")

# buick.to_s


# buick.name

# MyCar.howmany

# hoss = MyTruck.new(1953,"Red", "F-150")

# hoss.LIIIIIFFFFFFT

# puts MyTruck.ancestors
# puts Vehicle.ancestors

# puts "#{MyTruck::NUMBER_OF_DOORS}"

# puts hoss.age


# class Student
#   attr_writer :grade
#   attr_accessor :name

#   def initialize(name, grade)
#     @name = name
#     @grade = grade
#   end

#   def better_grade_than?(student)
#     self.grade > student.grade
#   end

#   protected

#   def grade
#     @grade
#   end

# end

# joe = Student.new("Joe",100)

# bob = Student.new("Bob",80)

# puts "Well done!" if joe.better_grade_than?(bob)

class MeMyselfAndI
  self

  def self.me
    p self.object_id
  end

  def myself
    p self.object_id
  end
end

p MeMyselfAndI.object_id

i = MeMyselfAndI.new

i.myself
