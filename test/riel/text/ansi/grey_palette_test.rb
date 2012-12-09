#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/grey_palette'
require 'riel/text/ansi/palette_tc'

module Text
  class GreyPaletteTest < PaletteTest
    def cls
      GreyPalette
    end

    def test_foregrounds
      expected = [
                  "grey foreground colors\n",
                  "[38;5;232m232[0m [38;5;233m233[0m [38;5;234m234[0m [38;5;235m235[0m [38;5;236m236[0m [38;5;237m237[0m \n",
                  "[38;5;238m238[0m [38;5;239m239[0m [38;5;240m240[0m [38;5;241m241[0m [38;5;242m242[0m [38;5;243m243[0m \n",
                  "[38;5;244m244[0m [38;5;245m245[0m [38;5;246m246[0m [38;5;247m247[0m [38;5;248m248[0m [38;5;249m249[0m \n",
                  "[38;5;250m250[0m [38;5;251m251[0m [38;5;252m252[0m [38;5;253m253[0m [38;5;254m254[0m [38;5;255m255[0m \n",
                  "\n",
                 ]

      assert_print expected, :print_foregrounds
    end

    def test_backgrounds
      expected = [
                  "grey background colors\n",
                  "[48;5;232m232[0m [48;5;233m233[0m [48;5;234m234[0m [48;5;235m235[0m [48;5;236m236[0m [48;5;237m237[0m \n",
                  "[48;5;238m238[0m [48;5;239m239[0m [48;5;240m240[0m [48;5;241m241[0m [48;5;242m242[0m [48;5;243m243[0m \n",
                  "[48;5;244m244[0m [48;5;245m245[0m [48;5;246m246[0m [48;5;247m247[0m [48;5;248m248[0m [48;5;249m249[0m \n",
                  "[48;5;250m250[0m [48;5;251m251[0m [48;5;252m252[0m [48;5;253m253[0m [48;5;254m254[0m [48;5;255m255[0m \n",
                  "\n",
                 ]

      assert_print expected, :print_backgrounds
    end
  end
end
