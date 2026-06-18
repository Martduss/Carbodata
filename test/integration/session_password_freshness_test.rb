require "test_helper"

class SessionPasswordFreshnessTest < ActionDispatch::IntegrationTest
  # Devise stores authenticatable_salt (derived from encrypted_password) in the
  # session and re-validates it on every request, so changing the password in
  # one session naturally invalidates any other active session for that user.
  test "changing password signs out other active sessions" do
    session_a = open_session
    session_b = open_session

    [session_a, session_b].each do |s|
      s.post user_session_path, params: { user: { email: users(:alice).email, password: "password" } }
    end

    session_a.patch user_registration_path, params: { user: { password: "newpassword", password_confirmation: "newpassword", current_password: "password" } }
    assert session_a.response.redirect?

    session_a.get recipes_path
    assert_equal 200, session_a.response.status

    session_b.get recipes_path
    assert_redirect_to_sign_in(session_b)
  end

  private

  def assert_redirect_to_sign_in(session)
    assert_equal 302, session.response.status
    assert_equal new_user_session_path, URI.parse(session.response.location).path
  end
end
