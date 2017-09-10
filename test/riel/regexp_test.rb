#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/regexp'
require 'paramesan'

class Riel::RegexTestCase < Test::Unit::TestCase
  include Paramesan
  
  param_test [
    [ "a\\z",     "a\\z"  ],
    [ "a\\.z",    "a.z"  ],
    [ "a\\.\\.z", "a..z" ],
    [ "a\\.z.*",  "a.z*" ],
    [ "a.z",      "a?z"  ],
    [ "a\\$",     "a$"   ],
    [ "a\\/z",    "a/z"  ],
    [ "a\\(z\\)", "a(z)" ],
  ].each do |exp, pat|
    assert_equal exp, Riel::RegexpFactory.new.from_shell_pattern(pat), "pat: #{pat}"
  end
end

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
