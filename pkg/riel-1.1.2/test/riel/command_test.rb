#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/command'

class CommandTestCase < RUNIT::TestCase

  def test_all
    assert_equal [ "/bin/ls\n" ], Command.run("ls", "/bin/ls")
    assert_equal [ "/bin/grep\n", "/bin/ls\n" ], Command.run("ls", "/bin/ls", "/bin/grep" )

    lnum = 0
    expected = [ "/bin/grep\n", "/bin/ls\n" ]
    lines = Command.run("ls", "/bin/ls", "/bin/grep" ) do |line|
      assert_equals(expected[lnum], line)
      lnum += 1
    end
    assert_equal expected, lines

    expected = [ "/bin/grep\n", "/bin/ls\n" ]
    lines = Command.run("ls", "/bin/ls", "/bin/grep" ) do |line, lnum|
      assert_equals(expected[lnum], line)
    end
    assert_equal expected, lines
  end
    
end
