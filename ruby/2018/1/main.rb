require "byebug"
require "set"

def fetch_input
  # TODO: Fix this monstrosity
  File.read((caller[-1].split(":")[0].split("/")[0..-2] + ["input.txt"]).join("/"))
end

def run(input)
  input.split("\n").map(&:to_i).sum
end

def run2(input)
  current = 0
  prev = Set.new
  i = 0
  loop_count = 0
  nums = input.split("\n").map(&:to_i)
  while true
    current += nums[i]
    break if prev.include?(current)

    i += 1
    if i >= nums.length
      loop_count += 1
      puts loop_count
      i = 0
    end
    prev << current
  end
  current
end

input = fetch_input
puts run(input)
puts run2(input)
