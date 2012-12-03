#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/highlight'

module Text
  # Highlights using HTML. Fonts are highlighted using <span> tags, not <font>.
  # Also note that negative is translated to white on black.
  # According to http://www.w3.org/TR/REC-CSS2/syndata.html#value-def-color,
  # valid color keywords are: aqua, black, blue, fuchsia, gray, green, lime,
  # maroon, navy, olive, purple, red, silver, teal, white, and yellow.
  # Thus, no magenta or cyan.

  class HTMLHighlighter < Highlighter
    def initialize colors
      super
      
      # we need to know what we're resetting from (bold, font, underlined ...)
      @stack = []
    end

    # Returns the start tag for the given name.
    
    def start_style name
      case name
      when "negative"
        "<span style=\"color: white; background-color: black\">"
      when /on_(\w+)/
        colval = color_value $1
        "<span style=\"background-color: #{colval}\">"
      else
        colval = color_value name
        "<span style=\"color: #{colval}\">"
      end
    end

    # Returns the end tag ("</span>").

    def end_style
      "</span>"
    end

    def color_value cname
      case cname
      when "cyan"
        "#00FFFF"
      when "magenta"
        "#FF00FF"
      else
        cname
      end
    end

    # Returns the code for the given name.
    def names_to_code names
      str = ""

      names = [ names ] unless names.kind_of? Array

      names.each do |name|
        @stack << name

        case name
        when "none", "reset"
          @stack.pop
          if @stack.length > 0
            begin
              prev = @stack.pop
              case prev
              when "bold"
                str << "</b>"
              when "underscore", "underline"
                str << "</u>"
              when "blink"
                str << "</blink>"
              when "concealed"
                str << " -->"
              else
                str << end_style
              end
            end while @stack.length > 0
          end
          str
        when "bold"
          str << "<b>"
        when "underscore", "underline"
          str << "<u>"
        when "blink"
          str << "<blink>"
        when "concealed"
          str << "<!-- "
        else
          str << start_style(name)
        end
      end

      str
    end
  end
end
