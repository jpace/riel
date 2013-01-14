#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = log.rb
#
# Logging Module
#
# Author:: Jeff Pace <jpace@incava.org>
# Documentation:: Author
#

require 'riel/log/log'
require 'rubygems'
require 'rainbow'

#
# == Loggable
#
# Including this module in a class gives access to the logger methods.
# 
# == Examples
#
# See the unit tests in log_test.rb
#
# == Usage
#
#  class YourClass
#    include Loggable
#
#    def some_method(...)
#      log "my message"
# 
#  That will log from the given class and method, showing the line number from
#  which the logger was called.
#
#    def another_method(...)
#      stack "my message"
# 
#  That will produce a stack trace from the given location.
# 

module RIEL
  module Loggable
    # Logs the given message, including the class whence invoked.
    def log msg = "", lvl = Log::DEBUG, depth = 1, &blk
      Log.log msg, lvl, depth + 1, self.class.to_s, &blk
    end

    def debug msg = "", depth = 1, &blk
      Log.log msg, Log::DEBUG, depth + 1, self.class.to_s, &blk
    end

    def info msg = "", depth = 1, &blk
      Log.log msg, Log::INFO, depth + 1, self.class.to_s, &blk
    end

    def warn msg = "", depth = 1, &blk
      Log.log msg, Log::WARN, depth + 1, self.class.to_s, &blk
    end

    def error msg = "", depth = 1, &blk
      Log.log msg, Log::ERROR, depth + 1, self.class.to_s, &blk
    end

    def fatal msg = "", depth = 1, &blk
      Log.log msg, Log::FATAL, depth + 1, self.class.to_s, &blk
    end

    def stack msg = "", lvl = Log::DEBUG, depth = 1, &blk
      Log.stack msg, lvl, depth + 1, self.class.to_s, &blk
    end

    def write msg = "", depth = 1, &blk
      Log.write msg, depth + 1, self.class.to_s, &blk
    end

    def method_missing meth, *args, &blk
      validcolors = Sickill::Rainbow::TERM_COLORS
      # only handling foregrounds, not backgrounds
      if code = validcolors[meth]
        add_color_method meth.to_s, code + 30
        send meth, *args, &blk
      else
        super
      end
    end

    def respond_to? meth
      validcolors = Sickill::Rainbow::TERM_COLORS
      validcolors.include?(meth) || super
    end

    def add_color_method color, code
      meth = Array.new
      meth << "def #{color}(msg = \"\", lvl = Log::DEBUG, depth = 1, cname = nil, &blk)"
      meth << "  Log.#{color} msg, lvl, depth + 1, self.class.to_s, &blk"
      meth << "end"
      self.class.module_eval meth.join("\n")
    end
  end
end
