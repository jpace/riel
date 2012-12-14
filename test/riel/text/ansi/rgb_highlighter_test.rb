#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/text/highlightable'
require 'riel/text/ansi/rgb_highlighter'
require 'riel/text/string'

class RGBHighlighterTest < Test::Unit::TestCase
  def setup
    String.highlight
    @hl = Text::ANSIHighlighter.instance 
  end
  
  def test_rgb
    str = "123".rgb(1, 2, 3)
    assert_equal "\x1b[38;5;67m123\e[0m", str
  end

  def test_on_rgb
    str = "123".on_rgb(1, 2, 3)
    assert_equal "\x1b[48;5;67m123\e[0m", str
  end

  def test_rgb_chained
    str = "gaudy".rgb(4, 1, 2).on_rgb(1, 5, 3)
    puts "str: #{str}"
    assert_equal "\x1b[48;5;85m\x1b[38;5;168mgaudy\e[0m\e[0m", str
  end

  def test_rgb_bold_underline
    str = "hey!".rgb(0, 3, 5).on_rgb(5, 2, 1).bold.underline
    puts "str: #{str}"
    assert_equal "\e[4m\e[1m\e[48;5;209m\x1b[38;5;39mhey!\e[0m\e[0m\e[0m\e[0m", str
  end

  def assert_to_codes expected, rgbstr
    codes = @hl.to_codes rgbstr
    assert_equal expected, codes
  end

  def test_to_rgb_code
    code = @hl.to_rgb_code 1, 3, 5
    assert_equal "\e[38;5;75m", code
  end

  def test_to_rgb_code_background
    code = @hl.to_rgb_code 1, 3, 5, :bg
    assert_equal "\e[48;5;75m", code
  end

  def test_to_codes_rgb_foreground
    assert_to_codes "\e[38;5;75m", '135'
  end

  def test_to_codes_rgb_onbackground
    assert_to_codes "\e[48;5;75m", 'on135'
  end

  def test_to_codes_rgb_on_background
    assert_to_codes "\e[48;5;75m", 'on_135'
  end
  
  def test_rgb_fg_alias
    @hl.add_alias :teal, 1, 4, 4
    
    str = "ABC".teal
    assert_equal "\x1b[38;5;80mABC\e[0m", str
  end

  def test_rgb_bg_alias
    @hl.add_alias :on_maroon, 1, 0, 2
    
    str = "ABC".on_maroon
    assert_equal "\x1b[48;5;54mABC\e[0m", str
  end
  
  def add_rrggbb name, red, green, blue
    rr, gg, bb = @hl.rrggbb(red, green, blue)
    @hl.add_alias name, rr, gg, bb
  end
  
  def test_rgb_multiple_aliases
    add_rrggbb :on_dahlia_mauve, 168, 83, 135
    add_rrggbb :mauve_chalk, 228, 211, 210
    
    str = "mauve chalk on dahlia".mauve_chalk.on_dahlia_mauve
    puts str
    assert_equal "\x1b[48;5;133m\x1b[38;5;224mmauve chalk on dahlia\e[0m\e[0m", str
  end

  def test_rrggbb
    rr, gg, bb = @hl.rrggbb(122, 212, 67)
    puts "rr, gg, bb: #{rr}, #{gg}, #{bb}"

    rr, gg, bb = @hl.rrggbb(121, 211, 62)
    puts "rr, gg, bb: #{rr}, #{gg}, #{bb}"
  end
end
