require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # save_recipe: owner can save their own assistant message
  test "owner can save a recipe from their own assistant message" do
    sign_in users(:alice)
    message = messages(:assistant_message)
    chat = chats(:alice_chat)

    post save_recipe_chat_message_path(chat, message)

    assert_redirected_to recipes_path
    assert_match "has been saved", flash[:notice]
    assert Recipe.exists?(name: "Salade de pois chiches", user: users(:alice))
  end

  # save_recipe: another user cannot access a message they don't own
  test "other user gets 404 when trying to save a message they do not own" do
    sign_in users(:bob)
    message = messages(:assistant_message)
    chat = chats(:alice_chat)

    post save_recipe_chat_message_path(chat, message)

    assert_response :not_found
  end

  # save_recipe: cannot save a user-role message
  test "cannot save a user message as a recipe" do
    sign_in users(:alice)
    message = messages(:user_message)
    chat = chats(:alice_chat)

    post save_recipe_chat_message_path(chat, message)

    assert_redirected_to chat_path(chat)
    assert_match "only save recipes from assistant messages", flash[:alert]
  end

  # save_recipe: unauthenticated user is redirected to sign-in
  test "unauthenticated user is redirected to sign in" do
    message = messages(:assistant_message)
    chat = chats(:alice_chat)

    post save_recipe_chat_message_path(chat, message)

    assert_redirected_to new_user_session_path
  end
end
