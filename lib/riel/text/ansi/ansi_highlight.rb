#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/highlight'
require 'riel/text/ansi/ansi_color'
require 'riel/text/ansi/ansi_colors'
require 'riel/text/ansi/ansi_decorations'
require 'riel/text/ansi/ansi_foregrounds'
require 'riel/text/ansi/ansi_backgrounds'

module Text
  # Highlights using ANSI escape sequences.
  class ANSIHighlighter < Highlighter
    DEFAULT_COLORS = [
                      "black on yellow",
                      "black on green",
                      "black on magenta",
                      "yellow on black",
                      "magenta on black",
                      "green on black",
                      "cyan on black",
                      "blue on yellow",
                      "blue on magenta",
                      "blue on green",
                      "blue on cyan",
                      "yellow on blue",
                      "magenta on blue",
                      "green on blue",
                      "cyan on blue",
                     ]
    
    ATTRIBUTES = Hash.new
    [ ANSIAttributes, ANSIForegrounds, ANSIBackgrounds ].each { |cls| colors = cls.new.colors; ATTRIBUTES.merge!(colors) }
    
    RESET = ANSIColor.new(0)

    def codes names
      names.collect { |name| ATTRIBUTES[name] }.compact
    end

    # Returns the escape sequence for the given names.
    def names_to_code names
      names = [ names ] unless names.kind_of? Array
      names.collect { |name| "\e[#{ATTRIBUTES[name]}m" }.join ''
    end

    def rgb red, green, blue
      # color = TermColor ...
      @@highlighter.rgb red, green, blue
    end
  end
end
