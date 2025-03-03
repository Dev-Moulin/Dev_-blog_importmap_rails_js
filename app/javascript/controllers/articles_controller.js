import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["count"];

  connect() {
    console.log("Articles controller connected");
  }

  count() {
    const articleCount = document.querySelectorAll(".article-item").length;
    this.countTarget.textContent = `Il y a ${articleCount} article(s) sur cette page.`;
    this.countTarget.style.display = "block";
  }
}
