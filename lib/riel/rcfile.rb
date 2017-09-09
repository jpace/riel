#!/usr/bin/ruby -w
# -*- ruby -*-

# Represents a resource file, where '#' is used to comment to end of lines, and name/value pairs are
# separated by '=' or ':'.

class RCFile
  attr_reader :settings

  # Reads the RC file, if it exists, and if a block is passed, calls the block with each name/value
  # pair, which are also accessible via <code>settings</code>.

  def initialize args = Hash.new, &blk
    @settings = Array.new

    unless lines = args[:lines]
      if fname = args[:filename]
        lines = IO::readlines fname
      end
    end

    cmtre = Regexp.new '\s*#.*'
    nvre = Regexp.new '\s*[=:]\s*'
    
    lines.each do |line|
      line.sub! cmtre, ''
      name, value = line.split nvre
      if name && value
        name.strip!
        value.strip!
        @settings << [ name, value ]
        if blk
          blk.call name, value
        end
      end
    end
  end
end
