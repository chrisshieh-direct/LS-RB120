class Player
  attr_reader :score, :marker, :moves

  def initialize
    @score = 0
    @moves = []
    @marker = 'aaa'
  end

  def score_win
    score += 1
  end

  def record_move(move)
    moves << move
  end

  def write_marker(mark)
    puts mark
    puts marker
    marker = mark
  end

  private

  attr_writer :score, :marker, :moves
end

class Game
  def initialize
    @human = Player.new
  end

  def marker
    @human.write_marker('X')
  end

  def play
    puts @human.marker
  end
end

bob = Game.new

bob.marker

bob.play
