require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  def valid_recipe
    Recipe.new(name: "Salade de quinoa", user: users(:alice))
  end

  # --- name ---

  test "valid without optional nutritional fields" do
    assert valid_recipe.valid?
  end

  test "invalid without name" do
    recipe = valid_recipe
    recipe.name = nil
    assert_not recipe.valid?
    assert_includes recipe.errors[:name], "can't be blank"
  end

  test "invalid with name exceeding 100 characters" do
    recipe = valid_recipe
    recipe.name = "a" * 101
    assert_not recipe.valid?
  end

  # --- indice_gly ---

  test "valid with indice_gly nil" do
    recipe = valid_recipe
    recipe.indice_gly = nil
    assert recipe.valid?
  end

  test "valid with indice_gly at boundaries" do
    recipe = valid_recipe
    recipe.indice_gly = 1
    assert recipe.valid?
    recipe.indice_gly = 100
    assert recipe.valid?
  end

  test "invalid with indice_gly below 1" do
    recipe = valid_recipe
    recipe.indice_gly = 0
    assert_not recipe.valid?
    assert recipe.errors[:indice_gly].any?
  end

  test "invalid with indice_gly above 100" do
    recipe = valid_recipe
    recipe.indice_gly = 101
    assert_not recipe.valid?
  end

  # --- ratio_glucide ---

  test "valid with ratio_glucide nil" do
    recipe = valid_recipe
    recipe.ratio_glucide = nil
    assert recipe.valid?
  end

  test "invalid with ratio_glucide out of range" do
    recipe = valid_recipe
    recipe.ratio_glucide = 0
    assert_not recipe.valid?
    recipe.ratio_glucide = 101
    assert_not recipe.valid?
  end

  # --- difficulty ---

  test "valid with difficulty nil" do
    recipe = valid_recipe
    recipe.difficulty = nil
    assert recipe.valid?
  end

  test "invalid with difficulty outside 1-5" do
    recipe = valid_recipe
    recipe.difficulty = 0
    assert_not recipe.valid?
    recipe.difficulty = 6
    assert_not recipe.valid?
  end
end
