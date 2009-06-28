module Feedtosis
  
  # Makes the response components both from the Curl::Easy object and the 
  # FeedNormalizer::Feed object available to the user by delegating appropriate
  # method calls to the correct object.  If FeedNormalizer wasn't able to process
  # the response, calls which would be delegated to this object return nil.  In
  # these cases, depending on your business logic you may want to inspect the 
  # state of the Curl::Easy object by using methods forwarded to it.
  class Result
    
    # Methods which should be delegated to the FeedNormalizer::Feed object.
    FEED_METHODS = [ :title, :description, :last_updated, :copyright, :authors, 
      :author, :urls, :url, :image, :generator, :items, :entries, :new_items, 
      :new_entries, :channel, :ttl, :skip_hours, :skip_days 
    ] unless defined?(FEED_METHODS)
    
    # Precompiled regexp for detecting removing setter methods from collection 
    # of methods to be delegated to the Curl::Easy object.
    SETTER_METHOD_RE = /=$/o unless defined?(SETTER_METHOD_RE)
    
    def initialize(curl, feed)
      @curl = curl
      @feed = feed
      
      raise ArgumentError, "Curl object must not be nil" if curl.nil?
    end
    
    # See what the Curl::Easy object responds to, and send any appropriate
    # messages its way.  We don't worry about setter methods, since those
    # aren't really useful to delegate.
    Curl::Easy.instance_methods(false).reject do |m| 
      m =~ SETTER_METHOD_RE
    end.each do |meth|                  # Example method:
      define_method meth do |*args|     # def title
        @curl.__send__(meth, *args)     #   @curl.title
      end                               # end
    end
    
    # Send methods through to the feed object unless it is nil.  If feed
    # object is nil, return nil in response to method call.
    FEED_METHODS.each do |meth|                         # Example method:
      define_method meth do |*args|                     # def author
        @feed.nil? ? nil : @feed.__send__(meth, *args)  #   @feed.nil? nil : @feed.author
      end                                               # end
    end    
    
  end
end