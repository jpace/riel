#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text'

class String

  def ends_with(substr)
    return rindex(substr) == (length - substr.length)
  end

  # Returns the string, as a number if it is one, and nil otherwise.
  def num
    begin
      Integer(self)
    rescue ArgumentError => ae
      nil
    end
  end

  # returns a string based on this instance, with the first occurrance of
  # +other+ removed. +other+ may be a string or regular expression.
  def -(other)
    sub(other, '')
  end

  Infinity = (1.0 / 0)

  #                       from  (maybe   to           this)
  RANGE_REGEXP = %r{^ \s* (\d*) (?: \s* (\-|\.\.) \s* (\d*) )? \s* $ }x

  # splits num into array of ranges.
  # handles 
  def self.to_ranges(str, args = Hash.new)
    min      = args[:min] || -Infinity
    max      = args[:max] || Infinity
    collapse = args[:collapse]
    
    ranges = Array.new
    str.split(%r{\s*,\s*}).each do |section|
      md   = section.match(RANGE_REGEXP)
      next unless md
      
      from = _matchdata_to_number(md, 1, min)
      to   = _has_matchdata?(md, 2) ? _matchdata_to_number(md, 3, max) : from

      prevrange = ranges[-1]

      if collapse && prevrange && prevrange.include?(from - 1) && prevrange.include?(to - 1)
        ranges[-1] = (prevrange.first .. to)
      else
        ranges << (from .. to)
      end
    end

    ranges
  end

  def self._has_matchdata?(md, idx)
    md && md[idx] && !md[idx].empty?
  end

  def self._matchdata_to_number(md, idx, default)
    _has_matchdata?(md, idx) ? md[idx].to_i : default
  end

  def to_ranges
    String.to_ranges(self)
  end

  HIGHLIGHTER = ::Text::ANSIHighlighter.new

  # returns a highlighted (colored) version of the string, applying the regular
  # expressions in the array, which are paired with the desired color.
  def highlight(re, color)
    gsub(re) do |match|
      HIGHLIGHTER.color(color, match)
    end
  end

end
