module Feedtosis
  
  # Makes the response components both from the Curl::Easy object and the 
  # FeedNormalizer::Feed object available to the user by delegating appropriate
  # method calls to the correct object.  If FeedNormalizer wasn't able to process
  # the response, calls which would be delegated to this object return nil.  In
  # these cases, depending on your business logic you may want to inspect the 
  # state of the Curl::Easy object by using methods forwarded to it.
  class Result
    extend Forwardable
        
    def initialize(curl, feed)
      @curl = curl
      @feed = feed
      
      raise ArgumentError, "Curl object must not be nil" if curl.nil?
    end
    
    # See what the Curl::Easy object responds to, and send any appropriate messages its way.  We ignore  
    # Curl setter methods since those aren't really useful to delegate.
    def_delegators :@curl, *Curl::Easy.instance_methods(false).reject {|m| m =~ /=$/o }
    
    # Send methods through to the feed object unless it is nil.  If feed object is nil, return nil in response to method call.
    # Unfortunately we can't just see what the object responds to, since FeedNormalizer uses method_missing.
    [ :title, :description, :last_updated, :copyright, :authors, :author, :urls, :url, :image, :generator, :items, 
      :entries, :new_items, :new_entries, :channel, :ttl, :skip_hours, :skip_days 
    ].each do |meth|                                    # Example method:
      define_method meth do |*args|                     # def author
        @feed.__send__(meth, *args) unless @feed.nil?   #   @feed.author unless @feed.nil?
      end                                               # end
    end    
    
  end
end