#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/log'
require 'riel/asciitable/cell'

module RIEL
  class Column
    attr_accessor :width
    attr_accessor :num
    attr_accessor :align
    attr_accessor :table

    def initialize table, num, width = nil, align = nil
      @table = table
      @num = num
      @width = width
      @align = align
    end

    def total fromrow, torow
      @table.cells_in_column(@num).inject(0) { |sum, cell| sum + (cell.row >= fromrow && cell.row <= torow ? cell.value.to_i : 0) }
    end
  end

  class Row
    attr_accessor :table
    attr_accessor :num

    def initialize table, num
      @table = table
      @num = num
    end

    def print columns, align = nil
      tocol = @table.last_column
      col = 0
      fmtdvalues = Array.new
      while col <= tocol
        aln = align || @table.get_column_align(col)
        cell = @table.cell(col, @num)
        width = @table.get_column_width col
        fmtdvalues << cell.formatted_value(width, aln)
        if cell.span
          col += (cell.span - col)
        end
        col += 1
      end
      print_cells fmtdvalues
    end

    def print_cells values
      $stdout.puts "| " + values.join(" | ") + " |"
    end
  end

  class BannerRow < Row
    def initialize table, char
      @char = char
      super(table, nil)
    end

    def print char = '-'
      banner = (0 .. @table.last_column).collect { |col| bc = BannerCell.new(char, col, 1) }
      bannervalues = banner.collect_with_index do |bc, col| 
        width = @table.get_column_width col
        bc.formatted_value width, :center
      end
      print_cells bannervalues
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
      @columns[col] ||= Column.new(self, col, @cellwidth, @align)
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
      Row.new(self, row).print @columns, align
    end

    def print_banner char = '-'
      BannerRow.new(self, char).print
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
