import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  handleSubmit(event) {
    const errorDiv = document.getElementById("form-error")
    errorDiv.style.display = "none"
    errorDiv.textContent = ""

    const titleInput = this.element.querySelector('input[name="task[title]"]:checked')

    const petRadioSelected = this.element.querySelector('input[name="task[pet_id]"]:checked')
    const hiddenPetField = this.element.querySelector('input[type="hidden"][name="task[pet_id]"]')
    const hiddenPetValue = hiddenPetField?.value

    let errors = []

    if (!titleInput) errors.push("Please select a task title.")

    // Only validate pet selection if hidden field is empty or not present
    if (!hiddenPetValue && !petRadioSelected) {
      errors.push("Please select a pet.")
    }

    if (errors.length > 0) {
      event.preventDefault()
      errorDiv.textContent = errors.join(" ")
      errorDiv.style.display = "block"
    }
  }
}
