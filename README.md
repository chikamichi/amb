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

Typically, the programmer would specify a limited number of alternatives (eg. variables values), so that the program must later choose between them at runtime to find which one(s) are valid predicates to solve the issue at stake. The "issue" is often formalized as a constraint or a set of constraint about the alternatives. The evaluation may result in the discovery of dead ends, in which case evaluation must backtrack to a previous branching point and start over with a different alternative.

To discover which alternatives groups are valid, a check/discard strategy must be enforced by the program. Most often it will make use of a ambiguous operator, `amb()`. The most basic version of `amb` would be `amb(x,y)`, which returns, *in an unpredictible way*, either x or y when both are defined, or if only one is defined, whichever is defined. If none is defined, it will terminate the program and complain no solution can be found given these alternatives and constraint(s). Using some recursivity, `amb()` may be used to define arbitrary, complex ambiguous functions.

The most common strategy used for implementing `amb()`'s logic (check/discard) is backtracking, which is "a general algorithm for finding all (or some) solutions to some computational problem, that incrementally builds candidates to the solutions, and abandons each partial candidate *c* ("backtracks") as soon as it determines that *c* cannot possibly be completed to a valid solution". It almost always relies on some sort of continuations. It may be turned into backjumping for more efficiency, depending on the problem at stake. Another strategy is reinforcement learning or constraint learning, as used in some AI systems. This library implements simple backtracking only.

More details on all of this in the doc/ folder.

## Examples

TODO, for now look at the examples/ directory.

## Installation

    gem install amb

## Usage

## TODO

## See also

* the doc/ and examples/ directories.
* Continuations and fibers concepts.
