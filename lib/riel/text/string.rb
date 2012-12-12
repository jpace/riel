#!/usr/bin/ruby -w
# -*- ruby -*-

# String can be extended to support highlighting.
class String
  def self.highlight
    require 'riel/text/highlightable'
    Text::Highlightable.add_to String
  end
end
