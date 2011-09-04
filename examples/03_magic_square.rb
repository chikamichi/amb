# Ruby Quiz # 70 -- Constraint Solving
# Copyright 2006 by Jim Weirich
#
# Again, using Amb to solve the magic square constraint problem. The
# key to getting this to run half-way efficiently is to do the
# assertions as soon as possible, before additional choices have been
# made. This minimizes the amount of backtracking needed.
#
# See the following for details about Amb:
# http://www.ccs.neu.edu/home/dorai/t-y-scheme/t-y-scheme-Z-H-16.html#node_chap_14

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.expand_path("../_shared.rb",  __FILE__)

# A Magic Square class, mostly to get convenient column/row/diagonal
# summations and detecting previously used values.
#
class MagicSquare
  def initialize(side)
    @side = side
    @values = Array.new(side**2) { 0 }
  end

  # Access square value
  def [](col, row)
    @values[col + @side*row]
  end

  # Set square value
  def []=(col, row, value)
    @values[index(col, row)] = value
  end

  # Calculate the sum of value along row +row+.
  def row_sum(row)
    (0...SIDE).inject(0) { |sum, col| sum + self[col,row] }
  end

  # Calculate the sum of values in column +col+.
  def col_sum(col)
    (0...SIDE).inject(0) { |sum, row| sum + self[col,row] }
  end

  # Calculate the sum of values along the major diagonal (i.e. r ==
  # c).
  def diagonal_sum
    (0...SIDE).inject(0) { |sum, i| sum + self[i,i] }
  end

  # Calculate the sum of values along the other diagnol (i.e. r ==
  # SIDE-c-1).
  def other_diagonal_sum
    (0...SIDE).inject(0) { |sum, i| sum + self[i,SIDE-i-1] }
  end

  # Has this value been previously used in the square in any previous
  # row, or any previous column of the current row?
  def previously_used?(col, row, value)
    (0...index(col, row)).any? { |i| @values[i] == value }
  end

  # Convert to string for display.
  def to_s
    (0...SIDE).collect { |r|
      (0...SIDE).collect { |c| self[c,r] }.join(' ')
    }.join("\n")
  end

  private

  def index(col, row)
    col + @side*row
  end
end

SIDE = 3
MAX = SIDE**2
SUM = (MAX*(MAX+1))/(2*SIDE)

A = Ambiguous.new
square = MagicSquare.new(SIDE)

# Build up the square position by position. To minimize backtracking,
# assert everything you know about a position as early as possible.

count = 0

begin
  (0...SIDE).each do |r|
    (0...SIDE).each do |c|
      value = A.choose(*(1..MAX))
      A.assert ! square.previously_used?(c, r, value)
      square[c,r] = value
      A.assert( (r < SIDE-1) || square.col_sum(c) == SUM)
    end
    A.assert square.row_sum(r) == SUM
  end

  A.assert square.diagonal_sum == SUM
  A.assert square.other_diagonal_sum == SUM

  count += 1
  puts "SOLUTION #{count}:"
  puts square

  # Explicitly force a failure and make the program search for another
  # solution.
  A.failure
rescue Amb::ExhaustedError
  puts "No More Solutions"
end
