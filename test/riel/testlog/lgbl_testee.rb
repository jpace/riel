#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'riel/log/loggable'

class LgblTestee
  include RIEL::Loggable

  def crystal
    info "hello!"
    blue "azul ... "
    red "rojo?"
  end
end
