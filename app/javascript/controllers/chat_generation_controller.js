import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Subscribes to ChatChannel so the server only starts generating
// SuperCarbo's response once this client is confirmed connected,
// avoiding a race where the response is already broadcast before
// the page finishes loading and subscribing to the chat stream.
export default class extends Controller {
  static values = { chatId: Number }

  connect() {
    this.subscription = consumer.subscriptions.create(
      { channel: "ChatChannel", chat_id: this.chatIdValue },
      {}
    )
  }

  disconnect() {
    this.subscription?.unsubscribe()
  }
}
