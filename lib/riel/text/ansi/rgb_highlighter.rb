#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/rgb_color'
require 'singleton'

module Text
  # Highlights using extended (RGB) ANSI escape sequences.
  module RGBHighlighter
    RGB_RE = Regexp.new '(on_?)?(\d)(\d)(\d)'

    def initialize 
      @aliases = Hash.new
    end
    
    def to_rgb_codes str
      codes = str.scan(RGB_RE).collect do |bg, r, g, b| 
        to_rgb_code r.to_i, g.to_i, b.to_i, bg ? :bg : :fg
        end
      codes.join ''
    end

    def to_rgb_code red, green, blue, fgbg = :fg
      color = RGBColor.new red, green, blue
      color.send fgbg
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
    
    def rrggbb red, green, blue
      [ red, green, blue ].collect { |x| (x * 6 / 255.0).to_i }
    end

    def add_alias name, red, green, blue
      type = name.to_s[0 .. 2] == 'on_' ? :bg : :fg
      color = RGBColor.new red, green, blue, type
      @aliases[name] = color
    end

    def has_alias? name
      @aliases.include? name
    end

    def respond_to? meth
      has_alias?(meth) || super
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
