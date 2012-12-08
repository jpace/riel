#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/ansi_color'
require 'riel/text/ansi/palette'
require 'singleton'

module Text
  class AnsiPalette < Palette
    include Singleton

    ANSI_RG = (0 .. 7)

    def each &blk
      ANSI_RG.each do |bg|
        color = AnsiColor.new bg
        blk.call color
      end
    end
    
    def print_foregrounds
      puts "ansi foregrounds"
      write_foregrounds
      puts
      puts
    end

    def print_backgrounds
      puts "ansi backgrounds"
      write_backgrounds
      puts
      puts
    end

    def print_combinations
      puts "ansi combinations"
      each do |bgcolor|
        puts "bg: #{bgcolor.to_str}"
        each do |fgcolor|
          print bgcolor.bg
          fgcolor.print_fg
        end
        puts
        puts
      end
    end
  end
end
