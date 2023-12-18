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
distances = array2d(parsed[0].size, parsed.size, Float::INFINITY)
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

# pp vertices
ans2 = 0
vertices.push(vertices[0])
area = 0
edge = 0
(0...vertices.size - 1).each do |i|
  p0 = vertices[i]
  p1 = vertices[i + 1]
  area += (p0[1] + p1[1]) * (-p0[0] + p1[0])
  edge += (p0[0] - p1[0]).abs
  edge += (p0[1] - p1[1]).abs
end
edge += 1
area = (area / 2).abs
pp area
pp edge
ans2 = area - edge / 2 + 1
pp ans2
