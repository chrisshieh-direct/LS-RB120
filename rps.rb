class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def reset_score
    @score = 0
  end

  def add_victory
    @score += 1
  end
end

class Human < Player
  attr_reader :copy_target

  def initialize
    super
    self.copy_target = 'rock'
  end

  def choose
    puts "Please choose rock, paper, or scissors."
    choice = ''
    loop do
      choice = gets.chomp
      break if ['rock', 'paper', 'scissors'].include?(choice)
      puts "Sorry, invalid choice. Please choose rock, paper, or scissors."
    end
    self.copy_target = choice
    self.move = Move.new(choice)
  end

  private

  attr_writer :copy_target

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
  def choose(opponent)
    case name
    when 'Rocklover'
      self.move = Move.new('rock')
    when 'Randy'
      self.move = Move.new(Move::VALUES.sample)
    when 'Copycat'
      self.move = Move.new(opponent.copy_target)
    when 'Edward'
      self.move = Move.new(['scissors', 'scissors', 'scissors', 'rock'].sample)
    end
  end

  private

  def set_name
    self.name = ['Rocklover', 'Copycat', 'Edward', 'Randy'].sample
    puts "You are playing against #{name}."
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
  attr_accessor :human, :computer, :log, :round

  def initialize
    @human = Human.new
    @computer = Computer.new
    @log = []
    @round = 1
  end

  def play
    display_welcome_message
    loop do
      computer.choose(human)
      human.choose
      display_moves
      record_log
      adjust_score(find_winner)
      break unless play_again?
    end
    end_of_game
  end

  def record_log
    @log << "#{round}|Human: #{human.move}, Computer: #{computer.move}"
    @round += 1
  end

  def show_log
    answer = ''
    loop do
      puts "Show log before you go? (y/n)"
      answer = gets.chomp.downcase
      break if answer == 'y' || answer == 'n'
      puts "Sorry, enter (Y)es or (N)o."
    end
    return unless answer == "y"
    log.each { |line| puts line }
  end

  def end_of_game
    show_log
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def find_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      winner = human
    elsif computer.move > human.move
      puts "#{computer.name} wins. Sorry."
      winner = computer
    else
      puts "It's a tie."
    end
    winner
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

  def adjust_score(player)
    return if player.nil?
    player.add_victory
    puts "SCORE"
    puts "#{human.name}: #{human.score} points"
    puts "#{computer.name}: #{computer.score} points."
    @round = 1 if (check_match_win(human, computer)).nil?
  end

  def check_match_win(hum, comp)
    if hum.score == 10
      hum.reset_score
      comp.reset_score
      return puts (log << "#{hum.name} WINS MATCH!").last
    elsif comp.score == 10
      hum.reset_score
      comp.reset_score
      return puts (log << "#{comp.name} wins the match.").last
    end
    true
  end
end

RPSGame.new.play
