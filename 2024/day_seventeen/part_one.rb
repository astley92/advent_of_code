require_relative("../utils.rb")

input = "Register A: 2024
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0"

input = "Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0"
input = File.read("2024/day_seventeen/input.txt")

register_strs, program_str = input.split("\n\n")
registers = {}

register_strs.split("\n").each do |line|
  id = line.split(" ")[1][0]
  registers[id] = line.split(" ")[-1].to_i
end

def combo_operator(i, registers)
  case i
  when 0, 1, 2, 3 then i
  when 4 then registers["A"]
  when 5 then registers["B"]
  when 6 then registers["C"]
  when 7 then nil
  end
end

output = []
instructions = {
  0 => Proc.new { |x| res = registers["A"] / 2 ** combo_operator(x, registers); registers["A"] = res; -1 },
  1 => Proc.new { |x| res = registers["B"] ^ x; registers["B"] = res; -1 },
  2 => Proc.new { |x| res = combo_operator(x, registers) % 8; registers["B"] = res; -1 },
  3 => Proc.new { |x| should_jump = registers["A"] != 0; should_jump ? x : -1 },
  4 => Proc.new { |x| res = registers["B"] ^ registers["C"]; registers["B"] = res; -1 },
  5 => Proc.new { |x| res = combo_operator(x, registers) % 8; output << res; -1 },
  6 => Proc.new { |x| res = registers["A"] / 2 ** combo_operator(x, registers); registers["B"] = res; -1 },
  7 => Proc.new { |x| res = registers["A"] / 2 ** combo_operator(x, registers); registers["C"] = res; -1 },
}

program = program_str.split(" ")[1].split(",").map(&:to_i)
instruction_pointer = 0

while instruction_pointer < program.count
  puts registers
  opcode, operand = program[instruction_pointer..instruction_pointer+1]
  next_pos = instructions[opcode].call(operand)
  if next_pos != -1
    instruction_pointer = next_pos
  else
    instruction_pointer += 2
  end
end
puts output.join(",")

