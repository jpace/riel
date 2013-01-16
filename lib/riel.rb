riellibdir = File.dirname(__FILE__)

$:.unshift(riellibdir) unless
  $:.include?(riellibdir) || $:.include?(File.expand_path(riellibdir))

module RIEL
  VERSION = '1.1.17'
end
