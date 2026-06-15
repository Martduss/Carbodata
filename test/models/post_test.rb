require "test_helper"

class PostTest < ActiveSupport::TestCase
  def valid_post
    Post.new(title: "Mon premier post", content: "Un contenu valide.", user: users(:alice))
  end

  test "valid with title and content" do
    assert valid_post.valid?
  end

  # --- title ---

  test "invalid without title" do
    post = valid_post
    post.title = nil
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "invalid with title exceeding 100 characters" do
    post = valid_post
    post.title = "a" * 101
    assert_not post.valid?
  end

  test "valid with title at exactly 100 characters" do
    post = valid_post
    post.title = "a" * 100
    assert post.valid?
  end

  # --- score ---

  test "score sums vote values using preloaded collection" do
    post = posts(:alice_post)
    post_with_votes = Post.includes(:votes).find(post.id)

    assert post_with_votes.votes.loaded?
    assert_equal 0, post_with_votes.score  # alice +1, bob -1 = 0
  end

  # --- content ---

  test "invalid without content" do
    post = valid_post
    post.content = nil
    assert_not post.valid?
    assert_includes post.errors[:content], "can't be blank"
  end

  test "invalid with content exceeding 5000 characters" do
    post = valid_post
    post.content = "a" * 5001
    assert_not post.valid?
  end

  test "valid with content at exactly 5000 characters" do
    post = valid_post
    post.content = "a" * 5000
    assert post.valid?
  end
end
