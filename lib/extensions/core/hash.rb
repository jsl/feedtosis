class Hash
  # Returns a Hash containing only input keys.
  # Method from merb-core.
  def except(*rejected)
    reject { |k,v| rejected.include?(k) }
  end
  
  def reverse_merge(other_hash)
    other_hash.merge(self)
  end

  # Returns a new hash containing only the input keys.
  # Method from merb-core.
  def only(*allowed)
    reject { |k,v| !allowed.include?(k) }
  end
end
