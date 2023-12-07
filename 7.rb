require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/7.txt"
  else
    "sample/7.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
parsed =
  input.map do |line|
    a, b = line.split(" ")
    [a, b.to_i]
  end

def check(deck)
  uniq = deck.chars.uniq
  if uniq.size == 1
    return -100 # five
  elsif uniq.size == 2
    if uniq.find { |c| deck.count(c) == 4 }
      return -99 #four
    elsif uniq.find { |c| deck.count(c) == 3 }
      return -98 #fullhouse
    end
  elsif uniq.size == 3
    if uniq.find { |c| deck.count(c) == 3 }
      return -97 #three
    elsif uniq.find { |c| deck.count(c) == 2 }
      return -96 #two
    end
  elsif uniq.size == 4
    return -95 # one
  else
    return -94 # highcard
  end
end

order = %w[]
#     a b c d e f g h i j k l m
mapp = {
  A: "a",
  K: "b",
  Q: "c",
  J: "d",
  T: "e",
  "9": "f",
  "8": "g",
  "7": "h",
  "6": "i",
  "5": "j",
  "4": "k",
  "3": "l",
  "2": "m"
}

pp parsed

res =
  parsed
    .map { |v| [v[0].chars.map { |c| mapp[c.to_sym] }.join, v[1]] }
    .sort do |a, b|
      next a[0] <=> b[0] if check(a[0]) == check(b[0])
      check(a[0]) <=> check(b[0])
    end
    .reverse

pp res
pp res.map.with_index { |v, i| v[1] * (i + 1) }.sum

mapp2 = {
  A: "a",
  K: "b",
  Q: "c",
  T: "e",
  "9": "f",
  "8": "g",
  "7": "h",
  "6": "i",
  "5": "j",
  "4": "k",
  "3": "l",
  "2": "m",
  J: "n",
}

def check2(deck)
  jokers = deck.chars.count("n")
  uniq = deck.chars.uniq
  if uniq.size == 1
    return -100 # five
  elsif uniq.size == 2
    if uniq.find { |c| deck.count(c) == 4 }
      return -100 if (jokers == 1 || jokers == 4)
      return -99 #four
    elsif uniq.find { |c| deck.count(c) == 3 }
      return -100 if (jokers == 3 || jokers == 2)
      return -99 if (jokers == 1)
      return -98 #fullhouse
    end
  elsif uniq.size == 3
    if uniq.find { |c| deck.count(c) == 3 }
      return -99 if (jokers == 3 || jokers == 1)
      return -98 if (jokers == 2)
      return -97 #three
    elsif uniq.find { |c| deck.count(c) == 2 }
      return -99 if (jokers == 2)
      return -98 if (jokers == 1)
      return -96 #two
    end
  elsif uniq.size == 4
    return -97 if (jokers == 1)
    return -97 if (jokers == 2)
    return -95 # one
  else
    return -95 if (jokers == 1)
    return -94 # highcard
  end
end

res =
  parsed
    .map { |v| [v[0].chars.map { |c| mapp2[c.to_sym] }.join, v[1]] }
    .sort do |a, b|
      next a[0] <=> b[0] if check2(a[0]) == check2(b[0])
      check2(a[0]) <=> check2(b[0])
    end
    .reverse

pp res
pp res.map.with_index { |v, i| v[1] * (i + 1) }.sum
