#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/log'
require 'riel/asciitable/cell'
require 'riel/asciitable/column'
require 'riel/asciitable/row'

module RIEL
  module ASCIITable
    class Header
    end
    
    class Table
      include Loggable      

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
end
