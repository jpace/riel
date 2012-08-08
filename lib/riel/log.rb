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

require 'riel/log/loggable'
require 'riel/log/log'

module RIEL
  class AppLog < Log
    include Log::Severity
  end
end

include RIEL

if __FILE__ == $0
  Log.verbose = true
  Log.set_widths 15, -5, -35
  #Log.outfile = "/tmp/log." + $$.to_s

  class Demo
    include Loggable
    
    def initialize
      # log "hello"
      Log.set_color Log::DEBUG, "cyan"
      Log.set_color Log::INFO,  "bold cyan"
      Log.set_color Log::WARN,  "reverse"
      Log.set_color Log::ERROR, "bold red"
      Log.set_color Log::FATAL, "bold white on red"
    end

    def meth
      # log

      i = 4
      # info { "i: #{i}" }

      i /= 3
      debug { "i: #{i}" }

      i **= 3
      info "i: #{i}"

      i **= 2
      warn "i: #{i}"

      i <<= 4
      error "i: #{i}"

      i <<= 1
      fatal "i: #{i}"
    end
  end

  class Another
    include Loggable
    
    def Another.cmeth
      # /// "Log" only in instance methods
      # log "I'm sorry, Dave, I'm afraid I can't do that."

      # But this is legal.
      Log.log "happy, happy, joy, joy"
    end
  end
  
  demo = Demo.new
  demo.meth

  # Log.colorize_line = true

  # demo.meth
  # Another.cmeth

  # Log.info "we are done."
end
