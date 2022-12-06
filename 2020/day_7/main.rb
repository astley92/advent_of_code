##### Part One Description #####
# --- Day 7: Handy Haversacks ---
# You land at the regional airport in time for your next flight. In fact, it
# looks like you'll even have time to grab some food: all flights are currently
# delayed due to issues in luggage processing.
#
# Due to recent aviation regulations, many rules (your puzzle input) are being
# enforced about bags and their contents; bags must be color-coded and must
# contain specific quantities of other color-coded bags. Apparently, nobody
# responsible for these regulations considered how long they would take to
# enforce!
#
# For example, consider the following rules:
#
# light red bags contain 1 bright white bag, 2 muted yellow bags.
# dark orange bags contain 3 bright white bags, 4 muted yellow bags.
# bright white bags contain 1 shiny gold bag.
# muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
# shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
# dark olive bags contain 3 faded blue bags, 4 dotted black bags.
# vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
# faded blue bags contain no other bags.
# dotted black bags contain no other bags.
#
# These rules specify the required contents for 9 bag types. In this example,
# every faded blue bag is empty, every vibrant plum bag contains 11 bags (5 faded
# blue and 6 dotted black), and so on.
#
# You have a shiny gold bag. If you wanted to carry it in at least one other bag,
# how many different bag colors would be valid for the outermost bag? (In other
# words: how many colors can, eventually, contain at least one shiny gold bag?)
#
# In the above rules, the following options would be available to you:
#
#
# A bright white bag, which can hold your shiny gold bag directly.
# A muted yellow bag, which can hold your shiny gold bag directly, plus some
# other bags.
# A dark orange bag, which can hold bright white and muted yellow bags, either of
# which could then hold your shiny gold bag.
# A light red bag, which can hold bright white and muted yellow bags, either of
# which could then hold your shiny gold bag.
#
# So, in this example, the number of bag colors that can eventually contain at
# least one shiny gold bag is 4.
#
# How many bag colors can eventually contain at least one shiny gold bag? (The
# list of rules is quite long; make sure you get all of it.)

require "byebug"
class Bag
  attr_reader :colour, :child_bags
  def initialize(colour:)
    @colour = colour
    @child_bags = []
  end

  def add_child(other)
    @child_bags << (other)
  end

  def leads_to_gold?
    return true if child_bags.any? { _1.colour == "shiny gold" }
    return false if child_bags.empty?

    child_bags
      .uniq { _1.colour }
      .any? { _1.leads_to_gold? }
  end

  def count_contents
    child_bags.count + child_bags.map { _1.count_contents }.sum
  end
end

class Solution
  attr_accessor :input
  def initialize(input)
    @input = input
  end

  def self.run!(input)
    solution = new(parse_input(input))
    <<~MSG
      Part One: #{solution.part_one!}
      Part Two: #{solution.part_two!}
    MSG
  end

  def self.parse_input(input)
    # Parse input
    bag_list = []
    input.split("\n").map do |line|
      current, others = line.split(/ contain /).map { _1.gsub(/(bags|\.)/, "").strip }

      bag = bag_list.detect { _1.colour == current }
      if bag.nil?
        bag = Bag.new(colour: current.strip)
        bag_list << bag
      end

      next if others.include?("no other")

      others.split(", ").each do |bag_string|
        count = bag_string.split(" ").first.to_i
        colour = bag_string.split(" ")[1..2].join(" ")
        other_bag = bag_list.detect { _1.colour == colour }
        if other_bag.nil?
          other_bag = Bag.new(colour: colour)
          bag_list << other_bag
        end
        count.times do
          bag.add_child(other_bag)
        end
      end
    end
    bag_list
  end

  def part_one!
    input
      .select { _1.leads_to_gold? }
      .count
  end

  def part_two!
    input
      .detect { _1.colour == "shiny gold" }
      .count_contents
  end
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
puts Solution.run!(input)
