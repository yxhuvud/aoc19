input = "152085-670283".split('-').map(&.to_i)
range = input[0]..input[1]

# Bleh. Ugly as hell but decreases allocations to be fast enough.
buf = IO::Memory.new(6)
count = range.count do |i|
  i.to_s(buf)
  chars = buf.to_slice
  match = false
  increasing = false
  buf.clear

  5.times do |c|
    increasing ||= chars[c] > chars[c + 1]
    match ||= chars[c] == chars[c + 1]
  end
  !increasing && match
end
puts "part1"
p count

match_types = Array(Char).new
triples = Array(Char).new

count = range.count do |i|
  i.to_s(buf)
  chars = buf.to_slice
  match_types.clear
  triples.clear
  buf.clear
  increasing = false

  5.times do |c|
    increasing ||= chars[c] > chars[c + 1]
    if chars[c] == chars[c + 1]
      triples << chars[c].chr if match_types.includes? chars[c].chr
      match_types << chars[c].chr
    end
  end
  !increasing && (match_types - triples).any?
end
puts "part2"
p count
