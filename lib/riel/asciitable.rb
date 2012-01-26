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
    attr_accessor :align
    
    def initialize args
      @cells = Hash.new { |h, k| h[k] = Hash.new }
      @cellwidth = args[:cellwidth] || 12
      @align = args[:align] || :left
      @columns = Array.new
    end
    
    def to_column
      @cells.keys.sort[-1]
    end

    def to_row
      xxx@cells.keys.sort[-1]
    end

    def set_column_align col, align
      _get_column(col).align = align
    end

    def set_column_width col, width
      _get_column(col).width = width
    end

    def get_column_width col
      ((c = @columns[col]) && c.width) || @cellwidth
    end

    def get_column_align col
      ((c = @columns[col]) && c.align) || @align
    end

    def _get_column col
      @columns[col] ||= Column.new
    end

    def cell col, row
      @cells[col][row] ||= Cell.new(col, row)
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

    def get_formatted_value val, colors = nil, width = nil, align = @align
      strval = val.nil? ? "" : val.to_s

      width ||= @cellwidth
      
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

    def get_cell_value col, row
      cell = cell(col, row)

      val, colors = if cell
                      [ cell.value, cell.colors ]
                    else
                      [ "", nil ]
                    end

      [ val, colors ]
    end

    def get_formatted_cell col, row, align = @align
      cell = cell(col, row)

      val, colors, span = if cell
                            [ cell.value, cell.colors, cell.span ? cell.span - col : 0 ]
                          else
                            [ "", nil, nil ]
                          end
      
      width = @cellwidth

      get_formatted_value val, colors, width, align
    end

    def print_cells values
      $stdout.puts "| " + values.join(" | ") + " |"
    end

    def print_row row, align = @align
      tocol = to_column
      fmtdvalues = (0 .. tocol).collect do |col| 
        aln = row == 0 ? :center : get_column_align(col)
        get_formatted_cell col, row, aln
      end
      print_cells fmtdvalues
    end
    
    def print_header
      # cells in the header are always centered
      print_row 0, :center

      banner = (0 .. to_column).collect do |col| 
        get_formatted_value '.' * @cellwidth, [ :cyan ], @cellwidth, align
      end
      print_cells banner
    end

    def print
      tocol = @cells.keys.sort[-1]
      rownums = @cells.values.collect { |x| x.keys }.flatten.sort

      torow = rownums[-1]

      print_header
      
      (1 .. torow).each do |row|
        print_row row
      end
    end
  end
end
