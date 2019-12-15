class Machine
  def initialize(@codes : Array(Int64), @input = Deque(Int64).new, @output = Deque(Int64).new)
    @pos = 0i32
    @relative_base = 0i32
    @modes = [] of Int64
  end

  def execute
    loop do
      case op = next_op
      when 1 then write(read + read)
      when 2 then write(read * read)
      when 3
        if @input.empty?
          @pos = @pos - 1
          break false
        end
        write(@input.shift)
      when  4 then @output << read
      when  5 then read > 0 ? (@pos = read.to_i32) : read
      when  6 then read == 0 ? (@pos = read.to_i32) : read
      when  7 then read < read ? write(1) : write(0)
      when  8 then read == read ? write(1) : write(0)
      when  9 then @relative_base += read
      when 99 then break true
      else         raise "Unreachable"
      end
    end
  end

  def input(n)
    @input << n.to_i64
  end

  def output
    @output.shift
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
