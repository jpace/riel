#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/size_converter'

class SizeConverterTestCase < RUNIT::TestCase

  SIZES = [
    # 0123456789012345 0123456789012345 0123456789012345 0123456789012345 0123456789012345 0123456789012345 0123456789012345 
    # base10.0         base10.1         base10.2         si.0             si.1             si.2             num              ]
    [ "1",             "1.0",           "1.00",          "1",             "1.0",           "1.00",          1                ],

    [ "1K",            "1.0K",          "1.02K",         "1KiB",          "1.0KiB",        "1.00KiB",       1024             ],
    [ "1K",            "1.0K",          "1.00K",         "1000",          "1000.0",        "1000.00",       1000             ],
    [ "2K",            "2.0K",          "2.05K",         "2KiB",          "2.0KiB",        "2.00KiB",       2048             ],
    [ "2K",            "2.0K",          "2.00K",         "2KiB",          "2.0KiB",        "1.95KiB",       2000             ],

    [ "1M",            "1.0M",          "1.00M",         "977KiB",        "976.6KiB",      "976.56KiB",     10 ** 6          ],
    [ "2M",            "2.0M",          "2.00M",         "2MiB",          "1.9MiB",        "1.91MiB",       2 * 10 ** 6      ],
    [ "1M",            "1.0M",          "1.05M",         "1MiB",          "1.0MiB",        "1.00MiB",       2 ** 20          ],
    [ "2M",            "2.1M",          "2.10M",         "2MiB",          "2.0MiB",        "2.00MiB",       2 * 2 ** 20      ],

    [ "1G",            "1.0G",          "1.00G",         "954MiB",        "953.7MiB",      "953.67MiB",     10 ** 9          ],
    [ "2G",            "2.0G",          "2.00G",         "2GiB",          "1.9GiB",        "1.86GiB",       2 * 10 ** 9      ],

    [ "1G",            "1.1G",          "1.07G",         "1GiB",          "1.0GiB",        "1.00GiB",       2 ** 30          ],
    [ "2G",            "2.1G",          "2.15G",         "2GiB",          "2.0GiB",        "2.00GiB",       2 * 2 ** 30      ],

    [ "1T",            "1.0T",          "1.00T",         "931GiB",        "931.3GiB",      "931.32GiB",     10 ** 12         ],
    [ "2T",            "2.0T",          "2.00T",         "2TiB",          "1.8TiB",        "1.82TiB",       2 * 10 ** 12     ],

    [ "1T",            "1.1T",          "1.10T",         "1TiB",          "1.0TiB",        "1.00TiB",       2 ** 40          ],
    [ "2T",            "2.2T",          "2.20T",         "2TiB",          "2.0TiB",        "2.00TiB",       2 * 2 ** 40      ],
  ]

  def assert_conversion(cls, data, offset, didx, sidx, dec_places = nil)
    numstr  = data[-1]
    conv    = dec_places.nil? ? cls.convert(numstr) : cls.convert(numstr, dec_places)
    assert_equals data[offset + didx], conv, "size index: #{sidx}; data index: #{didx}; offset: #{offset}; decimal_places: #{dec_places}"
  end

  def do_test(cls, offset)
    SIZES.each_with_index do |data, sidx|
      assert_conversion(cls, data, offset, 1, sidx)
      (0 .. 2).each do |dec_places|
        assert_conversion(cls, data, offset, dec_places, sidx, dec_places)
      end
    end
  end

  def test_default
    do_test(SizeConverter, 0)
  end

  def test_human
    do_test(SizeConverter::Human, 0)
  end

  def test_si
    do_test(SizeConverter::SI, 3)
  end

end
