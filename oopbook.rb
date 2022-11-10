class MyCar
  attr_accessor :color
  attr_reader :year, :model

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
  end

  def speed_up
    current_speed += 10
  end

  def brake
    current_speed = 0
  end

  def shut_off
  end

  def info
    puts "This is a #{color} #{year} #{model}. Noice."
  end

  def spray_paint(new_color)
    self.color = new_color
  end
end

buick = MyCar.new(2022, "Black", "Skylark")

buick.info

buick.spray_paint("Turqoise")

buick.info
