class Machine
  def initialize(@codes : Array(Int32))
    @pos = 0
    @modes = [] of Int32
  end

  def execute(input)
    loop do
      case op = next_op
      when  1 then write(read + read)
      when  2 then write(read * read)
      when  3 then write(input)
      when  4 then puts read
      when  5 then read > 0 ? (@pos = read) : read
      when  6 then read == 0 ? (@pos = read) : read
      when  7 then write(read < read ? 1 : 0)
      when  8 then write(read == read ? 1 : 0)
      when 99 then break
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

codes = File.read("input.day5").split(",").map(&.to_i)
puts "part1: "
Machine.new(codes.dup).execute(1)
puts "part2:"
Machine.new(codes.dup).execute(5)
