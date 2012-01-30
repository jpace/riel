#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/log'

module RIEL
  module ASCIITable
    class Row
      include Loggable
      
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
  end
end
