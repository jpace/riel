#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/regexp'
require 'paramesan'

class RegexpTestCase < Test::Unit::TestCase
  include Paramesan
  
  def test_negated
    assert NegatedRegexp.new("a[b-z]").match("aa")
    assert NegatedRegexp.new(".+").match("")
  end
  
  def test_invalid_whole_word
    assert_raises(RuntimeError) do
      Regexp.create ':abc', wholewords: true
    end
  end
end
