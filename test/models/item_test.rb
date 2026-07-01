require "test_helper"

class ItemTest < ActiveSupport::TestCase
  def valid_item
    Item.new(name: "Quinoa", indice_gly: 53, ratio_glucide: 64, user: users(:alice))
  end

  test "valid with all required fields" do
    assert valid_item.valid?
  end

  test "valid without optional nutritional fields" do
    item = valid_item
    item.indice_gly = nil
    item.ratio_glucide = nil
    assert item.valid?
  end

  # --- name ---

  test "invalid without name" do
    item = valid_item
    item.name = nil
    assert_not item.valid?
    assert_includes item.errors[:name], "can't be blank"
  end

  test "invalid with name exceeding 100 characters" do
    item = valid_item
    item.name = "a" * 101
    assert_not item.valid?
  end

  # --- indice_gly ---

  test "invalid with indice_gly out of range" do
    item = valid_item
    item.indice_gly = -1
    assert_not item.valid?
    item.indice_gly = 101
    assert_not item.valid?
  end

  # --- ratio_glucide ---

  test "invalid with ratio_glucide out of range" do
    item = valid_item
    item.ratio_glucide = -1
    assert_not item.valid?
    item.ratio_glucide = 101
    assert_not item.valid?
  end

  # --- nil guards on computed methods ---

  test "gi_level returns nil when indice_gly is nil" do
    item = valid_item
    item.indice_gly = nil
    assert_nil item.gi_level
  end

  test "gi_stars returns nil when indice_gly is nil" do
    item = valid_item
    item.indice_gly = nil
    assert_nil item.gi_stars
  end

  test "carb_stars returns nil when ratio_glucide is nil" do
    item = valid_item
    item.ratio_glucide = nil
    assert_nil item.carb_stars
  end

  test "gi_level classifies correctly" do
    item = valid_item
    item.indice_gly = 40
    assert_equal "low", item.gi_level
    item.indice_gly = 60
    assert_equal "medium", item.gi_level
    item.indice_gly = 80
    assert_equal "high", item.gi_level
  end
end
