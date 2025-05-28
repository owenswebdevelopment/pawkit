import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reset-input"
export default class extends Controller {
  connect() {
    console.log("connected");
  }

  reset() {
    this.element.reset();
  }
}
