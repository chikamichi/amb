require './lib/amb/version'

Gem::Specification.new do |s|
  s.name = "amb"
  s.author = "Jean-Denis Vauguet <jd@vauguet.fr>"
  s.email = "jd@vauguet.fr"
  s.homepage = "http://www.github.com/chikamichi/amb"
  s.summary = "McCarty's ambiguous function/operator implementations"
  s.description = "This gem is a compilation of several implementations of the ambiguous function/operator, useful for constraint programming."
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "README.md", "CHANGELOG.md"]
  s.version = Amb::VERSION
  s.add_development_dependency 'amb'
end
