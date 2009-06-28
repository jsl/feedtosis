require 'rubygems'
require 'curb'
require 'moneta'
require 'moneta/memory'
require 'http_headers'
require 'feed-normalizer'
require 'md5'

lib_dirs =  [ 'extensions', 'feedtosis' ].map do |d|
  File.join(File.dirname(__FILE__), d)
end

lib_dirs.each do |d|
  Dir[File.join(d, "**", "*.rb")].each do |file| 
    require file
  end
end
