require 'io/console'

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
      puts "Welcome to No-Bust Blackjack!".colorize(color)
      sleep 0.05
    end
    offer_rules
  end

  def continue
    puts ' '
    puts ">>> PRESS ANY KEY TO CONTINUE <<<"
    $stdin.getch
  end

  def offer_rules
    answer = ''
    loop do
      puts "\nWould you like to hear the rules? (Y/N)"
      answer = $stdin.getch.downcase
      break if answer == 'y' || answer == 'n'
      puts "Invalid response."
    end
    return if answer == 'n'
    rules = <<~RULESDOC
      No-Bust Blackjack is like regular blackjack with one big difference.
      You can still win if you bust! If you bust, the dealer will still
      play their hand. If the dealer busts and you have a LOWER total,
      you win the hand!
      RULESDOC
    puts ' '
    puts rules
    continue
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
    cards.pop
  end
end

class Card
  RANKS = { 'A' => 11, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,
            '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'J' => 10,
            'Q' => 10, 'K' => 10 }.freeze

  SUITS = ['♥', '♤', '♧', '♦'].freeze

  attr_reader :rank

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def suit
    return @suit.colorize(91) if @suit == '♥' || @suit == '♦'
    @suit
  end
end

class Player
  attr_accessor :hand, :total

  def initialize
    @hand = []
    @total = 0
  end

  def hit; end

  def stay; end

  def total_hand
    self.total = 0
    hand.each do |card|
      self.total += if card.rank != 'A'
                      Card::RANKS[card.rank]
                    elsif total + 11 > 21
                      1
                    else
                      11
                    end
    end
  end

  def show_hand(show_first: true)
    mask1 = true if show_first == false
    mask2 = true if show_first == false
    hand.length.times do
      print '┌──┐ '
    end
    puts "\n"
    hand.each do |card|
      rank_print = if card.rank == '10'
                     '10'
                   else
                     "#{card.rank} "
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
  def play_turn(deck, game)
    loop do
      move = hit_or_stay
      if move == 'h'
        hand << deck.pop
        total_hand
      end
      game.display_table
      break if total > 21 || move == 's'
    end

    if total > 21
      puts "You busted... but you're still in it!"
      game.game_status = 'BUST'
    else
      puts "Now it's the Dealer's turn."
    end
    sleep 1
  end

  def hit_or_stay
    answer = ''
    loop do
      puts "Would you like to (H)it or (S)tay?"
      answer = $stdin.getch.downcase
      break if answer == 'h' || answer == 's'
      puts "Invalid response."
    end
    answer
  end
end

class Dealer < Player
  STAY_TARGET = 17

  def play_turn(deck, game)
    game.display_table(show_dealer: true)
    puts "Dealer has #{total}"
    sleep 1.5

    until total >= STAY_TARGET
      hand << deck.pop
      total_hand
      game.display_table(show_dealer: true)
    end

    return unless total > 21
    puts "DEALER BUSTED! YOU WIN!"
    game.game_status = 'WIN'
    sleep 1
  end
end

class BlackjackGame
  include Interface
  attr_accessor :game_status

  WINNING_VALUE = 21

  def initialize
    @human = Human.new
    @dealer = Dealer.new
    @deck = Deck.new
    @game_status = nil
  end

  def play
    welcome
    loop do
      initial_deal
      display_table
      unless blackjack?
        @human.play_turn(@deck, self)
        display_table
        @dealer.play_turn(@deck, self)
      end
      calculate_winner
      show_result
      display_score
      break unless play_again?
      reshuffle
    end
    goodbye
  end

  def calculate_winner
    case game_status
    when 'WIN'
      puts 'WIN'
    when 'BUST'
      puts 'BUST'
    end
  end

  def blackjack?
    if @human.total == 21
      self.game_status = 'WIN'
      true
    else
      false
    end
  end

  def reshuffle
    return unless @deck.cards.length < 26
    puts "Reshuffling deck..."
    sleep 1
    @deck = Deck.new
  end

  def initial_deal
    @game_status = nil
    @human.hand = []
    @human.hand << @deck.pop
    @human.hand << @deck.pop
    @human.total_hand
    @dealer.hand = []
    @dealer.hand << @deck.pop
    @dealer.hand << @deck.pop
    @dealer.total_hand
  end

  def display_table(show_dealer: false)
    system "clear"
    dealer_view = show_dealer ? @dealer.total.to_s : '???'
    puts "DEALER: #{dealer_view}".colorize(30)
    @dealer.show_hand(show_first: show_dealer)
    puts "\n\n"
    puts "YOUR HAND: #{@human.total}".colorize(31)
    @human.show_hand
    puts "\n\n"
  end

  def show_result; end

  def display_score; end
end

game = BlackjackGame.new
game.play
