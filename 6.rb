require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/6.txt"
  else
    "sample/6.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
time = input[0].split(" ")[1..].map(&:to_i) # ms
distance = input[1].split(" ")[1..].map(&:to_i) # mm

pp time
pp distance

def dist(start, last)
  start * (last - start)
end

win =
  (0...time.size).map do |i|
    t = time[i]
    d = distance[i]
    (0..t).filter { |x| dist(x, t) > d }.count
  end

pp win
pp win.inject(:*)

pp input
time = (input[0].split(" ")[1..].join("")).to_i # ms
distance = input[1].split(" ")[1..].join("").to_i # mm
pp time
pp distance

# k*(time-k) > d
# k**2 -tk + d < 0
# k = (t+-sqrt(t**2-4*d))/2

minwin = ((time - Math.sqrt(time**2 - 4*distance))/2.0).ceil
maxwin = ((time + Math.sqrt(time**2 - 4*distance))/2.0).floor

pp maxwin-minwin +1
