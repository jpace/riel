#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/ansi_colors'

module Text
  class Foregrounds < Colors
    def initialize 
      super COLORS, 30
    end
  end
end
