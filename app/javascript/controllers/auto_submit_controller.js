import { Controller } from "@hotwired/stimulus"

// Submits the controller's <form> whenever a wired input fires its event.
// CSP-safe replacement for an inline `onchange="this.form.requestSubmit()"`.
//
// Usage:
//   data-controller="auto-submit"              on the <form>
//   data-action="change->auto-submit#submit"   on the input
export default class extends Controller {
  submit() {
    this.element.requestSubmit()
  }
}
