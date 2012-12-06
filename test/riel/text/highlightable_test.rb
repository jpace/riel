#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/text/ansi/ansi_highlight'
require 'riel/text/string'

class HighlightableTestCase < Test::Unit::TestCase
  def test_string_add_to
    Text::Highlightable.add_to String
    assert_equal "\e[34mfoo\e[0m", "foo".blue
  end

  class String
    include Text::Highlightable
  end

  def test_string_include
    assert_equal "\e[34mfoo\e[0m", "foo".blue
  end

  def test_string_respond_to
    str = ""
    assert str.respond_to? :blue
    assert !str.respond_to?(:azure)
  end
end
