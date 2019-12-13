require "complex"
require "./machine"

input = File.read("input.day11").split(',').map(&.to_i64)
input.concat Array(Int64).new(500) { 0i64 }

def paint(map, input)
  inputs = Deque(Int64).new
  outputs = Deque(Int64).new
  pos = Complex.new(0, 0)
  dir = Complex.new(0, -1)
  machine = Machine.new(input.dup, inputs, outputs)
  loop do
    inputs << (map[pos] ? 1i64 : 0i64)
    break if machine.execute
    map[pos] = outputs.shift == 1
    dir *= outputs.shift == 1 ? Complex.new(0, 1) : Complex.new(0, -1)
    pos += dir
  end
end

def print_map(map)
  0.upto(5) do |y|
    1.upto(40).each do |x|
      print map[Complex.new(x, y)] ? '#' : '.'
    end
    puts
  end
end

puts "part1:"
map = Hash(Complex, Bool).new { false }
paint(map, input)
p map.count &.itself

puts "part2:"
map = Hash(Complex, Bool).new { true }
paint(map, input)
print_map(map)
