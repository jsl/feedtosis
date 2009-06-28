# Extends FeedNormalizer::Feed with method for detecting new_items (aliased as new_entries for 
# convenience).
module Feedtosis
  module FeedInstanceMethods
    
    # Returns only the feeds that are new.
    def new_items
      self.entries.select do |e| 
        e.instance_variable_get(:@_seen) == false
      end
    end
    
    alias :new_entries :new_items
  end
end

FeedNormalizer::Feed.__send__(:include, Feedtosis::FeedInstanceMethods)