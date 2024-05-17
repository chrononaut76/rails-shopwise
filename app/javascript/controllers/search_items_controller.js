import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-items"
export default class extends Controller {
  static targets = ['input', 'results'];

  returnResults(event) {
    event.preventDefault();
    console.log(this.inputTarget.value);
    // this.resultsTarget.classList.add("border", "border-top-0");
    // this.resultsTarget.children[0].innerText = 'first result';
    // this.resultsTarget.children[1].innerText = 'second result';
    // this.resultsTarget.children[2].innerText = 'third result';
  }
}
