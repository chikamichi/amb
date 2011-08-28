# By Eric Kidd.
# See http://www.randomhacks.net/articles/2005/10/11/amb-operator.
module Amb
  # Use the ambiguous computation pattern as a stand-alone operator.
  module Operator
    require 'continuation'

    # A list of places we can "rewind" to if we encounter amb with no arguments.
    $backtrack_points = []

    # Rewind to our most recent backtrack point.
    #
    def backtrack
      if $backtrack_points.empty?
        raise "Can't backtrack"
      else
        $backtrack_points.pop.call
      end
    end

    # Recursive implementation of the amb operator, as defined by McCarty[63].
    #
    # When choices are provided as arguments, it will save a backtracking save
    # point for each and wait for being resumed. Resuming (starting the
    # check/discard process) is triggered by calling amb without any arguments.
    # It is expected you'll attach a conditionnal stating the constraint.
    #
    # @param choices a set of alternatives
    # @example
    #
    #    # amb will (appear to) choose values
    #    # for x and y that prevent future trouble.
    #    x = amb 1, 2, 3
    #    y = amb 4, 5, 6
    #
    #    # Ooops! If x*y isn't 8, amb would
    #    # get angry.  You wouldn't like
    #    # amb when it's angry.
    #    amb if x*y != 8
    #
    #    # Sure enough, x is 2 and y is 4.
    #    puts "x = #{x}, y = #{y}"
    #
    def amb *choices
      # Fail if we have no arguments.
      backtrack if choices.empty?

      callcc do |cc|
        # cc contains the "current continuation". When called, it will make the
        # program rewind to the end of this block.
        $backtrack_points << cc

        # Return our first argument.
        return choices[0]
      end

      # We only get here if we backtrack by resuming the stored value of cc.
      # We call amb recursively with the arguments we didn't use.
      amb(*choices[1...choices.length])
    end

    # Backtracking beyond a call to cut is strictly forbidden.
    #
    def cut
      $backtrack_points = []
    end
  end
end
