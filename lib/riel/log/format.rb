#!/usr/bin/ruby -w
# -*- ruby -*-

module RIEL
  class Format
    
    def trim_left str, maxlen
      str[0 ... maxlen.to_i.abs]
    end

    def trim_right str, maxlen
      mxln = maxlen.abs

      # magic number 3 for the ellipses ...

      if str.length > mxln
        path = str.split('/')
        newstr = "..."
        path.reverse.each do |element|
          if newstr.length + element.length > mxln
            while newstr.length < mxln
              newstr.insert 0, " "
            end
            return newstr
          else
            if newstr.length > 3
              newstr.insert 3, "/"
            end
            newstr.insert 3, element
          end
        end
        newstr
      else
        str
      end
    end

    def print_formatted file, line, func, msg, lvl, &blk
      if trim
        file = trim_right file, @file_width
        line = trim_left  line, @line_width
        func = trim_left  func, @function_width
      end

      hdr = sprintf @format, file, line, func
      puts "$$$$ hdr: #{hdr}".color(:yellow)
      print hdr, msg, lvl, &blk
    end
  end
end
