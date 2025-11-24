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

def fix_update(update, rule_map)
  result = []
  to_place = update[0..]

  while to_place.any?
    current = to_place.shift
    placed = false
    (result.count + 1).times do |n|
      possible = result[...n] + [current] + result[n..]
      next unless valid_update?(possible, rule_map)

      result = possible
      placed = true
      break
    end

    to_place << current if !placed
  end

  return result
end

fixed_updates = updates.select { !valid_update?(_1, rule_map) }.map { fix_update(_1, rule_map) }
puts fixed_updates.reduce(0) { |sum, a| sum + a[a.count / 2] }
