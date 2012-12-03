#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/highlight'

module Text
  # Does no highlighting.
  class NonHighlighter < Highlighter
    def initialize
      super nil
    end

    def names_to_code colorname
      ""
    end
  end
end
