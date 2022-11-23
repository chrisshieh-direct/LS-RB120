class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def reset
    @squares = { 1 => Square.new(' '), 2 => Square.new(' '),
                 3 => Square.new(' '), 4 => Square.new(' '),
                 5 => Square.new(' '), 6 => Square.new(' '),
                 7 => Square.new(' '), 8 => Square.new(' '),
                 9 => Square.new(' ') }
  end

  def get_sqr(location)
    @squares[location]
  end

  def set_sqr(location, marker)
    @squares[location].marker = marker
  end

  def empty_sqr_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    empty_sqr_keys.empty?
  end

  def detect_winner(marker)
    moves = @squares.
    winner = nil
    WINNING_LINES.each do |line|
      if @squares[line[0]].marker == marker &&
         @squares[line[1]].marker == marker &&
         @squares[line[2]].marker == marker
         winner = marker
      end
    end
    winner
  end
end

class Square
  attr_accessor :marker

  def initialize(marker)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == ' '
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  attr_reader :board, :human, :computer, :victor

  def initialize
    @board = Board.new
    @human = Player.new("X")
    @computer = Player.new("O")
    @victor = nil
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic tac Toe! Goodbye!"
  end

  def display_result
    if @victor == 'X' || @victor == 'O'
      winner = @victor == 'X' ? 'Human' : 'Computer'
      puts "The #{winner} wins!"
    elsif board.full?
      puts "It's a tie."
    end
  end

  # rubocop:disable Metrics/AbcSize
  def display_board
    system('clear')
    puts "=TIC TAC TOE="
    puts "-------------"
    puts "| #{board.get_sqr(1)} | #{board.get_sqr(2)} | #{board.get_sqr(3)} |"
    puts "-------------"
    puts "| #{board.get_sqr(4)} | #{board.get_sqr(5)} | #{board.get_sqr(6)} |"
    puts "-------------"
    puts "| #{board.get_sqr(7)} | #{board.get_sqr(8)} | #{board.get_sqr(9)} |"
    puts "-------------"
    puts ""
  end
  # rubocop:enable Metrics/AbcSize

  def human_moves
    move = nil
    loop do
      puts "Choose a square (#{board.empty_sqr_keys.join(', ')})"
      move = gets.chomp.to_i
      break if (board.empty_sqr_keys).include?(move)
      puts "Sorry, invalid choice."
    end

    board.set_sqr(move, human.marker)
  end

  def computer_moves
    sleep 0.5
    puts "Now I go."
    sleep 0.5
    move = board.empty_sqr_keys.sample
    puts "I pick square number #{move}"
    sleep 0.5
    board.set_sqr(move, computer.marker)
  end

  # rubocop:disable Metrics/MethodLength
  def play
    display_welcome_message
    display_board
    loop do
      human_moves
      display_board
      break if @victor = board.detect_winner('X') || board.full?
      computer_moves
      display_board
      break if @victor = board.detect_winner('O') || board.full?
    end
    display_result
    display_goodbye_message
  end
  # rubocop:enable Metrics/MethodLength

end

game = TTTGame.new
game.play
