require "test_helper"

class AccountLockoutTest < ActionDispatch::IntegrationTest
  test "account locks after 5 failed sign-in attempts" do
    5.times do
      post user_session_path, params: { user: { email: users(:alice).email, password: "wrongpassword" } }
    end

    assert users(:alice).reload.access_locked?

    post user_session_path, params: { user: { email: users(:alice).email, password: "password" } }
    assert_response :unprocessable_entity
    assert_match(/locked/i, response.body)
  end

  test "successful sign-in increments sign_in_count and records ip" do
    assert_equal 0, users(:alice).sign_in_count

    post user_session_path, params: { user: { email: users(:alice).email, password: "password" } }

    alice = users(:alice).reload
    assert_equal 1, alice.sign_in_count
    assert_not_nil alice.current_sign_in_at
    assert_not_nil alice.current_sign_in_ip
  end
end
