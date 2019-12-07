codes = File.read("input.day7").split(',').map(&.to_i)

class Machine
  property input : Deque(Int32)
  property output : Deque(Int32)

  def initialize(@codes : Array(Int32), @input, @output)
    @pos = 0
    @modes = [] of Int32
  end

  def execute
    loop do
      case op = next_op
      when 1 then write(read + read)
      when 2 then write(read * read)
      when 3
        if input.empty?
          @pos = @pos - 1
          break false
        end
        write(input.shift)
      when  4 then output << read
      when  5 then read > 0 ? (@pos = read) : read
      when  6 then read == 0 ? (@pos = read) : read
      when  7 then write(read < read ? 1 : 0)
      when  8 then write(read == read ? 1 : 0)
      when 99 then break true
      else         raise "Unknown code #{op}"
      end
    end
  end

  private def next_op
    @modes.clear
    op = read_and_increment
    @modes.push(op // 1000 % 10, op // 100 % 10)
    op % 100
  end

  private def read_and_increment
    @codes[@pos].tap { @pos += 1 }
  end

  private def read
    @modes.pop == 0 ? @codes[read_and_increment] : read_and_increment
  end

  private def write(value)
    @codes[read_and_increment] = value
  end
end

def pipeline(codes, perms)
  channels = Array(Deque(Int32)).new(5) { Deque(Int32).new }
  perms.each_permutation.max_of do |perm|
    5.times { |i| channels[i] << perm[i] }
    channels[0] << 0
    waiting = Array(Machine).new(5) { |i| Machine.new(codes, channels[i], channels[(i + 1) % 5]) }
    while m = waiting.shift?
      waiting << m unless m.execute
    end
    channels[0].pop
  end
end

puts "part1"
p pipeline(codes, [0, 1, 2, 3, 4])
puts "part2"
p pipeline(codes, [5, 6, 7, 8, 9])
