#!/usr/bin/ruby -w
# -*- ruby -*-

#
# = string.rb
#
# RIEL extensions to the Ruby String class.
#
# Author:: Jeff Pace <jpace@incava.org>
# Documentation:: Author
#

module RIEL
  module StringExt
    #
    # Returns whether the string ends with the given substring.
    #
    def ends_with substr
      return rindex(substr) == length - substr.length
    end

    #
    # Returns the string, as a number if it is one, and nil otherwise,
    #
    def num
      begin
        Integer self
      rescue ArgumentError
        nil
      end
    end

    # 
    # Returns a string based on this instance, with the first occurrance of
    # +other+ removed. +other+ may be a string or regular expression.
    #
    def - other
      sub other, ''
    end

    # 
    # Represents infinity, for the +to_ranges+ function.
    #
    Infinity = (1.0 / 0)

    # :stopdoc:
    #                       from  (maybe   to           this)
    RANGE_REGEXP = %r{^ \s* (\d*) (?: \s* (\-|\.\.) \s* (\d*) )? \s* $ }x
    # :startdoc:

    # 
    # Splits num into array of ranges, limiting itself to +args[:min]+ and +args[:max]+,
    # if specified. The +args[:collapse]+, if true, results in sequential values put
    # into the same range.
    # 
    # Examples:
    #   
    #    "1,2".to_ranges                                   # [ 1 .. 1, 2 .. 2 ]
    #    "1,2".to_ranges :collapse => true                 # [ 1 .. 2 ]
    #    "1-4".to_ranges                                   # [ 1 .. 4 ]
    #    "1-3,5-6,10,11,12,".to_ranges :collapse => true   # [ 1 .. 3, 5 .. 6, 10 .. 12 ]
    #    "1-3,5-6,10,11,12,".to_ranges                     # [ 1 .. 3, 5 .. 6, 10 .. 10, 11 .. 11, 12 .. 12 ]
    #    "-4".to_ranges                                    # [ -String::Infinity ..  4 ]
    #    "4-".to_ranges                                    # [ 4 .. String::Infinity ]
    #    "1-".to_ranges :min => 0, :max => 8               # [ 1 .. 8 ]
    # 
    def to_ranges args = Hash.new
      min = args[:min] || -Infinity
      max = args[:max] || Infinity
      collapse = args[:collapse]
      
      ranges = Array.new
      self.split(%r{\s*,\s*}).each do |section|
        md = section.match(RANGE_REGEXP)
        next unless md
        
        from = _matchdata_to_number md, 1, min
        to = _has_matchdata?(md, 2) ? _matchdata_to_number(md, 3, max) : from

        prevrange = ranges[-1]

        if collapse && prevrange && prevrange.include?(from - 1) && prevrange.include?(to - 1)
          ranges[-1] = (prevrange.first .. to)
        else
          ranges << (from .. to)
        end
      end

      ranges
    end

    # :stopdoc:
    def _has_matchdata? md, idx
      md && md[idx] && !md[idx].empty?
    end

    def _matchdata_to_number md, idx, default
      _has_matchdata?(md, idx) ? md[idx].to_i : default
    end
    # :startdoc:
  end
end
