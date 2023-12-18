require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/18.txt"
  else
    "sample/18.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
parsed =
  input.map do |line|
    # U 2 (#7a21e3)
    a, b, c = line.split
    [a, b.to_i, c[2..-2]]
  end

pp parsed

def uldr(s)
  case s
  when "U"
    return -1, 0
  when "L"
    return 0, -1
  when "R"
    return 0, 1
  when "D"
    return 1, 0
  end
end

wmin = 0
hmin = 0
wmax = 0
hmax = 0
now = [0, 0]
map = {}

parsed.each do |s, n, color|
  dir = uldr(s)
  (0...n).each do |i|
    newn = [now[0] + dir[0], now[1] + dir[1]]
    map[newn] = "#"
    hmin = [newn[0], hmin].min
    hmax = [newn[0], hmax].max
    wmin = [newn[1], wmin].min
    wmax = [newn[1], wmax].max
    now = newn
  end
end

pp [hmin, hmax, wmin, wmax]
mapp = array2d(wmax - wmin + 1, hmax - hmin + 1)
(hmin..hmax).each do |i|
  (wmin..wmax).each do |j|
    if map.key?([i, j])
      mapp[i - hmin][j - wmin] = "#"
    else
      mapp[i - hmin][j - wmin] = "."
    end
  end
end

# pp2d mapp

pad!(mapp, ".")
ins = 0
(1...mapp.size - 1).each do |i|
  st = 0
  is_in = false
  (1...mapp[0].size - 1).each do |j|
    c = mapp[i][j]
    if c == "#"
      ins += 1
      if mapp[i][j - 1] == "." && mapp[i][j + 1] == "."
        is_in = !is_in
      elsif mapp[i][j - 1] == "."
        st = -1 if mapp[i - 1][j] == "#"
        st = 1 if mapp[i + 1][j] == "#"
      elsif st != 0 && mapp[i][j + 1] == "."
        en = -1 if mapp[i - 1][j] == "#"
        en = 1 if mapp[i + 1][j] == "#"
        is_in = !is_in if en * st == -1
        st = 0
      else
      end
    else
      ins += 1 if is_in
    end
  end
end

pp ins

# 0 means R, 1 means D, 2 means L, and 3 means U.
dirr = { 0 => "R", 1 => "D", 2 => "L", 3 => "U" }

ins2 =
  parsed.map do |_, _, color|
    dir = uldr(dirr[color[-1].to_i])
    n = color[0..-2].to_i(16)
    [dir, n]
  end

polygon = [[0, 0]]
ins2.each do |dir, n|
  polygon.push([polygon[-1][0] + dir[0] * n, polygon[-1][1] + dir[1] * n])
end
polygon.push([0, 0])

ans2 = 0
# Shoelace formula
(0...polygon.size - 1).each do |i|
  p0 = polygon[i]
  p1 = polygon[i + 1]
  ans2 += (p0[1] + p1[1]) * (-p0[0] + p1[0])
  ans2 += (p0[0] - p1[0]).abs
  ans2 += (p0[1] - p1[1]).abs
end
pp ans2 / 2 + 1
