require 'prettyprint'
require 'set'
require_relative './lib'

input_path = if ARGV.length < 1
               'input/1.txt'
             else
               'sample/1.txt'
             end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)

# digits = input.map do |line|
#   first = line.chars.find {|c| c>='0' && c<='9'}
#   last = line.chars.reverse.find {|c| c>='0' && c<='9'}
#   (first + last).to_i
# end
# puts(digits.sum)

nums = {
  one: 1,
  two: 2,
  three: 3,
  four: 4,
  five: 5,
  six: 6,
  seven: 7,
  eight: 8,
  nine: 9
}
# nine  -> eight -> three
# one               two
# three
# five
#
# seven -> nine
# two -> one

digits = input.map do |line|
  fregex = Regexp.new "[1-9]|#{nums.keys.map { _1.to_s }.join('|')}"
  lregex = Regexp.new "[1-9]|#{nums.keys.map { _1.to_s.reverse }.join('|')}"
  pp fregex
  matches = line.scan(fregex)
  fc = matches[0]
  matches = line.reverse.scan(lregex)
  lc = matches[0]
  pp([line, fc, lc])
  nums.each do |k, v|
    fc = v.to_s if k.to_s == fc
    lc = v.to_s if k.to_s.reverse == lc
  end
  (fc + lc).to_i
end

puts(digits.size)
puts(digits.sum)
