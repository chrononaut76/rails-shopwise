import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["itemsList", "emptyMessageContainer"]

  connect() {
    this.toggleEmptyMessage();

    const observer = new MutationObserver(() => {
      this.toggleEmptyMessage();
    });

    observer.observe(this.itemsListTarget, { childList: true });
  }

  toggleEmptyMessage() {
    if (this.itemsListTarget.children.length > 0) {
      this.emptyMessageContainerTarget.style.display = 'none';
    } else {
      this.emptyMessageContainerTarget.style.display = 'block';
    }
  }

  moveItemToBottom(event) {
    const checkbox = event.target;
    const item = checkbox.closest('.card-body');
    const itemsList = this.itemsListTarget;

    if (checkbox.checked) {
      itemsList.appendChild(item);
    } else {
      itemsList.prepend(item);
    }
  }
}
