#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/timer'
require 'stringio'

class TimerTestCase < RUNIT::TestCase

  TIMER_STRING = "sleep for a second"

  def do_assertions(io)
    assert_not_nil io
    str = io.string
    assert_not_nil str

    assert str.index(TIMER_STRING + " start time:")
    assert str.index(TIMER_STRING + " end   time:")
    assert str.index(TIMER_STRING + " elapsed   :")
  end

  def test_to_stdout
    orig_out = $stdout
    $stdout  = StringIO.new
    timer = Timer.new(TIMER_STRING) do
      sleep(0.1)
    end

    do_assertions($stdout)
    
    $stdout  = orig_out
  end
  
  def test_to_io
    stringio = StringIO.new
    timer = Timer.new("sleep for a second", :io => stringio) do
      sleep(0.1)
    end

    do_assertions(stringio)
  end

end
