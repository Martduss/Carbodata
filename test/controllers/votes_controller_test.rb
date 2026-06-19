require "test_helper"

class VotesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @post = posts(:alice_post)
  end

  test "creates an upvote and increments the score" do
    sign_in users(:alice)
    @post.votes.destroy_all

    post post_vote_path(@post), params: { value: 1 }, as: :json

    assert_response :success
    assert_equal 1, JSON.parse(response.body)["score"]
  end

  test "clicking the same arrow twice removes the vote" do
    sign_in users(:alice)
    @post.votes.destroy_all
    post post_vote_path(@post), params: { value: 1 }, as: :json

    post post_vote_path(@post), params: { value: 1 }, as: :json

    assert_response :success
    assert_equal 0, JSON.parse(response.body)["score"]
  end

  test "switching from upvote to downvote moves the score by 2" do
    sign_in users(:alice)
    @post.votes.destroy_all
    post post_vote_path(@post), params: { value: 1 }, as: :json

    post post_vote_path(@post), params: { value: -1 }, as: :json

    assert_response :success
    assert_equal(-1, JSON.parse(response.body)["score"])
  end

  test "rejects an invalid vote value" do
    sign_in users(:alice)

    post post_vote_path(@post), params: { value: 42 }, as: :json

    assert_response :unprocessable_entity
    assert_equal "Invalid vote value", JSON.parse(response.body)["error"]
  end
end
