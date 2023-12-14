require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/14.txt"
  else
    "sample/14.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
parsed = input.map { |line| line.chars }

def tilt_north(field)
  field = clone_array(field)
  dir = [1, 0]
  (1...field.size).each do |i|
    (0...field[0].size).each do |j|
      c = field[i][j]
      next if c != "O"
      start = 0
      (0...i).to_a.reverse.each do |k|
        if field[k][j] == "#"
          start = k
          break
        end
      end
      (start...i).each do |k|
        if field[k][j] == "."
          field[k][j] = "O"
          field[i][j] = "."
          break
        end
      end
    end
  end
  field
end

def tilt_south(field)
  field = tilt_north(field.reverse)
  field = field.reverse
end

def tilt_west(field)
  field = tilt_north(field.transpose)
  field.transpose
end

def tilt_east(field)
  field = tilt_south(field.transpose)
  field.transpose
end

def calc_ans1(field)
  field
    .map
    .with_index do |line, i|
      ii = field.size - i
      ii * line.count("O")
    end
    .sum
end

f1 = tilt_north(parsed)
pp2d f1
pp calc_ans1(f1)

def cycle(field)
  field = tilt_north(field)
  field = tilt_west (field)
  field = tilt_south(field)
  field = tilt_east (field)
  field
end

def ans2(field)
  cache = {}
  lasti = 0
  hit = 0
  (1..1_000_000_000).each do |i|
    field = cycle(field)
    str = field.map { _1.join("") }.join("\n")
    if cache.key?(str)
      lasti = i
      hit = cache[str]
      break
    end
    cache[str] = i
  end
  cyc = lasti - hit
  rem = (1_000_000_000 - lasti) % cyc
  pp rem
  pp [hit, lasti]
  res = cache.find { |k, v| v == (rem + hit) }[0]
  a = res.split("\n").map { _1.chars }
  calc_ans1(a)
end

pp ans2(parsed)
