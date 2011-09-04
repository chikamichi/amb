$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.expand_path("../_shared.rb",  __FILE__)

class Ambiguous
  include Amb
end

# Constraint as an argument
@amb = Ambiguous.new
x = @amb.choose(1,2,3,4)
@amb.assert((x % 2) == 0)
puts x # 2

# Constraint with no valid execution path => raise
@amb = Ambiguous.new
begin
  y = @amb.choose(1,3,5)
  @amb.assert { y % 2 == 0 }
rescue Amb::ExhaustedError; end

# Constraint as a proc, with arbitrary parameters from args
@amb = Ambiguous.new
z = @amb.choose(1,2,3,4)
@amb.assert(3,1) { |i,j| (i*j*z) % 2 == 0 }
puts z # 2

puts "OK."
