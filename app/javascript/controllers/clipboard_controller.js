import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["input"]
  connect() {
  console.log("I am connected");
  }

  copy(event) {
    console.log(event);
    const text = this.inputTarget
    navigator.clipboard.writeText(text.value)
    .then(() =>{
      Swal.fire({
        title: "Copied",
        confirmButtonColor: "#78c2ad",
        width: '250px'
      });
    })
    .catch(error => {
      console.errorr("Failed to copy", error);
    });
  }
}
