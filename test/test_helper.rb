$:.unshift File.expand_path('../../lib', __FILE__)
require 'microgem'

FIXTURE_PATH = File.expand_path('../fixtures', __FILE__)
TMP_PATH = File.expand_path('../../tmp', __FILE__)

# Copy the fixtures to Gem::Micro::Config.gem_home
c = Gem::Micro::Config
c.sources.each do |hostname|
  unless File.exist?(File.join(c.gem_home, hostname))
    FileUtils.cp File.join(FIXTURE_PATH, hostname), c.gem_home
  end
end

# silence the logger
module Gem::Micro::Utils
  def log(level, message)
    # nada
  end
end

require 'test/unit'
class Test::Unit::TestCase
  private
  
  def fixture(name)
    File.join(FIXTURE_PATH, name)
  end
  
  def gem_spec_fixture(name, version)
    Marshal.load(File.read(fixture("#{name}-#{version}.gemspec.marshal")))
  end
end

module Kernel
  def remove_microgem_tmpdir!
    FileUtils.rm_rf Gem::Micro::Utils.tmpdir
  end
  remove_microgem_tmpdir! # ensure it doesn't exist before test run
  
  # we don't want to load rubygems, so use these work arounds
  alias_method :__require_before_microgems, :require
  def require(lib)
    __require_before_microgems(lib) unless lib == 'rubygems'
  end
  
  def gem(*args)
    # do nothing
  end
end

require 'net/http'
module Net
  class HTTP
    class TryingToMakeHTTPConnectionException < StandardError; end
    def connect
      raise TryingToMakeHTTPConnectionException, "Please mock your HTTP calls so you don't do any HTTP requests."
    end
  end
end

# for test/spec gem
$: << File.expand_path('../../', `gem which test/spec`.split("\n").last)
require 'test/spec'

# for mocha gem
module Gem
  class LoadError < StandardError; end
end
$: << File.expand_path('../', `gem which mocha`.split("\n").last)
require 'mocha'