module Colorful
  def colorize(color_code)
    "\e[1m\e[#{color_code}m#{self}\e[0m\e[22m"
  end
end

String.include(Colorful)

module Interface
  def welcome
    (30..40).each do |color|
    system "clear"
    puts "Welcome to Blackjack!".colorize(color)
    sleep 0.05
    end
    puts "Dealing..."
    sleep 2
  end

  def goodbye
    puts "Thank you for playing. Goodbye!"
  end

  def play_again?
    answer = ''
    loop do
      puts "Would you like to play again? (Y/N)"
      answer = gets.chomp.strip.downcase
      break if answer == 'y' || answer == 'n'
      puts "Invalid response."
    end
    answer == 'y'
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    create
    shuffle
  end

  def create
    Card::RANKS.keys.each do |rank|
      Card::SUITS.each do |suit|
        @cards << Card.new(rank, suit)
      end
    end
  end

  def shuffle
    self.cards = cards.shuffle
  end

  def pop
    self.cards.pop
  end
end

class Card
  RANKS = { 'A' => 11, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,
    '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'J' => 10,
    'Q' => 10, 'K' => 10 }.freeze

  SUITS = ['♥', '♤', '♧', '♦'].freeze

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    RANKS[rank]
  end

  def show
    puts " __"
    puts "|#{rank} |"
    puts "| #{suit}|"
    puts " --"
  end
end

class Player
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def hit
  end

  def stay
  end

  def total
    total_sum = 0
    ace_count = 0

    hand.each do |card|
      if card.rank != 'A'
        total_sum += Card::RANKS[card.rank]
      else
        if total_sum + 11 > 21
          total_sum += 1
        else
          total_sum += 11
        end
      end
    end
    total_sum
  end

  def show_hand(show_first = true)
    mask1 = true if show_first == false
    mask2 = true if show_first == false
    hand.length.times do
      print '┌──┐ '
    end
    puts "\n"
    hand.each do |card|
      if card.rank == '10'
        rank_print = '10'
      else
        rank_print = card.rank + ' '
      end

      if mask1 == true
        print '│XX│ '
      else
        print "│#{rank_print}│ "
      end

      mask1 = false
    end
    puts "\n"
    hand.each do |card|
      if mask2 == true
        print '│XX│ '
      else
        print "│ #{card.suit}│ "
      end

      mask2 = false
    end
    puts "\n"
    hand.length.times do
      print '└──┘ '
    end
  end
end

class Human < Player
end

class Dealer < Player
  STAY_TARGET = 17
end

class BlackjackGame
  include Interface

  WINNING_VALUE = 21

  def initialize
    @human = Human.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def play
    welcome
    loop do
      initial_deal
      display_table
      player_turn
      dealer_turn
      show_result
      display_score
      break unless play_again?
      reshuffle
    end
    goodbye
  end

  def reshuffle
    if @deck.cards.length < 26
      puts "Reshuffling deck..."
      sleep 1
      @deck = Deck.new
    end
  end

  def initial_deal
    @human.hand = []
    @human.hand << @deck.pop
    @human.hand << @deck.pop
    @dealer.hand = []
    @dealer.hand << @deck.pop
    @dealer.hand << @deck.pop
  end

  def display_table
    system "clear"
    puts "DEALER: #{@dealer.total}".colorize(30)
    @dealer.show_hand(show_first = false)
    puts "\n\n"
    puts "YOUR HAND: #{@human.total}".colorize(31)
    @human.show_hand
    puts "\n\n"
  end

  def player_turn
  end

  def dealer_turn
  end

  def show_result
  end

  def display_score
  end

  private

  attr_accessor :npcs
end

game = BlackjackGame.new
game.play
