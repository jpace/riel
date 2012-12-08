#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/text/ansi/ansi_highlight'
require 'riel/text/string'

class AnsiHighlightTestCase < Test::Unit::TestCase
  def run_ansi_test str, input, *chars
    escape_sequence = chars.collect { |ch| "\e[#{ch}m" }.join("")
    assert_equal "#{escape_sequence}#{str}\e[0m", input
  end
  
  def test_ansi_highlight
    str = "precision"

    run_ansi_test str, str.none,        0
    run_ansi_test str, str.bold,        1
    run_ansi_test str, str.underline,   4
    run_ansi_test str, str.underscore,  4
    run_ansi_test str, str.blink,       5 # every geocities site circa 1998
    run_ansi_test str, str.negative,    7
    run_ansi_test str, str.concealed,   8

    run_ansi_test str, str.black,      30
    run_ansi_test str, str.red,        31
    run_ansi_test str, str.green,      32
    run_ansi_test str, str.yellow,     33
    run_ansi_test str, str.blue,       34
    run_ansi_test str, str.magenta,    35
    run_ansi_test str, str.cyan,       36
    run_ansi_test str, str.white,      37

    run_ansi_test str, str.on_black,   40
    run_ansi_test str, str.on_red,     41
    run_ansi_test str, str.on_green,   42
    run_ansi_test str, str.on_yellow,  43
    run_ansi_test str, str.on_blue,    44
    run_ansi_test str, str.on_magenta, 45
    run_ansi_test str, str.on_cyan,    46
    run_ansi_test str, str.on_white,   47

    run_ansi_test str, str.none_on_white,  0, 47
    run_ansi_test str, str.none_on_black,  0, 40
    run_ansi_test str, str.none_on_blue,   0, 44
    run_ansi_test str, str.red_on_white,  31, 47
    run_ansi_test str, str.bold_red_on_white,  1, 31, 47
  end

  def test_highlighter
    hl = Text::ANSIHighlighter.instance
    assert_equal "\e[1m", hl.code('bold')
  end

  def test_gsub
    hl = Text::ANSIHighlighter.instance
    assert_equal "...\e[34mthis\e[0m... is blue",       hl.gsub("...this... is blue", %r{this}, "blue")
    assert_equal "...\e[34m\e[42mthis\e[0m... is blue", hl.gsub("...this... is blue", %r{this}, "blue on green")
  end

  def test_rgb
    Text::Highlightable.add_to String
    str = "123".rgb(1, 2, 3)
    assert_equal "\x1b[38;5;67m123\e[0m", str
  end

  def test_on_rgb
    Text::Highlightable.add_to String
    str = "123".on_rgb(1, 2, 3)
    assert_equal "\x1b[48;5;67m123\e[0m", str
  end

  def test_multiple
    Text::Highlightable.add_to String
    str = "ABC".bold.blue.on_green
    assert_equal "\e[42m\e[34m\e[1mABC\e[0m\e[0m\e[0m", str
  end

  def test_multiple_add_to
    Text::Highlightable.add_to String
    Text::Highlightable.add_to Integer
    str = "ABC".blue
    int = 123.red
    # puts str + int.to_s
    assert_equal "\e[34mABC\e[0m\e[31m123\e[0m", str + int
  end

  def test_rgb_fg_alias
    Text::Highlightable.add_to String
    hl = Text::ANSIHighlighter.instance 
    hl.add_alias :teal, 1, 4, 4
    
    str = "ABC".teal
    # puts str
    assert_equal "\x1b[38;5;80mABC\e[0m", str
  end

  def test_rgb_bg_alias
    Text::Highlightable.add_to String
    hl = Text::ANSIHighlighter.instance 
    hl.add_alias :on_maroon, 1, 0, 2
    
    str = "ABC".on_maroon
    # puts str
    assert_equal "\x1b[48;5;54mABC\e[0m", str
  end
end
