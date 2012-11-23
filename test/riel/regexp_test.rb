#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/regexp'

class RegexpTestCase < Test::Unit::TestCase
  def test_unixre_to_string
    assert_equal "a[b-z]",    Regexp.unixre_to_string("a[b-z]")
    assert_equal "ab\\.z",    Regexp.unixre_to_string("ab.z")
    assert_equal "ab\\.z.*",  Regexp.unixre_to_string("ab.z*")
    assert_equal "a.c",       Regexp.unixre_to_string("a?c")
    assert_equal "ab\\$",     Regexp.unixre_to_string("ab$")
    assert_equal "a\\/c",     Regexp.unixre_to_string("a/c")
    assert_equal "a\\(bc\\)", Regexp.unixre_to_string("a(bc)")
  end
  
  def test_negated
    assert NegatedRegexp.new("a[b-z]").match("aa")
    assert NegatedRegexp.new(".+").match("")
  end
end
