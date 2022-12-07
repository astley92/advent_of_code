##### Part One Description #####
# --- Day 7: No Space Left On Device ---
# You can hear birds chirping and raindrops hitting leaves as the expedition
# proceeds. Occasionally, you can even hear much louder sounds in the distance;
# how big do the animals get out here, anyway?
#
# The device the Elves gave you has problems with more than just its
# communication system. You try to run a system update:
#
# $ system-update --please --pretty-please-with-sugar-on-top
# Error: No space left on device
#
# Perhaps you can delete some files to make space for the update?
#
# You browse around the filesystem to assess the situation and save the resulting
# terminal output (your puzzle input). For example:
#
# $ cd /
# $ ls
# dir a
# 14848514 b.txt
# 8504156 c.dat
# dir d
# $ cd a
# $ ls
# dir e
# 29116 f
# 2557 g
# 62596 h.lst
# $ cd e
# $ ls
# 584 i
# $ cd ..
# $ cd ..
# $ cd d
# $ ls
# 4060174 j
# 8033020 d.log
# 5626152 d.ext
# 7214296 k
#
# The filesystem consists of a tree of files (plain data) and directories (which
# can contain other directories or files). The outermost directory is called /.
# You can navigate around the filesystem, moving into or out of directories and
# listing the contents of the directory you're currently in.
#
# Within the terminal output, lines that begin with $ are commands you executed,
# very much like some modern computers:
#
#
# cd means change directory. This changes which directory is the current
# directory, but the specific result depends on the argument:
#
# cd x moves in one level: it looks in the current directory for the directory
# named x and makes it the current directory.
# cd .. moves out one level: it finds the directory that contains the current
# directory, then makes that directory the current directory.
#   cd / switches the current directory to the outermost directory, /.
#
#
# ls means list. It prints out all of the files and directories immediately
# contained by the current directory:
#
# 123 abc means that the current directory contains a file named abc with size
# 123.
#   dir xyz means that the current directory contains a directory named xyz.
#
#
#
# Given the commands and output in the example above, you can determine that the
# filesystem looks visually like this:
#
# - / (dir)
#   - a (dir)
#     - e (dir)
#       - i (file, size=584)
#     - f (file, size=29116)
#     - g (file, size=2557)
#     - h.lst (file, size=62596)
#   - b.txt (file, size=14848514)
#   - c.dat (file, size=8504156)
#   - d (dir)
#     - j (file, size=4060174)
#     - d.log (file, size=8033020)
#     - d.ext (file, size=5626152)
#     - k (file, size=7214296)
#
# Here, there are four directories: / (the outermost directory), a and d (which
# are in /), and e (which is in a). These directories also contain files of
# various sizes.
#
# Since the disk is full, your first step should probably be to find directories
# that are good candidates for deletion. To do this, you need to determine the
# total size of each directory. The total size of a directory is the sum of the
# sizes of the files it contains, directly or indirectly. (Directories themselves
# do not count as having any intrinsic size.)
#
# The total sizes of the directories above can be found as follows:
#
#
# The total size of directory e is 584 because it contains a single file i of
# size 584 and no other directories.
# The directory a has total size 94853 because it contains files f (size 29116),
# g (size 2557), and h.lst (size 62596), plus file i indirectly (a contains e
# which contains i).
# Directory d has total size 24933642.
# As the outermost directory, / contains every file. Its total size is 48381165,
# the sum of the size of every file.
#
# To begin, find all of the directories with a total size of at most 100000, then
# calculate the sum of their total sizes. In the example above, these directories
# are a and e; the sum of their total sizes is 95437 (94853 + 584). (As in this
# example, this process can count files more than once!)
#
# Find all of the directories with a total size of at most 100000. What is the
# sum of the total sizes of those directories?

class Directory
  SEPERATOR = "/"
  @@dirs = []
  attr_reader :name

  def self.find_or_create(name)
    existing_dir = @@dirs.detect { _1.name == name }
    return existing_dir unless existing_dir.nil?

    new(name).tap { @@dirs << _1 }
  end

  def self.all
    @@dirs
  end

  def self.home_dir
    find_or_create("home")
  end

  def self.clear!
    @@dirs = []
  end

  def add_content(content_string)
    if content_string.start_with?("dir")
      add_dir(content_string)
    else
      add_file(content_string)
    end
  end

  def total_size
    return files.sum if dirs.empty?

    files.sum + @dirs.map { _1.total_size }.sum
  end

  def parent_dir
    self.class.find_or_create(name.split(SEPERATOR)[..-2].join(SEPERATOR))
  end

  def move_into(subdir_name)
    self.class.find_or_create(name + SEPERATOR + subdir_name)
  end

  private

  attr_accessor :files, :dirs
  def initialize(name)
    @name = name
    @files = []
    @dirs = []
  end

  def add_dir(arg_string)
    dirs << self.class.find_or_create(name + SEPERATOR + arg_string.split(" ")[1])
  end

  def add_file(arg_string)
    files << arg_string.split(" ")[0].to_i
  end
end

class Solution
  attr_accessor :input
  def initialize(input)
    @input = input
  end

  def self.run!(input)
    solution = new(parse_input(input))
    <<~MSG
      Part One: #{solution.part_one!}
      Part Two: #{solution.part_two!}
    MSG
  end

  def self.parse_input(input)
    # Parse input
    input.split("\n")
  end

  def part_one!
    run_all_commands
    Directory
      .all
      .select { _1.total_size <= 100_000 }
      .map { _1.total_size }
      .sum
  end

  def part_two!
    Directory.clear!
    run_all_commands

    Directory
      .all
      .select { _1.total_size >= required_to_free }
      .sort_by { _1.total_size }
      .first.total_size
  end

  private

  def run_all_commands
    current_dir = Directory.home_dir
    input.each do |line|
      if line.start_with?("$")
        cmd, args = line.split(" ")[1..]
        if cmd == "cd"
          case args
          when ".."
            current_dir = current_dir.parent_dir
          when "/"
            current_dir = Directory.home_dir
          else
            current_dir = current_dir.move_into(args)
          end
        end
      else
        current_dir.add_content(line)
      end
    end
  end

  def required_to_free
    total_space = 70_000_000
    required_available = 30_000_000
    total_space_used = Directory.home_dir.total_size
    current_available = total_space - total_space_used
    required_available - current_available
  end
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
puts Solution.run!(input)
