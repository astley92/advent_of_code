require "byebug"

def fetch_input
  # TODO: Fix this monstrosity
  File.read((caller[-1].split(":")[0].split("/")[0..-2] + ["input.txt"]).join("/"))
end

def run(input)
end

def run2(input)
end

input = fetch_input
puts run(input)
puts run2(input)
