import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "caret"]
  closeMenuOnClick = this.closeMenu.bind(this)

  toggleMenu() {
    if (this.menuTarget.style.display == '') return

    this.toggleCaretIcon()
    this.menuTarget.style.display = null
    setTimeout(() => window.addEventListener("click", this.closeMenuOnClick), 0)
  }

  closeMenu() {
    this.toggleCaretIcon()
    this.menuTarget.style.display = "none"
    window.removeEventListener("click", this.closeMenuOnClick)
  }

  toggleCaretIcon() {
    this.caretTarget.classList.toggle("fa-caret-down")
    this.caretTarget.classList.toggle("fa-caret-up")
  }
}