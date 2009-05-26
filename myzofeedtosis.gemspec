Gem::Specification.new do |s|
  s.name = %q{myzofeedtosis}
  s.version = "0.0.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Leitgeb"]
  s.date = %q{2009-05-22}
  s.description = %q{Myzofeedtosis finds new information in feeds quickly using smart fetching and matching of previously read entries}
  s.email = %q{justin@phq.org}
  
  s.files = ["lib/extensions/core/array.rb", "lib/extensions/core/hash.rb", 
    "lib/extensions/feed_normalizer/feed_instance_methods.rb", 
    "lib/myzofeedtosis/result.rb",
    "lib/myzofeedtosis/client.rb", "lib/myzofeedtosis.rb", "LICENSE", 
    "myzofeedtosis.gemspec", "Rakefile", "README.rdoc", 
    "spec/extensions/feed_normalizer/feed_instance_methods_spec.rb", 
    "spec/fixtures/http_headers/wooster.txt", 
    "spec/fixtures/xml/older_wooster.xml", "spec/fixtures/xml/wooster.xml", 
    "spec/myzofeedtosis/client_spec.rb", "spec/myzofeedtosis_spec.rb", 
    "spec/myzofeedtosis/result_spec.rb",
    "spec/spec_helper.rb"]
  
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jsl/myzofeedtosis}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Retrieves feeds using conditional GET and marks entries that you haven't seen before}
  s.test_files = ["spec/myzofeedtosis_spec.rb", "spec/spec_helper.rb", "spec/myzofeedtosis/client_spec.rb",
    "spec/myzofeedtosis/result_spec.rb" ]

  s.extra_rdoc_files = [ "README.rdoc" ]
  
  s.rdoc_options += [
    '--title', 'Myzofeedtosis',
    '--main', 'README.rdoc',
    '--line-numbers',
    '--inline-source'
   ]

  %w[ taf2-curb wycats-moneta jsl-hashback jsl-http_headers feed-normalizer ].each do |dep|
    s.add_dependency(dep)
  end

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
