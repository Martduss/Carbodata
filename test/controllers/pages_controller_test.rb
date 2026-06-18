require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # --- NIL NUTRITIONAL DATA (regression for production crash) ---

  test "profile renders successfully when recipes and items have no GI or carb ratio" do
    sign_in users(:alice)
    recipes(:alice_recipe_without_nutritional_info)
    items(:alice_item_without_nutritional_info)

    get profile_path

    assert_response :success
  end
end
