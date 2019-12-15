require "complex"
require "./machine"

input = File.read("input.day15").split(",").map(&.to_i64)
input.concat Array(Int64).new(1_000000) { 0_i64 }

def neighbors(pos : Complex)
  {
    pos + Complex.new(0, 1),
    pos + Complex.new(1, 0),
    pos + Complex.new(0, -1),
    pos + Complex.new(-1, 0),
  }
end

def calculate_path(map, current_pos, target)
  seen = Set{current_pos}
  tracks = Hash(Complex, Complex).new
  queue = Deque{current_pos}
  while (node = queue.shift?) && node != target
    neighbors =
      neighbors(node)
        .reject { |p| seen.includes?(p) }
        .select { |p| (map[p]? && map[p] != '#') || p == target }
    queue.concat(neighbors)
    seen.concat neighbors
    neighbors.each { |n| tracks[n] = n - node }
  end
  output = Deque(Complex).new
  while dir = tracks[target]?
    output << dir
    target -= dir
  end
  output
end

def calculate_path2(map, current_pos)
  seen = Set{current_pos}
  queue = Deque{ {current_pos, 0} }
  max = 0
  while pair = queue.shift?
    node, dist = pair
    max = dist if dist > max
    neighbors =
      neighbors(node)
        .reject { |p| seen.includes?(p) }
        .select { |p| (map[p]? && map[p] != '#') }
    queue.concat(neighbors.map { |n| {n, dist + 1} })
    seen.concat neighbors
  end
  max
end

def explore(input)
  inputs = Deque(Int64).new
  outputs = Deque(Int64).new
  machine = Machine.new(input.dup, inputs, outputs)

  oxygen = current_pos = Complex.new(0, 0)
  map = {current_pos => '.'}

  to_explore = Deque(Complex).new.concat(neighbors(current_pos))
  while target = to_explore.pop?
    path = calculate_path(map, current_pos, target)
    while next_step = path.pop?
      inputs <<
        case next_step
        when Complex.new(1, 0)  then 1
        when Complex.new(-1, 0) then 2
        when Complex.new(0, -1) then 3
        when Complex.new(0, 1)  then 4
        else                         raise "unreachable1"
        end.to_i64
      machine.execute
      next_pos = current_pos + next_step
      case result = outputs.shift
      when 0 then map[next_pos] = '#'
      when 1
        current_pos = next_pos
        map[current_pos] = ' '
        to_explore.concat(neighbors(current_pos).reject { |nb| map[nb]? })
      when 2
        current_pos = next_pos
        map[current_pos] = 'O'
        to_explore.concat(neighbors(current_pos).reject { |nb| map[nb]? })
        oxygen = current_pos
      else raise "unreachable2"
      end
    end
  end
  {map, oxygen}
end

map, oxygen = explore(input)
puts "part1"
puts calculate_path(map, Complex.new(0, 0), oxygen).size
puts "part2"
p calculate_path2(map, oxygen)
