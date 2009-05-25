require 'rubygems'
require 'mocha'
require 'spec'

require File.join(File.dirname(__FILE__), %w[.. lib myzofeedtosis])

Spec::Runner.configure do |config|
  config.mock_with(:mocha)
end

# Returns the xml fixture identified by +name+.
def xml_fixture(name)
  File.read(File.join(File.dirname(__FILE__), 'fixtures', 'xml', "#{name}.xml"))
end

def http_header(name)
  File.read(File.join(File.dirname(__FILE__), 'fixtures', 'http_headers', "#{name}.txt"))
end

shared_examples_for "all backends" do
  it "should respond to #get" do
    @backend.should respond_to(:get)
  end
  
  it "should respond to #set" do
    @backend.should respond_to(:set)
  end  
end
