input = File.read("2024/day_four/input.txt")

GRID = input.split("\n").map { _1.split("") }
i = 0
width = GRID.first.count

DIRS = [
  [1, 1],
  [-1, -1],
  [-1, 1],
  [1, -1],
]

SEARCH_WORD = "MAS"

def is_search_word?(pos, dir)
  current = pos[..-1]
  return false unless GRID[current[1]][current[0]] == SEARCH_WORD[0]

  2.times do |i|
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

finds = []
while i < (GRID.first.count * GRID.count - 1)
  x = i % width
  y = i / width

  DIRS.each do |dir|
    finds << [[x, y], dir] if is_search_word?([x, y], dir)
  end
  i += 1
end

def crosses?(find, other)
  fmiddle = [find[0][0] + find[1][0], find[0][1] + find[1][1]]
  omiddle = [other[0][0] + other[1][0], other[0][1] + other[1][1]]

  omiddle == fmiddle
end

puts finds.count
count = 0
finds.each do |found|
  finds.each do |other|
    next if found == other

    if crosses?(found, other)
      count += 1
      break
    end
  end
end

puts count / 2
