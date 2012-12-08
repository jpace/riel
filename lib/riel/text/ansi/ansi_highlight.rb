#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/highlight'
require 'riel/text/ansi/ansi_color'
require 'riel/text/ansi/ansi_colors'
require 'riel/text/ansi/attributes'
require 'riel/text/ansi/foregrounds'
require 'riel/text/ansi/backgrounds'
require 'riel/text/ansi/grey'
require 'riel/text/ansi/rgb_color'
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
    [ Attributes, Foregrounds, Backgrounds ].each { |cls| ATTRIBUTES.merge! cls.new.colors }

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

    def to_rgb str, red, green, blue, meth
      color = RGBColor.new red, green, blue
      color.send(meth) + str + color.reset
    end

    def rgb str, red, green, blue
      to_rgb str, red, green, blue, :fg
    end

    def on_rgb str, red, green, blue
      to_rgb str, red, green, blue, :bg
    end

    def to_grey str, value, meth
      color = Grey.new 232 + value
      color.send(meth) + str + color.reset
    end

    def grey str, value
      to_grey str, value, :fg
    end

    def on_grey str, value
      to_grey str, value, :bg
    end

    alias_method :gray, :grey
    alias_method :on_gray, :on_grey

    def add_alias name, red, green, blue
      type = name.to_s[0 .. 2] == 'on_' ? :bg : :fg
      color = RGBColor.new red, green, blue, type
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
