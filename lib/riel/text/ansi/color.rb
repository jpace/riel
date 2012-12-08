#!/usr/bin/ruby -w
# -*- ruby -*-

module Text
  class Color
    BOLD = "\e[1m"
    RESET = "\x1b[0m"

    # \e1 == \x1b

    attr_reader :value

    def initialize value, type
      @value = value
      @type = type
    end

    def to_s
      @type == :fg ? fg : bg
    end
    
    def fg
      str 38
    end

    def bg
      str 48
    end

    def str num
      "\x1b[#{num};5;#{value}m"
    end

    def bold
      BOLD
    end
    
    def reset
      RESET
    end

    def print_fg
      write fg
    end

    def print_bg
      write bg
    end

    def to_str
      sprintf "%03d", @value
    end
    
    private
    def write fgbg
      print fgbg
      print to_str
      print reset
      print ' '
    end
  end
end
