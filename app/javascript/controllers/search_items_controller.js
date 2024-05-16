import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-items"
export default class extends Controller {
  static targets = ['input']

  connect() {
    console.log(this.inputTarget);
  }
}
