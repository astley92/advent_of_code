module AdventOfCode::Options
  def self.from_argv(args)
    options = {day: nil, year: nil}

    OptionParser.new do |opts|
      opts.on("-d", "--day [INTEGER]", Integer, "The number of the day you wish to start") do |day|
        options[:day] = [day, 25].min
      end
      opts.on("-y", "--year [INTEGER]", Integer, "The year you wish to start") do |year|
        options[:year] = year
      end
    end.parse!(args)

    return apply_defaults(options)
  end

  def self.apply_defaults(options)
    new_opts = {}.merge(options)
    current_date = DateTime.now.new_offset("+1100").to_date

    if new_opts[:day].nil?
      new_opts[:day] = most_recent_day(current_date)
    end

    if new_opts[:year].nil?
      if current_date.month == 12 && current_date.day >= new_opts[:day]
        new_opts[:year] = current_date.year
      else
        new_opts[:year] = current_date.year - 1
      end
    end

    new_opts
  end

  def self.most_recent_day(current_date)
    if current_date.month == 12
      current_date.day > 25 ? 25 : current_date.day
    else
      1
    end
  end
end
