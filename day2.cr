input = File.read "input.day2"
codes = input.split(",").map(&.to_i)

def calculate(codes, noun, verb)
  codes = codes.dup
  codes[1] = noun
  codes[2] = verb
  pos = 0
  loop do
    code = codes[pos]
    case code
    when 1
      l1 = codes[pos + 1]
      l2 = codes[pos + 2]
      target = codes[pos + 3]
      codes[target] = codes[l1] + codes[l2]
    when 2
      l1 = codes[pos + 1]
      l2 = codes[pos + 2]
      target = codes[pos + 3]
      codes[target] = codes[l1] * codes[l2]
    when 99
      return codes[0]
    else
      puts "unknown code #{code}"
      break -1
    end
    pos += 4
  end
end

puts "part1 "
puts calculate(codes.dup, 12, 2)

needle = 19690720
(0..99).each do |noun|
  (0..99).each do |verb|
    if calculate(codes, noun, verb) == needle
      puts "part2"
      puts 100 * noun + verb
      break
    end
  end
end
