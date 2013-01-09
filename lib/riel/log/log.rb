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

require 'riel/log/logger'
require 'riel/log/severity'
require 'rubygems'
require 'rainbow'

#
# == Log
#
# Very minimal logging output. If verbose is set, this displays the method and
# line number whence called. It can be a mixin to a class, which displays the
# class and method from where it called. If not in a class, it displays only the
# method.
# 
# Remember: all kids love log.
#
# == Examples
#
# See the unit tests in log_test.rb
#
# == Usage
#
# The most general usage is simply to call:
#
#  Log.log "some message"
#
#  That will simply log the given message.
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
  class Log
    $LOGGING_LEVEL = nil
    
    include Log::Severity

    # by default, class methods delegate to a single app-wide log.

    @@log = Logger.new

    # Returns the logger of the log. A class method delegating to an instance
    # method ... not so good. But temporary.
    def self.logger
      @@log
    end

    def self.method_missing meth, *args, &blk
      validcolors = Sickill::Rainbow::TERM_COLORS
      # only handling foregrounds, not backgrounds
      if code = validcolors[meth]
        add_color_method meth.to_s, code + 30
        send meth, *args, &blk
      else
        super
      end
    end

    def self.respond_to? meth
      validcolors = Sickill::Rainbow::TERM_COLORS
      validcolors.include?(meth) || super
    end

    def self.add_color_method color, code
      instmeth = Array.new
      instmeth << "def #{color} msg = \"\", lvl = Log::DEBUG, depth = 1, cname = nil, &blk"
      instmeth << "  log(\"\\e[#{code}m\#{msg\}\\e[0m\", lvl, depth + 1, cname, &blk)"
      instmeth << "end"
      instance_eval instmeth.join("\n")

      clsmeth = Array.new
      clsmeth << "def #{color} msg = \"\", lvl = Log::DEBUG, depth = 1, cname = nil, &blk"
      clsmeth << "  logger.#{color}(\"\\e[#{code}m\#{msg\}\\e[0m\", lvl, depth + 1, cname, &blk)"
      clsmeth << "end"

      class_eval clsmeth.join("\n")
    end

    def self.set_default_widths
      logger.set_default_widths
    end

    def self.verbose
      logger.verbose
    end

    def self.verbose= v
      logger.verbose = v && v != 0 ? DEBUG : FATAL
    end

    def self.level= lvl
      logger.level = lvl
    end

    def self.quiet
      logger.quiet
    end

    def self.quiet= q
      logger.quiet = q
    end

    def self.format
      logger.format
    end

    def self.format= fmt
      logger.format = fmt
    end

    # Assigns output to the given stream.
    def self.output= io
      logger.output = io
    end

    def self.output
      logger.output
    end

    # sets whether to colorize the entire line, or just the message.
    def self.colorize_line= col
      logger.colorize_line = col
    end

    def self.colorize_line
      logger.colorize_line
    end

    # Assigns output to a file with the given name. Returns the file; client
    # is responsible for closing it.
    def self.outfile= fname
      logger.outfile = fname
    end

    def self.outfile
      logger.outfile
    end

    # Creates a printf format for the given widths, for aligning output.
    def self.set_widths file_width, line_width, func_width
      logger.set_widths file_width, line_width, func_width
    end

    def self.ignore_file fname
      logger.ignore_file fname
    end
    
    def self.ignore_method methname
      logger.ignored_method methname
    end
    
    def self.ignore_class classname
      logger.ignored_class classname
    end

    def self.log_file fname
      logger.log_file fname
    end
    
    def self.log_method methname
      logger.log_method methname
    end
    
    def self.log_class classname
      logger.log_class classname
    end

    def self.debug msg = "", depth = 1, &blk
      logger.log msg, DEBUG, depth + 1, &blk
    end

    def self.info msg = "", depth = 1, &blk
      logger.log msg, INFO, depth + 1, &blk
    end

    def self.fatal msg = "", depth = 1, &blk
      logger.log msg, FATAL, depth + 1, &blk
    end

    def self.log msg = "", lvl = DEBUG, depth = 1, cname = nil, &blk
      logger.log msg, lvl, depth + 1, cname, &blk
    end

    def self.stack msg = "", lvl = DEBUG, depth = 1, cname = nil, &blk
      logger.stack msg, lvl, depth + 1, cname, &blk
    end

    def self.warn msg = "", depth = 1, &blk
      if verbose
        logger.log msg, WARN, depth + 1, &blk
      else
        $stderr.puts "WARNING: " + msg
      end
    end

    def self.error msg = "", depth = 1, &blk
      if verbose
        logger.log msg, ERROR, depth + 1, &blk
      else
        $stderr.puts "ERROR: " + msg
      end
    end

    def self.write msg, depth = 1, cname = nil, &blk
      if verbose
        stack msg, Log::WARN, depth + 1, cname, &blk
      elsif quiet
        # nothing
      else
        $stderr.puts msg
      end
    end

    def self.set_color lvl, color
      logger.set_color lvl, color
    end
  end
end
