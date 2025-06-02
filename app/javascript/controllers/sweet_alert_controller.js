import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static targets = ["deleteButton"];

  connect() {
    this.deleteButtonTargets.forEach(button => {
      button.addEventListener("click", (event) => this.confirmDelete(event));
    });
  }

  confirmDelete(event) {
    event.preventDefault();

    Swal.fire({
      title: "Are you sure?",
      text: "This will permanently delete the pet record!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: "Yes, delete it!",
      cancelButtonText: "Cancel",
      confirmButtonColor: "#d33",
      cancelButtonColor: "#3085d6"
    }).then((result) => {
      if (result.isConfirmed) {
        event.target.closest("form").submit(); // Submit the form
      }
    });
  }
}
