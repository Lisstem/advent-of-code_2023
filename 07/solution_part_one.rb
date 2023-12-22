CARD_RANKING =  %w{A K Q J T 9 8 7 6 5 4 3 2}.each_with_index.to_h
TYPE_RANKING = %i{high_card one_pair two_pair three_kind fullhouse four_kind five_kind}.reverse.each_with_index.to_h

CARD_REGEX = /(#{CARD_RANKING.keys.join('|')})/
REGEX = /^(?<hand>#{CARD_REGEX}+)\s+(?<bid>\d+)$/

def find_type(hand)
    counts = hand.each_char.tally
    card, max = counts.max_by(&:last)
    case max
    when 1 then :high_card
    when 2
        counts.delete(card)
        _, second_max = counts.max_by(&:last)
        second_max == 2 ? :two_pair : :one_pair
    when 3 then counts.size == 2 ? :fullhouse : :three_kind
    when 4 then :four_kind
    when 5 then :five_kind
    end
end

def attach_sort(hand)
    hand["sort"] = hand["hand"].chars.map { |c| CARD_RANKING[c] }
end

data = File.open("input.txt").readlines.map { |line| line.match(REGEX).named_captures }.each{|hand| attach_sort(hand) }
grouped = data.group_by { |date| find_type(date["hand"]) }
sorted = grouped.transform_values { |hands| hands.sort_by { |hand| hand["sort"] } }.sort_by { |type, _| TYPE_RANKING[type] }
bids = sorted.flat_map { |_, hands| hands.map { |hand| hand["bid"] } }.map(&:to_i).reverse
sum = bids.each_with_index.map { |bid, i| bid*(i + 1) }.sum
puts sum


