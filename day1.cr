inputs = File
  .read("input.day1")
  .split
  .map(&.to_i)

def fuel(m)
  m // 3 - 2
end

def fuels(m)
  new_fuel = fuel(m)
  return 0 if new_fuel < 1

  new_fuel + fuels(new_fuel)
end

puts "part1: %s" % inputs.sum { |m| fuel(m) }
puts "part2: %s" % inputs.sum { |m| fuels(m) }
