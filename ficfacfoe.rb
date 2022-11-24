require 'io/console'
require 'colorize'

class Player
  attr_reader :score, :marker

  def initialize
    @score = 0
  end

  def score_win
    @score += 1
  end

  def move; end

  def write_marker(marker)
    @marker = marker
  end

  private

  attr_writer :score, :marker
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
    @marker = 'C'
  end

  def move(empty)
    empty.sample
  end

end

class KrayKray < Player
  def initialize
    super
    @name = 'KrayKray'
    @marker = 'K'
  end

  def move(empty)
    empty.sample
  end
end

class Board
  def initialize(human, cray, kraykray)
    @grid = {}
    @human = human
    @cray = cray
    @kraykray = kraykray
    launch
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def display
    system "clear"
    puts "---------------------  FIC FAC FOE!"
    puts "| #{sq(1)} | #{sq(2)} | #{sq(3)} | #{sq(4)} | #{sq(5)} |"
    puts "---------------------  First to win 3 times wins a match!"
    puts "| #{sq(6)} | #{sq(7)} | #{sq(8)} | #{sq(9)} | #{sq(10)} |"
    puts "---------------------  Current Score:"
    puts "| #{sq(11)} | #{sq(12)} | #{sq(13)} | #{sq(14)} | #{sq(15)} |"
    puts "---------------------  You (#{human.marker}): #{human.score}"
    puts "| #{sq(16)} | #{sq(17)} | #{sq(18)} | #{sq(19)} | #{sq(20)} |"
    puts "---------------------  Cray (#{cray.marker}): #{cray.score}"
    puts "| #{sq(21)} | #{sq(22)} | #{sq(23)} | #{sq(24)} | #{sq(25)} |"
    puts "---------------------  KrayKray (#{kraykray.marker}): #{kraykray.score}"
    puts
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def sq(int)
    color = ''
    case @grid[int][1]
    when 'Cray'
      color = :blue
    when 'KrayKray'
      color = :red
    when 'Human'
      color = :white
    end
    @grid[int][0].colorize(color)
  end

  def launch
    1.upto(25) do |x|
      grid[x] = " "
    end
  end

  def erase
    display
    1.upto(25) do |x|
      grid[x] = " "
      display
      sleep 0.05
    end
  end

  def empty
    @grid.select do |_k, v|
      v == ' '
    end.keys
  end

  def mark(player)
    @grid[player.move(empty)] = ["#{player.marker}", player.class.to_s]
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

  def set_markers
    @human.write_marker(choose_marker)
    @cray.write_marker('X') if @human.marker == 'C'
    @kraykray.write_marker('X') if @human.marker == 'K'
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
    marker
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
    puts "This is blue".colorize(:blue)
puts "This is light blue".colorize(:light_blue)
puts "This is also blue".colorize(:color => :blue)
puts "This is light blue with red background".colorize(:color => :light_blue, :background => :red)
puts "This is light blue with red background".colorize(:light_blue ).colorize( :background => :red)
puts "This is blue text on red".blue.on_red
    @human.write_name(welcome_getname)
    display_rules
    set_markers
    @board.display
    sleep 1
    @board.mark(@cray)
    @board.display
    sleep 0.2
  12.times do
      @board.mark(@kraykray)
      @board.display
      sleep 0.1
      @board.mark(@cray)
      @board.display
      sleep 0.1
    end
    sleep 1

    @board.erase

    # ask who goes first
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
