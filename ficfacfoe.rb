require 'io/console'

class Player
  attr_reader :score

  def initialize
    @score = 0
  end

  def score_win
    @score += 1
  end

  def move; end

  private

  attr_writer :score
end

class Human < Player
  attr_reader :name

  def write_name(name)
    @name = name
  end

  private

  attr_writer :name
end

class Cray < Player
  def initialize
    super
    @name = 'Cray'
  end
end

class KrayKray < Player
  def initialize
    super
    @name = 'KrayKray'
  end
end

class Board
  def initialize(human, cray, kraykray)
    @grid = {}
    @human = human
    @cray = cray
    @kraykray = kraykray
    reset
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def display
    system "clear"
    puts "---------------------  FIC FAC FOE!"
    puts "| #{sq(1)} | #{sq(2)} | #{sq(3)} | #{sq(4)} | #{sq(5)} |"
    puts "---------------------  First to win 3 times wins a match!"
    puts "| #{sq(1)} | #{sq(1)} | #{sq(1)} | #{sq(1)} | #{sq(1)} |"
    puts "---------------------  Current Score:"
    puts "| #{sq(1)} | #{sq(1)} | #{sq(1)} | #{sq(1)} | #{sq(1)} |"
    puts "---------------------  You: #{human.score}"
    puts "| #{sq(1)} | #{sq(1)} | #{sq(1)} | #{sq(1)} | #{sq(1)} |"
    puts "---------------------  Cray: #{cray.score}"
    puts "| #{sq(1)} | #{sq(1)} | #{sq(1)} | #{sq(1)} | #{sq(1)} |"
    puts "---------------------  KrayKray: #{kraykray.score}"
    puts
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def sq(int)
    @grid[int]
  end

  def reset
    1.upto(25) do |x|
      grid[x] = " "
    end
  end

  private

  attr_accessor :human, :cray, :kraykray, :grid
end

class Square
  def initialize; end
end

module Interface
  def welcome_getname
    answer = ''
    system "clear"
    loop do
      puts "Welcome to FIC FAC FOE. What's your name?"
      answer = gets.chomp
      break unless answer.empty?
      puts "Sorry, please enter a name for yourself."
    end
    answer
  end

  def display_rules
    answer = show_rules?
    return unless answer == 'y'
    puts ''
    puts "Try to get 5 of your markers in a row. You're playing against"
    puts "two computer opponents. Cray is a supercomputer and will try"
    puts "to play rationally. KrayKray is just plain crazy. Good luck!"
    continue
  end

  def continue
    puts ''
    puts ">>> PRESS ANY KEY TO CONTINUE <<<"
    $stdin.getch
  end

  def show_rules?
    answer = ''
    puts ''
    loop do
      puts "Okay #{@human.name}, would you like to hear the rules? (Y/N)"
      answer = $stdin.getch.downcase
      break if answer == 'y' || answer == 'n'
      puts "Sorry, please enter Y or N."
    end
    answer
  end

  def choose_marker
    marker = ''
    answer = ''
    loop do
      puts "Press any key to choose your marker."
      marker = $stdin.getch.upcase
      puts "Your marker is #{marker}, okay? (Y to confirm)"
      answer = $stdin.getch.downcase
      break if answer == 'y'
    end
  end
end

class FFFGame
  include Interface

  def initialize
    @human = Human.new
    @cray = Cray.new
    @kraykray = KrayKray.new
    @board = Board.new(@human, @cray, @kraykray)
  end

  WINNING_LINES = [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12, 13, 14, 15],
                   [16, 17, 18, 19, 20], [21, 22, 23, 24, 25], # horizontal
                   [1, 6, 11, 16, 21], [2, 7, 12, 17, 22], [3, 8, 13, 18, 23],
                   [4, 9, 14, 19, 24], [5, 10, 15, 20, 25], # vertical
                   [1, 7, 13, 19, 25], [5, 9, 13, 17, 21]] # diagonal

  # rubocop:disable Metrics/MethodLength
  def play
    @human.write_name(welcome_getname)
    display_rules
    choose_marker
    @board.display
    # ask who goes first
    # display empty board
    # huamn move / computer1 move / computer2 move
    #   chueck for win / check if full
    # after checks : display Score
    # play again?play
    # goodbye
  end
  # rubocop:enable Metrics/MethodLength
end

game = FFFGame.new
game.play
