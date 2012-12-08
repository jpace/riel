#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/color'

module Text
  # An ANSI color uses only the basic 8 colors.
  class AnsiColor < Color
    def initialize value
      super value, nil
    end

    def to_s
      "\e[#{value}m"
    end

    def print_fg
      print fg
      print "#{@value}/."
      print reset
      print ' '
    end    

    def print_bg
      print bg
      print "./#{@value}"
      print reset
      print ' '
    end    
  end
end
