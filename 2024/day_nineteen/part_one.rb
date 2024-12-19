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
design_possible_map = {}

def is_possible_design?(design, patterns, design_possible_map)
  return design_possible_map[design] if design_possible_map.key?(design)

  if design == ""
    design_possible_map[design] = true
    return true
  end

  patterns.each do |pattern|
    if design.start_with?(pattern) && is_possible_design?(design[pattern.length..], patterns, design_possible_map)
      design_possible_map[design] = true
      return true
    end
  end
  design_possible_map[design] = false
  return false
end

puts required_designs.select { is_possible_design?(_1, patterns, design_possible_map) }.count
