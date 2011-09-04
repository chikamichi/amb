# Copyright 2006 by Jim Weirich
#
# The Kalotans are a tribe with a peculiar quirk. Their males always
# tell the truth. Their females never make two consecutive true
# statements, or two consecutive untrue statements.
#
# An anthropologist (let's call him Worf) has begun to study
# them. Worf does not yet know the Kalotan language. One day, he meets
# a Kalotan (heterosexual) couple and their child Kibi. Worf asks
# Kibi: ``Are you a boy?'' Kibi answers in Kalotan, which of course
# Worf doesn't understand.
#
# Worf turns to the parents (who know English) for explanation. One of
# them says: ``Kibi said: `I am a boy.' '' The other adds: ``Kibi is a
# girl. Kibi lied.''
#
# Solve for the sex of the parents and Kibi.

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.expand_path("../_shared.rb",  __FILE__)

# Some helper methods for boolean logic.
class Object
  # Execute the provided boolean statement if `self` evaluates to true.
  #
  def implies(bool)
    self ? bool : true
  end

  def xor(bool)
    self ? !bool : bool
  end
end

# Find all the solutions to the constraints set.
Ambiguous.solve_all do |amb|
  count = 0 # keep track of solving tries.

  # Kibi's parents are either male or female, but must be distinct.
  parent1 = amb.choose(:male, :female)
  parent2 = amb.choose(:male, :female)
  amb.assert parent1 != parent2

  # Kibi sex, and Kibi's self description are separate facts.
  kibi = amb.choose(:male, :female)
  kibi_said = amb.choose(:male, :female)

  # We will capture whether kibi lied in a local variable. This will
  # make some later logic conditions a bit easier. (Note: the Scheme
  # implementation sets the kibi_lied variable to a choice of true or
  # false and then uses assertions to make all three variables
  # consistent. This way however, is just so much easier.)
  kibi_lied = kibi != kibi_said

  # Now we look at what the parents said. If the first parent was
  # male, then kibi must have described itself as male.
  # Using the block form just for the sake of readability.
  amb.assert { (parent1 == :male).implies(kibi_said == :male) }

  # If however the first parent is female, then there are no futher
  # deductions to be made on the first parent: their statement could
  # either be true or false. Moving on the second parent.

  # If the second parent is male, then both its statements must be true.
  amb.assert { (parent2 == :male).implies(kibi == :female) }
  amb.assert { (parent2 == :male).implies(kibi_lied) }

  # If however the second parent is female, then the condition is more
  # complex. In this case, one or the other of the second parent's
  # statements are false, but not both are false. Let's introduce
  # some variables for statements 1 and 2, just to make this a bit
  # clearer.
  s1 = kibi_lied
  s2 = (kibi == :female)
  amb.assert { (parent2 == :female).implies((s1 && !s2).xor(!s1 && s2)) }

  # Now just print out the solution.
  count += 1
  puts "Solution ##{count}"
  puts "-----------"
  puts "The first parent is #{parent1}."
  puts "The second parent is #{parent2}."
  puts "Kibi is #{kibi}."
  puts "Kibi said #{kibi_said}, hence #{kibi_lied ? 'lied' : 'told the truth'}."
end
