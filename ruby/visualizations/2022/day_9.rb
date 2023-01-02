module VectorMethods
  DIRECTIONS = {
    "R" => [1, 0],
    "L" => [-1, 0],
    "U" => [0, -1],
    "D" => [0, 1],
    "RU" => [1, -1],
    "RD" => [1, 1],
    "LU" => [-1, -1],
    "LD" => [-1, 1],
  }

  def dist_between_vecs(a, b)
    return 1.1 if directly_diagonal?(a, b)

    (a[0] - b[0]).abs + (a[1] - b[1]).abs
  end

  def directly_diagonal?(a, b)
    (a[0] - b[0]).abs == 1 && (a[1] - b[1]).abs == 1
  end

  def add_vecs(a, b)
    [a, b].transpose.map(&:sum)
  end

  def dir_vec(from:, to:)
    closest = nil
    closest_vec = nil
    DIRECTIONS.each do |_k, vec|
      new_pos = add_vecs(from, vec)
      dist = dist_between_vecs(new_pos, to)
      if closest.nil? || (dist < closest)
        closest = dist
        closest_vec = vec
      end
    end
    closest_vec
  end
end

class Movements
  include VectorMethods

  @@movement_list = nil

  def self.next
    build_movement_list if @@movement_list.nil?
    @@movement_list.shift
  end

  def self.clear!
    @@movement_list = nil
  end

  def self.build_for_debugging
    build_movement_list
    @@movement_list = @@movement_list[..100]
  end

  private

  def self.build_movement_list
    @@movement_list = []
    input = File.read(__FILE__.gsub("day_9.rb", "input.txt"))
    input.split("\n").each do |line|
      dir, len = line.split(" ")
      len.to_i.times { @@movement_list << DIRECTIONS.fetch(dir) }
    end

    @@movement_list = @@movement_list
  end
end

class Rope
  attr_reader :segments
  def self.make(segment_count:)
    segments = []
    segment_count.times { |i| segments << Segment.new(parent: segments[i-1]) }
    new(segments)
  end

  def move_head(unit_vec)
    @segments[0].move(unit_vec)
    @segments.each(&:follow_parent)
  end

  def segment_positions
    @segments.map(&:pos)
  end

  def tail_positions
    @segments[-1].position_history
  end

  def head_positions
    @segments[0].position_history
  end

  def reset!
    @segments.each(&:reset!)
  end

  private

  def initialize(segments)
    @segments = segments
  end
end

class Segment
  include VectorMethods

  attr_reader :pos, :position_history
  def initialize(parent:)
    @parent = parent
    @pos = [0,0]
    @position_history = [[0,0]]
  end

  def move(unit_vec)
    @pos = add_vecs(@pos, unit_vec)
    @position_history << @pos
  end

  def follow_parent
    return if @parent.nil?

    if too_far_from_parent?
      move(dir_vec(from: @pos, to: @parent.pos))
    end
  end

  def reset!
    @pos = [0,0]
    @position_history = [[0,0]]
  end

  private

  def too_far_from_parent?
    dist_between_vecs(pos, @parent.pos) > 1.5
  end
end

require "ruby2d"

### GENERATE REQUIRED WINDOW ATTRS ###

part_1_rope = Rope.make(segment_count: 2)
part_2_rope = Rope.make(segment_count: 10)
active_rope = part_2_rope

while true
  movement = Movements.next
  break if movement.nil?

  active_rope.move_head(movement)
end

CELL_SIZE = 5
MAX_X = active_rope.head_positions.max_by { |x, y| x }[0]
MIN_X = active_rope.head_positions.min_by { |x, y| x }[0]
MAX_Y = active_rope.head_positions.max_by { |x, y| y }[1]
MIN_Y = active_rope.head_positions.min_by { |x, y| y }[1]
REQUIRED_WIDTH = MAX_X - MIN_X
REQUIRED_HEIGHT = MAX_Y - MIN_Y
BUFFER = 15
WINDOW_WIDTH = (REQUIRED_WIDTH * CELL_SIZE) + BUFFER
WINDOW_HEIGHT = (REQUIRED_HEIGHT * CELL_SIZE) + BUFFER
COLOUR_MAP = {
  "white" => [0.92941, 0.92941, 0.93725, 1],
  "green" => [0.53725, 0.92941, 0.49412, 1],
  "background" => [0.05098, 0.04706, 0.10196, 1],
}

### VISUALIZATION ###

active_rope.reset!
Movements.clear!

module SegmentRenderer
  def self.render(pos, colour: "green", z: 10)
    shifted_pos = shift(pos)
    Square.new(
      x: shifted_pos[0] * CELL_SIZE,
      y: shifted_pos[1] * CELL_SIZE,
      size: CELL_SIZE,
      color: COLOUR_MAP.fetch(colour),
      z: z
    )
  end

  def self.shift(pos)
    [
      pos[0] - MIN_X,
      pos[1] - MIN_Y
    ]
  end
end

set(
  title: "AOC 2022 Day 9 Visualization",
  width:  WINDOW_WIDTH,
  height: WINDOW_HEIGHT,
  background: Color.new(COLOUR_MAP.fetch("background")),
  resizable: true,
)

paused = true

on :mouse_down do |event|
  if event.button == :middle
    paused = false
  end
end

removable_segments = []
update do
  unless paused
    removable_segments.each(&:remove)
    next_movement = Movements.next

    if next_movement.nil?
      sleep
    else
      # Update
      active_rope.move_head(next_movement)

      # Draw
      removable_segments = active_rope.segments[...-1].map { SegmentRenderer.render(_1.pos, colour: "white", z: 50) }
      SegmentRenderer.render(active_rope.segments[-1].pos, colour: "green", z: 100)
    end
  end
end

show
