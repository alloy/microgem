Gem::Specification.new do |s|
  s.name = "paypal"
  s.version = "2.0.0"

  s.specification_version = 1 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.authors = ["Tobias Luetke"]
  s.autorequire = "paypal"
  s.bindir = "bin"
  s.cert_chain = nil
  s.date = "2006-06-30"
  s.default_executable = nil
  s.description = "Paypal IPN integration library for rails and other web applications"
  s.email = "tobi@leetsoft.com"
  s.executables = []
  s.extensions = []
  s.extra_rdoc_files = []
  s.files = ["init.rb", "README", "Rakefile", "MIT-LICENSE", "lib/helper.rb", "lib/notification.rb", "lib/paypal.rb", "misc/PayPal - Instant Payment Notification - Technical Overview.pdf", "misc/paypal.psd", "test/helper_test.rb", "test/mocks", "test/notification_test.rb", "test/remote", "test/mocks/http_mock.rb", "test/mocks/method_mock.rb", "test/remote/remote_test.rb"]
  s.has_rdoc = true
  s.homepage = "http://dist.leetsoft.com/api/paypal"
  s.platform = "ruby"
  s.post_install_message = nil
  s.rdoc_options = []
  s.require_paths = ["lib"]
  s.required_ruby_version = #<Gem::Version::Requirement:0x56c854 @requirements=[[">", #<Gem::Version:0x56c9a8 @version="0.0.0">]], @version=nil>
  s.requirements = []
  s.rubyforge_project = nil
  s.rubygems_version = "0.9.0"
  s.signing_key = nil
  s.summary = "Paypal IPN integration library for rails and other web applications"
  s.test_files = []

  s.add_dependency("money", ["#<Gem::Version::Requirement:0x56be2c>"])
end