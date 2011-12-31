$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module RIEL
  VERSION = '0.0.1'
end

rbfiles = Dir[File.dirname(__FILE__) + "/riel/**/*.rb"]

rbfiles.sort.each do |rbfile|
  rootname = rbfile.match(%r{.*/(\w+)\.rb})[1]
  require "riel/" + rootname
end
