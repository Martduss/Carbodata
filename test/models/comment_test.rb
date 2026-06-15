require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def valid_comment
    Comment.new(content: "Super recette !", user: users(:alice), post: posts(:alice_post))
  end

  test "valid with content" do
    assert valid_comment.valid?
  end

  test "invalid without content" do
    comment = valid_comment
    comment.content = nil
    assert_not comment.valid?
    assert_includes comment.errors[:content], "can't be blank"
  end

  test "invalid with empty content" do
    comment = valid_comment
    comment.content = ""
    assert_not comment.valid?
  end

  test "invalid with content exceeding 1000 characters" do
    comment = valid_comment
    comment.content = "a" * 1001
    assert_not comment.valid?
  end

  test "valid with content at exactly 1000 characters" do
    comment = valid_comment
    comment.content = "a" * 1000
    assert comment.valid?
  end
end
