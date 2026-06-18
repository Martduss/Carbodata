require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "reversed_stars returns nil when stars is nil" do
    assert_nil reversed_stars(nil)
  end

  test "reversed_stars mirrors the rating, capped between 1 and 5" do
    assert_equal 4, reversed_stars(1)
    assert_equal 1, reversed_stars(5)
    assert_equal 1, reversed_stars(6)
  end
end
