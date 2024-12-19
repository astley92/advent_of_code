require_relative("../utils.rb")

input = "r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb"

input = File.read("2024/day_nineteen/input.txt")

patterns_str, required_designs_str = input.split("\n\n")
patterns = patterns_str.split(", ")
required_designs = required_designs_str.split("\n")
design_count_map = {}

def possible_design_count(design, patterns, design_count_map)
  return design_count_map[design] if design_count_map.key?(design)

  possible_count = 0
  patterns.each do |pattern|
    next if pattern.length > design.length

    if pattern == design
      possible_count += 1
    elsif design.start_with?(pattern)
      possible_count += possible_design_count(design[pattern.length..], patterns, design_count_map)
    end
  end

  design_count_map[design] = possible_count
  return possible_count
end

puts required_designs.map { possible_design_count(_1, patterns, design_count_map) }.sum
