require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "updates profile without requiring current_password" do
    sign_in users(:alice)

    patch user_registration_path, params: { user: { profile_name: "Alicia" } }

    assert_redirected_to profile_path
    assert_equal "Alicia", users(:alice).reload.profile_name
  end

  test "rejects password change without current_password" do
    sign_in users(:alice)

    patch user_registration_path, params: { user: { password: "newpassword", password_confirmation: "newpassword" } }

    assert_response :unprocessable_entity
    assert_not users(:alice).reload.valid_password?("newpassword")
  end

  test "rejects password change with wrong current_password" do
    sign_in users(:alice)

    patch user_registration_path, params: { user: { password: "newpassword", password_confirmation: "newpassword", current_password: "wrongpassword" } }

    assert_response :unprocessable_entity
    assert_not users(:alice).reload.valid_password?("newpassword")
  end

  test "allows changing password with correct current_password" do
    sign_in users(:alice)

    patch user_registration_path, params: { user: { password: "newpassword", password_confirmation: "newpassword", current_password: "password" } }

    assert_redirected_to profile_path
    assert users(:alice).reload.valid_password?("newpassword")
  end

  test "rejects email change without current_password" do
    sign_in users(:alice)

    patch user_registration_path, params: { user: { email: "alicia@example.com" } }

    assert_response :unprocessable_entity
    assert_not_equal "alicia@example.com", users(:alice).reload.email
  end

  test "allows changing email with correct current_password" do
    sign_in users(:alice)

    patch user_registration_path, params: { user: { email: "alicia@example.com", current_password: "password" } }

    assert_redirected_to profile_path
    # Email changes are reconfirmable: the new address is staged in
    # unconfirmed_email until the confirmation link is clicked.
    assert_equal "alicia@example.com", users(:alice).reload.unconfirmed_email
    assert_equal "alice@example.com", users(:alice).email
  end

  test "new sign-ups can sign in immediately without confirming their email" do
    post user_registration_path, params: { user: { email: "carol@example.com", password: "password", password_confirmation: "password", profile_name: "Carol", accept_terms: "1" } }

    user = User.find_by(email: "carol@example.com")
    assert user.confirmed?

    post user_session_path, params: { user: { email: "carol@example.com", password: "password" } }
    assert_redirected_to home_path
  end

  test "sign-up records when the user accepted the privacy policy" do
    post user_registration_path, params: { user: { email: "dave@example.com", password: "password", password_confirmation: "password", profile_name: "Dave", accept_terms: "1" } }

    user = User.find_by(email: "dave@example.com")
    assert_not_nil user.accepted_terms_at
  end

  test "sign-up is rejected when the privacy policy checkbox is left unchecked" do
    post user_registration_path, params: { user: { email: "erin@example.com", password: "password", password_confirmation: "password", profile_name: "Erin", accept_terms: "0" } }

    assert_nil User.find_by(email: "erin@example.com")
    assert_response :unprocessable_entity
  end

  test "the demo account cannot access the edit profile form" do
    sign_in users(:demo_user)

    get edit_user_registration_path

    assert_redirected_to home_path
  end

  test "the demo account cannot update its profile" do
    sign_in users(:demo_user)

    patch user_registration_path, params: { user: { profile_name: "Hacked" } }

    assert_redirected_to home_path
    assert_not_equal "Hacked", users(:demo_user).reload.profile_name
  end

  test "the demo account cannot delete itself" do
    sign_in users(:demo_user)

    delete user_registration_path

    assert_redirected_to home_path
    assert User.exists?(users(:demo_user).id)
  end
end
