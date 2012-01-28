#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/log'

Log.level = Log::DEBUG

module RIEL
  class Cell
    attr_reader :column
    attr_reader :row

    attr_accessor :value
    attr_accessor :colors
    attr_accessor :span

    def initialize column, row, value = nil, colors = Array.new
      @column = column
      @row = row
      @value = value
      @colors = colors
      @span = span
    end

    def _value width
      value.nil? ? "" : value.to_s
    end

    def inspect
      "(#{@column}, #{@row}) => #{@value}"
    end

    def formatted_value width, align
      strval = _value width

      if @span
        ncolumns = @span - @column
        width = width * (1 + ncolumns) + (3 * ncolumns)
      end

      diff = width - strval.length
        
      lhs, rhs = case align
                 when :left
                   [ 0, diff ]
                 when :right
                   [ diff, 0 ]
                 when :center
                   l = diff / 2
                   r = diff - l
                   [ l, r ]
                 else
                   $stderr.puts "oh my!: #{align}"
                 end

      str = (" " * lhs) + strval + (" " * rhs)
      
      if colors
        colors.each do |cl|
          str = str.send cl
        end
      end

      str
    end
  end

  class BannerCell < Cell
    def initialize char, col, row
      @char = char
      super(col, row)
    end

    def _value width
      @char * width
    end
  end  

  class Column
    attr_accessor :width
    attr_accessor :align

    def initialize width = nil, align = nil
      @width = width
      @align = align
    end
  end

  class Header
  end
  
  class AsciiTable
    def initialize args
      @cells = Array.new
      @cellwidth = args[:cellwidth] || 12
      @align = args[:align] || :left
      @columns = Array.new
      @separator_rows = Hash.new
      @default_value = args[:default_value] || ""
    end

    # sets a separator for the row preceding +rownum+. Does not change the
    # coordinates for any other cells.
    def set_separator_row rownum, char = '-'
      @separator_rows[rownum] = char
    end
    
    def last_column
      @cells.collect { |cell| cell.column }.max
    end

    def last_row
      @cells.collect { |cell| cell.row }.max
    end

    def cells_in_column col
      @cells.select { |cell| cell.column == col }
    end

    def cells_in_row row
      @cells.select { |cell| cell.row == row }
    end

    def cell col, row
      cl = @cells.detect { |c| c.row == row && c.column == col }
      unless cl
        cl = Cell.new(col, row, @default_value)
        @cells << cl
      end
      cl
    end

    def set_column_align col, align
      column(col).align = align
    end

    def set_column_width col, width
      column(col).width = width
    end

    def get_column_width col
      ((c = @columns[col]) && c.width) || @cellwidth
    end

    def get_column_align col
      ((c = @columns[col]) && c.align) || @align
    end

    def column col
      @columns[col] ||= Column.new
    end

    def set_cellspan fromcol, tocol, row
      cell(fromcol, row).span = tocol
    end

    def set col, row, val
      cell(col, row).value = val
    end

    def set_color col, row, *colors
      cell(col, row).colors = colors
    end

    def print_cells values
      $stdout.puts "| " + values.join(" | ") + " |"
    end

    def print_row row, align = nil
      tocol = last_column
      col = 0
      fmtdvalues = Array.new
      while col <= tocol
        aln = align || get_column_align(col)
        cell = cell(col, row)
        fmtdvalues << cell.formatted_value(@cellwidth, aln)
        if cell.span
          col += (cell.span - col)
        end
        col += 1
      end
      print_cells fmtdvalues
    end

    def print_banner char = '-'
      banner = (0 .. last_column).collect { |col| bc = BannerCell.new(char, col, 1) }
      bannervalues = banner.collect { |bc| bc.formatted_value @cellwidth, :center }
      print_cells bannervalues
    end
    
    def print_header
      # cells in the header are always centered
      print_row 0, :center
      print_banner
    end

    def print
      print_header
      
      (1 .. last_row).each do |row|
        if char = @separator_rows[row]
          print_banner char
        end
        print_row row
      end
    end
  end
end
