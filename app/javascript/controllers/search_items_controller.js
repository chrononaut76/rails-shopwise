import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-items"
export default class extends Controller {
  static targets = ['form', 'input', 'results', 'bar'];

  results() {
    const query = this.inputTarget.value.trim().toLowerCase();
    if (query.length > 0) {
      const url = `${this.formTarget.action}?query=${query}`;
      fetch(url, { headers: { 'Accept': 'text/plain' } })
        .then(response => response.text())
        .then(data => {
          this.resultsTarget.innerHTML = data;
          this.resultsTarget.classList.add('visible');
          this.barTarget.classList.add('results-visible');
        });
    } else {
      this.resultsTarget.classList.remove('visible');
      this.barTarget.classList.remove('results-visible');
    }
  }

  submitForm(event) {
    event.preventDefault();
  }
}
