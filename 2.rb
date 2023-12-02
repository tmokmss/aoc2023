require 'prettyprint'
require 'set'
require_relative './lib'

input_path = if ARGV.length < 1
               'input/2.txt'
             else
               'sample/2.txt'
             end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
parsed = input.map do |line|
  game, nums = line.split(':')
  idx = game.gsub('Game ', '').to_i
  ss = nums.split(';')
  res = ss.map do |s|
    b = s.split(',')
    b.map do |c|
      num, color = c.split(' ')
      num = num.to_i
      [color.to_sym, num]
    end.to_h
  end
  [idx, res]
end.to_h

pp parsed
res1 = parsed.map do |idx, game|
  aggr = Hash.new(0)
  game.each do |m|
    m.each do |col, n|
      aggr[col] = [n, aggr[col]].max
    end
  end
  pp aggr
  next idx if aggr[:blue] <= 14 && aggr[:green] <= 13 && aggr[:red] <= 12

  0
  # 12 red cubes, 13 green cubes, and 14 blue cubes?
end

pp res1
puts(res1.sum)

res2 = parsed.map do |_idx, game|
  aggr = Hash.new(0)
  game.each do |m|
    m.each do |col, n|
      aggr[col] = [n, aggr[col]].max
    end
  end
  pp aggr
  pow = aggr[:blue] * aggr[:green] * aggr[:red]
end
pp res2
puts(res2.sum)
