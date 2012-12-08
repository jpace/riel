#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/color'

module Text
  class Grey < Color
    def initialize value
      super value, nil
    end

    def to_s
      "\e[#{value}m"
    end

    def print_fg
      print fg
      print to_str
      print reset
      print ' '
    end    

    def print_bg
      print bg
      print to_str
      print reset
      print ' '
    end    
  end
end
