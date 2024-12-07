input = "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"

# input = File.read("2024/day_seven/input.txt")

def evaluate(operations)
  while operations.count > 1
    op = operations.shift(3)
    case op[1]
    when "+", "*"
      operations.unshift(eval(op.join))
    else
      operations.unshift("#{op[0]}#{op[2]}".to_i)
    end
  end

  return operations[0]
end

def values_can_eq_num?(num, values, gen)
  possible_operations = gen.ops_for(values.count - 1)
  possible_operations.each do |operation|
    func_str = values.zip(operation).flatten.compact
    result = evaluate(func_str)

    return true if result == num
  end

  return false
end

class OpGenerator
  def initialize(symbols:)
    @symbols = symbols
    @count_ops_map = { 1 => symbols.map { [_1] } }
  end

  def ops_for(count)
    return @count_ops_map[count] if @count_ops_map[count]

    prev = ops_for(count-1)
    current = []
    prev.each do |op|
      @symbols.each do |o|
        current << op + [o]
      end
    end
    @count_ops_map[count] = current
  end
end

lines = input.split("\n")
gen = OpGenerator.new(symbols: %w[+ * ||])
result = 0
line_count = lines.count

lines.each_with_index do |line, index|
  print("#{index + 1} of #{line_count}\r")
  num, value_str = line.split(": ")
  num = num.to_i
  values = value_str.split(" ")
  result += values_can_eq_num?(num, values, gen) ? num : 0
end

puts "### #{result} ###"
