#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/ansi_list'

module Text
  class ANSIColors < ANSIList
    COLORS = [ :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white ]

    def initialize colors, start
      color_to_code = Hash.new
      colors.each_with_index { |color, idx| color_to_code[color.to_s] = start + idx }
      super color_to_code
    end
  end
end
