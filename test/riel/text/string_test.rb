#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/text/ansi_highlight'
require 'riel/text/string'

class StringTestCase < Test::Unit::TestCase
  def run_test str, input, *chars
    escape_sequence = chars.collect { |ch| "\e[#{ch}m" }.join("")
    assert_equal "#{escape_sequence}#{str}\e[0m", input
  end
  
  def test_all_ansi
    String.highlighter = "ANSI"

    str = "precision"

    run_test str, str.none,           0
    run_test str, str.bold,           1
    run_test str, str.underline,      4
    run_test str, str.underscore,     4
    run_test str, str.blink,          5 # every geocities site circa 1998
    run_test str, str.negative,       7
    run_test str, str.concealed,      8
    run_test str, str.black,         30
    run_test str, str.red,           31
    run_test str, str.green,         32
    run_test str, str.yellow,        33
    run_test str, str.blue,          34
    run_test str, str.magenta,       35
    run_test str, str.cyan,          36
    run_test str, str.white,         37
    run_test str, str.on_black,      40
    run_test str, str.on_red,        41
    run_test str, str.on_green,      42
    run_test str, str.on_yellow,     43
    run_test str, str.on_blue,       44
    run_test str, str.on_magenta,    45
    run_test str, str.on_cyan,       46
    run_test str, str.on_white,      47
    run_test str, str.none_on_white,  0, 47
    run_test str, str.none_on_black,  0, 40
    run_test str, str.none_on_blue,   0, 44
    run_test str, str.red_on_white,  31, 47
    run_test str, str.bold_red_on_white,  1, 31, 47
  end
end
