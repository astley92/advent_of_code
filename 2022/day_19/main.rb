##### Part One Description #####
# --- Day 19: Not Enough Minerals ---
# Your scans show that the lava did indeed form obsidian!
#
# The wind has changed direction enough to stop sending lava droplets toward you,
# so you and the elephants exit the cave. As you do, you notice a collection of
# geodes around the pond. Perhaps you could use the obsidian to create some
# geode-cracking robots and break them open?
#
# To collect the obsidian from the bottom of the pond, you'll need waterproof
# obsidian-collecting robots. Fortunately, there is an abundant amount of clay
# nearby that you can use to make them waterproof.
#
# In order to harvest the clay, you'll need special-purpose clay-collecting
# robots. To make any type of robot, you'll need ore, which is also plentiful but
# in the opposite direction from the clay.
#
# Collecting ore requires ore-collecting robots with big drills. Fortunately, you
# have exactly one ore-collecting robot in your pack that you can use to kickstart
# the whole operation.
#
# Each robot can collect 1 of its resource type per minute. It also takes one
# minute for the robot factory (also conveniently from your pack) to construct any
# type of robot, although it consumes the necessary resources available when
# construction begins.
#
# The robot factory has many blueprints (your puzzle input) you can choose from,
# but once you've configured it with a blueprint, you can't change it. You'll need
# to work out which blueprint is best.
#
# For example:
#
# Blueprint 1:
#   Each ore robot costs 4 ore.
#   Each clay robot costs 2 ore.
#   Each obsidian robot costs 3 ore and 14 clay.
#   Each geode robot costs 2 ore and 7 obsidian.
#
# Blueprint 2:
#   Each ore robot costs 2 ore.
#   Each clay robot costs 3 ore.
#   Each obsidian robot costs 3 ore and 8 clay.
#   Each geode robot costs 3 ore and 12 obsidian.
#
# (Blueprints have been line-wrapped here for legibility. The robot factory's
# actual assortment of blueprints are provided one blueprint per line.)
#
# The elephants are starting to look hungry, so you shouldn't take too long; you
# need to figure out which blueprint would maximize the number of opened geodes
# after 24 minutes by figuring out which robots to build and when to build them.
#
# Using blueprint 1 in the example above, the largest number of geodes you could
# open in 24 minutes is 9. One way to achieve that is:
#
# == Minute 1 ==
# 1 ore-collecting robot collects 1 ore; you now have 1 ore.
#
# == Minute 2 ==
# 1 ore-collecting robot collects 1 ore; you now have 2 ore.
#
# == Minute 3 ==
# Spend 2 ore to start building a clay-collecting robot.
# 1 ore-collecting robot collects 1 ore; you now have 1 ore.
# The new clay-collecting robot is ready; you now have 1 of them.
#
# == Minute 4 ==
# 1 ore-collecting robot collects 1 ore; you now have 2 ore.
# 1 clay-collecting robot collects 1 clay; you now have 1 clay.
#
# == Minute 5 ==
# Spend 2 ore to start building a clay-collecting robot.
# 1 ore-collecting robot collects 1 ore; you now have 1 ore.
# 1 clay-collecting robot collects 1 clay; you now have 2 clay.
# The new clay-collecting robot is ready; you now have 2 of them.
#
# == Minute 6 ==
# 1 ore-collecting robot collects 1 ore; you now have 2 ore.
# 2 clay-collecting robots collect 2 clay; you now have 4 clay.
#
# == Minute 7 ==
# Spend 2 ore to start building a clay-collecting robot.
# 1 ore-collecting robot collects 1 ore; you now have 1 ore.
# 2 clay-collecting robots collect 2 clay; you now have 6 clay.
# The new clay-collecting robot is ready; you now have 3 of them.
#
# == Minute 8 ==
# 1 ore-collecting robot collects 1 ore; you now have 2 ore.
# 3 clay-collecting robots collect 3 clay; you now have 9 clay.
#
# == Minute 9 ==
# 1 ore-collecting robot collects 1 ore; you now have 3 ore.
# 3 clay-collecting robots collect 3 clay; you now have 12 clay.
#
# == Minute 10 ==
# 1 ore-collecting robot collects 1 ore; you now have 4 ore.
# 3 clay-collecting robots collect 3 clay; you now have 15 clay.
#
# == Minute 11 ==
# Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
# 1 ore-collecting robot collects 1 ore; you now have 2 ore.
# 3 clay-collecting robots collect 3 clay; you now have 4 clay.
# The new obsidian-collecting robot is ready; you now have 1 of them.
#
# == Minute 12 ==
# Spend 2 ore to start building a clay-collecting robot.
# 1 ore-collecting robot collects 1 ore; you now have 1 ore.
# 3 clay-collecting robots collect 3 clay; you now have 7 clay.
# 1 obsidian-collecting robot collects 1 obsidian; you now have 1 obsidian.
# The new clay-collecting robot is ready; you now have 4 of them.
#
# == Minute 13 ==
# 1 ore-collecting robot collects 1 ore; you now have 2 ore.
# 4 clay-collecting robots collect 4 clay; you now have 11 clay.
# 1 obsidian-collecting robot collects 1 obsidian; you now have 2 obsidian.
#
# == Minute 14 ==
# 1 ore-collecting robot collects 1 ore; you now have 3 ore.
# 4 clay-collecting robots collect 4 clay; you now have 15 clay.
# 1 obsidian-collecting robot collects 1 obsidian; you now have 3 obsidian.
#
# == Minute 15 ==
# Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
# 1 ore-collecting robot collects 1 ore; you now have 1 ore.
# 4 clay-collecting robots collect 4 clay; you now have 5 clay.
# 1 obsidian-collecting robot collects 1 obsidian; you now have 4 obsidian.
# The new obsidian-collecting robot is ready; you now have 2 of them.
#
# == Minute 16 ==
# 1 ore-collecting robot collects 1 ore; you now have 2 ore.
# 4 clay-collecting robots collect 4 clay; you now have 9 clay.
# 2 obsidian-collecting robots collect 2 obsidian; you now have 6 obsidian.
#
# == Minute 17 ==
# 1 ore-collecting robot collects 1 ore; you now have 3 ore.
# 4 clay-collecting robots collect 4 clay; you now have 13 clay.
# 2 obsidian-collecting robots collect 2 obsidian; you now have 8 obsidian.
#
# == Minute 18 ==
# Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
# 1 ore-collecting robot collects 1 ore; you now have 2 ore.
# 4 clay-collecting robots collect 4 clay; you now have 17 clay.
# 2 obsidian-collecting robots collect 2 obsidian; you now have 3 obsidian.
# The new geode-cracking robot is ready; you now have 1 of them.
#
# == Minute 19 ==
# 1 ore-collecting robot collects 1 ore; you now have 3 ore.
# 4 clay-collecting robots collect 4 clay; you now have 21 clay.
# 2 obsidian-collecting robots collect 2 obsidian; you now have 5 obsidian.
# 1 geode-cracking robot cracks 1 geode; you now have 1 open geode.
#
# == Minute 20 ==
# 1 ore-collecting robot collects 1 ore; you now have 4 ore.
# 4 clay-collecting robots collect 4 clay; you now have 25 clay.
# 2 obsidian-collecting robots collect 2 obsidian; you now have 7 obsidian.
# 1 geode-cracking robot cracks 1 geode; you now have 2 open geodes.
#
# == Minute 21 ==
# Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
# 1 ore-collecting robot collects 1 ore; you now have 3 ore.
# 4 clay-collecting robots collect 4 clay; you now have 29 clay.
# 2 obsidian-collecting robots collect 2 obsidian; you now have 2 obsidian.
# 1 geode-cracking robot cracks 1 geode; you now have 3 open geodes.
# The new geode-cracking robot is ready; you now have 2 of them.
#
# == Minute 22 ==
# 1 ore-collecting robot collects 1 ore; you now have 4 ore.
# 4 clay-collecting robots collect 4 clay; you now have 33 clay.
# 2 obsidian-collecting robots collect 2 obsidian; you now have 4 obsidian.
# 2 geode-cracking robots crack 2 geodes; you now have 5 open geodes.
#
# == Minute 23 ==
# 1 ore-collecting robot collects 1 ore; you now have 5 ore.
# 4 clay-collecting robots collect 4 clay; you now have 37 clay.
# 2 obsidian-collecting robots collect 2 obsidian; you now have 6 obsidian.
# 2 geode-cracking robots crack 2 geodes; you now have 7 open geodes.
#
# == Minute 24 ==
# 1 ore-collecting robot collects 1 ore; you now have 6 ore.
# 4 clay-collecting robots collect 4 clay; you now have 41 clay.
# 2 obsidian-collecting robots collect 2 obsidian; you now have 8 obsidian.
# 2 geode-cracking robots crack 2 geodes; you now have 9 open geodes.
#
# However, by using blueprint 2 in the example above, you could do even better:
# the largest number of geodes you could open in 24 minutes is 12.
#
# Determine the quality level of each blueprint by multiplying that blueprint's
# ID number with the largest number of geodes that can be opened in 24 minutes
# using that blueprint. In this example, the first blueprint has ID 1 and can open
# 9 geodes, so its quality level is 9. The second blueprint has ID 2 and can open
# 12 geodes, so its quality level is 24. Finally, if you add up the quality levels
# of all of the blueprints in the list, you get 33.
#
# Determine the quality level of each blueprint using the largest number of
# geodes it could produce in 24 minutes. What do you get if you add up the quality
# level of all of the blueprints in your list?

require "byebug"

class Cost
  attr_reader :amount, :type
  def initialize(type, amount)
    @type = type
    @amount = amount
  end
end

class Robot
  attr_reader :type
  def initialize(type)
    @type = type
  end

  def dump_resource
    @type
  end
end

class RobotType
  attr_reader :type, :importance, :costs
  def initialize(type, importance)
    @type = type
    @importance = importance
    @costs = []
  end

  def add_cost(type, cost)
    @costs << Cost.new(type, cost)
  end

  def build
    Robot.new(type)
  end
end

class Blueprint
  attr_accessor :id
  attr_reader :robot_types
  def initialize
    @id = nil
    @robot_types = []
  end

  def create_new_robot_type(type, importance)
    robot_type = RobotType.new(type, importance)
    @robot_types << robot_type
    robot_type
  end

  def build_new_robot(type)
    costs = @robot_types.detect { _1.type == type }.costs
    robot = @robot_types.detect { _1.type == type }.build
    [costs, robot]
  end

  def all_robot_types
    @robot_types.map { _1.type }
  end

  def try_to_build_robot(type, resources)
    robot_type = @robot_types.detect { _1.type == type }
    if robot_type.costs.all? { |cost| resources[cost.type] && resources[cost.type] >= cost.amount }
      return [robot_type.costs, build_new_robot(type)]
    end
    [nil, nil]
  end

  def max_turn_spend_for(type)
    robot_types.flat_map { _1.costs }.select { _1.type == type }.map { _1.amount }.max
  end
end

def self.parse_input(input)
  blueprints = []
  input.split("\n").each do |blue_print_string|
    blueprint = Blueprint.new
    id_string, robot_cost_string = blue_print_string.split(":")

    blueprint.id = id_string.scan(/\d+/).first.to_i

    importance = 0
    robot_cost_string.split(". ").each do |cost_string|
      type_string, costs_string = cost_string.split(" robot costs ")
      robot_type = type_string.split(" ").last
      robot_type = blueprint.create_new_robot_type(robot_type, importance)

      costs_string.split(" and ").each do |cost_string|
        cost, type = cost_string.split(" ")
        robot_type.add_cost(type.gsub(/\W/, ""), cost.to_i)
      end
      importance += 1
    end
    blueprints << blueprint
  end
  blueprints
end

def part_one(input)
  quality_levels = []
  input.each do |blueprint|
    puts blueprint.id
    resources = {}
    robots = [blueprint.build_new_robot("ore")[1]]
    paths = [[resources, robots]]
    24.times do |i|
      new_paths = []

      while paths.any?
        resources, robots = paths.pop

        # Collect resources
        collected_resources = robots.map(&:dump_resource).to_a.tally
        new_paths << [add_resources(resources.dup, collected_resources), robots.dup]

        # Find afforable robots before collection
        affordable_robots = blueprint.all_robot_types.select do |robot_type|
          blueprint.try_to_build_robot(robot_type, resources) != [nil, nil]
        end

        affordable_robots.each do |type|
          next if robots.select { _1.type == type }.count >= blueprint.max_turn_spend_for(type)

          resources_after_this_build = resources.dup
          costs, new_robot = blueprint.build_new_robot(type)
          costs.each do |cost|
            resources_after_this_build[cost.type] -= cost.amount
          end

          new_paths << [add_resources(resources_after_this_build, collected_resources), robots + [new_robot]]
        end
      end

      paths = new_paths
    end
    best_path = paths.max_by { |resources, _| (resources["geode"] || 0) }
    quality_levels << (best_path[0]["geode"] || 0) * blueprint.id
  end
  quality_levels.sum
end

def part_two(input)
  # Solve part two
end

def add_resources(a, b)
  b.each do |type, amount|
    if a[type]
      a[type] += amount
    else
      a[type] = amount
    end
  end
  a
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
puts "Part One: #{part_one(parse_input(input))}"
puts "Part Two: #{part_two(parse_input(input))}"
