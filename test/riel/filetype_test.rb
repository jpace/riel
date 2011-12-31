#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/filetype'


class FileTypeTestCase < RUNIT::TestCase

  def test_default_extensions
    ft = FileType.instance

    assert(ft.text_extensions.include?("rb"))

    assert(!ft.text_extensions.include?("rbx"))
    assert(!ft.text_extensions.include?("tar"))
    assert(!ft.text_extensions.include?("jar"))
    assert(!ft.text_extensions.include?("gz"))

    assert(ft.nontext_extensions.include?("tar"))
    assert(ft.nontext_extensions.include?("jar"))
    assert(ft.nontext_extensions.include?("gz"))

    ft.set_extensions(true, "rbx")
    assert(ft.text_extensions.include?("rbx"))

    ft.set_extensions(true, "foo", "bar")
    assert(ft.text_extensions.include?("foo"))
    assert(ft.text_extensions.include?("bar"))
  end

end
