#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/text/ansi/ansi_highlight'
require 'riel/text/string'

class HighlightableTestCase < Test::Unit::TestCase
  def test_string_addto
    Text::Highlightable.add_to String
    assert_equal "\e[34mfoo\e[0m", "foo".blue
  end

  class String
    include Text::Highlightable
  end

  def test_string_include
    assert_equal "\e[34mfoo\e[0m", "foo".blue
  end
end
