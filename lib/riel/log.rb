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
