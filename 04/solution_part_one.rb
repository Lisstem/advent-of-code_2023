def calc_winning_numbers(card)
    card.slice("winning", "having").map { |_, v| v.split("\s") }.reduce(:intersection)
end

card_regex = /^Card\s+(?<card>\d+):\s+(?<winning>(\d+\s+)+)\|(?<having>(\s+\d+)+)$/

file = File.open("input.txt")
cards = file.readlines.map { |line| line.match(card_regex)&.named_captures }.reject(&:nil?)
winning_numbers = cards.map { |card| calc_winning_numbers(card) }
points = winning_numbers.map(&:count).reject(&:zero?).map { |c| 2**(c-1) }
puts points.sum
