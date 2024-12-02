DIGITS = { one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9 }

FORWARD_REGEX = Regexp.new DIGITS.keys.join('|')
BACKWARD_REGEX = Regexp.new DIGITS.keys.join('|').reverse

def convert_digits_forward(s)
    s.gsub(FORWARD_REGEX) { |m| DIGITS[m.to_sym] }
end

def convert_digits_backward(s)
    s.reverse.gsub(BACKWARD_REGEX) { |m| DIGITS[m.reverse.to_sym] }
end

def transform(line)
    # puts line
    first = convert_digits_forward(line).delete('^0-9').chars&.first
    second = convert_digits_backward(line).delete('^0-9').chars&.first
    line = first&.+ second
    # puts line
    line
end

file = File.open "input.txt"
solution = file.readlines.map{|line| transform(line) }.map(&:to_i).sum()
puts solution
