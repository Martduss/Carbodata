require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "update updates the content of the user's own comment" do
    sign_in users(:bob)
    comment = comments(:bob_comment)

    patch post_comment_path(comment.post, comment), params: { comment: { content: "Updated content" } }

    assert_redirected_to post_path(comment.post)
    assert_equal "Updated content", comment.reload.content
  end

  test "update does not allow editing another user's comment" do
    sign_in users(:bob)
    comment = comments(:alice_comment)

    patch post_comment_path(comment.post, comment), params: { comment: { content: "Hacked" } }

    assert_response :not_found
    assert_equal "Merci !", comment.reload.content
  end

  test "update rejects blank content" do
    sign_in users(:bob)
    comment = comments(:bob_comment)

    patch post_comment_path(comment.post, comment), params: { comment: { content: "" } }

    assert_redirected_to post_path(comment.post)
    assert_equal "Super recette !", comment.reload.content
  end

  test "destroy removes the user's own comment" do
    sign_in users(:bob)
    comment = comments(:bob_comment)

    assert_difference("Comment.count", -1) do
      delete post_comment_path(comment.post, comment)
    end

    assert_redirected_to post_path(comment.post)
  end

  test "destroy does not allow deleting another user's comment" do
    sign_in users(:bob)
    comment = comments(:alice_comment)

    assert_no_difference("Comment.count") do
      delete post_comment_path(comment.post, comment)
    end

    assert_response :not_found
  end
end
