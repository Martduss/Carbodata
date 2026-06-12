require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # --- VISIBILITY: read access ---

  test "owner can view their own private recipe" do
    sign_in users(:alice)
    get recipe_path(recipes(:alice_private_recipe))
    assert_response :success
  end

  test "other user cannot view a private recipe" do
    sign_in users(:bob)
    get recipe_path(recipes(:alice_private_recipe))
    assert_response :not_found
  end

  test "other user can view a shared recipe" do
    sign_in users(:bob)
    get recipe_path(recipes(:alice_shared_recipe))
    assert_response :success
  end

  # --- VISIBILITY: write access ---

  test "owner can edit their own recipe" do
    sign_in users(:alice)
    get edit_recipe_path(recipes(:alice_private_recipe))
    assert_response :success
  end

  test "other user cannot edit a shared recipe they do not own" do
    sign_in users(:bob)
    get edit_recipe_path(recipes(:alice_shared_recipe))
    assert_redirected_to recipes_path
    assert_match "not authorized", flash[:alert]
  end

  test "other user cannot destroy a recipe they do not own" do
    sign_in users(:bob)
    delete recipe_path(recipes(:alice_shared_recipe))
    assert_redirected_to recipes_path
    assert_match "not authorized", flash[:alert]
    assert Recipe.exists?(recipes(:alice_shared_recipe).id)
  end

  test "owner can update their own recipe" do
    sign_in users(:alice)
    patch recipe_path(recipes(:alice_private_recipe)), params: { recipe: { name: "Updated Soup" } }
    assert_redirected_to recipes_path
    assert_equal "Updated Soup", recipes(:alice_private_recipe).reload.name
  end

  # --- AUTH ---

  test "unauthenticated user is redirected to sign in" do
    get recipes_path
    assert_redirected_to new_user_session_path
  end
end
