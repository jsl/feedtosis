require 'rubygems'
require 'curb'
require 'hashback'
require 'http_headers'
require 'feed-normalizer'
require 'md5'

lib_dirs =  [ 'extensions', 'myzofeedtosis' ].map do |d|
  File.join(File.dirname(__FILE__), d)
end

lib_dirs.each do |d|
  Dir[File.join(d, "**", "*.rb")].each {|file| require file }
end
