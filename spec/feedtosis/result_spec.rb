require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Feedtosis::Result do
  before do
    @c = mock('curl')
    @f = mock('feed')
    @r = Feedtosis::Result.new(@c, @f)
  end
  
  it "should raise an ArgumentError if the Curl object is nil" do
    lambda {
      Feedtosis::Result.new(nil, nil)
    }.should raise_error(ArgumentError)
  end
  
  it "should send author to the Feed object" do
    @f.expects(:author)
    @r.author
  end
  
  it "should send body_str to the curl object" do
    @c.expects(:body_str)
    @r.body_str
  end
  
  it "should not respond to setter methods common in the Curl::Easy class" do
    @r.should_not respond_to(:encoding=)
  end
  
  it "should return nil for author if the Feed is nil" do
    r = Feedtosis::Result.new(@c, nil)
    r.author
  end
end