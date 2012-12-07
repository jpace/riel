#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/highlight'
require 'riel/text/ansi/ansi_color'
require 'riel/text/ansi/ansi_colors'
require 'riel/text/ansi/ansi_decorations'
require 'riel/text/ansi/ansi_foregrounds'
require 'riel/text/ansi/ansi_backgrounds'
require 'riel/text/ansi/term_rgb_color'
require 'singleton'

module Text
  # Highlights using ANSI escape sequences.
  class ANSIHighlighter < Highlighter
    include Singleton
    
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

    def initialize 
      @aliases = Hash.new
    end
    
    def codes names
      names.collect { |name| ATTRIBUTES[name] }.compact
    end

    # Returns the escape sequence for the given names.
    def names_to_code names
      names = [ names ] unless names.kind_of? Array
      names.collect { |name| ATTRIBUTES[name].to_s }.join ''
    end

    def rgb str, red, green, blue
      color = TermRGB.new red, green, blue
      color.fg + str + color.reset
    end

    def add_alias name, red, green, blue
      type = name.to_s[0 .. 2] == 'on_' ? :bg : :fg
      color = TermRGB.new red, green, blue, type
      @aliases[name] = color
    end

    def has_alias? name
      @aliases.include? name
    end

    def respond_to? meth
      has_alias? meth
    end

    def method_missing(meth, *args, &blk)
      if has_alias? meth
        methdecl = Array.new
        methdecl << "def #{meth}(str, &blk);"
        methdecl << "  color = @aliases[:#{meth}];"
        methdecl << "  color.to_s + str + color.reset;"
        methdecl << "end"
        self.class.class_eval methdecl.join("\n")
        send meth, *args, &blk
      else
        super
      end
    end
  end
end
