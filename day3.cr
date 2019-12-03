record(Turn, dir : Char, length : Int32)
record(Pos, x : Int32, y : Int32) do
  def dist
    x.abs + y.abs
  end
end
record(Collision, pos : Pos, steps : Int32)
record(Label, source : Int32, steps : Int32)

def update(map, collisions, pos, label)
  if map[pos]? && map[pos].source != label.source
    collisions << Collision.new(pos, map[pos].steps + label.steps)
  else
    map[pos] = label
  end
end

input = File.read "input.day3"
turns = input.lines.map do |line|
  line.split(/,/).map { |s| Turn.new(s[0], s[1..].to_i32) }
end

map = Hash(Pos, Label).new
collisions = Set(Collision).new

turns.each_with_index do |orders, wire|
  pos = Pos.new(0, 0)
  step = 0
  orders.each do |turn|
    turn.length.times do
      step += 1
      pos =
        case turn.dir
        when 'U'
          Pos.new(pos.x + 1, pos.y)
        when 'D'
          Pos.new(pos.x - 1, pos.y)
        when 'L'
          Pos.new(pos.x, pos.y - 1)
        when 'R'
          Pos.new(pos.x, pos.y + 1)
        else
          raise "Unreachable"
        end
      update(map, collisions, pos, Label.new(wire, step))
    end
  end
end

puts "Part1"
p collisions.min_of &.pos.dist
puts "Part2"
p collisions.min_of &.steps
