module Validatable
  def number?(num)
    num.match?(/[0-9]/)
  end

  def hit_or_stay
    answer = nil
    loop do
      puts "Would you like to 'hit' or 'stay'?"
      input = gets.chomp.downcase
      break answer = input[0] if %w(hit stay h s).include?(input)
      puts "Invalid input."
    end
    answer
  end

  def yes_or_no
    answer = nil
    loop do
      input = gets.chomp.downcase
      break answer = input if %w(y n yes no).include?(input)
      puts "Invalid input.\nType 'y' or 'n' please."
    end
    answer[0]
  end

  def validate_name
    name = nil
    loop do
      input = gets.chomp
      break name = input if input.match?(/[A-Za-z]/)
      puts "Invalid input. At least put one letter."
    end
    name
  end
end

module Displayable
  def clear_screen
    system 'clear' || 'cls'
  end

  def display_welcome_message
    clear_screen
    message = <<~WLM
      Welcome to 21! The game where Everyone is a winner, roughly 33-45% of the time!
      Choose to hit or stay, when it's your turn.
      Highest score without busting is 21.
      Good Luck! Again, about 1/3 of the time...

      <hit Enter when ready>
    WLM
    puts message
    gets
  end

  def display_busted(player)
    puts "#{player} has busted!"
  end

  def display_results(winners, losers, tiers)
    display_winners(winners) if !winners.empty?
    display_losers(losers) if !losers.empty?
    display_tiers(tiers) if !tiers.empty?
  end

  def display_winners(winners)
    case winners.size
    when 1
      puts "#{winners.first} wins!"
    when 2
      puts "#{winners.join(' and ')} win!"
    else
      puts "#{winners[0..-2].join(', ')} and #{winners.last} win!"
    end
  end

  def display_losers(losers)
    case losers.size
    when 1
      puts "#{losers.first} lost."
    when 2
      puts "#{losers.join(' and ')} lost."
    else
      puts "#{losers[0..-2].join(', ')} and #{losers.last} lost."
    end
  end

  # rubocop:disable Metrics/AbcSize
  def show_dealer_cards
    if @first_show
      puts "Dealer: #{dealer}--Score: #{dealer.card_values.first}"
      puts prep_card_display([dealer.hand.first, Card.new('?', '?')])
    else
      puts "Dealer: #{dealer}--Score: #{dealer.evaluate_hand}"
      puts prep_card_display(dealer.hand)
    end
  end
  # rubocop:enable Metrics/AbcSize

  def show_player_cards
    prepped_cards = players.each_with_object({}) do |player, output|
      output[player] = prep_card_display(player.hand)
    end
    prepped_cards.each do |player, cards|
      puts "Player: #{player}--Score: #{player.evaluate_hand}"
      puts cards
      puts ''
    end
  end

  def display_tiers(tiers)
    case tiers.size
    when 1
      puts "#{tiers.first} tied with dealer."
    when 2
      puts "#{tiers.join(' and ')} tied with dealer."
    else
      puts "#{tiers[0..-2].join(', ')} and #{tiers.last} tied with dealer."
    end
  end

  def show_cards
    clear_screen
    show_dealer_cards
    show_player_cards
  end

  def display_goodbye_message
    puts "\n"
    puts "Thanks for playing! Stay warm out there, #{players.first}."
  end

  def display_score
    puts score
  end

  def clear_and_display_score
    clear_screen
    puts score
  end
end

class Deck
  attr_reader :deck

  SUITS = %w(♥ ♤ ♧ ♦).freeze
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'].freeze

  def initialize
    @deck = []
    reset
  end

  def reset
    SUITS.each do |suit|
      RANKS.each do |rank|
        deck << Card.new(rank, suit)
      end
    end
  end

  def shuffle!
    deck.shuffle!
  end

  def draw
    deck.pop
  end

  def empty?
    deck.empty?
  end
end

class Card
  attr_reader :suit, :rank

  def initialize(rank, suit)
    @suit = suit
    @rank = rank
  end

  def to_s
    puts image
    ''
  end

  def image
    ['  _________  ',
     " |       #{rank.to_s.rjust(2)}| ",
     ' |         | ',
     " |    #{suit}    | ",
     ' |         | ',
     " |#{rank.to_s.rjust(2)}       | ",
     ' |_________| ',
     '']
  end
end

class Player
  attr_accessor :hand, :name

  def initialize
    @name = set_name
    @hand = []
  end

  def busted?
    evaluate_hand > 21
  end

  def toss_cards
    self.hand = []
  end

  def to_s
    name
  end

  def card_values
    hand.map do |card|
      case card.rank
      when 'A'
        11
      when 'J', 'Q', 'K'
        10
      else
        card.rank
      end
    end
  end

  def count_aces
    hand.count { |card| card.rank == 'A' }
  end

  def evaluate_hand
    aces = count_aces
    total = card_values.sum
    until total <= 21 || aces == 0
      total -= 10
      aces -= 1
    end
    total
  end
end

class Human < Player
  include Validatable
  @@humans = 0

  def initialize
    @@humans += 1
    super
  end

  def set_name
    print "Player #{@@humans}, Please enter your name: "
    self.name = validate_name
  end

  def hit?(move)
    move == 'h'
  end

  def stay?(move)
    move == 's'
  end
end

class Computer < Player
  NAMES = %w( Max Calvin Pietro Sam Shiela Denise Carol Jenny
              Belladonna Cleopatra Carl )

  private

  def set_name
    NAMES.sample
  end
end

class Dealer < Player
  NAMES = %w( James Arthur Taylor John
              Sally Kim Carry Jessie Chrissa
              Clamtrop Claptrap Rose Dorothy Sophia Blanche)

  attr_reader :deck

  def initialize
    super
    @deck = Deck.new
    deck.shuffle!
  end

  def set_name
    NAMES.sample
  end

  def deal(player, num_cards)
    num_cards.times do
      restock if deck.empty?
      player.hand << deck.draw
    end
  end

  def restock
    deck.reset
    deck.shuffle!
  end
end

class Score
  attr_reader :scores

  def initialize
    @scores = Hash.new do |hash, key|
      hash[key] = { won: 0, lost: 0, tied: 0, bust: 0 }
    end
  end

  # rubocop:disable Metrics/AbcSize
  def add(players, winners, losers, tiers)
    players.each do |player|
      scores[player][:won]  += 1 if winners.include?(player.name)
      scores[player][:lost] += 1 if losers.include?(player.name)
      scores[player][:tied] += 1 if tiers.include?(player.name)
      scores[player][:bust] += 1 if player.busted?
    end
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Layout/LineLength
  def to_s
    board_size = 20
    line = '-' * board_size
    puts line
    puts "Score".center(board_size)
    scores.each do |player, score|
      puts line
      puts player
      puts "Won: ".rjust(8)  + score[:won].to_s
      puts "Lost: ".rjust(8) + score[:lost].to_s
      puts "Tied: ".rjust(8) + score[:tied].to_s
      puts "Win Rate: " + (score[:won].fdiv(score.values[0, 3].sum) * 100).ceil.to_s + "%"
      puts "Total Rounds: " + score.values[0, 3].sum.to_s
      puts "TIMES BUSTED: " + score[:bust].to_s
    end
    line
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Layout/LineLength
end

class TwentyOne
  include Validatable, Displayable

  def initialize
    @players = []
    @dealer = Dealer.new
    @score = Score.new
  end

  def play
    display_welcome_message
    set_players
    main_game
    clear_and_display_score
    display_goodbye_message
  end

  private

  attr_accessor :players, :dealer, :score, :first_show

  def main_game
    loop do
      reset
      deal_all
      show_cards
      take_turns
      determine_winners
      display_score
      break unless play_again?
    end
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    answer = yes_or_no
    answer == 'y'
  end

  def determine_winners
    winners = players_won
    losers = players_lost
    tiers = players_tied
    display_results(winners, losers, tiers)
    puts "The House Wins..." if losers.size == players.size
    score.add(players, winners, losers, tiers)
  end

  def players_won
    players.select do |player|
      dealer.busted? && !player.busted? ||
        player.evaluate_hand > dealer.evaluate_hand &&
          !player.busted?
    end.map(&:name)
  end

  def players_lost
    players.select do |player|
      player.busted? ||
        player.evaluate_hand < dealer.evaluate_hand &&
          !dealer.busted?
    end.map(&:name)
  end

  def players_tied
    players.select do |player|
      !player.busted? && player.evaluate_hand == dealer.evaluate_hand
    end.map(&:name)
  end

  def reset
    dealer.toss_cards
    players.each(&:toss_cards)
    self.first_show = true
  end

  def prep_card_display(hand)
    hand.map(&:image).transpose.map(&:join)
  end

  def take_turns
    player_turns
    dealer_turn
  end

  def player_turns
    players.each do |player|
      take_turn(player)
      display_busted(player) if player.busted?
    end
    self.first_show = false if first_show
  end

  def take_turn(player)
    if player.is_a? Computer
      automate_turn(player)
    else
      player_decide(player)
    end
  end

  def player_decide(player)
    loop do
      puts "#{player}'s turn."
      move = hit_or_stay
      dealer.deal(player, 1) if player.hit?(move)
      show_cards
      break if player.stay?(move) || player.busted?
    end
  end

  def automate_turn(player)
    until player.evaluate_hand >= 17 || player.busted?
      dealer.deal(player, 1)
      show_cards
    end
  end

  def dealer_turn
    all_bust = players.all?(&:busted?)
    unless all_bust
      automate_turn(dealer)
    end
    show_cards
  end

  def set_players
    humans = set_humans
    computers = set_computers
    if humans + computers == 0
      puts "We need at least one player to play."
      set_players
    end
    humans.times { players << Human.new }
    computers.times { players << Computer.new }
  end

  def set_humans
    humans = nil
    loop do
      puts "How many humans will be playing today?"
      input = gets.chomp
      if number?(input) && input.to_i >= 0
        break humans = input.to_i
      end
      puts "Please input a number greater than or equal to 0"
    end
    humans
  end

  def set_computers
    computers = nil
    loop do
      puts "Would you like to add additional computer players?"
      input = gets.chomp
      if number?(input) && input.to_i >= 0
        break computers = input.to_i
      end
      puts "Please input a number greater than or equal to 0"
    end
    computers
  end

  def deal_all
    participants = players + [dealer]
    participants.each do |player|
      dealer.deal(player, 2)
    end
  end
end

twenty_one = TwentyOne.new
twenty_one.play
