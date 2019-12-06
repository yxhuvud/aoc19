input = File.read "input.day6"

orbits =
  input
    .lines
    .map(&.split(")"))
    .to_h { |(orbit, orbitee)| {orbitee, orbit} }

orbit_sums = {} of String => Int32

def calc(str, orbits, orbit_sums)
  return 0 unless orbit_around = orbits[str]?

  orbit_sums[str] =
    if orbit_sums[orbit_around]?
      orbit_sums[orbit_around] + 1
    else
      calc(orbit_around, orbits, orbit_sums) + 1
    end
end

orbits.keys.each do |orbit|
  calc(orbit, orbits, orbit_sums)
end

puts "part 1"
puts orbit_sums.values.sum

def chain(str, orbits, set = Set(String).new)
  chain(orbits[str], orbits, set) if orbits[str]?
  set << str
end

santa_chain = chain(orbits["SAN"], orbits)
you_chain = chain(orbits["YOU"], orbits)

puts "part2"
puts (you_chain ^ santa_chain).size
