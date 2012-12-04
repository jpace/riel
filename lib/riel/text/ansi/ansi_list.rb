#!/usr/bin/ruby -w
# -*- ruby -*-

module Text
  class ANSIList
    attr_reader :colors

    def initialize colors
      @colors = colors
    end
  end
end
