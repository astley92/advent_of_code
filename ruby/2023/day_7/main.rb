require_relative("/Users/blakeastley/Projects/advent_of_code/ruby/runner.rb")
require("byebug")

runner = Runner.new
runner.add_test(:part_one, expected: 6440, skip: false, input: <<~MSG)
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
MSG

runner.add_test(:part_two, expected: 5905, skip: false, input: <<~MSG)
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
MSG

module Solution
  module_function

  def part_one(raw_input)
    hands = parse(raw_input)
    sorted_hands = hands.sort_by { [_1.type_strength, _1.secondary_strength] }
    sorted_hands.map.with_index do |hand, rank|
      hand.bid * (rank + 1)
    end.sum
  end

  def part_two(raw_input)
    hands = parse(raw_input)
    sorted_hands = hands.sort_by { [_1.optimal_type_strength, _1.secondary_strength(jacks_lowest: true)] }
    sorted_hands.map.with_index do |hand, rank|
      hand.bid * (rank + 1)
    end.sum
  end

  def parse(input)
    input.split("\n").map { Hand.parse(_1) }
  end

  class Hand
    HAND_TYPE_TO_STRNGTH_MAP = {
      high_card: 1,
      one_pair: 2,
      two_pair: 3,
      three_of_a_kind: 4,
      full_house: 5,
      four_of_a_kind: 6,
      five_of_a_kind: 7,
    }

    def self.parse(string)
      cards, bid = string.split(" ")
      new(
        cards: cards.chars.map { Card.parse(_1) },
        bid: bid.to_i
      )
    end

    attr_reader :bid
    def initialize(cards:, bid:)
      @cards = cards
      @bid = bid
      @type = determine_hand_type
    end

    def type_strength
      HAND_TYPE_TO_STRNGTH_MAP.fetch(@type)
    end

    def secondary_strength(jacks_lowest: false)
      @cards.map { _1.individual_strength(jacks_lowest: jacks_lowest).to_s }.join.to_i
    end

    def to_s
      @cards.map(&:representation).join
    end

    def optimal_type_strength
      return type_strength unless @cards.any? { _1.is_jack? }

      best = -1
      Card::CARD_TO_STRNGTH_MAP.keys.each do |char|
        temporary_replace_jacks(char) do

          new_score = HAND_TYPE_TO_STRNGTH_MAP.fetch(determine_hand_type)
          if new_score > best
            best = new_score
          end
        end
      end
      best
    end

    private

    def temporary_replace_jacks(char)
      jacks = @cards.select { _1.is_jack? }
      jacks.each { _1.representation = char }
      yield
      jacks.each { _1.representation = "J" }
    end

    def determine_hand_type
      uniq_counts = @cards.map(&:representation).tally.values.sort
      case uniq_counts
      when [1,1,1,2]
        :one_pair
      when [1,1,3]
        :three_of_a_kind
      when [1,2,2]
        :two_pair
      when [2, 3]
        :full_house
      when [1, 4]
        :four_of_a_kind
      when [5]
        :five_of_a_kind
      when [1,1,1,1,1]
        :high_card
      else
        raise NotImplementedError, "Unknown card tally #{uniq_counts.inspect}"
      end
    end
  end

  class Card
    CARD_TO_STRNGTH_MAP = {
      "2" => 101,
      "3" => 102,
      "4" => 103,
      "5" => 104,
      "6" => 105,
      "7" => 106,
      "8" => 107,
      "9" => 108,
      "T" => 109,
      "J" => 110,
      "Q" => 111,
      "K" => 112,
      "A" => 113,
    }

    def self.parse(char)
      new(representation: char)
    end

    attr_accessor :representation
    def initialize(representation:)
      @representation = representation
    end

    def individual_strength(jacks_lowest: false)
      if jacks_lowest && representation == "J"
        100
      else
        CARD_TO_STRNGTH_MAP.fetch(representation)
      end
    end

    def is_jack?
      @representation == "J"
    end
  end
end

# Part One Description
# --- Day 7: Camel Cards ---
# Your all-expenses-paid trip turns out to be a one-way, five-minute ride in an
# airship. (At least it's a cool airship!) It drops you off at the edge of a vast
# desert and descends back to Island Island.
#
# "Did you bring the parts?"
#
# You turn around to see an Elf completely covered in white clothing, wearing
# goggles, and riding a large camel.
#
# "Did you bring the parts?" she asks again, louder this time. You aren't sure
# what parts she's looking for; you're here to figure out why the sand stopped.
#
# "The parts! For the sand, yes! Come with me; I will show you." She beckons you
# onto the camel.
#
# After riding a bit across the sands of Desert Island, you can see what look
# like very large rocks covering half of the horizon. The Elf explains that the
# rocks are all along the part of Desert Island that is directly above Island
# Island, making it hard to even get there. Normally, they use big machines to
# move the rocks and filter the sand, but the machines have broken down because
# Desert Island recently stopped receiving the parts they need to fix the
# machines.
#
# You've already assumed it'll be your job to figure out why the parts stopped
# when she asks if you can help. You agree automatically.
#
# Because the journey will take a few days, she offers to teach you the game of
# Camel Cards. Camel Cards is sort of similar to poker except it's designed to be
# easier to play while riding a camel.
#
# In Camel Cards, you get a list of hands, and your goal is to order them based
# on the strength of each hand. A hand consists of five cards labeled one of A, K,
# Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2. The relative strength of each card follows
# this order, where A is the highest and 2 is the lowest.
#
# Every hand is exactly one type. From strongest to weakest, they are:
#
#
# Five of a kind, where all five cards have the same label: AAAAA
# Four of a kind, where four cards have the same label and one card has a
# different label: AA8AA
# Full house, where three cards have the same label, and the remaining two cards
# share a different label: 23332
# Three of a kind, where three cards have the same label, and the remaining two
# cards are each different from any other card in the hand: TTT98
# Two pair, where two cards share one label, two other cards share a second
# label, and the remaining card has a third label: 23432
# One pair, where two cards share one label, and the other three cards have a
# different label from the pair and each other: A23A4
# High card, where all cards' labels are distinct: 23456
#
# Hands are primarily ordered based on type; for example, every full house is
# stronger than any three of a kind.
#
# If two hands have the same type, a second ordering rule takes effect. Start by
# comparing the first card in each hand. If these cards are different, the hand
# with the stronger first card is considered stronger. If the first card in each
# hand have the same label, however, then move on to considering the second card
# in each hand. If they differ, the hand with the higher second card wins;
# otherwise, continue with the third card in each hand, then the fourth, then the
# fifth.
#
# So, 33332 and 2AAAA are both four of a kind hands, but 33332 is stronger
# because its first card is stronger. Similarly, 77888 and 77788 are both a full
# house, but 77888 is stronger because its third card is stronger (and both hands
# have the same first and second card).
#
# To play Camel Cards, you are given a list of hands and their corresponding bid
# (your puzzle input). For example:
#
# 32T3K 765
# T55J5 684
# KK677 28
# KTJJT 220
# QQQJA 483
#
# This example shows five hands; each hand is followed by its bid amount. Each
# hand wins an amount equal to its bid multiplied by its rank, where the weakest
# hand gets rank 1, the second-weakest hand gets rank 2, and so on up to the
# strongest hand. Because there are five hands in this example, the strongest hand
# will have rank 5 and its bid will be multiplied by 5.
#
# So, the first step is to put the hands in order of strength:
#
#
# 32T3K is the only one pair and the other hands are all a stronger type, so it
# gets rank 1.
# KK677 and KTJJT are both two pair. Their first cards both have the same label,
# but the second card of KK677 is stronger (K vs T), so KTJJT gets rank 2 and
# KK677 gets rank 3.
# T55J5 and QQQJA are both three of a kind. QQQJA has a stronger first card, so
# it gets rank 5 and T55J5 gets rank 4.
#
# Now, you can determine the total winnings of this set of hands by adding up the
# result of multiplying each hand's bid with its rank (765 * 1 + 220 * 2 + 28 * 3
# + 684 * 4 + 483 * 5). So the total winnings in this example are 6440.
#
# Find the rank of every hand in your set. What are the total winnings?

input = File.read(__FILE__.gsub("main.rb", "input.txt"))

runner.run!(input)
