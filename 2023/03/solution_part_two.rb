def touches?(number, number_y, x, y)
    return false unless number
    
    first, last = number.offset(0)
    case number_y
    when y
        first - 1 == x || last == x
    when y + 1
        (first-1..last).include? x
    when y - 1
        (first-1..last).include? x
    else
        false
    end
end

def neighboring_numbers(numbers, x, y)
    relevant = numbers[y-1..y+1].each_with_index.flat_map {|line, i| line.select { |number| touches?(number, y-1+i, x, y) }.map {|number| number.match(0).to_i } }
end

file = File.open "input.txt"
schematic = file.readlines.map { |line| "." + line.strip + "." }.prepend("").append("")
numbers = schematic.map { |line| line.to_enum(:scan, /\d+/).map { Regexp.last_match } }
stars = schematic.each_with_index.flat_map { |line, y| line.chars.each_with_index.select { |c, x| c == '*' }.map { |_, x| [x, y] } }.reject(&:empty?)
neighbors = stars.map { |x,y| neighboring_numbers(numbers, x,y) }
gears = neighbors.select { |arr| arr.count == 2 }
sum = gears.sum { |arr| arr.inject(:*) }
puts sum
