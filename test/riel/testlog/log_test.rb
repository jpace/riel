#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'
require 'test/unit'
require 'stringio'
require 'riel/log'

class LogTestCase < Test::Unit::TestCase
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
    
    run_test @nonverbose_setup, log
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

    methname = if RUBY_VERSION == "1.8.7" then "test_output_arg" else "block in test_output_arg" end

    expected = Array.new
    (0 .. 5).each do |lnum|
      expected << sprintf("[   ...testlog/log_test.rb:  %2d] {%-20s} hello, world?", 30 + lnum, methname[0 .. 19])
    end
    expected << "[   ...testlog/log_test.rb: 179] {call                } "
    expected << "[   ...testlog/log_test.rb: 179] {run_test            } "
    expected << "[   ...testlog/log_test.rb:  48] {test_output_arg     } "
    
    run_test @verbose_setup, log, *expected
  end

  def test_output_block
    log = Proc.new { 
      Log.log { "output block" }
    }
    
    Log.set_default_widths
    # run_test @verbose_setup, log, "[ ...test/riel/log_test.rb:  73] {test_output_block   } output block"

    info_setup = Proc.new {
      Log.level = Log::INFO
      Log.output  = StringIO.new
    }

    evaluated = false
    log = Proc.new { 
      Log.debug { evaluated = true; "hello, world?" }
    }
    
    # run_test info_setup, log
    
    assert_equal false, evaluated
  end

  def test_instance_log
    log = Proc.new { 
      log "hello, world?"
    }
    
    Log.set_widths(-15, 4, -40)
    # the class name is different in 1.8 and 1.9, so we won't test it.
    # run_test(@verbose_setup, log, "[ ...log_test.rb:  96] {LogTestCase#test_instance_log           } hello, world?")
    run_test @verbose_setup, log, nil

    Log.set_default_widths
  end

  def test_colors
    log = Proc.new { 
      white "white wedding"
      blue "blue iris"
      on_cyan "red"
    }

    # test_col has become 'block in test colors' in 1.9
    # run_test(@verbose_setup, log,
    #          "[ ...test/riel/log_test.rb: 107] {LogTestCase#test_col} \e[37mwhite wedding\e[0m",
    #          "[ ...test/riel/log_test.rb: 108] {LogTestCase#test_col} \e[34mblue iris\e[0m",
    #          "[ ...test/riel/log_test.rb: 109] {LogTestCase#test_col} \e[46mred\e[0m")

    Log.set_default_widths
  end

  def test_format
    log = Proc.new { 
      Log.log "format"
    }
    
    Log.set_default_widths
    # run_test(@verbose_setup, log, "[ ...test/riel/log_test.rb: 122] {test_format         } format")

    # Log.set_widths(file_width, line_width, func_width)
    
    #run_format_test(log, -25,    8, 30, "[ ...test/riel/log_test.rb:     122] {                   test_format} format")
    #run_format_test(log,  25,    8, 30, "[ ...test/riel/log_test.rb:     122] {                   test_format} format")
    #run_format_test(log,  25, "08", 30, "[ ...test/riel/log_test.rb:00000122] {                   test_format} format")
    
    # useless feature of truncating line numbers, but so it goes ...
    # run_format_test(log,   4,   2, -10, "[ ...:12] {test_forma} format")
    
    Log.set_default_widths
  end

  def test_color
    log = Proc.new { 
      Log.blue "format"
    }
    
    Log.set_default_widths
    expmeth = if RUBY_VERSION == "1.8.7" then "test_color" else "block in test_color" end
    expmsg = sprintf "[   ...testlog/log_test.rb: 125] {%-20s} \e[34mformat\e[0m", expmeth
    exec_test @verbose_setup, log, [ expmsg ]
  end

  def run_format_test log, file_width, line_width, func_width, expected
    Log.set_widths file_width, line_width, func_width
    run_test @verbose_setup, log, expected
  end    

  # the ctor is down here so the lines above are less likely to change.
  def initialize test, name = nil
    @nonverbose_setup = Proc.new {
      Log.verbose = false
      Log.output  = StringIO.new
    }
    
    @verbose_setup = Proc.new {
      Log.verbose = true
      Log.output  = StringIO.new
    }

    super test
  end

  def exec_test setup, log, expected = Array.new
    io = setup.call

    log.call

    assert_not_nil io
    str = io.string
    assert_not_nil str

    lines = str.split "\n"

    unless expected.empty?
      (0 ... expected.size).each do |idx|
        if expected[idx]
          assert_equal expected[idx], lines[idx], "index: #{idx}"
        end
      end
    end

    Log.output = io
  end

  def run_test setup, log, *expected
    io = setup.call

    log.call

    assert_not_nil io
    str = io.string
    assert_not_nil str

    lines = str.split "\n"

    (0 ... expected.size).each do |idx|
      if expected[idx]
        assert_equal expected[idx], lines[idx], "index: #{idx}"
      end
    end

    Log.output = io
  end
end
