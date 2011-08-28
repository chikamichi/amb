This gem is a compilation of several implementations of the **ambiguous function/operator** pattern, useful for constraint programming. Each implementation comes with its own copyright notice and authors, so be sure to check the CREDITS file!

Ever wanted to:

* write straightforward parsers?
* solve crosswords and sudokus or the n-queens problem?
* design an equation-solver or a modelizer?
* understand how logic programming languages (Prolog…) work?

Them amb may be of interest to you.

## Synopsis

*You may want to jump straight to the Examples section if formal stuff annoys you.*

Ambiguous functions were [defined in John McCarty's 1963 paper](http://www-formal.stanford.edu/jmc/basis1/node7.html) *A basis for a mathematical theory of computation*. They allow for writing nondeterministic programs which contain various alternatives for the program flow.

Typically, the programmer would specify a limited number of alternatives (eg. different values for a variable), so that the program must later choose between them at runtime to find which one(s) are valid predicates to solve the issue at stake. The "issue" is often formalized as a constraint or a set of constraints referencing the variables some alternatives have been provided for. The evaluation may result in the discovery of dead ends, in which case it must "switch" to a previous branching point and start over with a different alternative.

To discover which alternatives groups are valid, a check/discard/switch strategy must be enforced by the program. Most often it will make use of a ambiguous operator, `amb()` which implements this strategy. The most basic version of `amb` would be `amb(x,y)`, which returns, *in an unpredictible way*, either x or y when both are defined, or if only one is defined, whichever is defined. If none is defined, it will terminate the program and complain no solution can be found given these alternatives and constraint(s). Using some recursivity, `amb()` may be used to define arbitrary, complex ambiguous functions. It is quite difficult to implement a good `amb()` operator matching that formal definition. A simpler (yet functional) version has the operator return its first defined argument, then pass over the next defined one in case of a dead-end.

The most common strategy used for implementing `amb()`'s logic (check/discard) is backtracking, which is "a general algorithm for finding all (or some) solutions to some computational problem, that incrementally builds candidates to the solutions, and abandons each partial candidate *c* ("backtracks") as soon as it determines that *c* cannot possibly be completed to a valid solution". It almost always relies on some sort of continuations. It may be turned into backjumping for more efficiency, depending on the problem at stake. Another strategy is reinforcement learning or constraint learning, as used in some AI systems. This library implements simple backtracking only.

More details on all of this under the `doc/`` folder (*pending*).

## Examples

``` ruby
# Amb is a module
A = Class.new { include Amb }.new

x = A.choose(1,2,3,4) # register each alternative as a backtrack point
y = A.choose(1,2,3,4) # same for y, so we have 16 backtracking branches

puts "examining x = #{x}, y = #{y}"

# assertions will backtrack if a dead-end is discovered
A.assert x + y == 5
A.assert x - y == 1
#A.assert x == 2    # if this line is uncommented, then no solution can be found
                    # and the program raises a Amb::ExhaustedError

puts "> solution: x = #{x}, y = #{y}"
```

will produce:

``` ruby
examining x = 1, y = 1
examining x = 1, y = 2
examining x = 1, y = 3
examining x = 1, y = 4
examining x = 2, y = 1
examining x = 2, y = 2
examining x = 2, y = 3
examining x = 2, y = 4
examining x = 3, y = 1
examining x = 3, y = 2
solution: x = 3, y = 2
```
This illustrates the incremental, backtracking pattern. Many more examples under the `examples/` directory.

## Installation

    gem install amb

## Usage

## TODO

## See also

* the `doc/` and `examples/` directories.
* Continuations and fibers concepts.
