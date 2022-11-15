class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  def choose
    puts "Please choose rock, paper, or scissors."
    choice = ''
    loop do
      choice = gets.chomp
      break if ['rock', 'paper', 'scissors'].include?(choice)
      puts "Sorry, invalid choice. Please choose rock, paper, or scissors."
    end
    self.move = Move.new(choice)
  end

  private

  def set_name
    answer = ''
    loop do
      puts "What's your name?"
      answer = gets.chomp
      break unless answer.empty?
    end
    self.name = answer
    puts "Your name is #{name}."
  end
end

class Computer < Player
  def choose
    self.move = Move.new(Move::VALUES.sample)
  end

  private

  def set_name
    self.name = ['Charles', 'Ada', 'Grace', 'Alan'].sample
    puts "The computer's name is #{name}."
  end
end

class Move
  attr_reader :value

  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  # two different structures
  def >(other_move)
    return true if rock? && other_move.scissors?
    return true if paper? && other_move.rock?
    return true if scissors? && other_move.paper?
  end

  def <(other_move)
    (paper? && other_move.scissors?)   ||
      (scissors? && other_move.rock?)  ||
      (rock? && other_move.paper?)
  end

  protected

  def rock?
    @value == 'rock'
  end

  def scissors?
    @value == 'scissors'
  end

  def paper?
    @value == 'paper'
  end
end

# Game orch engine
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      computer.move
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_winner
    a = human.move
    b = computer.move
    puts "#{human.name} chose #{a}\n#{computer.name} chose #{b}"
    if a > b
      puts "#{human.name} won!"
    elsif a < b
      puts "#{computer.name} wins. Sorry."
    else
      puts "It's a tie."
    end
  end

  def play_again?
    answer = ''
    loop do
      puts "Play again? (y/n)"
      answer = gets.chomp.downcase
      break if answer == "y" || answer == "n"
      puts "Sorry, enter (Y)es or (N)o."
    end
    answer == "y"
  end
end

RPSGame.new.play
