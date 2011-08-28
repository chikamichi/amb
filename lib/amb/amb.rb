# Copyright 2006 by Jim Weirich <jim@weirichhouse.org>. All rights reserved.
# Permission is granted for use, modification and distribution as
# long as the above copyright notice is included.
# Modified by Jean-Denis Vauguet <jd@vauguet.fr> for Amb gem release.

# Amb is an ambiguous choice maker. You can ask an Amb object to
# select from a discrete list of choices, and then specify a set of
# constraints on those choices. After the constraints have been
# specified, you are guaranteed that the choices made earlier by amb
# will obey the constraints.
#
# For example, consider the following code:
#
#   amb = Class.new { include Amb }.new
#   x = amb.choose(1,2,3,4)
#
# At this point, amb may have chosen any of the four numbers (1
# through 4) to be assigned to x. But, now we can assert some
# conditions:
#
#   amb.assert (x % 2) == 0
#
# This asserts that x must be even, so we know that the choice made by
# amb will be either 2 or 4. Next we assert:
#
#   amb.assert x >= 3
#
# This further constrains our choice to 4.
#
#   puts x    # prints '4'
#
# Amb works by saving a contination at each choice point and
# backtracking to previousl choices if the contraints are not
# satisfied. In actual terms, the choice reconsidered and all the
# code following the choice is re-run after failed assertion.
#
# You can print out all the solutions by printing the solution and
# then explicitly failing to force another choice. For example:
#
#   amb = Class.new { include Amb }.new
#   x = Amb.choose(*(1..10))
#   y = Amb.choose(*(1..10))
#   amb.assert x + y == 15
#
#   puts "x = #{x}, y = #{y}"
#
#   amb.failure
#
# The above code will print all the solutions to the equation x + y ==
# 15 where x and y are integers between 1 and 10.
#
# The Amb class has two convience functions, solve and solve_all for
# encapsulating the use of Amb.
#
# This example finds the first solution to a set of constraints:
#
#   Amb.solve do |amb|
#     x = amb.choose(1,2,3,4)
#     amb.assert (x % 2) == 0
#     puts x
#   end
#
# This example finds all the solutions to a set of constraints:
#
#   Amb.solve_all do |amb|
#     x = amb.choose(1,2,3,4)
#     amb.assert (x % 2) == 0
#     puts x
#   end
#
module Amb
  require 'continuation'

  class ExhaustedError < RuntimeError; end

  def self.included(base)
    base.extend(ClassMethods)
  end

  # Memoize and return the alternatives associated continuations.
  #
  # @return [Array<Proc, Continuation>]
  #
  def back_amb
    @__back_amb ||= [Proc.new { fail ExhaustedError, "amb tree exhausted" }]
  end

  # Make a choice amoung a set of discrete values.
  #
  # @param choices
  #
  def choose(*choices)
    choices.each do |choice|
      callcc do |fk|
        back_amb << fk
        return choice
      end
    end
    failure
  end
  alias :choices :choose
  alias :alternatives :choose

  # Unconditional failure of a constraint, causing the last choice to be
  # retried. This is equivalent to saying `assert(false)`.
  #
  # Use to force a search for another solution (see examples).
  # @TODO it'd be better not to have to
  #
  def failure
    back_amb.pop.call
  end

  # Assert the given condition is true. If the condition is false,
  # cause a failure and retry the last choice. One may specify the condition
  # either as an argument or as a block. If a block is provided, it will be
  # passed the arguments, whereas without a block, the first argument will
  # be used as the condition.
  #
  # @param cond
  # @yield
  #
  def assert(*args)
    cond = block_given? ? yield(*args) : args.first
    failure unless cond
  end

  # Report the given failure message.  This is called by solve in the event
  # that no solutions are found, and by +solve_all+ when no more solutions
  # are to be found.  Report will simply display the message to standard
  # output, but you may override this method in a derived class if you need
  # different behavior.
  #
  # @param [#to_s] failure_message
  #
  def report(failure_message)
    puts failure_message
  end

  module ClassMethods
    # Class convenience method to search for the first solution to the
    # constraints.
    #
    def solve(failure_message = "No Solution")
      amb = self.new
      yield(amb)
    rescue Amb::ExhaustedError => ex
      amb.report(failure_message)
    end

    # Class convenience method to search for all the solutions to the
    # constraints.
    #
    def solve_all(failure_message = "No More Solutions")
      amb = self.new
      yield(amb)
      amb.failure
    rescue Amb::ExhaustedError => ex
      amb.report(failure_message)
    end
  end

  extend self
  extend self::ClassMethods
end
