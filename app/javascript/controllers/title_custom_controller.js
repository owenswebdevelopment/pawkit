import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["customInput"]

  connect() {
    console.log("TitleCustomController connected")
    this.toggleCustomInput()
  }

  toggleCustomInput(event) {
    const selectedValue = event?.target?.value || this.element.querySelector("input[name='task[title]']:checked")?.value
    this.customInputTarget.style.display = selectedValue === "custom" ? "block" : "none"
  }
}
