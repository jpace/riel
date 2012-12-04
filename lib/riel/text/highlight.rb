#!/usr/bin/ruby -w
# -*- ruby -*-

module Text
  # Highlights text using either ANSI terminal codes, or HTML.

  # Note that the foreground and background sections can have modifiers
  # (attributes).
  # 
  # Examples:
  #     black
  #     blue on white
  #     bold green on yellow
  #     underscore bold magenta on cyan
  #     underscore red on cyan
  
  class Highlighter
    VERSION = "1.0.4"
    ATTRIBUTES = %w{
      none
      reset
      bold
      underscore
      underline
      blink
      negative
      concealed
      black
      red
      green
      yellow
      blue
      magenta
      cyan
      white
      on_black
      on_red
      on_green
      on_yellow
      on_blue
      on_magenta
      on_cyan
      on_white
    }
    
    NONE = Object.new
    HTML = Object.new
    ANSI = Object.new

    COLORS      = %w{ black red green yellow blue magenta cyan white }
    DECORATIONS = %w{ none reset bold underscore underline blink negative concealed }

    BACKGROUND_COLORS = COLORS.collect { |color| "on_#{color}" }
    FOREGROUND_COLORS = COLORS

    COLORS_RE = Regexp.new('(?: ' + 
                                # background will be in capture 0
                                'on(?:\s+|_) ( ' + COLORS.join(' | ') + ' ) | ' +
                                # foreground will be in capture 1
                                '( ' + (COLORS + DECORATIONS).join(' | ') + ' ) ' +
                            ')', Regexp::EXTENDED);

    DEFAULT_COLORS = [
      "black on yellow",
      "black on green",
      "black on magenta",
      "yellow on black",
      "magenta on black",
      "green on black",
      "cyan on black",
      "blue on yellow",
      "blue on magenta",
      "blue on green",
      "blue on cyan",
      "yellow on blue",
      "magenta on blue",
      "green on blue",
      "cyan on blue",
    ]

    attr_reader :colors
    
    def parse_colors str
      str.scan(Regexp.new(COLORS_RE)).collect do |color|
        color[0] ? "on_" + color[0] : color[1]
      end
    end

    # returns a list of all color combinations.
    def self.all_colors
      all_colors = Array.new
      ([ nil ] + DECORATIONS).each do |dec|
        ([ nil ] + FOREGROUND_COLORS).each do |fg|
          ([ nil ] + BACKGROUND_COLORS).each do |bg|
            name = [ dec, fg, bg ].compact.join("_")
            all_colors << name if name && name.length > 0
          end
        end
      end
      all_colors
    end
    
    def highlight str
      # implemented by subclasses
    end

    def to_s
      (@colors || '').join(' ')
    end

    def == other
      return @colors.sort == other.colors.sort
    end

    # Colorizes the given object. If a block is passed, its return value is used
    # and the stream is reset. If a String is provided as the object, it is
    # colorized and the stream is reset. Otherwise, only the code for the given
    # color name is returned.
    
    def color colorstr, obj = nil, &blk
      colornames = parse_colors colorstr
      result = names_to_code colornames
      
      if blk
        result << blk.call
      elsif obj.kind_of? String
        result << obj
      end
      result << names_to_code("reset")
      result
    end

    # returns the code for the given color string, which is in the format:
    # foreground* [on background]?
    # 
    # Note that the foreground and background sections can have modifiers
    # (attributes).
    # 
    # Examples:
    #     black
    #     blue on white
    #     bold green on yellow
    #     underscore bold magenta on cyan
    #     underscore red on cyan
    def code str
      fg, bg = str.split(/\s*\bon_?\s*/)
      (fg ? foreground(fg) : "") + (bg ? background(bg) : "")
    end

    # Returns the code for the given background color(s).
    def background bgcolor
      names_to_code "on_" + bgcolor
    end

    # Returns the code for the given foreground color(s).
    def foreground fgcolor
      fgcolor.split(/\s+/).collect { |fg| names_to_code fg }.join("")
    end
  
    # Returns a highlighted (colored) version of the string, applying the regular
    # expressions in the array, which are paired with the desired color.
    def gsub str, re, color
      str.gsub(re) do |match|
        self.color color, match
      end
    end
  end
end
