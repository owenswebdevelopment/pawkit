import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("connected to memories");
    const input = document.getElementById("input");
    if (input) {
      input.scrollTop = input.scrollHeight;
    }
  }
}
