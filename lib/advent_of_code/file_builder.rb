class AdventOfCode::FileBuilder
  def self.call(year:, day:)
    new(year, day).send(:run)
  end

  attr_reader :year, :day, :base_dir_path, :template_path
  def initialize(year, day)
    @year = year
    @day = day
    @base_dir_path = "/Users/blakeastley/Projects/advent_of_code/solutions/"
    @template_path = "/Users/blakeastley/Projects/advent_of_code/templates/"
  end

  private

  def run
    file_directory = find_or_create_directories
    create_files(file_directory)
  end

  def find_or_create_directories
    year_dir = find_or_create_directory("#{year}")
    find_or_create_directory("#{year}/#{day}")
  end

  def find_or_create_directory(path)
    full_path = File.join(base_dir_path, path)
    existing_dir = Dir[full_path].first

    return existing_dir if existing_dir
    return create_dir(full_path)
  end

  def create_dir(path)
    Dir.mkdir(path)
    return path
  end

  def create_files(directory)
    File.open(File.join(directory, "input.txt"), "w") {}
    FileUtils.cp(File.join(template_path, "main.rb"), directory)
  end
end
