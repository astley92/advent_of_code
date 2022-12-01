require "byebug"

def fetch_input
  # TODO: Fix this monstrosity
  File.read((caller[-1].split(":")[0].split("/")[0..-2] + ["input.txt"]).join("/"))
end

class String
  def upper?
    !!match?(/[A-Z]/)
  end
end

def will_react?(c1, c2)
  c1 == c2.swapcase
end

def run(input)
  chars = input.chars
  removed = []
  i = 0
  while true
    break if i >= chars.length - 1

    if will_react?(chars[i], chars[i + 1])
      puts chars.length
      chars.delete_at(i+1)
      chars.delete_at(i)
      i=0
      next
    end

    i += 1
  end
  chars.join.length
end

def run2(input)
  res = []

  ("a".."z").each do |target|
    chars = input.chars
    i = chars.length-1
    while true
      break if i < 0

      chars.delete_at(i) if chars[i].downcase == target
      i -= 1
    end

    i = 0
    while true
      break if i >= chars.length - 1

      if will_react?(chars[i], chars[i + 1])
        print("\r#{target}: #{chars.count} ".rjust(20, "#"))
        chars.delete_at(i+1)
        chars.delete_at(i)
        i=0
        next
      end

      i += 1
    end
    res << [target, chars.join.length]
  end
  res.min_by { _1[1] }
end

input = fetch_input.strip

# puts "Part One: #{run(input)}"
puts "Part Two: #{run2(input)}"
