#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'
require 'riel/string'


class Pathname

  # a compliment to the +dirname+, +basename+, and +extname+ family, this returns
  # the basename without the extension, e.g. "foo" from "/usr/share/lib/foo.bar".
  def rootname
    basename.to_s - extname.to_s
  end

end
