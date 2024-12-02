x, y = File.readlines('input-1.txt')
    .map{ |x| x.strip.split(/\s+/).map(&:to_i) }
    .transpose
y = y.group_by(&:itself).map{ |k,v| [k, v.count]}.to_h
y.default = 0
puts x.map { |x| x * y[x] }.sum
