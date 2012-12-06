#!/usr/bin/ruby -w
# -*- ruby -*-

class TermColor
  BOLD = "\e[1m"
  RESET = "\x1b[0m"

  # \e1 == \x1b
  
  def fg
    str 38
  end

  def bg
    str 48
  end

  def str num
    "\x1b[#{num};5;#{value}m"
  end

  def bold
    BOLD
  end
  
  def reset
    RESET
  end

  def print_fg
    write fg
  end

  def print_bg
    write bg
  end

  private
  def write fgbg
    print fgbg
    print to_s
    print reset
    print ' '
  end
end
