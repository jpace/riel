#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/timer'
require 'stringio'

class TimerTestCase < Test::Unit::TestCase
  TIMER_STRING = "sleep for a second"

  def run_assertions io
    assert_not_nil io
    str = io.string
    assert_not_nil str

    assert str.index(TIMER_STRING + " start time:")
    assert str.index(TIMER_STRING + " end   time:")
    assert str.index(TIMER_STRING + " elapsed   :")
  end

  def test_to_stdout
    orig_out = $stdout
    $stdout = StringIO.new
    Timer.new(TIMER_STRING) do
      sleep 0.1
    end

    run_assertions $stdout
    
    $stdout  = orig_out
  end
  
  def test_to_io
    stringio = StringIO.new
    Timer.new("sleep for a second", :io => stringio) do
      sleep 0.1
    end

    run_assertions stringio
  end
end
