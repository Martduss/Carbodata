class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat = Chat.find_by(id: params[:chat_id])
    return reject unless chat
    return if chat.messages.exists?

    GenerateLlmResponseJob.perform_later(
      chat_id: chat.id,
      user_message_content: nil,
      generate_title: true
    )
  end
end
