require "test_helper"

class DemoSessionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "signs the visitor in as the demo user and redirects to the feed" do
    post demo_login_path

    assert_redirected_to feed_path
    assert_equal users(:demo_user).id, controller.current_user.id
  end

  test "never reads a user/email from params to pick who to sign in as" do
    post demo_login_path, params: { email: users(:alice).email }

    assert_equal users(:demo_user).id, controller.current_user.id
  end

  test "redirects to the homepage with no demo user configured" do
    User.where(demo: true).update_all(demo: false)

    post demo_login_path

    assert_redirected_to root_path
    assert_nil controller.current_user
  end

  test "back to homepage ends the demo session so sign up/log in are reachable again" do
    sign_in users(:demo_user)

    delete demo_logout_path

    assert_redirected_to home_path
    assert_nil controller.current_user
  end

  test "hitting demo_logout while signed in as a regular user doesn't sign them out" do
    sign_in users(:alice)

    delete demo_logout_path

    assert_redirected_to home_path
    assert_equal users(:alice).id, controller.current_user.id
  end
end
