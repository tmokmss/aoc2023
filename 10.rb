require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/10.txt"
  else
    "sample/10.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).strip().split("\n").map(&:strip)
start = [0, 0]
parsed =
  input.map.with_index do |line, i|
    start = [i, line.chars.find_index("S")] if line.chars.find_index("S")
    next line.chars
  end

pad!(parsed, ".")
start[0] += 1
start[1] += 1
# pp parsed
pp start

pair = {
  "|": [[0, 1], [0, -1]],
  "-": [[1, 0], [-1, 0]],
  L: [[0, -1], [1, 0]],
  J: [[0, -1], [-1, 0]],
  "7": [[0, 1], [-1, 0]],
  F: [[0, 1], [1, 0]],
  ".": []
}

sdir =
  around4(start[0], start[1]).flat_map do |x, y|
    dirs = pair[parsed[x][y].to_sym]
    next [] if dirs.empty?
    dx = x - start[0]
    dy = y - start[1]
    pp [dx, dy]
    next [[dy, dx]] if dirs.any? { |dir| dir[1] == -dx && dir[0] == -dy }
    []
  end

pp sdir
distances = array2d(parsed.size, parsed[0].size, Float::INFINITY)
distances[start[0]][start[1]] = 0
# clockwise
curr = start
dir = sdir[0]
vertices = [start]
loop do
  nextc = [curr[0] + dir[1], curr[1] + dir[0]]
  break if nextc == start
  vertices.push(nextc)
  distances[nextc[0]][nextc[1]] = [
    distances[curr[0]][curr[1]] + 1,
    distances[nextc[0]][nextc[1]]
  ].min
  nextdir =
    pair[parsed[nextc[0]][nextc[1]].to_sym].find do |d|
      d[0] != -dir[0] || d[1] != -dir[1]
    end
  dir = nextdir
  curr = nextc
end

# anticlock
curr = start
dir = sdir[1]
loop do
  nextc = [curr[0] + dir[1], curr[1] + dir[0]]
  break if nextc == start
  distances[nextc[0]][nextc[1]] = [
    distances[curr[0]][curr[1]] + 1,
    distances[nextc[0]][nextc[1]]
  ].min
  nextdir =
    pair[parsed[nextc[0]][nextc[1]].to_sym].find do |d|
      d[0] != -dir[0] || d[1] != -dir[1]
    end
  dir = nextdir
  curr = nextc
end

# pp distances
pp distances.flatten.filter { _1 != Float::INFINITY }.max

mapp = distances.map { |row| row.map { _1 == Float::INFINITY ? "." : "#" } }
puts mapp.map { _1.join("") }.join("\n")

def check_range(rangei, rangej, mapp)
  check = array2d(mapp.size, mapp[0].size, "?")

  (0...check.size).each do |i|
    check[i][0] = "O"
    check[i][-1] = "O"
  end
  (0...check[0].size).each do |j|
    check[0][j] = "O"
    check[-1][j] = "O"
  end

  unknown_map = {}
  unknown_con = Hash.new { |h, k| h[k] = [] }

  id = 0
  rangei.each do |i|
    rangej.each do |j|
      c = mapp[i][j]
      next if c == "#"
      unknown = Set.new
      around4(i, j).each do |ii, jj|
        unknown.add(check[ii][jj]) if check[ii][jj].start_with?("id")
        check[i][j] = "I" if check[ii][jj] == "I"
        check[i][j] = "O" if check[ii][jj] == "O"
      end
      if check[i][j] == "?"
        if !unknown.empty?
          check[i][j] = unknown.first
          unknown_con[unknown.first].push(*unknown.to_a)
        else
          check[i][j] = "id#{id}"
          id += 1
        end
      else
        unknown.each { |u| unknown_map[u] = check[i][j] } if !unknown.empty?
      end
    end
  end

  pp unknown_map
  rangei.each do |i|
    rangej.each do |j|
      unknown_map.each { |k, v| check[i][j] = v if check[i][j] == k }
      # check[i][j] = "I" if check[i][j].start_with?("id")
    end
  end

  check
end

check1 = check_range((1...mapp.size - 1), (1...mapp[0].size - 1), mapp)
# check2 =
#   check_range((1...mapp.size - 1).to_a.reverse, (1...mapp[0].size - 1), mapp)
# check3 =
#   check_range(
#     (1...mapp.size - 1).to_a.reverse,
#     (1...mapp[0].size - 1).to_a.reverse,
#     mapp
#   )
# check4 =
#   check_range((1...mapp.size - 1), (1...mapp[0].size - 1).to_a.reverse, mapp)

check = array2d(parsed.size, parsed[0].size, "?")
puts check1.map { _1.join("") }.join("\n")

# (0...check.size).each do |i|
#   (0...check[0].size).each do |j|
#     next check[i][j] = "#" if mapp[i][j] == "#"
#     next check[i][j] = "O" if check1[i][j] == "O"
#     next check[i][j] = "O" if check2[i][j] == "O"
#     next check[i][j] = "O" if check3[i][j] == "O"
#     next check[i][j] = "O" if check4[i][j] == "O"
#     check[i][j] = "I"
#   end
# end

# puts check.map { _1.join("") }.join("\n")
puts check.flatten.filter { _1 == "I" }.size
