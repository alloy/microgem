Gem::Specification.new do |s|
  s.name = %q{rails}
  s.version = "2.1.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Heinemeier Hansson"]
  s.date = %q{2008-09-04}
  s.default_executable = %q{rails}
  s.description = %q{Rails is a framework for building web-application using CGI, FCGI, mod_ruby, or WEBrick on top of either MySQL, PostgreSQL, SQLite, DB2, SQL Server, or Oracle with eRuby- or Builder-based templates.}
  s.email = %q{david@loudthinking.com}
  s.executables = ["rails"]
  s.homepage = %q{http://www.rubyonrails.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rails}
  s.rubygems_version = '1.3.1'
  s.summary = %q{Web-application framework with template engine, control-flow layer, and ORM.}

  s.add_dependency(%q<rake>, [">= 0.8.1"])
  s.add_dependency(%q<activesupport>, ["= 2.1.1"])
  s.add_dependency(%q<activerecord>, ["= 2.1.1"])
  s.add_dependency(%q<actionpack>, ["= 2.1.1"])
  s.add_dependency(%q<actionmailer>, ["= 2.1.1"])
  s.add_dependency(%q<activeresource>, ["= 2.1.1"])
end
