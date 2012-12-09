riellibdir = File.dirname(__FILE__)

$:.unshift(riellibdir) unless
  $:.include?(riellibdir) || $:.include?(File.expand_path(riellibdir))

module RIEL
  VERSION = '1.1.14'
end

rbfiles = Dir[riellibdir + "/riel/**/*.rb"]

rieldir = riellibdir + '/riel'

rbfiles.sort.each do |rbfile|
  rootname = rbfile.sub(Regexp.new('^' + rieldir + '/([\/\w]+)\.rb'), '\1')
  require "riel/" + rootname
end
