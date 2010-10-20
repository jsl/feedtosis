Gem::Specification.new do |s|
  s.name = "feedtosis"
  s.version = "0.0.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.author = "Justin Leitgeb"
  s.summary = "Retrieves feeds using conditional GET and marks entries that you haven't seen before"
  s.description = <<-EOF
    Feedtosis finds new information in feeds quickly using smart fetching and matching of 
    previously read entries.
  EOF
  
  s.email = "justin@stackbuilders.com"
  
  s.files = [
    "lib/extensions/core/hash.rb", 
    "lib/extensions/feed_normalizer/feed_instance_methods.rb", 
    "lib/feedtosis/result.rb",
    "lib/feedtosis/client.rb", "lib/feedtosis.rb", "LICENSE", 
    "feedtosis.gemspec", "Rakefile", "README.rdoc", 
    "spec/extensions/feed_normalizer/feed_instance_methods_spec.rb", 
    "spec/fixtures/http_headers/wooster.txt", 
    "spec/fixtures/xml/older_wooster.xml", "spec/fixtures/xml/wooster.xml", 
    "spec/feedtosis/client_spec.rb",
    "spec/feedtosis/result_spec.rb",
    "spec/spec_helper.rb"
  ]
  
  s.has_rdoc = true
  s.homepage = "http://github.com/jsl/feedtosis"
  
  s.test_files = [
    "spec/spec_helper.rb", 
    "spec/feedtosis/client_spec.rb", 
    "spec/feedtosis/result_spec.rb"
  ]

  s.extra_rdoc_files = [ "README.rdoc" ]
  
  s.rdoc_options = [
    '--title', 'Feedtosis',
    '--main', 'README.rdoc',
    '--line-numbers'
   ]

  %w[ curb moneta http_headers feed-normalizer ].each do |dep|
    s.add_dependency(dep)
  end
end
