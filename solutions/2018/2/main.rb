require "byebug"
require "set"

def fetch_input
  # TODO: Fix this monstrosity
  File.read((caller[-1].split(":")[0].split("/")[0..-2] + ["input.txt"]).join("/"))
end

def run(input)
  ids = input.split("\n")
  twos = ids.select { _1.chars.tally.invert.key? 2 }.count
  threes = ids.select { _1.chars.tally.invert.key? 3 }.count
  twos * threes
end

def run2(input)
  ids = input.split("\n")
  boxes = ids.select { |id| (id.chars.tally.invert.key?(2) || id.chars.tally.invert.key?(3)) }
  while true
    current = boxes.shift
    boxes.each do |other|
      if char_diff(current, other) == 1
        answer = [current, other]

        word = ""
        current.chars.each_with_index do |char, i|
          word += char if other.chars[i] == char
        end
        return word
      end
    end

    break if boxes.count == 0
  end

  raise "Didn't find an answer"
end

def char_diff(a, b)
  a_chars = a.chars
  b_chars = b.chars
  diff_count = 0
  a_chars.each_with_index do |c, i|
    next if b_chars[i] == c

    diff_count += 1
    return if diff_count >= 2
  end
  diff_count
end

input = fetch_input
# puts run(input)
puts run2(input)
