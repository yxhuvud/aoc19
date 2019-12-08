chunks = File.read("input.day8").chomp
  .chars.in_groups_of(25*6).reverse

counts = chunks.min_by(&.count &.==('0')).tally
puts "part 1"
puts counts['1'] * counts['2']

image = chunks.reduce(chunks.last) do |img, chunk|
  img.zip(chunk).map do |i, c|
    case c
    when '0' then ' '
    when '1' then '#'
    else          i
    end
  end
end
puts "part 2"
puts image.each_slice(25).map(&.join).join('\n')
