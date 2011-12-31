#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/text'

class TextTestCase < RUNIT::TestCase

  def do_ansi_test(str, input, *chars)
    escape_sequence = chars.collect { |ch| "\e[#{ch}m" }.join("")
    assert_equals "#{escape_sequence}#{str}\e[0m", input
  end
  
  def test_ansi_highlight
    String.highlighter = "ANSI"

    str = "precision"

    do_ansi_test(str, str.none,           0)
    do_ansi_test(str, str.bold,           1)
    do_ansi_test(str, str.underline,      4)
    do_ansi_test(str, str.underscore,     4)
    do_ansi_test(str, str.blink,          5) # every geocities site circa 1998
    do_ansi_test(str, str.negative,       7)
    do_ansi_test(str, str.concealed,      8)
    do_ansi_test(str, str.black,         30)
    do_ansi_test(str, str.red,           31)
    do_ansi_test(str, str.green,         32)
    do_ansi_test(str, str.yellow,        33)
    do_ansi_test(str, str.blue,          34)
    do_ansi_test(str, str.magenta,       35)
    do_ansi_test(str, str.cyan,          36)
    do_ansi_test(str, str.white,         37)
    do_ansi_test(str, str.on_black,      40)
    do_ansi_test(str, str.on_red,        41)
    do_ansi_test(str, str.on_green,      42)
    do_ansi_test(str, str.on_yellow,     43)
    do_ansi_test(str, str.on_blue,       44)
    do_ansi_test(str, str.on_magenta,    45)
    do_ansi_test(str, str.on_cyan,       46)
    do_ansi_test(str, str.on_white,      47)
    do_ansi_test(str, str.none_on_white,  0, 47)
    do_ansi_test(str, str.none_on_black,  0, 40)
    do_ansi_test(str, str.none_on_blue,   0, 44)
    do_ansi_test(str, str.red_on_white,  31, 47)
    do_ansi_test(str, str.bold_red_on_white,  1, 31, 47)

  end

  def do_html_test(expected, input)
    assert_equals expected, input
  end
  
  def test_html_highlight
    String.highlighter = "HTML"

    str = "precision"

    do_html_test(str, str.none)
    do_html_test("<b>" + str + "</b>", str.bold)

    [ str.underline, str.underscore ].each do |input|
      do_html_test("<u>" + str + "</u>", input)
    end

    do_html_test("<blink>" + str + "</blink>", str.blink)
    do_html_test("<span style=\"color: white; background-color: black\">" + str + "</span>", str.negative)
    do_html_test("<!-- " + str + " -->", str.concealed)
    do_html_test("<span style=\"color: black\">" + str + "</span>", str.black)
    do_html_test("<span style=\"color: red\">" + str + "</span>", str.red)
    do_html_test("<span style=\"color: green\">" + str + "</span>", str.green)
    do_html_test("<span style=\"color: yellow\">" + str + "</span>", str.yellow)
    do_html_test("<span style=\"color: blue\">" + str + "</span>", str.blue)
    do_html_test("<span style=\"color: #FF00FF\">" + str + "</span>", str.magenta)
    do_html_test("<span style=\"color: #00FFFF\">" + str + "</span>", str.cyan)
    do_html_test("<span style=\"color: white\">" + str + "</span>", str.white)
    do_html_test("<span style=\"background-color: black\">" + str + "</span>", str.on_black)
    do_html_test("<span style=\"background-color: red\">" + str + "</span>", str.on_red)
    do_html_test("<span style=\"background-color: green\">" + str + "</span>", str.on_green)
    do_html_test("<span style=\"background-color: yellow\">" + str + "</span>", str.on_yellow)
    do_html_test("<span style=\"background-color: blue\">" + str + "</span>", str.on_blue)
    do_html_test("<span style=\"background-color: #FF00FF\">" + str + "</span>", str.on_magenta)
    do_html_test("<span style=\"background-color: #00FFFF\">" + str + "</span>", str.on_cyan)
    do_html_test("<span style=\"background-color: white\">" + str + "</span>", str.on_white)
    do_html_test("<span style=\"background-color: white\">" + str + "</span>", str.none_on_white)
    do_html_test("<span style=\"background-color: black\">" + str + "</span>", str.none_on_black)
    do_html_test("<span style=\"background-color: blue\">" + str + "</span>", str.none_on_blue)
    do_html_test("<span style=\"color: red\">" + "<span style=\"background-color: white\">" + str + "</span>" + "</span>", str.red_on_white)
    do_html_test("<b><span style=\"color: red\">" + "<span style=\"background-color: white\">" + str + "</span>" + "</span></b>", str.bold_red_on_white)

  end
  
  def test_string_reverse
    String.highlighter = "HTML"

    str = "precision"

    # this tests that string.reverse does not mean ANSI reverse
    assert_equal("noisicerp", "precision".reverse)
  end

end
