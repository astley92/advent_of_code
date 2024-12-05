require("set")

input = File.read("2024/day_five/input.txt")

rules, updates = input.split("\n\n")
updates = updates.split("\n").map { _1.split(",").map(&:to_i) }
rules = rules.split("\n").map { _1.split("|").map(&:to_i) }
rule_map = {}

rules.each do |rule|
  left, right = rule
  if rule_map.key?(right)
    rule_map[right] << left
  else
    rule_map[right] = [left]
  end
end

def valid_update?(update, rule_map)
  seen = Set.new
  update.count.times do |n|
    seen << update[n]
    n_valid = rule_map.fetch(update[n], []).all? do |other|
      seen.include?(other) || !update.include?(other)
    end
    if !n_valid
      return false
    end
  end
end

puts updates.select { valid_update?(_1, rule_map) }.reduce(0) { |sum, a| sum + a[a.count / 2] }
