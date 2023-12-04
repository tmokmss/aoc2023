require 'prettyprint'
require 'set'
require_relative './lib'

input_path = if ARGV.length < 1
               'input/4.txt'
             else
               'sample/4.txt'
             end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
parsed = input.map do |line|
  # Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  card, seq = line.split(':')
  card = card.split(' ')[1].to_i
  seq1, seq2 = seq.split('|')
  seq1 = seq1.split(' ').map(&:to_i)
  seq2 = seq2.split(' ').map(&:to_i)
  [card, [seq1, seq2]]
end.to_h
pp parsed

scores = parsed.map do |_id, seqs|
  win = Set.new(seqs[0])
  have = Set.new(seqs[1])
  next 0 if win.intersection(have).size == 0

  2**(win.intersection(have).size - 1)
end
pp scores.sum

copies = Hash.new(0)
n = parsed.size

parsed.each do |id, seqs|
  copies[id] += 1
  win = Set.new(seqs[0])
  have = Set.new(seqs[1])
  m = win.intersection(have).size
  (id + 1..[n, id + m].min).each do |i|
    copies[i] += 1 * copies[id]
  end
end

pp copies.values.sum
