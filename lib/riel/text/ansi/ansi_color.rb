#!/usr/bin/ruby -w
# -*- ruby -*-

module Text
  class ANSIColor
    def initialize code
      @code = code
    end

    def str
      "\e[#{@code}m"
    end
  end
end
