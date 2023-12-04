def calc_winning_numbers(card)
    card.slice("winning", "having").map { |_, v| v.split("\s") }.reduce(:intersection)
end

card_regex = /^Card\s+(?<card>\d+):\s+(?<winning>(\d+\s+)+)\|(?<having>(\s+\d+)+)$/

file = File.open("input.txt")
cards = file.readlines.map { |line| line.match(card_regex)&.named_captures }.reject(&:nil?)
winning_numbers = cards.map { |card| calc_winning_numbers(card) }
wins = winning_numbers.map(&:count)

counts = [1] * wins.count
wins.each_with_index do |count, i|
    1.upto(count) do |j|
        counts[i + j] += counts[i]
    end
end

puts counts.sum
