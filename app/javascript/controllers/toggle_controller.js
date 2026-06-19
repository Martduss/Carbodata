import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  toggle() {
    this.contentTargets.forEach(content => content.classList.toggle("d-none"))
  }
}
