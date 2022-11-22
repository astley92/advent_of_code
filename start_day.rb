require_relative("boot.rb")

options = AdventOfCode::Options.from_argv(ARGV)
AdventOfCode::FileBuilder.call(**options)
