#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/text'

class TextTestCase < Test::Unit::TestCase
  def run_ansi_test str, input, *chars
    escape_sequence = chars.collect { |ch| "\e[#{ch}m" }.join("")
    assert_equal "#{escape_sequence}#{str}\e[0m", input
  end
  
  def test_ansi_highlight
    String.highlighter = "ANSI"

    str = "precision"

    run_ansi_test str, str.none,           0
    run_ansi_test str, str.bold,           1
    run_ansi_test str, str.underline,      4
    run_ansi_test str, str.underscore,     4
    run_ansi_test str, str.blink,          5 # every geocities site circa 1998
    run_ansi_test str, str.negative,       7
    run_ansi_test str, str.concealed,      8
    run_ansi_test str, str.black,         30
    run_ansi_test str, str.red,           31
    run_ansi_test str, str.green,         32
    run_ansi_test str, str.yellow,        33
    run_ansi_test str, str.blue,          34
    run_ansi_test str, str.magenta,       35
    run_ansi_test str, str.cyan,          36
    run_ansi_test str, str.white,         37
    run_ansi_test str, str.on_black,      40
    run_ansi_test str, str.on_red,        41
    run_ansi_test str, str.on_green,      42
    run_ansi_test str, str.on_yellow,     43
    run_ansi_test str, str.on_blue,       44
    run_ansi_test str, str.on_magenta,    45
    run_ansi_test str, str.on_cyan,       46
    run_ansi_test str, str.on_white,      47
    run_ansi_test str, str.none_on_white,  0, 47
    run_ansi_test str, str.none_on_black,  0, 40
    run_ansi_test str, str.none_on_blue,   0, 44
    run_ansi_test str, str.red_on_white,  31, 47
    run_ansi_test str, str.bold_red_on_white,  1, 31, 47
  end

  def run_html_test expected, input
    assert_equal expected, input
  end
  
  def test_html_highlight
    String.highlighter = "HTML"

    str = "precision"

    run_html_test str, str.none
    run_html_test "<b>" + str + "</b>", str.bold

    [ str.underline, str.underscore ].each do |input|
      run_html_test "<u>" + str + "</u>", input
    end

    run_html_test "<blink>" + str + "</blink>", str.blink
    run_html_test "<span style=\"color: white; background-color: black\">" + str + "</span>", str.negative
    run_html_test "<!-- " + str + " -->", str.concealed
    run_html_test "<span style=\"color: black\">" + str + "</span>", str.black
    run_html_test "<span style=\"color: red\">" + str + "</span>", str.red
    run_html_test "<span style=\"color: green\">" + str + "</span>", str.green
    run_html_test "<span style=\"color: yellow\">" + str + "</span>", str.yellow
    run_html_test "<span style=\"color: blue\">" + str + "</span>", str.blue
    run_html_test "<span style=\"color: #FF00FF\">" + str + "</span>", str.magenta
    run_html_test "<span style=\"color: #00FFFF\">" + str + "</span>", str.cyan
    run_html_test "<span style=\"color: white\">" + str + "</span>", str.white
    run_html_test "<span style=\"background-color: black\">" + str + "</span>", str.on_black
    run_html_test "<span style=\"background-color: red\">" + str + "</span>", str.on_red
    run_html_test "<span style=\"background-color: green\">" + str + "</span>", str.on_green
    run_html_test "<span style=\"background-color: yellow\">" + str + "</span>", str.on_yellow
    run_html_test "<span style=\"background-color: blue\">" + str + "</span>", str.on_blue
    run_html_test "<span style=\"background-color: #FF00FF\">" + str + "</span>", str.on_magenta
    run_html_test "<span style=\"background-color: #00FFFF\">" + str + "</span>", str.on_cyan
    run_html_test "<span style=\"background-color: white\">" + str + "</span>", str.on_white
    run_html_test "<span style=\"background-color: white\">" + str + "</span>", str.none_on_white
    run_html_test "<span style=\"background-color: black\">" + str + "</span>", str.none_on_black
    run_html_test "<span style=\"background-color: blue\">" + str + "</span>", str.none_on_blue
    run_html_test "<span style=\"color: red\">" + "<span style=\"background-color: white\">" + str + "</span>" + "</span>", str.red_on_white
    run_html_test "<b><span style=\"color: red\">" + "<span style=\"background-color: white\">" + str + "</span>" + "</span></b>", str.bold_red_on_white
  end
  
  def test_string_reverse
    String.highlighter = "HTML"

    str = "precision"

    # this tests that string.reverse does not mean ANSI reverse
    assert_equal "noisicerp", str.reverse
  end
end
