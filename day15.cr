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
  while (node = queue.shift?) && map[node]? != target
    neighbors(node).each do |n|
      if map[n]? != '#' && !seen.includes?(n)
        queue << n
        seen << n
        tracks[n] = n - node
      end
    end
  end
  if node
    output = Deque(Complex).new
    while dir = tracks[node]?
      output << dir
      node -= dir
    end
    output
  end
end

def calculate_path2(map, current_pos)
  seen = Set{current_pos}
  queue = Deque{ {current_pos, 0} }
  max = 0
  while pair = queue.shift?
    node, dist = pair
    max = dist if dist > max
    neighbors(node).each do |n|
      if map[n]? != '#' && !seen.includes?(n)
        queue << {n, dist + 1}
        seen << n
      end
    end
  end
  max
end

def explore(input)
  machine = Machine.new(input.dup)
  oxygen = current_pos = Complex.new(0, 0)
  map = {current_pos => '.'}

  while path = calculate_path(map, current_pos, nil)
    while next_step = path.pop?
      machine.input(
        case next_step
        when Complex.new(1, 0)  then 1
        when Complex.new(-1, 0) then 2
        when Complex.new(0, -1) then 3
        when Complex.new(0, 1)  then 4
        else                         raise "unreachable1"
        end
      )
      machine.execute
      next_pos = current_pos + next_step
      current_pos, map[next_pos] =
        case machine.output
        when 0 then {current_pos, '#'}
        when 1 then {next_pos, ' '}
        when 2 then oxygen = next_pos; {next_pos, ' '}
        else        raise "unreachable2"
        end
    end
  end
  {map, oxygen}
end

map, oxygen = explore(input)
puts "part1"
puts calculate_path(map, oxygen, '.').try &.size
puts "part2"
p calculate_path2(map, oxygen)
