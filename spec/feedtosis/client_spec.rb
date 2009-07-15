require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Feedtosis::Client do
  before do
    @url      = "http://www.example.com/feed.rss"
    @backend  = Hash.new
    @fr       = Feedtosis::Client.new(@url, :backend => @backend)
  end

  describe "initialization" do    
    it "should set #url to an Array when an Array is given" do
      @fr.url.should == @url
    end
    
    describe "validation of url in first argument" do
      it "should not raise an error on initialization with a valid HTTP url" do
        lambda {
          Feedtosis::Client.new('http://www.example.com')
        }.should_not raise_error
      end
      
      it "should raise an error on initialization with an invalid url" do
        lambda {
          Feedtosis::Client.new('ftp://www.example.com')
        }.should raise_error(ArgumentError)
      end
    end
    
    it "should raise ArgumentError if options is not a Hash" do
      lambda {
        Feedtosis::Client.new('http://www.example.com', Object.new)
      }.should raise_error(ArgumentError)
    end
    
    it "should set the If-None-Match and If-Modified-Since headers to the value of the summary hash" do
      curl_headers = mock('headers')
      curl_headers.expects(:[]=).with('If-None-Match', '42ab')
      curl_headers.expects(:[]=).with('If-Modified-Since', 'Mon, 25 May 2009 16:38:49 GMT')
      
      summary = { :etag => '42ab', :last_modified => 'Mon, 25 May 2009 16:38:49 GMT', :digests => [ ] }
      
      @fr.__send__(:set_summary, summary)
      
      curl_easy = mock('curl', :perform => true, :follow_location= => true, 
        :response_code => 200, :body_str => xml_fixture('wooster'),
        :header_str => http_header('wooster')
      )
      
      curl_easy.expects(:headers).returns(curl_headers).times(2)
      
      @fr.expects(:new_curl_easy).returns(curl_easy)
      @fr.fetch
    end
    
    describe "#summary_for_feed" do
      it "should return a hash with :digests set to an empty Array when summary is nil" do
        @fr.__send__(:set_summary, nil)
        @fr.__send__(:summary_for_feed).should == {:digests => [ ]}
      end
    end
    
    describe "when given a pre-initialized backend" do
      it "should set the @backend to the pre-initialized structure" do
        h   = Moneta::Memory.new
        fc  = Feedtosis::Client.new(@url, :backend => h)
        fc.__send__(:instance_variable_get, :@backend).should == h
      end
      
      it "should raise an error if the backend is not a key-value store based on behavior" do
        o = Object.new
        
        lambda {
          Feedtosis::Client.new(@url, :backend => o)          
        }.should raise_error(ArgumentError)
      end
    end
  end
    
  describe "#key_for_cached" do
    it "should default to the MD5 of the url after the namespace" do
      c = Feedtosis::Client.new(@url)
      c.__send__(:key_for_cached).should == [ 'feedtosis', MD5.hexdigest(@url) ].join('_')
    end
    
    it "should respect a custom namespace if given" do
      c = Feedtosis::Client.new(@url, :namespace => 'justin')
      c.__send__(:key_for_cached).should == [ 'justin', MD5.hexdigest(@url) ].join('_')
    end
  end
    
  describe "#fetch" do
    it "should call Curl::Easy.perform with the url, and #process_curl_response" do
      curl_easy = mock('curl', :perform => true)
      @fr.expects(:build_curl_easy).returns(curl_easy)
      @fr.expects(:process_curl_response)
      @fr.fetch
    end
    
    describe "when called more than once" do
      it "should call new_curl_easy with #{@url}" do
        mock_curl = mock('curl')
        mock_curl.expects(:follow_location=).with(true).twice
        mock_curl.expects(:perform).twice
        mock_curl.expects(:response_code).twice
        @fr.expects(:new_curl_easy).with(@url).twice.returns(mock_curl)
        @fr.fetch
        @fr.fetch
      end
    end
    
    describe "when the response code is not 200" do
      it "should return nil for feed methods such as #title and #author" do
        curl = mock('curl', :perform => true, :response_code => 304)
        @fr.expects(:build_curl_easy).returns(curl)
        res = @fr.fetch
        res.title.should be_nil
        res.author.should be_nil
      end
      
      it "should return a Feedtosis::Result object" do
        curl = mock('curl', :perform => true, :response_code => 304)
        @fr.expects(:build_curl_easy).returns(curl)
        @fr.fetch.should be_a(Feedtosis::Result)
      end
    end

    describe "when the response code is 200" do
      describe "when an identical resource has been retrieved previously" do
        before do
          curl = mock('curl', :perform => true, :response_code => 200,
            :body_str => xml_fixture('wooster'), :header_str => http_header('wooster'))
          @fr.expects(:build_curl_easy).returns(curl)
          @fr.fetch
        end
        
        it "should have an empty array for new_entries" do
          curl = mock('curl', :perform => true, :response_code => 200,
            :body_str => xml_fixture('wooster'), :header_str => http_header('wooster'))
          @fr.expects(:build_curl_easy).returns(curl)
          @fr.fetch.new_entries.should == []
        end
      end
      
      describe "when the resource has been previously retrieved minus two entries" do
        before do
          curl = mock('curl', :perform => true, :response_code => 200,
            :body_str => xml_fixture('older_wooster'), :header_str => http_header('wooster'))
          @fr.expects(:build_curl_easy).returns(curl)
          @fr.fetch        
        end
        
        it "should have two elements in new_entries" do
          curl = mock('curl', :perform => true, :response_code => 200,
            :body_str => xml_fixture('wooster'), :header_str => http_header('wooster'))
          @fr.expects(:build_curl_easy).returns(curl)
          @fr.fetch.new_entries.size.should == 2
        end
      end
    end
  end  
  
end