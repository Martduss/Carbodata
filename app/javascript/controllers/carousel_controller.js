import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track"]

  next() {
    this.trackTarget.scrollBy({ left: 420, behavior: "smooth" })
  }

  prev() {
    this.trackTarget.scrollBy({ left: -420, behavior: "smooth" })
  }
}
