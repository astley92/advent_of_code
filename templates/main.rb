require "byebug"

def fetch_input
  # TODO: Fix this monstrosity
  File.read((caller[-1].split(":")[0].split("/")[0..-2] + ["input.txt"]).join("/"))
end

def run(input)
end

def run2(input)
end

input = fetch_input.split("\n")

puts "Part One: #{run(input)}"
puts "Part Two: #{run2(input)}"
