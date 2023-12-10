require_relative("/Users/blakeastley/Projects/advent_of_code/ruby/runner.rb")
require("byebug")

runner = Runner.new
runner.add_test(:part_one, expected: 6, skip: false, input: <<~MSG)
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
MSG

runner.add_test(:part_two, expected: 6, skip: false, input: <<~MSG)
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
MSG

module Solution
  module_function

  class Node
    def self.parse(string)
      id, args = string.split(" = ")
      left, right = args[1...-1].split(", ")
      new(id, left, right)
    end

    attr_reader :id, :left, :right
    attr_accessor :steps_taken
    def initialize(id, left, right)
      @id = id
      @left = left
      @right = right
      @path = []
      @steps_taken = nil
    end

    def has_seen_end?
      @path.any? { _1[-1] == "Z" }
    end

    def is_start_node?
      @id[-1] == "A"
    end

    def is_end_node?
      @id[-1] == "Z"
    end
  end

  def part_one(raw_input)
    instructions, nodes = parse(raw_input)
    nodes = nodes.split("\n").map { Node.parse(_1) }
    current_node = nodes.detect { _1.id == "AAA" }
    steps = 0
    while current_node.id != "ZZZ"
      direction = instructions[steps % instructions.length]
      next_node_id =
        case direction
        when "L"
          current_node.left
        when "R"
          current_node.right
        end
      next_node = nodes.detect { _1.id == next_node_id }
      current_node = next_node
      steps += 1
    end
    steps
  end

  def part_two(raw_input)
    instructions, nodes = parse(raw_input)
    nodes = nodes.split("\n").map { Node.parse(_1) }
    start_nodes = nodes.select { _1.is_start_node? }
    start_nodes.each do |start_node|
      steps = 0

      current_node = start_node
      while start_node.steps_taken == nil
        if current_node.is_end_node?
          start_node.steps_taken = steps
        end

        direction = instructions[steps % instructions.length]
        next_node_id =
          case direction
          when "L"
            current_node.left
          when "R"
            current_node.right
          end
        next_node = nodes.detect { _1.id == next_node_id }
        current_node = next_node
        steps += 1
      end
    end

    start_nodes.map { _1.steps_taken }.reduce(1, :lcm)
  end

  def parse(input)
    input.split("\n\n")
  end
end

# Part One Description
# --- Day 8: Haunted Wasteland ---
# You're still riding a camel across Desert Island when you spot a sandstorm
# quickly approaching. When you turn to warn the Elf, she disappears before your
# eyes! To be fair, she had just finished warning you about ghosts a few minutes
# ago.
#
# One of the camel's pouches is labeled "maps" - sure enough, it's full of
# documents (your puzzle input) about how to navigate the desert. At least, you're
# pretty sure that's what they are; one of the documents contains a list of
# left/right instructions, and the rest of the documents seem to describe some
# kind of network of labeled nodes.
#
# It seems like you're meant to use the left/right instructions to navigate the
# network. Perhaps if you have the camel follow the same instructions, you can
# escape the haunted wasteland!
#
# After examining the maps for a bit, two nodes stick out: AAA and ZZZ. You feel
# like AAA is where you are now, and you have to follow the left/right
# instructions until you reach ZZZ.
#
# This format defines each node of the network individually. For example:
#
# RL
#
# AAA = (BBB, CCC)
# BBB = (DDD, EEE)
# CCC = (ZZZ, GGG)
# DDD = (DDD, DDD)
# EEE = (EEE, EEE)
# GGG = (GGG, GGG)
# ZZZ = (ZZZ, ZZZ)
#
# Starting with AAA, you need to look up the next element based on the next
# left/right instruction in your input. In this example, start with AAA and go
# right (R) by choosing the right element of AAA, CCC. Then, L means to choose the
# left element of CCC, ZZZ. By following the left/right instructions, you reach
# ZZZ in 2 steps.
#
# Of course, you might not find ZZZ right away. If you run out of left/right
# instructions, repeat the whole sequence of instructions as necessary: RL really
# means RLRLRLRLRLRLRLRL... and so on. For example, here is a situation that takes
# 6 steps to reach ZZZ:
#
# LLR
#
# AAA = (BBB, BBB)
# BBB = (AAA, ZZZ)
# ZZZ = (ZZZ, ZZZ)
#
# Starting at AAA, follow the left/right instructions. How many steps are
# required to reach ZZZ?

input = File.read(__FILE__.gsub("main.rb", "input.txt"))

runner.run!(input)
