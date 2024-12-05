input = File.read("2024/day_four/input.txt")

GRID = input.split("\n").map { _1.split("") }

DIRS = [
  [1, 0],
  [0, 1],
  [-1, 0],
  [0, -1],
  [1, 1],
  [-1, -1],
  [-1, 1],
  [1, -1],
]

SEARCH_WORD = "XMAS"
def is_search_word?(pos, dir)
  current = pos[..-1]
  return false unless GRID[current[1]][current[0]] == SEARCH_WORD[0]

  3.times do |i|
    current[0] += dir[0]
    current[1] += dir[1]

    return false if current[0] >= GRID.first.count
    return false if current[1] >= GRID.count
    return false if current[0] < 0
    return false if current[1] < 0
    return false if GRID[current[1]][current[0]] != SEARCH_WORD[i+1]
  end

  return true
end

i = 0
width = GRID.first.count
count = 0
while i < (width * GRID.count - 1)
  y, x = i.divmod(width)

  count += DIRS.select do |dir|
    is_search_word?([x, y], dir)
  end.count

  i += 1
end

puts count
