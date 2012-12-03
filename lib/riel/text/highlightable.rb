#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/highlight'
require 'riel/text/ansi_highlight'
require 'riel/text/html_highlight'
require 'riel/text/non_highlight'

module Text
  # An object that can be highlighted. This is used by the String class.
  module Highlightable
    # The highlighter for the class in which this module is included.
    @@highlighter = ANSIHighlighter.new Text::Highlighter::DEFAULT_COLORS

    # this dynamically adds methods for individual colors.
    def method_missing(meth, *args, &blk)
      if Text::Highlighter::all_colors.include? meth.to_s
        methdecl = Array.new
        methdecl << "def #{meth}(&blk)"
        methdecl << "  @@highlighter.color(\"#{meth}\", self, &blk)"
        methdecl << "end"
        self.class.class_eval methdecl.join("\n")
        send meth, *args, &blk
      else
        super
      end
    end

    # Sets the highlighter for this class. This can be either by type or by
    # String.
    def highlighter= hl
      @@highlighter = case hl
                      when Text::Highlighter
                        hl
                      when Text::Highlighter::NONE, "NONE", nil
                        Text::NonHighlighter.new
                      when Text::Highlighter::HTML, "HTML"
                        Text::HTMLHighlighter.new
                      when Text::Highlighter::ANSI, "ANSI"
                        Text::ANSIHighlighter.new
                      else
                        Text::NonHighlighter.new
                      end
      
    end

    def self.add_to cls
      cls.class_eval %{ include Text::Highlightable; extend Text::Highlightable }
    end
  end
end
