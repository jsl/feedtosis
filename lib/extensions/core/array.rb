class Array
    
  # From Rails' ActiveSupport library
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end

end
