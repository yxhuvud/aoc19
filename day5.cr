class Memory
  property pos

  def initialize(@codes : Array(Int32))
    @pos = 0
    @modes = [] of Int32
  end

  def next_op
    @modes.clear
    op = read_and_increment
    @modes.push(op // 1000 % 10, op // 100 % 10)
    op % 100
  end

  def read_and_increment
    @codes[@pos].tap { @pos += 1 }
  end

  def read
    @modes.pop == 0 ? @codes[read_and_increment] : read_and_increment
  end

  def write(value)
    @codes[read_and_increment] = value
  end
end

def execute(memory, input)
  loop do
    case op = memory.next_op
    when 1
      memory.write(memory.read + memory.read)
    when 2
      memory.write(memory.read * memory.read)
    when 3
      memory.write(input)
    when 4
      puts memory.read
    when 5
      memory.read > 0 ? memory.pos = memory.read : memory.read
    when 6
      memory.read == 0 ? memory.pos = memory.read : memory.read
    when 7
      memory.write(memory.read < memory.read ? 1 : 0)
    when 8
      memory.write(memory.read == memory.read ? 1 : 0)
    when 99
      return codes[0]
    else
      raise "Unknown code #{op}"
    end
  end
end

codes = File.read("input.day5").split(",").map(&.to_i)
puts "part1: "
execute(Memory.new(codes.dup), 1)
puts "part2:"
execute(Memory.new(codes.dup), 5)
