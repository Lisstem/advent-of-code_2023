def extract_cube(input)
  count, color = input.split(' ')
  [color.to_sym, count.to_i]
end

def extract_cubes(input)
  input.split(', ').map { |c| extract_cube(c) }.to_h
end
 
def extract_sets(input)
  input.split('; ').map { |s| extract_cubes(s) }
end

def extract_game(input)
  game, sets = input.split(': ')
  [game[5..].to_i, extract_sets(sets)]
end

def set_possible?(set, cubes)
  set.all? { |color, count| count <= cubes[color] }
end

def game_possible?(sets, cubes)
  sets.all? { |set| set_possible? set, cubes }
end

cubes = { red: 12, green: 13, blue: 14 }
file = File.open "input.txt"
games = file.each_line.map { |line| extract_game line }
possible_games = games.select { |id, sets| game_possible? sets, cubes }
sum = possible_games.sum { |id, sets| id }
puts sum

