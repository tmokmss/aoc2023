require 'prettyprint'
require 'set'
require_relative './lib'

input_path = if ARGV.length < 1
               'input/5.txt'
             else
               'sample/5.txt'
             end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
maps = Hash.new { |h, k| h[k] = [] }
seeds = []
map_key = nil
input.each do |line|
  if line.start_with?('seeds:')
    seeds = line.split(':')[1].split(' ').map(&:to_i)
  elsif line.end_with?('map:')
    map_key = line.split(' ')[0]
  else
    nums = line.split(' ').map(&:to_i)
    maps[map_key].push(nums) if nums.size > 0
  end
end

result = seeds.map do |seed|
  curr = seed
  res = seed
  maps.each_value do |ranges|
    ranges.each do |range|
      if curr >= range[1] && curr <= range[1] + range[2]
        res = curr + range[0] - range[1]
        next
      end
    end
    curr = res
  end
  res
end

pp result.min

ranges = seeds.each_slice(2).map do |srange|
  [srange[0], srange[0] + srange[1]]
end

maps.each_value do |mranges|
  # phase loop
  sranges = ranges.dup
  ranges = []
  sranges.each do |srange|
    r2 = srange
    min = r2[1]
    max = r2[0]
    mranges.each do |mrange|
      r1 = [mrange[1], mrange[1] + mrange[2]]
      next unless r1[0] <= r2[1] && r2[0] <= r1[1]

      start = [r1[0], r2[0]].max
      last = [r1[1], r2[1]].min
      diff = mrange[0] - mrange[1]
      ranges.push([start + diff, last + diff])
      min = [start - 1, min].min
      max = [last + 1, max].max
    end
    ranges.push([r2[0], min]) if min >= r2[0]
    ranges.push([max, r2[1]]) if max <= r2[1] && !(r2[0] == max && r2[1] == min)
  end
end

pp ranges.map { |r| r[0] }.min
