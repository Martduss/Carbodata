require "test_helper"

class UserTest < ActiveSupport::TestCase
  def new_user(accept_terms:)
    User.new(
      email: "new_user@example.com",
      password: "password",
      profile_name: "New user",
      accept_terms: accept_terms
    )
  end

  test "is invalid on create without accepting terms" do
    user = new_user(accept_terms: false)

    assert_not user.valid?
    assert_includes user.errors[:accept_terms], "must be accepted"
  end

  test "is invalid on create when the checkbox is left unchecked" do
    user = new_user(accept_terms: "0")

    assert_not user.valid?
  end

  test "records accepted_terms_at when terms are accepted on create" do
    user = new_user(accept_terms: true)

    assert user.save
    assert_not_nil user.accepted_terms_at
  end

  test "does not require accept_terms on update" do
    user = users(:alice)

    user.accept_terms = nil
    assert user.valid?
  end
end
