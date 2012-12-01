#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/command'

class CommandTestCase < Test::Unit::TestCase
  def run_command_test expected, *args
    assert_equal expected, Command.run(*args)
  end

  def test_one_returned
    run_command_test [ "/bin/ls\n" ], "ls", "/bin/ls"
  end

  def test_two_returned
    run_command_test [ "/bin/grep\n", "/bin/ls\n" ], "ls", "/bin/ls", "/bin/grep"
  end

  def test_with_line_numbers
    expected = [ "/bin/grep\n", "/bin/ls\n" ]
    lines = Command.run("ls", "/bin/ls", "/bin/grep" ) do |line, ln|
      assert_equal expected[ln], line
    end
    assert_equal expected, lines
  end
end
