require_relative("../boot.rb")

solution = Solution.new(day: 10, year: 2025)

solution.add_input(File.read(File.join(__dir__, "input.txt")))
solution.add_input(<<~TXT, id: "test_input")
  aaa: you hhh
  you: bbb ccc
  bbb: ddd eee
  ccc: ddd eee fff
  ddd: ggg
  eee: out
  fff: out
  ggg: out
  hhh: ccc fff iii
  iii: out
TXT

solution.add_input(<<~TXT, id: "test_input_2")
  svr: aaa bbb
  aaa: fft
  fft: ccc
  bbb: tty
  tty: ccc
  ccc: ddd eee
  ddd: hub
  hub: fff
  eee: dac
  dac: fff
  fff: ggg hhh
  ggg: out
  hhh: out
TXT

solution.add_test(part: 1, expected_answer: 5, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 2, input_id: "test_input_2")

class Graph
  def initialize
    @data = {}
    @memo = {}
  end

  def add_node(id:, edges:)
    raise ArgumentError, "Dup id #{id.inspect}" if @data[id]

    @data[id] = Node.new(id:, edges:)
  end

  def find(id)
    @data[id]
  end

  def count_paths(from:, to:, dac_seen: false, fft_seen: false, require_seen: false)
    if from == to
      if require_seen
        paths_seen = dac_seen && fft_seen
        return paths_seen ? 1 : 0
      else
        return 1
      end
    end
    memo_key = "#{from}#{dac_seen}#{fft_seen}#{require_seen}"
    return @memo[memo_key] if @memo[memo_key]

    @memo[memo_key] = @data[from].edges.map do |edge|
      dac = dac_seen || from == "dac"
      fft = fft_seen || from == "fft"
      count_paths(from: edge, to: to, dac_seen: dac, fft_seen: fft, require_seen:)
    end.sum
  end

  class Node
    attr_reader :id, :edges
    def initialize(id:, edges:)
      @id = id
      @edges = edges
    end
  end
end

solution.add_solver(part: 1) do |input|
  graph = Graph.new
  input.split("\n").map do |line|
    id, *edges = line.split(" ")
    graph.add_node(id: id[...-1], edges: edges)
  end
  graph.count_paths(from: "you", to: "out")
end

solution.add_solver(part: 2) do |input|
  graph = Graph.new
  input.split("\n").map do |line|
    id, *edges = line.split(" ")
    graph.add_node(id: id[...-1], edges: edges)
  end
  graph.count_paths(from: "svr", to: "out", require_seen: true)
end

solution.run!
