#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/regexp'
require 'paramesan'

class Riel::RegexpFactoryTestCase < Test::Unit::TestCase
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

  param_test [
    [ Regexp.new("a"), "a", Hash.new ],
  ].each do |exp, pat, args|
    assert_equal exp, Riel::RegexpFactory.new.create(pat, args), "pat: #{pat}; args: #{args}"
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
