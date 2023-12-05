class CategoryMap
    attr_reader :from, :to
    
    def initialize(from, to)
        @from = from
        @to = to
        @ranges = []
    end
    
    def add_range(range)
        range.transform_values!(&:to_i)
        @ranges << range
    end
    
    def map(number)
        result = nil
        @ranges.each do |range|
            source = range["source"]
            length = range["length"]
            if (source...source+length).include? number
                result = range["destination"] + number - source
            end
        end
        result || number
    end
end

class Almanac
    CATEGORIES = %w{seed soil fertilizer water light temperature humidity location}
    SEED_REGEX = Regexp.new /^seeds:(?<seeds>(\s+\d+)+)\s*$/
    MAP_START_REGEX = Regexp.new /^(?<from>(#{CATEGORIES.join("|")}))-to-(?<to>(#{CATEGORIES.join("|")}))\s+map:\s*$/
    MAP_ENTRY_REGEX = Regexp.new /^(?<destination>\d+)\s+(?<source>\d+)\s+(?<length>\d+)\s*$/
    attr_accessor :maps
    def initialize(filename)
        @maps = {}
        parse(filename)
    end

    def parse_seeds(file, match)
        raw = match.named_captures["seeds"]
        @seeds = raw.strip.split(/\s+/).map(&:to_i)
        
        if file.eof?
            nil
        else
            file.readline
        end
    end
    
    def parse_map_entries(file, map)
        while !file.eof? do
            line = file.readline
            if line.match(MAP_ENTRY_REGEX)
                map.add_range(Regexp.last_match.named_captures)
            else
                return line
            end
        end
        nil
    end
    
    def parse_map(file, match)
        from = match.named_captures["from"]
        to = match.named_captures["to"]
        @maps[from] = CategoryMap.new(from, to)
        parse_map_entries(file, @maps[from])
    end
    
    def parse(filename)
        file = File.open filename
        line = file.readline
        while line do
            line = case line
            when SEED_REGEX
                parse_seeds(file, Regexp.last_match)
            when MAP_START_REGEX
                parse_map(file, Regexp.last_match)
            when /^\w*/
                file.eof? ? nil : file.readline
            end
        end
    end
    
    def propagate(number, category)
        while @maps[category] do
            number = @maps[category].map(number)
            category = @maps[category].to
        end
        [number, category]
    end
    
    def propagate_seeds()
        @seeds.map{|seed| propagate(seed, "seed") }
    end
end

almanc = Almanac.new("input.txt")
locations = almanc.propagate_seeds().select { |_, category| category == "location" }
puts locations.inspect
puts locations.map {|no, _| no }.min
