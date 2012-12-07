#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/ansi_color'

module Text
  class ANSIList
    attr_reader :colors

    def initialize colors
      @colors = Hash.new
      colors.each do |name, code|
        @colors[name] = TermAnsi.new code
      end
    end
  end
end
