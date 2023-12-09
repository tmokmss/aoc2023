require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/9.txt"
  else
    "sample/9.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
parsed = input.map { |line| line.split(" ").map(&:to_i) }

ans1 =
  parsed.map do |nums|
    lasts = [nums[-1]]
    arr = nums
    loop do
      diff = (0...arr.size - 1).map { |i| arr[i + 1] - arr[i] }
      lasts.push(diff[-1])
      break if diff.uniq.size == 1
      arr = diff
    end
    lasts.sum
  end

pp ans1.sum

ans2 =
  parsed.map do |nums|
    starts = [nums[0]]
    arr = nums
    loop do
      diff = (0...arr.size - 1).map { |i| arr[i + 1] - arr[i] }
      starts.push(diff[0])
      break if diff.uniq.size == 1
      arr = diff
    end
    ans = 0
    starts.reverse.each { |n| ans = n - ans }
    ans
  end

pp ans2.sum
