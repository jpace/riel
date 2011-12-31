#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/pathname'


class PathnameTestCase < RUNIT::TestCase

  def do_rootname_test(exp, path)
    pn = Pathname.new(path)
    assert_equals(exp, pn.rootname)
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
      do_rootname_test("a", path)
    end

    [
      "/this/is/.atest",
      "/.atest",
      ".atest"
    ].each do |path|
      do_rootname_test(".atest",  path)
    end
  end

end
