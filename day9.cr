input = File.read("input.day9").split(',').map(&.to_i64)
input.concat Array(Int64).new(500) { 0i64 } # 500 Int64 ought to be enough for everyone.

class Machine
  def initialize(@codes : Array(Int64))
    @pos = 0i32
    @relative_base = 0i32
    @modes = [] of Int64
  end

  def execute(input : Int64)
    loop do
      case op = next_op
      when  1 then write(read + read)
      when  2 then write(read * read)
      when  3 then write(input)
      when  4 then return read
      when  5 then read > 0 ? (@pos = read.to_i32) : read
      when  6 then read == 0 ? (@pos = read.to_i32) : read
      when  7 then read < read ? write(1) : write(0)
      when  8 then read == read ? write(1) : write(0)
      when  9 then @relative_base += read
      when 99 then break
      else         raise "Unknown code #{op}"
      end
    end
  end

  private def next_op
    @modes.clear
    op = read_and_increment
    @modes.push(op // 10000 % 10, op // 1000 % 10, op // 100 % 10)
    op % 100
  end

  private def read_and_increment
    @codes[@pos].tap { @pos += 1 }
  end

  private def read
    case @modes.pop
    when 0 then @codes[read_and_increment]
    when 1 then read_and_increment
    when 2 then @codes[@relative_base + read_and_increment]
    else        raise "Unreachable"
    end
  end

  private def write(value : Int64)
    case @modes.pop
    when 0 then @codes[read_and_increment] = value
    when 2 then @codes[@relative_base + read_and_increment] = value
    else        raise "Unreachable"
    end
  end
end

puts "part1:"
puts Machine.new(input.dup).execute(1)
puts "part2:"
puts Machine.new(input.dup).execute(2)
