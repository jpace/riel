#!/usr/bin/ruby -w
# -*- ruby -*-

class IO

  $-w = false

  # Reads the stream into an array. It works even when $/ == nil, which
  # works around a problem in Ruby 1.8.1.
  def readlines
    contents = []
    while ((line = gets) && line.length > 0)
      contents << line
    end
    contents
  end

  $-w = true

end
