#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/term_value'

module Text
  class TermGrey < TermValue
  end

  class TermAnsi < TermValue
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
