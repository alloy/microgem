$:.unshift File.expand_path('../../lib', __FILE__)
require 'minigems'

FIXTURE_PATH = File.expand_path('../fixtures', __FILE__)

# load the tests source_index.yaml
Gem::SourceIndex.load_from_file(File.join(FIXTURE_PATH, 'source_index.yaml'))

require 'test/unit'
class Test::Unit::TestCase
  private
  
  def fixture(name)
    File.join(FIXTURE_PATH, name)
  end
end

# we don't want to load rubygems, so use these work arounds

module Kernel
  alias_method :__require_before_minigems, :require
  def require(lib)
    __require_before_minigems(lib) unless lib == 'rubygems'
  end
  
  def gem(*args)
    # do nothing
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