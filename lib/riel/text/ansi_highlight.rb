#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/highlight'

module Text
  class ANSIColor
    def initialize code
      @code = code
    end

    def str
      "\e[#{@code}m"
    end
  end

  class ANSIList
    attr_reader :colors

    def initialize colors
      @colors = colors
    end
  end

  class ANSIAttributes < ANSIList
    def initialize 
      super Hash[
                 'none'       => '0', 
                 'reset'      => '0',
                 'bold'       => '1',
                 'underscore' => '4',
                 'underline'  => '4',
                 'blink'      => '5',
                 'negative'   => '7',
                 'concealed'  => '8',
                ]
    end
  end

  class ANSIColors < ANSIList
    COLORS = [ :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white ]

    def initialize colors, start
      color_to_code = Hash.new
      colors.each_with_index { |color, idx| color_to_code[color.to_s] = start + idx }
      super color_to_code
    end
  end

  class ANSIForegrounds < ANSIColors
    def initialize 
      super COLORS, 30
    end
  end

  class ANSIBackgrounds < ANSIColors
    def initialize 
      on_colors = COLORS.collect { |color| "on_#{color}" }
      super on_colors, 40
    end
  end

  # Highlights using ANSI escape sequences.
  class ANSIHighlighter < Highlighter
    ATTRIBUTES = Hash.new
    [ ANSIAttributes, ANSIForegrounds, ANSIBackgrounds ].each { |cls| colors = cls.new.colors; ATTRIBUTES.merge!(colors) }
    
    RESET = ANSIColor.new(0)

    def codes names
      names.collect { |name| ATTRIBUTES[name] }.compact
    end

    # Returns the escape sequence for the given names.
    def names_to_code names
      names = [ names ] unless names.kind_of? Array
      names.collect { |name| "\e[#{ATTRIBUTES[name]}m" }.join ''
    end

    def rgb red, green, blue
      # color = TermColor ...
      @@highlighter.rgb red, green, blue
    end
  end
end
