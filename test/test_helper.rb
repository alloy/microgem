$:.unshift File.expand_path('../../lib', __FILE__)
require 'microgem'

FIXTURE_PATH = File.expand_path('../fixtures', __FILE__)
TMP_PATH = File.expand_path('../../tmp', __FILE__)

# load the tests source_index.yaml
# Gem::SourceIndex.load_from_file(File.join(FIXTURE_PATH, 'source_index.yaml'))
# Gem::Micro.instance_variable_set(:@source_index, Gem::SourceIndex.instance)
# 
# Gem::Micro::Config[:install_dir] = '/path/to/download/dir'

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