require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/8.txt"
  else
    "sample/8.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
seq = input[0].chars
parsed =
  input[2..]
    .map do |line|
      # HSR = (JPX, CXF)
      match = /([1-9A-Z]+) = \(([1-9A-Z]+), ([1-9A-Z]+)\)/.match(line)
      [match[1], [match[2], match[3]]]
    end
    .to_h

pp parsed

start = "AAA"
last = "ZZZ"

cnt = 0
now = start
loop do
  break if now == last
  inst = seq[cnt % seq.length]
  idx = 0 if inst == "L"
  idx = 1 if inst == "R"
  now = parsed[now][idx]
  cnt += 1
end

pp cnt

starts = parsed.keys.filter { _1.end_with? ("A") }
pp starts
count =
  starts.map do |start|
    now = start
    cnt = 0
    loop do
      break cnt if now.end_with?("Z")
      inst = seq[cnt % seq.length]
      idx = 0 if inst == "L"
      idx = 1 if inst == "R"
      now = parsed[now][idx]
      cnt += 1
    end
  end

pp count
pp count.inject(:lcm)
