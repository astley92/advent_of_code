##### Part One Description #####
# --- Day 16: Proboscidea Volcanium ---
# The sensors have led you to the origin of the distress signal: yet another
# handheld device, just like the one the Elves gave you. However, you don't see
# any Elves around; instead, the device is surrounded by elephants! They must have
# gotten lost in these tunnels, and one of the elephants apparently figured out
# how to turn on the distress signal.
#
# The ground rumbles again, much stronger this time. What kind of cave is this,
# exactly? You scan the cave with your handheld device; it reports mostly igneous
# rock, some ash, pockets of pressurized gas, magma... this isn't just a cave,
# it's a volcano!
#
# You need to get the elephants out of here, quickly. Your device estimates that
# you have 30 minutes before the volcano erupts, so you don't have time to go back
# out the way you came in.
#
# You scan the cave for other options and discover a network of pipes and
# pressure-release valves. You aren't sure how such a system got into a volcano,
# but you don't have time to complain; your device produces a report (your puzzle
# input) of each valve's flow rate if it were opened (in pressure per minute) and
# the tunnels you could use to move between the valves.
#
# There's even a valve in the room you and the elephants are currently standing
# in labeled AA. You estimate it will take you one minute to open a single valve
# and one minute to follow any tunnel from one valve to another. What is the most
# pressure you could release?
#
# For example, suppose you had the following scan output:
#
# Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
# Valve BB has flow rate=13; tunnels lead to valves CC, AA
# Valve CC has flow rate=2; tunnels lead to valves DD, BB
# Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
# Valve EE has flow rate=3; tunnels lead to valves FF, DD
# Valve FF has flow rate=0; tunnels lead to valves EE, GG
# Valve GG has flow rate=0; tunnels lead to valves FF, HH
# Valve HH has flow rate=22; tunnel leads to valve GG
# Valve II has flow rate=0; tunnels lead to valves AA, JJ
# Valve JJ has flow rate=21; tunnel leads to valve II
#
# All of the valves begin closed. You start at valve AA, but it must be damaged
# or jammed or something: its flow rate is 0, so there's no point in opening it.
# However, you could spend one minute moving to valve BB and another minute
# opening it; doing so would release pressure during the remaining 28 minutes at a
# flow rate of 13, a total eventual pressure release of 28 * 13 = 364. Then, you
# could spend your third minute moving to valve CC and your fourth minute opening
# it, providing an additional 26 minutes of eventual pressure release at a flow
# rate of 2, or 52 total pressure released by valve CC.
#
# Making your way through the tunnels like this, you could probably open many or
# all of the valves by the time 30 minutes have elapsed. However, you need to
# release as much pressure as possible, so you'll need to be methodical. Instead,
# consider this approach:
#
# == Minute 1 ==
# No valves are open.
# You move to valve DD.
#
# == Minute 2 ==
# No valves are open.
# You open valve DD.
#
# == Minute 3 ==
# Valve DD is open, releasing 20 pressure.
# You move to valve CC.
#
# == Minute 4 ==
# Valve DD is open, releasing 20 pressure.
# You move to valve BB.
#
# == Minute 5 ==
# Valve DD is open, releasing 20 pressure.
# You open valve BB.
#
# == Minute 6 ==
# Valves BB and DD are open, releasing 33 pressure.
# You move to valve AA.
#
# == Minute 7 ==
# Valves BB and DD are open, releasing 33 pressure.
# You move to valve II.
#
# == Minute 8 ==
# Valves BB and DD are open, releasing 33 pressure.
# You move to valve JJ.
#
# == Minute 9 ==
# Valves BB and DD are open, releasing 33 pressure.
# You open valve JJ.
#
# == Minute 10 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve II.
#
# == Minute 11 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve AA.
#
# == Minute 12 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve DD.
#
# == Minute 13 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve EE.
#
# == Minute 14 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve FF.
#
# == Minute 15 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve GG.
#
# == Minute 16 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve HH.
#
# == Minute 17 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You open valve HH.
#
# == Minute 18 ==
# Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
# You move to valve GG.
#
# == Minute 19 ==
# Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
# You move to valve FF.
#
# == Minute 20 ==
# Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
# You move to valve EE.
#
# == Minute 21 ==
# Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
# You open valve EE.
#
# == Minute 22 ==
# Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
# You move to valve DD.
#
# == Minute 23 ==
# Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
# You move to valve CC.
#
# == Minute 24 ==
# Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
# You open valve CC.
#
# == Minute 25 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
#
# == Minute 26 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
#
# == Minute 27 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
#
# == Minute 28 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
#
# == Minute 29 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
#
# == Minute 30 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
#
# This approach lets you release the most pressure possible in 30 minutes with
# this valve layout, 1651.
#
# Work out the steps to release the most pressure in 30 minutes. What is the most
# pressure you can release?
require "byebug"

class Valve
  attr_reader :name, :adjoining_valves, :flow_rate
  def initialize(name:, flow_rate: nil, parent: nil)
    @name = name
    @flow_rate = flow_rate
    @parent = parent
    @adjoining_valves = []
  end

  def add_adjoining_valve(valve)
    @adjoining_valves << valve
  end

  def set_flow_rate(rate)
    @flow_rate = rate
  end
end

def self.parse_input(input)
  # Parse input
  valves = []
  input.split("\n").map do |line|
    flow_rate_details, tunnels = line.split(";")

    name = flow_rate_details.scan(/[A-Z]{2}/).first
    flow_rate = flow_rate_details.scan(/\d+/).first.to_i
    current_valve = valves.detect { _1.name == name }

    if current_valve
      current_valve.set_flow_rate(flow_rate)
    else
      current_valve = Valve.new(
        name: name,
        flow_rate: flow_rate,
      )
      valves << current_valve
    end
    tunnels.scan(/[A-Z]{2}/).each do |other|
      current_valve.add_adjoining_valve(other)
    end
  end
  valves
end

class Walk
  attr_reader :current_valve, :open_valves, :released_pressure, :visited

  def initialize(current_valve:, all_valves:, open_valves: [], released_pressure: 0, visited: [], other_valve: nil)
    @current_valve = current_valve
    @other_valve = other_valve
    @all_valves = all_valves
    @open_valves = open_valves
    @released_pressure = released_pressure
    @visited = visited
  end

  def release_pressure
    @open_valves.each { @released_pressure += _1.flow_rate }
  end

  def branches
    res = []
    # Open current valve
    if !@open_valves.include?(@current_valve) && @current_valve.flow_rate > 0
      res << {
        current_valve: @current_valve,
        open_valves: @open_valves + [@current_valve],
        released_pressure: @released_pressure,
        all_valves: @all_valves,
        visited: @visited + [@current_valve],
      }
    end

    # Walk to each adjoining valve
    @current_valve.adjoining_valves.each do |valve_name|
      next_valve = @all_valves.detect { _1.name == valve_name }

      res << {
        current_valve: next_valve,
        open_valves: @open_valves,
        released_pressure: @released_pressure,
        all_valves: @all_valves,
        visited: @visited + [@current_valve],
      }
    end
    res
  end

  def branches_for_part_two
    res = []
    # Open current valve
    current_valve_options = @current_valve.adjoining_valves.map { |valve_name| @all_valves.detect { |valve| valve.name == valve_name } }
    other_valve_options = @other_valve.adjoining_valves.map { |valve_name| @all_valves.detect { |valve| valve.name == valve_name } }
    if !@open_valves.include?(@current_valve) && @current_valve.flow_rate > 0
      other_valve_options.each do |other_valve|
        res << {
          current_valve: @current_valve,
          other_valve: other_valve,
          open_valves: @open_valves + [@current_valve],
          released_pressure: @released_pressure,
          all_valves: @all_valves,
          visited: @visited + [@current_valve],
        }
      end
    end

    if (!@open_valves.include?(@current_valve) && @current_valve.flow_rate > 0) && (!@open_valves.include?(@other_valve) && @other_valve.flow_rate > 0) && @other_valve != @current_valve
      res << {
        current_valve: @current_valve,
        other_valve: @other_valve,
        open_valves: @open_valves + [@current_valve] + [@other_valve],
        released_pressure: @released_pressure,
        all_valves: @all_valves,
        visited: @visited + [@current_valve],
      }
    end

    if !@open_valves.include?(@other_valve) && @other_valve.flow_rate > 0
      current_valve_options.each do |next_valve|
        res << {
          current_valve: next_valve,
          other_valve: @other_valve,
          open_valves: @open_valves + [@other_valve],
          released_pressure: @released_pressure,
          all_valves: @all_valves,
          visited: @visited + [@current_valve],
        }
      end
    end

    # Walk to each adjoining valve
    current_valve_options.each do |next_valve|
      other_valve_options.each do |next_other_valve|
        res << {
          current_valve: next_valve,
          other_valve: next_other_valve,
          open_valves: @open_valves,
          released_pressure: @released_pressure,
          all_valves: @all_valves,
          visited: @visited + [@current_valve],
        }
      end
    end
    res
  end

  def fully_explored?(valve)
    (valve.adjoining_valves.all? { @visited.map(&:name).include? _1 }) && (@visited.include? valve)
  end

  def inspect
    "\nOpen Valves#{@open_valves.map(&:name)}\nReleased each minute: #{@open_valves.map(&:flow_rate).sum}\nPath: #{@visited.map(&:name)}"
  end
end

def part_one(input)
  time_left = 30
  start = input.detect { _1.name == "AA" }
  walks = [Walk.new(current_valve: start, all_valves: input)]
  while time_left > 0
    time_left -= 1
    bw = walks.max_by { _1.open_valves.map(&:flow_rate).sum }
    next_walks = []
    walks.each(&:release_pressure)
    while walks.any?
      w = walks.pop
      branches = w.branches
      if branches.count == 0
        next_walks << w
      end
      branches.each { next_walks << Walk.new(**_1) }
    end
    walks = next_walks
    if walks.count > 10_000
      walks = walks.sort_by { _1.released_pressure }[-10_000..]
    end
  end
  walks.max_by { _1.released_pressure }.released_pressure
end

def part_two(input)
  time_left = 26
  start = input.detect { _1.name == "AA" }
  useful_valves = input.select { _1.flow_rate > 0 }
  walks = [Walk.new(current_valve: start, other_valve: start, all_valves: input)]
  while time_left > 0
    time_left -= 1
    bw = walks.max_by { _1.open_valves.map(&:flow_rate).sum }
    next_walks = []
    walks.each(&:release_pressure)
    best_walk = walks.max_by { _1.released_pressure }
    next if useful_valves.all? { |valve| best_walk.open_valves.include?(valve) }

    while walks.any?
      w = walks.pop
      branches = w.branches_for_part_two
      if branches.count == 0
        next_walks << w
      end
      branches.each { next_walks << Walk.new(**_1) }
    end
    walks = next_walks
    if walks.count > 10_000
      walks = walks.sort_by { _1.released_pressure }[-10_000..]
    end
  end
  walks.max_by { _1.released_pressure }.released_pressure
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
puts "Part One: #{part_one(parse_input(input))}"
puts "Part Two: #{part_two(parse_input(input))}"
