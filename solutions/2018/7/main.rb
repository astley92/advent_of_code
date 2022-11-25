require "byebug"

def fetch_input
  # TODO: Fix this monstrosity
  File.read((caller[-1].split(":")[0].split("/")[0..-2] + ["input.txt"]).join("/"))
end

CHARS = ("A".."Z").to_a
PENALTY = 60

class Step
  attr_accessor :next_steps, :value, :previous
  def initialize(value)
    @value = value
    @previous = []
    @next_steps = []
    @time_left = PENALTY + CHARS.index(value) + 1
  end

  def deduct_second
    @time_left -= 1
  end

  def complete?
    @time_left == 0
  end
end

def run(input)
  step_list = []

  input.each do |line|
    before, after = line.scan(/\s[A-Z]\s/).map(&:strip)
    before = step_list.detect { _1.value == before } || Step.new(before)
    after = step_list.detect { _1.value == after } || Step.new(after)
    before.next_steps << after.value
    after.previous << before.value
    step_list << before unless step_list.include? before
    step_list << after unless step_list.include? after
  end

  stack = step_list.select { _1.previous == [] }
  result = []

  while stack.count > 0
    stack.sort_by! { _1.value }
    current = stack.shift
    result << current.value
    current.next_steps.each do |value|
      step = step_list.detect { _1.value == value }
      stack << step if step.previous.all? { result.include? _1 }
    end
  end

  result.join
end

def run2(input)
  step_list = []

  input.each do |line|
    before, after = line.scan(/\s[A-Z]\s/).map(&:strip)
    before = step_list.detect { _1.value == before } || Step.new(before)
    after = step_list.detect { _1.value == after } || Step.new(after)
    before.next_steps << after.value
    after.previous << before.value
    step_list << before unless step_list.include? before
    step_list << after unless step_list.include? after
  end

  stack = step_list.select { _1.previous == [] }
  result = []
  working = [nil]
  worker_count = 5
  seconds = 0

  while stack.count > 0 || working.count > 0
    working.compact!
    seconds += 1

    while worker_count > 0 && stack.any?
      stack.sort_by! { _1.value }
      worker_count -= 1
      working << stack.shift
    end

    working.each(&:deduct_second)
    working.select { _1.complete? }.each do |step|
      working.delete(step)
      worker_count += 1
      result << step.value
      next_steps = step.next_steps.map { |value| step_list.detect { |s| s.value == value } }
      next_steps.each do |ns|
        stack << ns if ns.previous.all? { result.include? _1 }
      end
    end
  end
  result.join + " - " + seconds.to_s + " seconds to complete"
end

input = fetch_input.split("\n")

puts "Part One: #{run(input)}"
puts "Part Two: #{run2(input)}"
