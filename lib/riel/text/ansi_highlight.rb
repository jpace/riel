#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/highlight'

module Text
  # Highlights using ANSI escape sequences.
  class ANSIHighlighter < Highlighter
    ATTRIBUTES = Hash[
                      'none'       => '0', 
                      'reset'      => '0',
                      'bold'       => '1',
                      'underscore' => '4',
                      'underline'  => '4',
                      'blink'      => '5',
                      'negative'   => '7',
                      'concealed'  => '8',
                      'black'      => '30',
                      'red'        => '31',
                      'green'      => '32',
                      'yellow'     => '33',
                      'blue'       => '34',
                      'magenta'    => '35',
                      'cyan'       => '36',
                      'white'      => '37',
                      'on_black'   => '40',
                      'on_red'     => '41',
                      'on_green'   => '42',
                      'on_yellow'  => '43',
                      'on_blue'    => '44',
                      'on_magenta' => '45',
                      'on_cyan'    => '46',
                      'on_white'   => '47',
                     ]

    RESET = "\e[0m"

    def initialize colors = DEFAULT_COLORS
      super
      @code = nil
    end

    def codes names
      names.collect { |name| ATTRIBUTES[name] }.compact
    end

    # Returns the escape sequence for the given names.
    def names_to_code names
      names = [ names ] unless names.kind_of? Array
      codes(names).collect { |code| "\e[#{code}m" }.join ''
    end

    def highlight str
      @code ||= begin
                  @code = @colors.collect do |color|
                    names_to_code color
                  end.join ''
                end
      
      @code + str + RESET
    end
  end
end
