require "test_helper"

class DemoAccountLockTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "the demo account cannot log out" do
    sign_in users(:demo_user)

    delete destroy_user_session_path

    assert_redirected_to home_path
    assert_equal users(:demo_user).id, controller.current_user.id
  end

  test "a regular account can still log out" do
    sign_in users(:alice)

    delete destroy_user_session_path

    assert_redirected_to root_path
    assert_nil controller.current_user
  end
end
