require 'prettyprint'
require 'set'
require_relative './lib'

input_path = if ARGV.length < 1
               'input/3.txt'
             else
               'sample/3.txt'
             end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
parsed = input.map do |line|
  line.chars
end

# pp parsed

h = parsed.size
w = parsed[0].size
pad!(parsed, '.')
ans1 = 0
gears = Hash.new { |h, k| h[k] = [] }
(1..h).each do |i|
  curr = ''
  (1..w + 1).each do |j|
    c = parsed[i][j]
    if c >= '0' && c <= '9'
      curr += c
    elsif curr != ''
      inc = false
      (0...curr.size).each do |k|
        around8(i, j - k - 1).each do |x, y|
          cc = parsed[x][y]
          inc = true if cc != '.' && !(cc >= '0' && cc <= '9')
          gears[[x, y]].push(curr.to_i) if cc == '*'
        end
        break if inc
      end
      ans1 += curr.to_i if inc
      curr = ''
    end
  end
end

pp ans1

pp gears.filter { |_k, v| v.size == 2 }.map { |_k, v| v.inject(:*) }.sum
