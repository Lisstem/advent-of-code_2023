
NODE_REGEX = /[A-Z]{3}/
REGEX = /^(?<node>#{NODE_REGEX})\s+=\s+\((?<L>#{NODE_REGEX}),\s+(?<R>#{NODE_REGEX})\)\s*$/

def find_node(directions, nodes, start, stop)
  return 0 if start == stop
  
  i = 0
  node = nodes[start]
  
  puts node.inspect
  
  directions.chars.cycle do |direction|
    i += 1
    puts [i, node, direction].inspect
    
    return i if node[direction] == stop
    
    node = nodes[node[direction]]
  end
end


data = File.open("input.txt").readlines
directions = data.first
map = data[2..]
nodes = map.map{ |line| line.match(REGEX).named_captures }.map { |node| [node["node"], node.slice("L", "R")] }.to_h
puts nodes.inspect
puts find_node(directions.strip, nodes, "AAA", "ZZZ")
