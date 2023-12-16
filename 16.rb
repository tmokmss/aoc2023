require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/16.txt"
  else
    "sample/16.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
parsed = input.map { |line| line.chars }

def next_light(mapp, seen, pos, dir)
  c = mapp[pos[0]][pos[1]]
  # pp [pos, dir, c]
  newp = []
  case c
  when "."
    pos[0] += dir[0]
    pos[1] += dir[1]
    newp.push([pos, dir])
  when "/"
    ndir = [-1, 0] if dir == [0, 1]
    ndir = [1, 0] if dir == [0, -1]
    ndir = [0, 1] if dir == [-1, 0]
    ndir = [0, -1] if dir == [1, 0]
    pos[0] += ndir[0]
    pos[1] += ndir[1]
    newp.push([pos, ndir])
  when "\\"
    ndir = [1, 0] if dir == [0, 1]
    ndir = [-1, 0] if dir == [0, -1]
    ndir = [0, -1] if dir == [-1, 0]
    ndir = [0, 1] if dir == [1, 0]
    pos[0] += ndir[0]
    pos[1] += ndir[1]
    newp.push([pos, ndir])
  when "|"
    if dir[0] != 0
      newp.push([[pos[0] + dir[0], pos[1] + dir[1]], dir])
    else
      newp.push([[pos[0] + 1, pos[1]], [1, 0]])
      newp.push([[pos[0] - 1, pos[1]], [-1, 0]])
    end
  when "-"
    if dir[1] != 0
      newp.push([[pos[0] + dir[0], pos[1] + dir[1]], dir])
    else
      newp.push([[pos[0], pos[1] + 1], [0, 1]])
      newp.push([[pos[0], pos[1] - 1], [0, -1]])
    end
  end

  res =
    newp
      .filter { |p| !(seen.include?([*p[0], *p[1]])) }
      .filter do |p, _|
        p[0] >= 0 && p[0] < mapp.size && p[1] >= 0 && p[1] < mapp[0].size
      end
  res.each { |p| seen.add([*p[0], *p[1]]) }
  res
end

dir = [0, 1] # right
start = [0, 0]
pos = [[start, dir]]
seen = Set.new
seen.add([*start, *dir])

loop do
  pos = pos.flat_map { |p| next_light(parsed, seen, p[0], p[1]) }
  # pp pos
  break if pos.empty?
end

# pp seen
pp seen.to_a.map { [_1[0], _1[1]] }.uniq.size

def search(start, dir, mapp)
  seen = Set.new
  seen.add([*start, *dir])
  pos = [[start, dir]]

  loop do
    pos = pos.flat_map { |p| next_light(mapp, seen, p[0], p[1]) }
    # pp pos
    break if pos.empty?
  end
  seen.to_a.map { [_1[0], _1[1]] }.uniq.size
end

maxbt =
  (0...parsed.size)
    .map do |i|
      [
        search([0, i], [1, 0], parsed),
        search([parsed.size - 1, i], [-1, 0], parsed)
      ].max
    end
    .max
maxrl =
  (0...parsed[0].size)
    .map do |i|
      [
        search([i, 0], [0, 1], parsed),
        search([i, parsed[0].size - 1], [0, -1], parsed)
      ].max
    end
    .max
pp [maxrl, maxbt].max
