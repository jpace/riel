#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/ansi_colors'

module Text
  class ANSIBackgrounds < ANSIColors
    def initialize 
      on_colors = COLORS.collect { |color| "on_#{color}" }
      super on_colors, 40
    end
  end
end
