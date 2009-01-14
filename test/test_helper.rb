# we don't want to load rubygems, so use this work around
$: << File.expand_path('../../', `gem which test/spec`.split("\n").last)
require 'test/spec'

$:.unshift File.expand_path('../../lib', __FILE__)

FIXTURE_PATH = File.expand_path('../fixtures', __FILE__)

class Test::Unit::TestCase
  private
  
  def fixture(name)
    File.join(FIXTURE_PATH, name)
  end
end