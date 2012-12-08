#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/color'

module Text
  class RGBColor < Color
    attr_reader :red
    attr_reader :green
    attr_reader :blue
    
    def initialize red, green, blue, type = :fg
      super((red * 36) + (green * 6) + blue + 16, type)
      
      @red = red
      @green = green
      @blue = blue
    end

    def to_str
      sprintf "%d%d%d", @red, @green, @blue
    end

    def value
      (@red * 36) + (@green * 6) + @blue + 16
    end
  end
end
