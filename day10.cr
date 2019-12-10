record(Pos, x : Int32, y : Int32)

input = File.read("input.day10")
map = input.lines.map(&.chars)

asteroids = Array(Pos).new
map.each_with_index do |row, y|
  row.each_with_index do |char, x|
    asteroids << Pos.new(x, y) if char != '.'
  end
end

sightings =
  asteroids.map do |a|
    asteroids.compact_map do |p|
      dx = a.x - p.x
      dy = a.y - p.y
      len = Math.sqrt(dx ** 2 + dy ** 2)
      next if len.zero?
      {(dx / len).round(10), (dy / len).round(10), p, len}
    end.group_by { |dx, dy| {dx, dy} }
      .values                # ie, of all in the same direction, find
      .map(&.min_by(&.last)) # the closest.
  end

orbital = sightings.max_by(&.size)
puts "part1"
puts orbital.size

shooting_order =
  (
    first_quadrant = orbital.select do |dx, dy|
      dx <= 0 && dy >= 0
    end.sort_by &.[1]
  ) + (
    second_and_third_quadrant = orbital.select do |dx, dy|
      dy < 0
    end.sort_by &.[0]
  ) + (
    fourth_quadrant = orbital.select do |dx, dy|
      dx > 0 && dy >= 0
    end.sort_by &.[1]
  )

puts "part2"
puts shooting_order[199][2].x * 100 + shooting_order[199][2].y
