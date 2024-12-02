def char_symbol?(char)
    char && char != "."
end

def string_symbol?(line, first, last)
    line = line&.slice(first, last - first + 1)
    line&.match(/[^\.]/)
end

def symbol?(first, last, prior, line, after)
    char_symbol?(line[first - 1]) ||
    char_symbol?(line[last]) ||
    string_symbol?(prior, first - 1, last) ||
    string_symbol?(after, first - 1, last)
end

def find_numbers(prior, line, after)
    line.to_enum(:scan, /\d+/).map { Regexp.last_match}.each_with_object([prior, line, after])
end

file = File.open "input.txt"
schematic = [""].chain(file.readlines.map { |line| "." + line.strip + "." }, [""])
numbers = schematic.each_cons(3).map { |lines| find_numbers(*lines) }.inject(:chain).select { |match, lines| symbol?(*match.offset(0), *lines) }.map { |match, lines| match.match(0).to_i }

puts numbers.sum
