require_relative("../utils.rb")

input = "2333133121414131402"
input = File.read("2024/day_nine/input.txt")

expanded = []
i = 0

input.split("").each_slice(2) do |size, space|
  size.to_i.times do
    expanded << i
  end
  space.to_i.times do
    expanded << nil
  end
  i += 1
end

chunks = expanded.slice_when { |a, b| a != b }.to_a

i = 0
while i < chunks.count do
  chunk = chunks[i]

  if chunk[0] == nil
    available_space = chunk.count
    chunks[i+1..].reverse.each_with_index do |potential_chunk, j|
      next if potential_chunk[0] == nil

      if potential_chunk.count <= available_space
        chunks.delete_at(-(j+1))
        chunks.insert(-(j+1), [nil] * potential_chunk.count)
        chunks.delete_at(i)
        chunks.insert(i, potential_chunk)
        remainder = available_space - potential_chunk.count
        chunks.insert(i+1, [nil]*remainder) unless remainder == 0
        break
      end
    end
  end
  i += 1
end

csum = 0
chunks.flatten.each_with_index do |n, i|
  next if n == nil

  csum += n * i
end
puts csum
