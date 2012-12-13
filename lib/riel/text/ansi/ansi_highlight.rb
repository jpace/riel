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
require 'riel/text/ansi/rgb_highlighter'
require 'singleton'

module Text
  # Highlights using ANSI escape sequences.
  class ANSIHighlighter < Highlighter
    include Singleton, RGBHighlighter
    
    ATTRIBUTES = Hash.new
    [ Attributes, Foregrounds, Backgrounds ].each { |cls| ATTRIBUTES.merge! cls.new.colors }

    RGB_RE = Regexp.new '(on_?)?(\d)(\d)(\d)'

    def initialize 
      super
      @default_codes = nil
    end

    def default_codes limit = -1
      @default_codes ||= DEFAULT_COLORS.collect { |color| to_codes color }
      @default_codes[0 .. limit]
    end
    
    def to_codes str
      names = parse_colors str
      if names.empty?
        return to_rgb_codes str
      end
      names_to_code names
    end
    
    def codes names
      names.collect { |name| ATTRIBUTES[name] }.compact
    end

    # Returns the escape sequence for the given names.
    def names_to_code names
      names = [ names ] unless names.kind_of? Array
      names.collect { |name| ATTRIBUTES[name].to_s }.join ''
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
  end
end
