#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/highlight'
require 'riel/text/ansi/ansi_color'
require 'riel/text/ansi/ansi_colors'
require 'riel/text/ansi/ansi_decorations'
require 'riel/text/ansi/ansi_foregrounds'
require 'riel/text/ansi/ansi_backgrounds'
require 'riel/text/ansi/term_rgb_color'

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
    [ ANSIAttributes, ANSIForegrounds, ANSIBackgrounds ].each { |cls| ATTRIBUTES.merge! cls.new.colors }
    
    def codes names
      names.collect { |name| ATTRIBUTES[name] }.compact
    end

    # Returns the escape sequence for the given names.
    def names_to_code names
      names = [ names ] unless names.kind_of? Array
      names.collect { |name| ATTRIBUTES[name].str }.join ''
    end

    def rgb str, red, green, blue
      # color = TermColor ...
      color = TermRGB.new red, green, blue
      color.fg + str + color.reset
    end
  end
end
