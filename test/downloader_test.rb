##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Downloader, in simple mode" do
  before do
    @arguments = {
      :remote => 'http://gems.rubyforge.org/gems/rake-0.8.1.gem',
      :local  => File.join(TMP_PATH, 'gems', 'rake-0.8.1.gem')
    }
    FileUtils.rm_rf(File.join(TMP_PATH, 'gems'))
    Gem::Micro::Config.stubs(:[]).with(:simple_downloader).returns(true)
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

describe "DownloadError, in complex mode" do
  before do
    @arguments = {
      :remote => 'http://gems.rubyforge.org/gems/rake-0.8.1.gem',
      :local  => File.join(TMP_PATH, 'gems', 'rake-0.8.1.gem')
    }
    FileUtils.rm_rf(File.join(TMP_PATH, 'gems'))
    Gem::Micro::Config.stubs(:[]).with(:simple_downloader).returns(false)
  end
  
  it "should GET files with Net::HTTP" do
    stub_response('200', {
      'Content-Length'   => '90112',
      'Content-Type'     => 'application/x-tar',
      'Content-Encoding' => 'posix'
    }, body = 'Gem body')
    
    Gem::Micro::Downloader.get(@arguments[:remote], @arguments[:local])
    File.should.exist(@arguments[:local])
    File.read(@arguments[:local]).should == body
  end
  
  it "should raise a DownloadError when something goes wrong" do
    stub_response('500', {
      'Content-Length'   => '0',
      'Content-Type'     => 'text/plain'
    }, body = '')
    
    lambda {
      Gem::Micro::Downloader.get(@arguments[:remote], @arguments[:local])
    }.should.raise(Gem::Micro::Downloader::DownloadError)
    
    File.should.not.exist(@arguments[:local])
  end
  
  it "should follow redirects" do
    stub_response('302', {
      'Location'      => (location = 'http://rubyforge-gems.ruby-forum.com/gems/rake-0.8.1.gem'),
      'Content-Type'  => 'text/html; charset=iso-8859-1'
    }, body = '', 'http://gems.rubyforge.org/gems/rake-0.8.1.gem')
    stub_response('200', {
      'Content-Length'   => '90112',
      'Content-Type'     => 'application/x-tar',
      'Content-Encoding' => 'posix'
    }, body = 'Gem body', location)
    
    Gem::Micro::Downloader.get(@arguments[:remote], @arguments[:local])
    File.should.exist(@arguments[:local])
    File.read(@arguments[:local]).should == body
  end
  
  private
  
  def stub_response(status_code, headers, body, url=nil)
    uri = URI.parse(url) unless url.nil?
    
    explanation = {
      '200' => ['OK', Net::HTTPOK],
      '302' => ['Found', Net::HTTPFound],
      '500' => ['Internal server error', Net::HTTPInternalServerError]
    }
    http_response = explanation[status_code].last.new('1.1', status_code, explanation[status_code].first)
    http_response.stubs(:read_body).returns(body)
    headers.each do |key, value|
      http_response.add_field(key, value)
    end
    if uri.nil?
      Net::HTTP.stubs(:start).returns(http_response)
    else
      Net::HTTP.stubs(:start).with(uri.host, uri.port).returns(http_response)
    end
  end
end