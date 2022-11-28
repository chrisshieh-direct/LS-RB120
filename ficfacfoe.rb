require 'io/console'

module Colorful
  def colorize(color_code)
    "\e[1m\e[#{color_code}m#{self}\e[0m\e[22m"
  end
end

String.include(Colorful)

module Interface
  def welcome_getname
    answer = ''
    system "clear"
    loop do
      puts "Welcome to FIC FAC FOUR! What's your name?"
      answer = gets.chomp.strip
      break unless answer.empty?
      puts "Sorry, please enter a name for yourself."
    end
    answer
  end

  def display_rules
    answer = show_rules?
    return unless answer == 'y'
    rules = <<~RULES
      Try to get 4 of your markers in a row. You're playing against
      two computer opponents. Cray is a supercomputer and will try
      to play rationally. KrayKray is just plain crazy. Good luck!
      RULES
    puts rules
    continue
  end

  def continue
    puts ''
    puts ">>> PRESS ANY KEY TO CONTINUE <<<"
    puts ''
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

  # rubocop:disable Metrics/MethodLength
  def choose_marker
    marker = ''
    answer = ''
    loop do
      loop do
        puts "Choose a letter to represent your marker."
        marker = $stdin.getch.upcase
        break if ('A'..'Z').include?(marker)
        puts "Invalid entry."
      end
      puts "Your marker is #{marker}, okay? (Y to confirm)"
      answer = $stdin.getch.downcase
      break if answer == 'y'
    end
    marker
  end
  # rubocop:enable Metrics/MethodLength

  def farewell
    puts "Fare thee well. Have a wonderful day!"
  end
end

class Player
  attr_reader :score, :marker, :moves, :match_score

  def initialize
    @score = 0
    @match_score = 0
    @moves = []
  end

  def score_win
    self.score += 1
  end

  def match_win
    self.match_score += 1
  end

  def record_move(move)
    moves << move
  end

  def write_marker(mark)
    self.marker = mark
  end

  def erase
    self.moves = []
  end

  def match_erase
    self.score = 0
  end

  def move(empty_squares)
    finish = finish_win(empty_squares)
    return finish if finish
  end

  # rubocop:disable Metrics/MethodLength
  def finish_win(empty_squares)
    Board::WINNING_LINES.each do |line|
      count = 0
      line.each do |square|
        count += 1 if moves.include?(square)
      end
      if count == 3
        target = (line - moves).first
        return target if empty_squares.include?(target)
      end
    end
    nil
  end
  # rubocop:enable Metrics/MethodLength

  private

  attr_writer :score, :marker, :moves, :match_score
end

class Human < Player
  attr_reader :name

  def write_name(name)
    @name = name
  end

  def move(empty_squares)
    answer = ''
    loop do
      puts "Choose a space (#{empty_squares.join(', ')})."
      answer = gets.chomp.downcase.to_i
      break if empty_squares.include?(answer)
      puts "Sorry, invalid choice."
      puts ''
      sleep 0.3
    end
    answer
  end

  private

  attr_writer :name
end

class Cray < Player
  attr_reader :name

  PREFERRED_SQUARES = [[13], [7, 8, 9, 12, 14, 17, 18, 19],
                       [2, 4, 6, 10, 16, 20, 22, 24]]

  def initialize
    super
    @name = 'Cray'
    @marker = 'C'
  end

  def move(empty_squares)
    return super if super
    targets = empty_preferred_squares(empty_squares)
    targets.each do |squares|
      next if squares.empty?
      return squares.sample
    end
    empty_squares.sample
  end

  def empty_preferred_squares(empty_squares)
    PREFERRED_SQUARES.map do |squares|
      squares.select do |square|
        empty_squares.include?(square)
      end
    end
  end
end

class KrayKray < Player
  attr_reader :name

  def initialize
    super
    @name = 'KrayKray'
    @marker = 'K'
  end

  def move(empty_squares)
    return super if super
    empty_squares.sample
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

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Layout/LineLength
  def display
    system "clear"
    puts "---------------------  FIC FAC FOUR!"
    puts "| #{sq(1)} | #{sq(2)} | #{sq(3)} | #{sq(4)} | #{sq(5)} |"
    puts "---------------------  First to win 3 times wins a match!"
    puts "| #{sq(6)} | #{sq(7)} | #{sq(8)} | #{sq(9)} | #{sq(10)} |"
    puts "---------------------  Current Score:"
    puts "| #{sq(11)} | #{sq(12)} | #{sq(13)} | #{sq(14)} | #{sq(15)} |"
    puts "---------------------  You (#{human.marker.colorize(93)}) | Games: #{human.score} Matches: #{human.match_score}"
    puts "| #{sq(16)} | #{sq(17)} | #{sq(18)} | #{sq(19)} | #{sq(20)} |"
    puts "---------------------  Cray (#{cray.marker.colorize(91)}) | Games: #{cray.score} Matches: #{cray.match_score}"
    puts "| #{sq(21)} | #{sq(22)} | #{sq(23)} | #{sq(24)} | #{sq(25)} |"
    puts "---------------------  KrayKray (#{kraykray.marker.colorize(94)}) | Games: #{kraykray.score} Matches: #{kraykray.match_score}"
    puts
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Layout/LineLength

  def sq(int)
    color_code = 0
    case @grid[int][1]
    when 'Cray'
      color_code = 91
    when 'KrayKray'
      color_code = 94
    when 'Human'
      color_code = 93
    end
    @grid[int][0].colorize(color_code)
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
      sleep 0.03
    end
  end

  def empty_squares
    @grid.select do |_k, v|
      v == ' '
    end.keys
  end

  def check_for_finish(player)
    return player if check_win(player)
    return 'tie' if empty_squares.empty?
    false
  end

  WINNING_LINES = [[1, 2, 3, 4], [2, 3, 4, 5], [6, 7, 8, 9], [7, 8, 9, 10],
                   [11, 12, 13, 14], [12, 13, 14, 15], [16, 17, 18, 19],
                   [17, 18, 19, 20], [21, 22, 23, 24], [22, 23, 24, 25], # horiz
                   [1, 6, 11, 16], [6, 11, 16, 21], [2, 7, 12, 17],
                   [7, 12, 17, 22], [3, 8, 13, 18], [8, 13, 18, 23],
                   [4, 9, 14, 19], [9, 14, 19, 24], [5, 10, 15, 20],
                   [10, 15, 20, 25], # vertical
                   [1, 7, 13, 19], [7, 13, 19, 25], [2, 8, 14, 20],
                   [6, 12, 18, 24], [5, 9, 13, 17], [9, 13, 17, 21],
                   [4, 8, 12, 16], [10, 14, 18, 22]] # diag

  def check_win(player)
    result = false
    WINNING_LINES.each do |line|
      if line.all? { |x| player.moves.include?(x) }
        result = true
      end
    end
    result
  end

  def mark(player)
    choice = player.move(empty_squares)
    @grid[choice] = [player.marker.to_s, player.class.to_s]
    player.record_move(choice)
  end

  private

  attr_accessor :human, :cray, :kraykray, :grid
end

class FFFGame
  include Interface

  def initialize
    @human = Human.new
    @cray = Cray.new
    @kraykray = KrayKray.new
    @board = Board.new(@human, @cray, @kraykray)
  end

  def play
    @human.write_name(welcome_getname)
    display_rules
    set_markers
    main_game
    farewell
  end

  # rubocop:disable Metrics/MethodLength
  def main_game
    loop do
      single_game
      winner = check_match_win
      if winner
        puts "#{winner.name} won the match!"
        winner.match_win
        sleep 2
        match_reset
      end
      single_game_reset
      break unless play_again?
    end
  end
  # rubocop:enable Metrics/MethodLength

  def check_match_win
    return @human if @human.score == 3
    return @cray if @cray.score == 3
    return @kraykray if @kraykray.score == 3
    nil
  end

  def match_reset
    @human.match_erase
    @cray.match_erase
    @kraykray.match_erase
  end

  # rubocop:disable Metrics/MethodLength
  def single_game
    order = set_playing_order
    @board.display
    winner_or_tie = nil
    loop do
      order.each do |player|
        round(player)
        winner_or_tie = @board.check_for_finish(player)
        break if winner_or_tie
      end
      break if winner_or_tie
    end
    post_game(winner_or_tie)
    sleep 1.5
  end
  # rubocop:enable Metrics/MethodLength

  def single_game_reset
    @board.erase
    @human.erase
    @cray.erase
    @kraykray.erase
  end

  def play_again?
    answer = ''
    loop do
      puts "Play again? (Y/N)"
      answer = gets.chomp.downcase
      break if answer == 'y' || answer == 'n'
      puts "Please enter Y or N."
    end
    answer == 'y'
  end

  def post_game(game_over)
    if game_over == 'tie'
      puts "It's a tie!"
    else
      puts "The winner is #{game_over.name}!"
      game_over.score_win
    end
  end

  def round(player)
    sleep 1 if player != @human
    @board.mark(player)
    @board.display
  end

  def set_playing_order
    print "Randomizing the order ."
    8.times do
      print '.'
      sleep 0.08
    end
    random_order = [@human, @cray, @kraykray].shuffle
    print " #{random_order[0].name} will go first."
    sleep 1.4
    random_order
  end
end

game = FFFGame.new
game.play
