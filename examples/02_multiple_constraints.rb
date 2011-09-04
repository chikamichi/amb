$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.expand_path("../_shared.rb",  __FILE__)

# a valid solution exists (first-match: x=3, y=2)
@amb = Ambiguous.new
x = @amb.choose(1,2,3,4)
y = @amb.choose(1,2,3,4)
@amb.assert x + y == 5
@amb.assert x - y == 1
puts "x = #{x}, y = #{y}"

# no valid solution exists
@amb = Ambiguous.new
x = @amb.choose(1,2,3,4)
y = @amb.choose(1,2,3,4)
@amb.assert x + y == 5
@amb.assert x - y == 1
@amb.assert x == 2 # will raise Amb::ExhaustedError
