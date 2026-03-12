import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selectionButton", "exportForm", "selectionNote", "counter", "hiddenIds"]

  connect() {
    this.selectedIds = new Set()
    this.reportMode = false
    this.refreshUI()
  }

  toggleMode() {
    this.reportMode = !this.reportMode
    if (!this.reportMode) {
      this.selectedIds.clear()
      this.syncHiddenInputs()
    }
    this.refreshUI()
  }

  toggleReceipt(event) {
    const button = event.currentTarget
    const receiptId = button.dataset.receiptId

    if (this.selectedIds.has(receiptId)) {
      this.selectedIds.delete(receiptId)
    } else {
      this.selectedIds.add(receiptId)
    }

    this.syncHiddenInputs()
    this.refreshRowButton(button)
    this.refreshMeta()
  }

  refreshUI() {
    this.element.querySelectorAll("[data-report-toggle]").forEach((node) => {
      node.classList.toggle("hidden", !this.reportMode)
    })

    this.element.querySelectorAll("[data-report-select]").forEach((button) => {
      this.refreshRowButton(button)
    })

    this.selectionButtonTarget.textContent = this.reportMode ? "Cancel Report" : "Generate Report"
    this.selectionButtonTarget.classList.toggle("border-rose-400/40", this.reportMode)
    this.selectionButtonTarget.classList.toggle("bg-rose-500/20", this.reportMode)
    this.selectionButtonTarget.classList.toggle("text-rose-100", this.reportMode)

    this.refreshMeta()
  }

  refreshRowButton(button) {
    const selected = this.selectedIds.has(button.dataset.receiptId)
    button.textContent = selected ? "Added" : "+"
    button.classList.toggle("border-emerald-400/40", selected)
    button.classList.toggle("bg-emerald-500/20", selected)
    button.classList.toggle("text-emerald-100", selected)
  }

  refreshMeta() {
    const count = this.selectedIds.size
    this.counterTarget.textContent = count
    this.selectionNoteTarget.classList.toggle("hidden", !this.reportMode)
    this.exportFormTarget.classList.toggle("hidden", !this.reportMode)
    this.exportFormTarget.querySelector("button").disabled = count === 0
  }

  syncHiddenInputs() {
    this.hiddenIdsTarget.innerHTML = ""
    this.selectedIds.forEach((id) => {
      const input = document.createElement("input")
      input.type = "hidden"
      input.name = "receipt_ids[]"
      input.value = id
      this.hiddenIdsTarget.appendChild(input)
    })
  }
}
