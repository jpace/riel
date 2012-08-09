#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'
require 'rubyunit'
require 'stringio'
require 'riel/log'

class LogTestCase < RUNIT::TestCase
  include Loggable

  def test_no_output
    # I could make this an instance variable, but I want to check the method
    # names in the output string.

    log = Proc.new { 
      Log.log   "hello, world?"
      Log.debug "hello, world?"
      Log.info  "hello, world?"
      Log.warn  "EXPECTED OUTPUT TO STDERR: hello, world." # will go to stderr
      Log.error "EXPECTED OUTPUT TO STDERR: hello, world." # will go to stderr
      Log.stack "hello, world?"
    }
    
    run_test(@nonverbose_setup, log)
  end

  def test_output_arg
    log = Proc.new { 
      Log.log   "hello, world?"
      Log.debug "hello, world?"
      Log.info  "hello, world?"
      Log.warn  "hello, world?"
      Log.error "hello, world?"
      Log.stack "hello, world?"
    }

    expected_output = [
      "[ ...test/riel/log_test.rb:  30] {test_output_arg     } hello, world?",
      "[ ...test/riel/log_test.rb:  31] {test_output_arg     } hello, world?",
      "[ ...test/riel/log_test.rb:  32] {test_output_arg     } hello, world?",
      "[ ...test/riel/log_test.rb:  33] {test_output_arg     } hello, world?",
      "[ ...test/riel/log_test.rb:  34] {test_output_arg     } hello, world?",
      "[ ...test/riel/log_test.rb:  35] {test_output_arg     } hello, world?",
      "[ ...test/riel/log_test.rb: 163] {call                } ",
      "[ ...test/riel/log_test.rb: 163] {run_test            } ",
      "[ ...test/riel/log_test.rb:  68] {test_output_arg     } ",
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
    ]

    run_test @verbose_setup, log, *expected_output
  end

  def test_output_block
    log = Proc.new { 
      Log.log { "output block" }
    }
    
    Log.set_default_widths
    run_test(@verbose_setup, log, "[ ...test/riel/log_test.rb:  73] {test_output_block   } output block")

    info_setup = Proc.new {
      Log.level = Log::INFO
      Log.output  = StringIO.new
    }

    evaluated = false
    log = Proc.new { 
      Log.debug { evaluated = true; "hello, world?" }
    }
    
    run_test(info_setup, log)
    
    assert_equals false, evaluated
  end

  def test_instance_log
    log = Proc.new { 
      log "hello, world?"
    }
    
    Log.set_widths(-15, 4, -40)
    run_test(@verbose_setup, log, "[ ...log_test.rb:  96] {LogTestCase#test_instance_log           } hello, world?")

    Log.set_default_widths
  end

  def test_colors
    log = Proc.new { 
      white "white wedding"
      blue "blue iris"
      on_cyan "red"
    }
    
    run_test(@verbose_setup, log,
             "[ ...test/riel/log_test.rb: 107] {LogTestCase#test_col} \e[37mwhite wedding\e[0m",
             "[ ...test/riel/log_test.rb: 108] {LogTestCase#test_col} \e[34mblue iris\e[0m",
             "[ ...test/riel/log_test.rb: 109] {LogTestCase#test_col} \e[46mred\e[0m")

    Log.set_default_widths
  end

  def test_format
    log = Proc.new { 
      Log.log "format"
    }
    
    Log.set_default_widths
    run_test(@verbose_setup, log, "[ ...test/riel/log_test.rb: 122] {test_format         } format")

    # Log.set_widths(file_width, line_width, func_width)
    
    run_format_test(log, -25,    8, 30, "[ ...test/riel/log_test.rb:     122] {                   test_format} format")
    run_format_test(log,  25,    8, 30, "[ ...test/riel/log_test.rb:     122] {                   test_format} format")
    run_format_test(log,  25, "08", 30, "[ ...test/riel/log_test.rb:00000122] {                   test_format} format")
    
    # useless feature of truncating line numbers, but so it goes ...
    run_format_test(log,   4,   2, -10, "[ ...:12] {test_forma} format")
    
    Log.set_default_widths
  end

  def run_format_test log, file_width, line_width, func_width, expected
    Log.set_widths file_width, line_width, func_width
    run_test @verbose_setup, log, expected
  end    

  # the ctor is down here so the lines above are less likely to change.
  def initialize test, name
    @nonverbose_setup = Proc.new {
      Log.verbose = false
      Log.output  = StringIO.new
    }
    
    @verbose_setup = Proc.new {
      Log.verbose = true
      Log.output  = StringIO.new
    }

    super
  end

  def run_test setup, log, *expected
    io = setup.call

    log.call

    assert_not_nil io
    str = io.string
    assert_not_nil str

    lines = str.split "\n"

    assert_equals expected.size, lines.size, "number of lines of output"

    (0 ... expected.size).each do |idx|
      if expected[idx]
        assert_equals expected[idx], lines[idx], "index: #{idx}"
      end
    end

    Log.output = io
  end

end
