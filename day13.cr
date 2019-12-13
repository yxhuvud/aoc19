require "complex"
require "./machine"

input = File.read("input.day13").split(',').map(&.to_i64)
input.concat Array(Int64).new(100) { 0i64 }

def play(input, early_exit)
  inputs = Deque(Int64).new
  outputs = Deque(Int64).new
  map = Hash(Complex, Int64).new { 0i64 }
  machine = Machine.new(input.dup, inputs, outputs)
  score = 0i64
  count = 0
  ball = 0i64
  paddle = 0i64

  loop do
    machine.execute
    while outputs.any?
      case output = {outputs.shift, outputs.shift}
      when {-1, 0}
        new_score = outputs.shift
        score = new_score unless new_score == 0
      else
        case v = outputs.shift
        when 2 then count += 1
        when 3 then ball = output[0]
        when 4 then paddle = output[0]
        end
        count -= 1 if map[Complex.new(*output)] == 2
        map[Complex.new(*output)] = v
      end
    end
    inputs << (paddle <=> ball).to_i64
    return {count, score} if count == 0 || count > 0 && early_exit
  end
end

puts "part1:"
p play(input, true)[0]

puts "part2"
p play(input, false)[1]
