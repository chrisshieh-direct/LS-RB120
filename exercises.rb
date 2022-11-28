class GuessingGame
  def initialize
  end

  def play
    self.guesses = 7
    self.number = rand(1..100)

    while guesses > 0
      win = round
      break if win
      self.guesses -= 1
    end

    if win
      puts "You won!"
    else
      puts "You have no more guesses. You lost!"
    end
  end

  def round
    puts "You have #{guesses} guesses remaining."
    answer = nil
    loop do
      print "Enter a number between 1 and 100: "
      answer = gets.chomp
      break if answer.to_i.to_s == answer && (1..100).include?(answer.to_i)
      puts "Please enter a number between 1 and 100."
    end

    answer = answer.to_i

    if answer == number
      puts "That's the number!"
      win = true
    elsif answer > number
      puts "Your guess is too high."
    elsif answer < number
      puts "Your guess is too low."
    end
  end

  private

  attr_accessor :guesses, :number
end

game = GuessingGame.new
game.play
game.play
