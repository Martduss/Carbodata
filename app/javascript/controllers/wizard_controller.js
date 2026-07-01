import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step"]

  // Go to next step (with validation)
  goToNext(event) {
    const currentStep = this.stepTargets[event.target.dataset.currentStep]

    // Validate before moving forward
    if (!this.validate(currentStep)) return

    currentStep.classList.add("d-none")
    this.stepTargets[event.target.dataset.nextStep].classList.remove("d-none")
  }

  // Go to previous step
  goToPrevious(event) {
    this.stepTargets[event.target.dataset.currentStep].classList.add("d-none")
    this.stepTargets[event.target.dataset.previousStep].classList.remove("d-none")
  }

  // Validate required fields in current step
  validate(step) {
    let isValid = true

    step.querySelectorAll("input, textarea, select").forEach((input) => {
      if (input.type === "hidden") return
      if (!input.required) return

      input.classList.remove("is-invalid")

      if (!input.value.trim()) {
        isValid = false
        input.classList.add("is-invalid")
      }
    })

    return isValid
  }

  // Reset when offcanvas closes
  reset() {
    // Show first step, hide all others
    this.stepTargets.forEach((step, index) => {
      if (index === 0) {
        step.classList.remove("d-none")
      } else {
        step.classList.add("d-none")
      }
    })

    // Clear validation errors
    this.element.querySelectorAll(".is-invalid").forEach((el) => el.classList.remove("is-invalid"))

    // Clear form inputs
    const form = this.element.querySelector("form")
    if (form) form.reset()
  }
}
