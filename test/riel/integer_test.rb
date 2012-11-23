require 'test_helper'

require 'riel/integer'

module PVN
  class TestInteger < Test::Unit::TestCase
    
    def setup
    end

    def assert_true boolean, message = ""
      assert boolean, message
    end
    
    def assert_false boolean, message = ""
      assert !boolean, message
    end
    
    def assert_negative_integer val
      assert_true Integer.negative? val
    end
    
    def assert_not_negative_integer val
      assert_false Integer.negative? val
    end
    
    def test_negative_integer
      assert_negative_integer(-3)
      assert_negative_integer("-3")
      assert_negative_integer(-10)
      assert_negative_integer "-15"
      assert_negative_integer(-100)
      assert_negative_integer "-9002"

      assert_not_negative_integer 1
      assert_not_negative_integer "1"
      assert_not_negative_integer 1.5
      assert_not_negative_integer "5.1"
      assert_not_negative_integer 123
      assert_not_negative_integer "123"
      assert_not_negative_integer "negative three"
    end
  end
end
