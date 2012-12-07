#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/term_color'

module Text
  class TermValue < TermColor
    attr_reader :value
    
    def initialize value, type = :fg
      super type
      @value = value
    end

    def to_str
      sprintf "%03d", @value
    end
  end
end
