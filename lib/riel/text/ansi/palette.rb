#!/usr/bin/ruby -w
# -*- ruby -*-

module Text
  class Palette
    def write_foregrounds
      each do |color|
        color.print_fg
      end
    end

    def write_backgrounds
      each do |color|
        color.print_bg
      end
    end
  end
end
