file = File.open "input.txt"
solution = file.readlines.map { |line| line.delete('^0-9') }.reject(&:empty?).map{ |x| x.chars.first + x.chars.last}.map(&:to_i).sum()
puts solution
