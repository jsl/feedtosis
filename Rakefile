require 'rubygems'
require 'spec'

require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

require 'lib/myzofeedtosis'

desc 'Test the plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts  = ["--format", "progress", "--colour"]
  t.libs << 'lib'
  t.verbose = true
end

desc "Run all the tests"
task :default => :spec

desc 'Generate documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Myzofeedtosis'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/myzofeedtosis/**/*.rb')
end

