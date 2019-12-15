require "big"

input = File.read("input.day14")
parsed =
  input.lines
    .map(&.split("=>")
      .map(&.split(",")
        .map(&.chomp.split)))

cookbook = parsed.to_h do |row|
  {
    row.last.flatten.last,
    {
      row.last.flatten.first.to_i64,
      row.first.to_h { |reagent| {reagent.last, reagent.first.to_i64} },
    },
  }
end

def cook(cookbook, fuel)
  ore_need = 0i64
  inventory = {} of String => Int64
  needs = {"FUEL" => fuel.to_i64}

  while needs.any?
    key, amount = needs.shift
    if inventory[key]? && inventory[key] >= amount
      inventory[key] -= amount
    elsif inventory[key]?
      amount -= inventory[key]
      inventory.delete(key)
      needs[key] = amount
    else
      unit, ingredients = cookbook[key]
      factor = (amount / unit).ceil.to_i64
      inventory[key] = factor * unit - amount
      ingredients.each do |ingredient, value|
        value *= factor
        if ingredient == "ORE"
          ore_need += value
        elsif needs[ingredient]?
          needs[ingredient] += value
        else
          needs[ingredient] = value
        end
      end
    end
  end
  ore_need
end

puts "part1"
p cook(cookbook, 1)

amount = (0..1000000000).bsearch do |i|
  cook(cookbook, i + 1) > 1000000000000
end
puts "part2"
p amount if amount
