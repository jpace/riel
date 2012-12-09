#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/rgb_color'
require 'riel/text/ansi/palette'
require 'singleton'

module Text
  class RGBPalette < Palette
    include Singleton

    def each &blk
      rgbrg = (0 .. 5)

      count = 0
      rgbrg.each do |red|
        rgbrg.each do |green|
          rgbrg.each do |blue|
            blk.call RGBColor.new(red, green, blue)
            count += 1
            puts if count > 0 && (count % 6) == 0
          end
        end
        puts
      end
    end
    
    def print_foregrounds
      puts "rgb foreground colors"
      write_foregrounds
    end

    def print_backgrounds
      puts "rgb background colors"
      write_backgrounds
    end

    def print_combinations
      puts "all combinations"
      each do |rgbbg|
        puts "bg: #{rgbbg.to_str}"
        each do |rgbfg|
          print rgbbg.bg
          rgbfg.print_fg
        end
      end
    end
  end
end
