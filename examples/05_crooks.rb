# Copyright 2006 by Jim Weirich
#
# Two thieves have being working together for years. Nobody knows their
# identities, but one is known to be a Liar and the other a Knave. The
# local sheriff gets a tip that the bandits are about to commit another
# crime. When the sheriff arrives at the scene of the crime, he finds
# three men: A, B and C.
#
# C has been stabbed with a dagger. He cries out: "A stabbed me", before
# anybody can say anything else; then, he falls down dead from the stabbing.
#
# Not sure which of the three men are the crooks, the sheriff takes the two
# suspects to the jail and interrogates them. He gets the following
# information:
#
# A's statements:
#   1. B is one of the crooks.
#   2. B's second statement is true.
#   3. C was telling the truth.
#
# B's statements:
#   1. A killed the other guy.
#   2. C was killed by one of the thieves.
#   3. C's next statement would have been a lie.
#
# C's statement:
#   1. A stabbed me (so he cried)
#
# Liars always lie, knights always tell the truth and knaves strictly alternate
# between truth and lies.
#
# The sheriff knows that the murderer is among these three people. Who should
# the sheriff arrest for killing C?

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.expand_path("../_shared.rb",  __FILE__)

# Some helper methods for boolean logic.
class Object
  def implies(bool)
    self ? bool : true
  end

  def xor(bool)
    self ? !bool : bool
  end
end

# True if the given list of boolean values alternate between true and false.
def alternating(*bools)
  expected = bools.first
  bools.each do |item|
    if item != expected
      return false
    end
    expected = !expected
  end
  true
end

# A person class to keep track of the information about a single person in our
# puzzle.
class Person
  attr_reader :name, :type, :murderer, :thief
  attr_accessor :statements

  def initialize(amb, name)
    @name = name
    @type = amb.choose(:liar, :knave, :knight)
    @murderer = amb.choose(true, false)
    @thief = amb.choose(true, false)
    @statements = []
  end

  def to_s
    "#{name} is a #{type} " +
      (thief ? "and a thief." : "but not a thief.") +
      (murderer ? " He is also the murderer." : "")
  end
end

# Find all the solutions.
Ambiguous.solve_all do |amb|
  count = 0

  # Create the three people in our puzzle.
  a = Person.new(amb, "A")
  b = Person.new(amb, "B")
  c = Person.new(amb, "C")

  # Some lists used to do collective assertions.
  people = [a, b, c]
  thieves = people.select { |p| p.thief }

  # Basic assertions about the thieves:
  # there are only two thieves in our problem...
  amb.assert thieves.size == 2
  # and one is a knave, the other a liar.
  amb.assert thieves.collect { |p| p.type }.sort == [:knave, :liar]

  # Basic assertions about the murderer:
  # there is only one murderer...
  amb.assert people.select { |p| p.murderer }.size == 1
  # and we assume he has not commited suicide (he's not C)
  murderer = people.find { |p| p.murderer }
  amb.assert !c.murderer

  # Create the *logic* statements of each of the people involved. Note that we
  # are just creating them here: we won't assert the truth of them until a bit
  # later. So keep in mind, they may be *either true or false*!

  # C's statements
  c1 = a.murderer               # cried "A stabbed me"
  c2 = case c.type              # (hypothetical next statement)
  when :knight then
    true
  when :liar then
    false
  when :knave then
    !c1
  end
  c.statements = [c1, c2]

  # B's statements
  b1 = a.murderer               # "A killed the other guy"
  b2 = murderer.thief           # "C was killed by one of the thieves"
  b3 = !c2                      # "C's next statement would have been a lie"
  b.statements = [b1, b2, b3]

  # A's statements
  a1 = b.thief                  # "B is one of the crooks"
  a2 = b2                       # "B's second statement is true"
  a3 = c1                       # "C was telling the truth"
  a.statements = [a1, a2, a3]

  # Now we make assertions on the truthfulness of each of persons statements,
  # based on whether they are a Knight, a Knave or a Liar.
  people.each do |p|
    amb.assert do
      (p.type == :knight).implies(p.statements.all? { |s| s })
    end

    amb.assert do
      (p.type == :liar).implies(p.statements.all? { |s| !s })
    end

    amb.assert do
      (p.type == :knave).implies(alternating(*p.statements))
    end
  end

  # Now we print out the solution.
  count += 1
  puts "Solution #{count}:"
  puts "-----------"
  people.each { |p| puts p }
end
