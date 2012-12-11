#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/text'

class TextTestCase < Test::Unit::TestCase
  def run_html_test expected, input
    assert_equal expected, input
  end
  
  def xxx_disabled_test_html_highlight
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
  
  def xxx_disabled_test_string_reverse
    String.highlighter = "HTML"

    str = "precision"

    # string.reverse does not mean ANSI reverse:
    assert_equal "noisicerp", str.reverse
  end

  def test_nothing
    
  end
end
