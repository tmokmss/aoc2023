require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/11.txt"
  else
    "sample/11.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
parsed = input.map { |line| line.chars }

pp parsed

expand = (0...parsed.size).map { [_1, nil] }
expand.concat((0...parsed[0].size).map { [nil, _1] })
expand = Set.new(expand)
pp expand
(0...parsed.size).each do |i|
  (0...parsed[i].size).each do |j|
    c = parsed[i][j]
    if c == "#"
      expand.delete([nil, j])
      expand.delete([i, nil])
    end
  end
end

pp expand
rowadd = 0
coladd = 0
expand.each do |i, j|
  if j == nil
    row = Array.new(parsed[0].size) { "." }
    parsed.insert(i + rowadd, row)
    rowadd += 1
  else
    (0...parsed.size).each { |k| parsed[k].insert(j + coladd, ".") }
    coladd += 1
  end
end

galaxies = []
(0...parsed.size).each do |i|
  (0...parsed[i].size).each do |j|
    c = parsed[i][j]
    galaxies << [i, j] if c == "#"
  end
end

pp galaxies.combination(2).size
ans1 = 0
galaxies
  .combination(2)
  .each { |a, b| ans1 += (a[0] - b[0]).abs + (a[1] - b[1]).abs }

pp ans1

repeat = 1_000_000

input = File.read(input_path).split("\n").map(&:strip)
parsed = input.map { |line| line.chars }
pp expand

galaxies = []
(0...parsed.size).each do |i|
  (0...parsed[i].size).each do |j|
    c = parsed[i][j]
    galaxies << [i, j] if c == "#"
  end
end

expandr = expand.filter { |x| x[0] != nil }.map { _1[0] }.sort
expandc = expand.filter { |x| x[1] != nil }.map { _1[1] }.sort
pp expandr, expandc

pp galaxies
ans2 = 0
galaxies
  .combination(2)
  .each do |a, b|
    colx1 = expandr.bsearch_index { _1 >= [a[0], b[0]].min } || expandr.size
    colx2 =
      expandr.size -
        (
          expandr.reverse.bsearch_index { _1 <= [a[0], b[0]].max } ||
            expandr.size
        )
    addx = (colx2 - colx1)
    rowy1 = expandc.bsearch_index { _1 >= [a[1], b[1]].min } || expandc.size
    rowy2 =
      expandc.size -
        (
          expandc.reverse.bsearch_index { _1 <= [a[1], b[1]].max } ||
            expandc.size
        )
    addy = (rowy2 - rowy1)
    ans2 += (a[0] - b[0]).abs + (a[1] - b[1]).abs + (addx + addy) * (repeat - 1)
  end
pp ans2
