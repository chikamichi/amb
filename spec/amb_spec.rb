require 'minitest/autorun'
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
    x = @amb.choose(1,2,3,4)
    @amb.assert((x % 2) == 0)
    assert x == 2, "#{x} must equal 2 (first-match)"
  end

  def test_simple_constraint_as_block
    x = @amb.choose(1,2,3,4)
    @amb.assert { x % 2 == 0 }
    assert x == 2, "#{x} must equal 2 (first-match)"
  end
end
