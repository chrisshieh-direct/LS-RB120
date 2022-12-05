require 'io/console'
require 'yaml'

MESSAGES = YAML.load_file('21_oop.yml')

module Colorful
  def colorize(color_code)
    "\e[1m\e[#{color_code}m#{self}\e[0m\e[22m"
  end
end

String.include Colorful

module Interface
  def welcome
    (30..40).each do |color|
      system "clear"
      puts MESSAGES["welcome"].colorize(color)
      sleep 0.05
    end
    offer_rules
  end

  def continue
    puts ' '
    puts MESSAGES["continue"]
    $stdin.getch
  end

  def offer_rules
    answer = ''
    loop do
      puts MESSAGES["rules?"]
      answer = $stdin.getch.downcase
      break if answer == 'y' || answer == 'n'
      puts MESSAGES["invalid"]
    end
    return if answer == 'n'
    puts MESSAGES["rules"]
    continue
  end

  def goodbye
    puts MESSAGES["goodbye"]
  end

  def play_again?
    puts MESSAGES["playagain?"]
    answer = $stdin.getch.downcase
    answer == 'n'
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
  attr_accessor :hand, :total, :wins

  def initialize
    @hand = []
    @total = 0
    @wins = 0
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

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

class Human < Player
  def play_turn(deck, game)
    loop do
      move = hit_or_stay
      if move == 'h'
        hand << deck.pop
        total_hand
        game.display_table
      end
      break if total > 21 || move == 's'
    end
    check_bust(game)
  end

  def check_bust(game)
    if total > 21
      puts MESSAGES["bustedpush"]
      game.win_state = 'BUST'
    else
      puts MESSAGES["dealerpush"]
      game.win_state = 'STAY'
    end
  end

  def hit_or_stay
    answer = ''
    loop do
      puts MESSAGES["hitorstay"]
      answer = $stdin.getch.downcase
      break if answer == 'h' || answer == 's'
      puts MESSAGES["invalid"]
    end
    answer
  end
end

class Dealer < Player
  STAY_TARGET = 17

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def play_turn(deck, game)
    game.display_table(show_dealer: true)
    puts "Dealer has #{total}"
    sleep 1.5

    until total >= STAY_TARGET
      hand << deck.pop
      total_hand
      game.display_table(show_dealer: true)
      puts "Dealer has #{total}"
      sleep 1.5
    end

    if total > 21
      print MESSAGES["dealerbusted"]
      sleep 1
      case game.win_state
      when 'BUST'
        print MESSAGES["playerbusted"]
        game.win_state = 'BUSTBUST'
        return
      when 'STAY'
        game.win_state = 'WIN'
        return
      end
    end
    game.win_state = game.win_state == 'BUST' ? 'LOSE' : 'STAYSTAY'
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize

class BlackjackGame
  include Interface
  attr_accessor :win_state, :total_count

  WINNING_VALUE = 21

  def initialize
    @human = Human.new
    @dealer = Dealer.new
    @deck = Deck.new
    @win_state = nil
    @total_count = 0
  end

  def play
    welcome
    loop do
      initial_deal
      display_table
      game_rounds
      postgame
      break if play_again?
      reshuffle
    end
    goodbye
  end

  def game_rounds
    return if blackjack?
    @human.play_turn(@deck, self)
    continue
    display_table
    @dealer.play_turn(@deck, self)
  end

  def postgame
    show_result
    continue
    show_score
  end

  # rubocop:disable Metrics/MethodLength
  def show_result
    case win_state
    when 'WIN'
      puts MESSAGES["win"]
      @human.wins += 1
    when 'LOSE'
      puts MESSAGES["lose"]
      @dealer.wins += 1
    when 'BUSTBUST'
      puts MESSAGES["bothbusted"]
      bustpush_check
    else
      calculate_winner
    end
  end
  # rubocop:enable Metrics/MethodLength

  def show_score
    puts "You've played #{total_count} games."
    puts "Your wins: #{@human.wins}"
    puts "Dealer wins: #{@dealer.wins}"
  end

  def bustpush_check
    if @human.total == @dealer.total
      puts MESSAGES["tie"]
    elsif @human.total < @dealer.total
      puts MESSAGES["bustedwin"]
      @human.wins += 1
    else
      puts MESSAGES["bustedlose"]
      @dealer.wins += 1
    end
  end

  def calculate_winner
    if @human.total == @dealer.total
      puts MESSAGES["tie"]
    elsif @human.total > @dealer.total
      puts MESSAGES["win"]
      @human.wins += 1
    else
      puts MESSAGES["lose"]
      @dealer.wins += 1
    end
  end

  def blackjack?
    if @human.total == 21
      puts MESSAGES["blackjack"]
      sleep 1.5
      self.win_state = 'WIN'
      true
    else
      false
    end
  end

  def reshuffle
    return unless @deck.cards.length < 26
    puts MESSAGES["reshuffle"]
    sleep 1
    @deck = Deck.new
  end

  def initial_deal
    @win_state = nil
    @human.hand = []
    @human.hand << @deck.pop
    @human.hand << @deck.pop
    @human.total_hand
    @dealer.hand = []
    @dealer.hand << @deck.pop
    @dealer.hand << @deck.pop
    @dealer.total_hand
    @total_count += 1
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
end

game = BlackjackGame.new
game.play
