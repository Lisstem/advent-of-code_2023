def solution_range(time, distance)
    root = Math.sqrt(0.25*time*time - 1.0 * distance)
    first = 0.5*time - root
    last = 0.5*time + root
    first = first == first.ceil ? first.ceil + 1 : first.ceil
    last = last == last.floor ? last.floor - 1 : last.floor
    (first..last)
end

regex = Regexp.new(/^Time:(?<time>(\s+\d+)+)\s*^Distance:(?<distance>(\s+\d+)+)\s*/)

lines = File.open("input.txt").read
data = lines.match(regex).named_captures.map { |k,v| [k, v.gsub(/\s+/, "").to_i] }.to_h
puts data
puts solution_range(data["time"], data["distance"]).count

