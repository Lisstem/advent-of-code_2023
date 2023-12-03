def char_symbol?(char)
    char && char != "."
end

def string_symbol?(line, first, last)
    line = line&.slice(first, last - first + 1)
    line&.match(/[^\.]/)
end

def symbol?(schematic, line, first, last)
    char_symbol?(schematic[line][first - 1]) ||
    char_symbol?(schematic[line][last + 1]) ||
    string_symbol?(schematic[line-1], first - 1, last + 1) ||
    string_symbol?(schematic[line+1], first - 1, last + 1)
end

file = File.open "input.txt"
schematic = file.readlines.map { |line| "." + line.strip + "." }.prepend("").append("")
line_matches = schematic.map { |line| line.to_enum(:scan, /\d+/).map { Regexp.last_match } }
numbers = line_matches.each_with_index.flat_map do |matches, i|
    matches.map do |match|
        first, last = match.offset(0)
        if symbol? schematic, i, first, last -1
            match.match(0).to_i
        else
            nil
        end
    end
end.compact

puts numbers.inspect
puts numbers.sum
