#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/term_color'

class TermRGB < TermColor
  attr_reader :red
  attr_reader :green
  attr_reader :blue
  
  def initialize red, green, blue
    @red = red
    @green = green
    @blue = blue
  end

  def to_s
    sprintf "%d%d%d", @red, @green, @blue
  end

  def value
    (@red * 36) + (@green * 6) + @blue + 16
  end
end
