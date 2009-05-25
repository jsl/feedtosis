require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe Myzofeedtosis::FeedInstanceMethods do
  before do
    @fn = FeedNormalizer::FeedNormalizer.parse(xml_fixture('wooster'))
  end
  
  it "should respond to new_entries and new_items" do
    @fn.should respond_to(:new_entries)
    @fn.should respond_to(:new_items)
  end
end