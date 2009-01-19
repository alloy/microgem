##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Downloader, in simple mode" do
  before do
    @arguments = {
      :remote => 'http://gems.rubyforge.org/gems/rake-0.8.1.gem',
      :local  => '/tmp/rake-0.8.1.gem'
    }
  end
  
  it "should GET files with curl" do
    Gem::Micro::Downloader.expects(:system).with("#{Gem::Micro::Downloader.curl_binary} --silent --location --output '#{@arguments[:local]}' '#{@arguments[:remote]}'").returns(true)
    Gem::Micro::Downloader.get(@arguments[:remote], @arguments[:local])
  end
  
  it "should raise a DownloadError when something goes wrong" do
    Gem::Micro::Downloader.expects(:system).returns(false)
    lambda {
      Gem::Micro::Downloader.get(@arguments[:remote], @arguments[:local])
    }.should.raise(Gem::Micro::Downloader::DownloadError)
  end
end