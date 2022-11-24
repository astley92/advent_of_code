require "byebug"

def fetch_input
  # TODO: Fix this monstrosity
  File.read((caller[-1].split(":")[0].split("/")[0..-2] + ["input.txt"]).join("/"))
end

class Entry
  def self.from_string(string)
    dirty_time_string, _, type = string.partition("] ")
    clean_time_string = dirty_time_string.scan(/[0-9\-\s:]{16}/).first
    time = Time.new(*clean_time_string.split(/[\-\s:]/).map(&:to_i))
    new(time: time, type: type)
  end

  attr_reader :time, :type
  def initialize(time:, type:)
    @time = time
    @type = type
  end
end

def fetch_guard_id(string)
  string.scan(/#\d*/).first.gsub("#", '').to_i
end

class Sleep
  attr_reader :guard_id, :start
  attr_accessor :end_time
  def initialize(guard_id:, start:)
    @guard_id = guard_id
    @start = start
    @end_time = nil
  end

  def length
    end_time.min - start.min
  end

  def minutes
    (start.min...end_time.min).to_a
  end
end

def run(inputs)
  entries = inputs.map { Entry.from_string(_1) }.sort_by { _1.time }
  sleeps = []
  current_guard = fetch_guard_id(entries.shift.type)
  current_sleep = nil
  entries.each do |entry|
    case entry.type
    when "falls asleep"
      current_sleep = Sleep.new(guard_id: current_guard, start: entry.time)
    when "wakes up"
      current_sleep.end_time = entry.time
      sleeps << current_sleep
    else
      current_guard = fetch_guard_id(entry.type)
    end
  end

  grouped_sleeps = sleeps.group_by { _1.guard_id }

  biggest_sleeper = grouped_sleeps
    .map{ |id, sleeps| [id, sleeps.map(&:length)] }
    .max_by { _1[1].sum }[0]

  most_common_minute = grouped_sleeps
    .fetch(biggest_sleeper)
    .flat_map(&:minutes)
    .tally
    .max_by { |k,v| v }[0]

  biggest_sleeper * most_common_minute
end

def run2(inputs)
  entries = inputs.map { Entry.from_string(_1) }.sort_by { _1.time }
  sleeps = []
  current_guard = fetch_guard_id(entries.shift.type)
  current_sleep = nil
  entries.each do |entry|
    case entry.type
    when "falls asleep"
      current_sleep = Sleep.new(guard_id: current_guard, start: entry.time)
    when "wakes up"
      current_sleep.end_time = entry.time
      sleeps << current_sleep
    else
      current_guard = fetch_guard_id(entry.type)
    end
  end

  grouped_sleeps = sleeps.group_by { _1.guard_id }
  id_minute_tallies = grouped_sleeps.map { |id, sleeps| [id, sleeps.flat_map(&:minutes).tally] }
  id, minute_info = id_minute_tallies
    .map { |id, tallies| [id, tallies.max_by { |k, v| v }] }
    .max_by { |id, minute_info| minute_info[1] }
  id * minute_info[0]
end

input = fetch_input.split("\n")

puts "Part One: #{run(input)}"
puts "Part Two: #{run2(input)}"
