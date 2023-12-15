require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/15.txt"
  else
    "sample/15.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)[0]
parsed = input.split(",")
pp parsed

def calc_hash(str)
  curr = 0
  str
    .chars
    .map { _1.ord }
    .each do |c|
      curr += c
      curr *= 17
      curr %= 256
    end
  curr
end

def parse(str)
  a, b = str.split("=")
  return *[a, b.to_i], true if b != nil
  a, b = str.split("-")
  return *[a, 0], false
end

pp parsed.map { calc_hash(_1) }.sum

boxes = Hash.new { |h, k| h[k] = {} }
labels = {}
parsed
  .map { parse(_1) }
  .each do |label, length, is_add|
    if is_add
      al = labels[label]
      box = calc_hash(label)
      boxes[box][label] = length
      labels[label] = boxes[box]
    else
      al = labels[label]
      al.delete(label) if !al.nil?
    end
  end

pp boxes
ans2 =
  boxes
    .map do |id, lenses|
      lenses.values.map.with_index(1) { |len, j| len * j }.sum * (id + 1)
    end
    .sum
pp ans2
