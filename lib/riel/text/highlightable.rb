#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/highlight'
require 'riel/text/ansi/ansi_highlight'
require 'riel/text/html_highlight'
require 'riel/text/non_highlight'

module Text
  # An object that can be highlighted. This is used by the String class.
  module Highlightable
    # The highlighter for the class in which this module is included.
    @@highlighter = ANSIHighlighter.instance

    # this dynamically adds methods for individual colors.
    def method_missing(meth, *args, &blk)
      if has_color? meth.to_s
        methdecl = Array.new
        methdecl << "def #{meth}(&blk);"
        methdecl << "  @@highlighter.color(\"#{meth}\", self, &blk);"
        methdecl << "end"
        self.class.class_eval methdecl.join("\n")
        send meth, *args, &blk
      elsif Text::ANSIHighlighter.instance.has_alias? meth
        methdecl = Array.new
        methdecl << "def #{meth}(&blk);"
        methdecl << "  @@highlighter.#{meth}(self, &blk);"
        methdecl << "end"
        self.class.class_eval methdecl.join("\n")
        send meth, *args, &blk
      else
        super
      end
    end

    def respond_to? meth
      has_color?(meth.to_s) || Text::ANSIHighlighter.instance.has_alias?(meth) || super
    end

    def has_color? color
      Text::Highlighter::all_colors.include? color
    end

    # Sets the highlighter for this class. This can be either by type or by
    # String.
    def highlighter= hl
      @@highlighter = case hl
                      when Text::Highlighter
                        hl
                      when :none, "NONE", nil
                        Text::NonHighlighter.new
                      when :html, "HTML"
                        Text::HTMLHighlighter.new
                      when :ansi, "ANSI"
                        Text::ANSIHighlighter.instance
                      else
                        Text::NonHighlighter.new
                      end
      
    end

    def rgb red, green, blue
      @@highlighter.rgb self, red, green, blue
    end

    def on_rgb red, green, blue
      @@highlighter.on_rgb self, red, green, blue
    end

    def self.add_to cls
      cls.send :include, Text::Highlightable
    end
  end
end
