#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/grey'
require 'riel/text/ansi/palette'
require 'singleton'

module Text
  class GreyPalette < Palette
    include Singleton

    GREY_RG = (0 .. 23)
    
    def each &blk
      count = 0
      GREY_RG.each do |grey|
        code = 232 + grey
        color = Grey.new code
        blk.call color
        count += 1
        puts if count > 0 && (count % 6) == 0
      end
      puts
    end

    def print_foregrounds
      puts "grey foreground colors"
      write_foregrounds
    end

    def print_backgrounds
      puts "grey background colors"
      write_backgrounds
    end
  end
end
