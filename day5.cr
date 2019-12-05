class Machine
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

  def execute(input)
    loop do
      case op = next_op
      when 1
        write(read + read)
      when 2
        write(read * read)
      when 3
        write(input)
      when 4
        puts read
      when 5
        read > 0 ? (@pos = read) : read
      when 6
        read == 0 ? (@pos = read) : read
      when 7
        write(read < read ? 1 : 0)
      when 8
        write(read == read ? 1 : 0)
      when 99
        break
      else
        raise "Unknown code #{op}"
      end
    end
  end
end

codes = File.read("input.day5").split(",").map(&.to_i)
puts "part1: "
Machine.new(codes.dup).execute(1)
puts "part2:"
Machine.new(codes.dup).execute(5)
