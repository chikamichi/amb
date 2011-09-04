require 'minitest/autorun'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.expand_path("../../lib/amb.rb",  __FILE__)

class Ambiguous
  include Amb
end

class TestAmb < MiniTest::Unit::TestCase
  def setup
    @amb = Ambiguous.new
  end

  def test_public_api
    assert_respond_to Amb, :choose
    assert_respond_to Amb, :failure
    assert_respond_to Amb, :assert
    assert_respond_to Amb, :report
    assert_respond_to Amb, :solve
    assert_respond_to Amb, :solve_all

    assert_respond_to @amb, :choose
    assert_respond_to @amb, :failure
    assert_respond_to @amb, :assert
    assert_respond_to @amb, :report
    assert_respond_to @amb.class, :new
    assert_respond_to @amb.class, :solve
    assert_respond_to @amb.class, :solve_all
  end

  def test_simple_constraint_as_arg
    @x = @amb.choose(1,2,3,4)
    @amb.assert((@x % 2) == 0)
    assert @x == 2, "#{@x} must equal 2 (first-match)"
  end

  def test_simple_constraint_as_block
    @x = @amb.choose(1,2,3,4)
    @amb.assert { @x % 2 == 0 }
    assert @x == 2, "#{@x} must equal 2 (first-match)"
  end

  def test_simple_constraint_as_block_with_parameters
    @x = @amb.choose(1,2,3,4)
    @amb.assert(4) { |i| (i * @x) % 2 == 0 }
    assert @x == 1, "#{@x} must equal 1 (first-match)"
  end

  def test_multiple_alternatives
    x = @amb.choose(1,2,3,4)
    y = @amb.choose(1,2,3,4)

    @amb.assert x + y == 5
    @amb.assert x - y == 1

    assert x == 3, "#{x} must equal 3"
    assert y == 2, "#{y} must equal 2"
  end

  def test_amb_tree_exhausted
    assert_raises(Amb::ExhaustedError) do
      x = @amb.choose(1,2,3,4)
      y = @amb.choose(1,2,3,4)

      @amb.assert x + y == 5
      @amb.assert x - y == 1
      @amb.assert x == 2
    end
  end
end
