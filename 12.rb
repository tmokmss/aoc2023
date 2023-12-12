require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/12.txt"
  else
    "sample/12.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
parsed =
  input.map do |line|
    s, ns = line.split
    [s.chars, ns.split(",").map(&:to_i)]
  end

pp parsed

def arrange(chars, springs)
  n = chars.count("?")
  res = 0
  (0..((1 << n) - 1)).each do |k|
    qc = -1
    newc =
      chars
        .map
        .with_index do |c, i|
          next c if c != "?"
          qc += 1
          next "#" if (k >> qc) & 1 == 1
          next "."
        end
        .join("")
    spr = newc.split(".").filter { _1 != "" }.map { _1.size }
    res += 1 if spr == springs
    # pp newc
    # pp newc if spr == springs
    # pp k if spr == springs
  end
  pp res
  res
end

# ans1
# pp parsed.map { arrange(_1, _2) }.sum

$ans2 = {}
def arrange2(chars, springs)
  # pp [chars&.join(""), springs]
  if springs.empty?
    return 1 if chars.nil? || chars.none?("#")
    return 0
  end
  if chars.nil? || chars.empty? || chars.all?(".")
    return 1 if springs.empty?
    return 0 if springs.size > 0
  end
  return 1 if springs.size == 1 && chars.none?(".") && springs[0] == chars.size
  return 0 if chars.size < springs.sum + springs.size - 1
  str = chars.join("")
  return $ans2[[str, springs]] if $ans2[[str, springs]]
  nextspr = springs[0]
  cont = 0
  idx = 0
  a =
    chars.each do |c|
      idx += 1
      if c == "?"
        # if cont == nextspr
        #   # choose "."
        #   break arrange2(chars[idx..], springs[1..])
        # elsif cont == nextspr - 1
        #   # choose "#"
        #   break 0 if chars[idx] == "#"
        #   break arrange2(chars[idx + 1..], springs[1..])
        # else
        # either choose "#" or choose "."
        ans = 0
        chars[idx - 1] = "#"
        ans += arrange2(chars, springs)
        chars[idx - 1] = "."
        ans += arrange2(chars, springs)
        chars[idx - 1] = "?"
        break ans
        # end
      elsif c == "."
        if cont == 0
          next
        elsif cont == nextspr
          break arrange2(chars[idx..], springs[1..])
        else
          break 0
        end
      elsif c == "#"
        cont += 1
        if cont == nextspr
          break 0 if chars[idx] == "#"
          break arrange2(chars[idx + 1..], springs[1..])
        elsif cont > nextspr
          break 0
        end
      end
      break 0 if idx == chars.size
    end
  $ans2[[str, springs]] = a
  a
end

a2 =
  parsed
    .map do |chars, springs|
      arrange2(
        5.times.map { chars.join }.join("?").chars,
        5.times.map { springs }.flatten
      )
    end
    .sum
# a2 = parsed.map { |chars, springs| arrange2(chars, springs) }.sum

# pp $ans2
pp a2
