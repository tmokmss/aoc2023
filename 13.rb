require "prettyprint"
require "set"
require_relative "./lib"

input_path =
  if ARGV.length < 1
    "input/13.txt"
  else
    "sample/13.txt"
  end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
matrices = []
parsed =
  input.map do |line|
    if line == ""
      matrices.push([])
      next
    end
    matrices[-1].push(line.chars)
  end

def find_reflection(matrix)
  # find row ref
  rows = []
  (1...matrix.size).each do |i|
    found = true
    scan = [matrix.size - i, i].min
    (1..scan).each do |j|
      # pp [i, i + j, i - j]
      if matrix[i + j - 1] != matrix[i - j]
        found = false
        break
      end
    end
    if found
      # pp "found row! #{i}"
      rows.push i
    end
  end
  rows.push(0) if rows.empty?
  rows
end

def find_reflection_row_col(matrix)
  row = find_reflection(matrix)
  col = find_reflection(transpose(matrix))
  [row, col]
end

refl = matrices.map { |matrix| find_reflection_row_col(matrix) }
ans1 = refl.map { |res| res[1][0] + res[0][0] * 100 }.sum
pp ans1
# exit
def try_smudge(matrix, org_refl)
  (0...matrix.size).each do |i|
    (0...matrix[0].size).each do |j|
      c = matrix[i][j]
      matrix[i][j] = "#" if c == "."
      matrix[i][j] = "." if c == "#"
      new_refl = find_reflection_row_col(matrix)
      matrix[i][j] = c
      # pp [org_refl, new_refl, [i, j]]
      if new_refl != [[0], [0]]
        nr = new_refl[0].find { _1 != org_refl[0] && _1 != 0 }
        nc = new_refl[1].find { _1 != org_refl[1] && _1 != 0 }
        # pp [new_refl, org_refl]
        next if nr == nil && nc == nil
        return nr || 0, nc || 0
      end
    end
  end
  # pp2d matrix
  # pp org_refl
  raise "not found"
end

newrefl =
  matrices.map.with_index do |matrix, i|
    try_smudge(matrix, [refl[i][0][0], refl[i][1][0]])
  end
ans2 = newrefl.map { |res| res[1] + res[0] * 100 }.sum
pp ans2
