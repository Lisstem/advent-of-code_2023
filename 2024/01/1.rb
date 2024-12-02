puts File.readlines('input-1.txt')
    .map{ |x| x.strip.split(/\s+/).map(&:to_i) }
    .transpose
    .map(&:sort)
    .transpose
    .map{ |x, y| (x - y).abs }
    .sum
