#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/pathname'

class PathnameTestCase < Test::Unit::TestCase
  def run_rootname_test exp, path
    pn = Pathname.new path
    assert_equal exp, pn.rootname
  end

  def test_rootname
    [
      "/this/is/a.test",
      "/a.test",
      "a.test",
      "/this/is/a",
      "/a",
      "a"
    ].each do |path|
      run_rootname_test "a", path
    end

    [
      "/this/is/.atest",
      "/.atest",
      ".atest"
    ].each do |path|
      run_rootname_test ".atest",  path
    end
  end
end
