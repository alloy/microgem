Gem::Specification.new do |s|
  s.name = "rake"
  s.version = "0.8.1"

  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.authors = ["Jim Weirich"]
  s.date = %q{2007-12-26}
  s.default_executable = %q{rake}
  s.description = %q{Rake is a Make-like program implemented in Ruby. Tasks and dependencies are specified in standard Ruby syntax.}
  s.email = %q{jim@weirichhouse.org}
  s.executables = ["rake"]
  s.has_rdoc = true
  s.homepage = %q{http://rake.rubyforge.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rake}
  s.rubygems_version = `gem -v`.strip # we stub it to use the latest gem version
  s.summary = %q{Ruby based make-like utility.}
end