class Card
  include Comparable
  attr_reader :rank, :suit, :rank_sort

  SORT_VALUES = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8,
    9 => 9, 10 => 10, 'Jack' => 11, 'Queen' => 12,
    'King' => 13, 'Ace' => 14 }.freeze

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @rank_sort = calculate_sort(rank)
  end

  def calculate_sort(rank)
    SORT_VALUES[rank]
  end

  def <=>(other)
    self.rank_sort <=> other.rank_sort
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def ==(other)
    self.rank_sort == other.rank_sort && self.suit == other.suit
  end

  def same_suit?(other)
    self.suit == other.suit
  end

  def same_rank?(other)
    self.rank == other.rank
  end
end

class Deck
  attr_accessor :cards

  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    @cards = []
    reset
  end

  def reset
    RANKS.each do |rank|
      SUITS.each do |suit|
        cards << Card.new(rank, suit)
      end
    end
    shuffle_cards
  end

  def draw
    reset if cards.length == 0
    cards.shift
  end

  def shuffle_cards
    cards.shuffle!
  end
end

class PokerHand
  attr_accessor :hand, :ranks, :suits

  def initialize(deck)
    @hand = []
    5.times { @hand << deck.draw }
  end

  def print
    hand.sort.each do |singlecard|
      puts singlecard
    end
  end

  def evaluate
    @ranks = hand.map { |x| x.rank_sort }.sort
    @suits = hand.map { |x| x.suit }.sort
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  def sort
    hand.sort_by do |singlecard|
      singlecard.rank_sort
    end
  end

  private

  def royal_flush?
    straight_flush? && ranks.first == 10
  end

  def straight_flush?
    flush? && straight?
  end

  def four_of_a_kind?
    ranks.any? { |x| ranks.count(x) == 4 }
  end

  def full_house?
    three_check = ranks.count { |x| ranks.count(x) == 3 }
    two_check = ranks.count { |x| ranks.count(x) == 2 }
    two_check == 2 && three_check == 3
  end

  def flush?
    suits.uniq.count == 1
  end

  def straight?
    straight = true
    4.times { |x| straight = false if ranks[x] + 1 != ranks[x+1] }
    straight
  end

  def three_of_a_kind?
    ranks.any? { |rank| ranks.count(rank) >= 3 }
  end

  def two_pair?
    check = ranks.count { |x| ranks.count(x) == 2 }
    check == 4
  end

  def pair?
    check = ranks.count { |x| ranks.count(x) == 2 }
    check == 2
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'
