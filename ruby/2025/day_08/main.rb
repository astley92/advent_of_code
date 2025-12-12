require_relative("../boot.rb")

solution = Solution.new(day: 8, year: 2025)

solution.add_input(File.read(File.join(__dir__, "input.txt")))
solution.add_input(<<~TXT, id: "test_input")
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
TXT

solution.add_test(part: 1, expected_answer: 40, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 25272, input_id: "test_input")

solution.add_solver(part: 1) do |input, is_test|
  conn_count = is_test ? 10 : 1000
  positions = input.split("\n").map { _1.split(",").map(&:to_i) }.map { Vec3.new(*_1) }
  circuits = positions.map { [_1] }

  distances = []
  positions.each.with_index do |p1, p1i|
    positions[p1i + 1..].each do |p2|
      dist = p1.distance_to(p2)
      distances << [dist, p1, p2]
    end
  end
  sorted_distances = distances.sort_by { _1[0] }

  sorted_distances[...conn_count].each do |_, p1, p2|
    p1c = circuits.detect { _1.include?(p1) }
    p2c = circuits.detect { _1.include?(p2) }
    next if p1c == p2c

    circuits.reject! { _1 == p1c || _1 == p2c }
    circuits << p1c + p2c
  end
  circuits.map { _1.size }.sort.reverse[..2].reduce(&:*)
end

solution.add_solver(part: 2) do |input|
  positions = input.split("\n").map { _1.split(",").map(&:to_i) }.map { Vec3.new(*_1) }
  circuits = positions.map { [_1] }

  distances = []
  positions.each.with_index do |p1, p1i|
    positions[p1i + 1..].each do |p2|
      dist = p1.distance_to(p2)
      distances << [dist, p1, p2]
    end
  end
  sorted_distances = distances.sort_by { _1[0] }

  res = nil
  sorted_distances.each do |_, p1, p2|
    p1c = circuits.detect { _1.include?(p1) }
    p2c = circuits.detect { _1.include?(p2) }
    next if p1c == p2c

    circuits.reject! { _1 == p1c || _1 == p2c }
    circuits << p1c + p2c

    if circuits.count == 1
      res = [p1, p2].map(&:x).reduce(&:*)
      break
    end
  end
  res
end

solution.run!
