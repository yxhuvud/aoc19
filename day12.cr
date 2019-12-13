input = File.read("input.day12")

input = input.lines.map &.tr("xy>=z<", "").split(",").map(&.to_i)

record(Pos, x : Int32, y : Int32, z : Int32) do
  def -(other)
    Pos.new(x - other.x, y - other.y, z - other.z)
  end

  def +(other)
    Pos.new(x + other.x, y + other.y, z + other.z)
  end

  def abs
    x.abs + y.abs + z.abs
  end
end

class Moon
  property :pos, :vel

  def initialize(@pos : Pos, @vel : Pos)
  end

  def energy
    pos.abs * vel.abs
  end

  def ==(other)
    pos = other.pos && vel == other.vel
  end
end

def moons(input)
  {
    Moon.new(Pos.new(input[0][0], input[0][1], input[0][2]), (Pos.new(0, 0, 0))),
    Moon.new(Pos.new(input[1][0], input[1][1], input[1][2]), (Pos.new(0, 0, 0))),
    Moon.new(Pos.new(input[2][0], input[2][1], input[2][2]), (Pos.new(0, 0, 0))),
    Moon.new(Pos.new(input[3][0], input[3][1], input[3][2]), (Pos.new(0, 0, 0))),
  }
end

def step(moons)
  moons.each do |m|
    moons.each do |m2|
      dp = m2.pos - m.pos
      m.vel += Pos.new(dp.x <=> 0, dp.y <=> 0, dp.z <=> 0)
    end
  end
  moons.each { |m| m.pos += m.vel }
end

moons = moons(input)
1000.times do
  step(moons)
end
puts "part1"
puts moons.sum &.energy

def period(input)
  moons = moons(input)
  # Abusing the fact that the starting state is part of the loop..
  start = (moons.map(&.pos) + moons.map(&.vel)).map { |p| yield p }
  (0..).each do |i|
    step(moons)
    state = (moons.map(&.pos) + moons.map(&.vel)).map { |p| yield p }
    return i + 1 if start == state
  end
  raise "Unreachable"
end

puts "part2"
puts [
  period(input, &.x),
  period(input, &.y),
  period(input, &.z),
].map(&.to_i64).reduce { |a, b| a.lcm(b) }
