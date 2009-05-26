module Myzofeedtosis
  
  # Makes the response components both from the Curl::Easy object and the 
  # FeedNormalizer::Feed object available to the user by delegating appropriate
  # method calls to the correct object.  If FeedNormalizer wasn't able to process
  # the response, calls which would be delegated to this object return nil.  In
  # these cases, depending on your business logic you may want to inspect the 
  # state of the Curl::Easy object.
  class Result
    
    # Methods which should be delegated to the FeedNormalizer::Feed object.
    FEED_METHODS = [ :title, :description, :last_updated, :copyright, :authors, 
      :author, :urls, :url, :image, :generator, :items, :entries, :new_items, 
      :new_entries, :channel, :ttl, :skip_hours, :skip_days 
    ] unless defined?(FEED_METHODS)
    
    def initialize(curl, feed)
      @curl = curl
      @feed = feed
      
      raise ArgumentError, "Curl object must not be nil" if curl.nil?
      
      # See what the Curl::Easy object responds to, and send any appropriate
      # messages its way.
      @curl.public_methods(false).each do |meth|
        (class << self; self; end).class_eval do
          define_method meth do |*args|
            @curl.send(meth, *args)
          end
        end
      end
    end
    
    # Send methods through to the feed object unless it is nil.  If feed
    # object is nil, return nil in response to method call.
    FEED_METHODS.each do |meth|
      define_method meth do |*args|
        @feed.nil? ? nil : @feed.__send__(meth, *args)
      end
    end    
    
  end
end