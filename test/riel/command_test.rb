#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/command'

class CommandTestCase < Test::Unit::TestCase
  def test_all
    assert_equal [ "/bin/ls\n" ], Command.run("ls", "/bin/ls")
    assert_equal [ "/bin/grep\n", "/bin/ls\n" ], Command.run("ls", "/bin/ls", "/bin/grep" )

    lnum = 0
    expected = [ "/bin/grep\n", "/bin/ls\n" ]
    lines = Command.run("ls", "/bin/ls", "/bin/grep" ) do |line|
      assert_equal expected[lnum], line
      lnum += 1
    end
    assert_equal expected, lines

    expected = [ "/bin/grep\n", "/bin/ls\n" ]
    lines = Command.run("ls", "/bin/ls", "/bin/grep" ) do |line, ln|
      assert_equal expected[ln], line
    end
    assert_equal expected, lines
  end
end
