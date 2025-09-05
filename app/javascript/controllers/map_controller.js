import { Controller } from "@hotwired/stimulus"

export default class MapController extends Controller {
  static targets = ["location", "map"]

  connect() {
    let location = this.locationTarget.value

    this.map = L.map(this.mapTarget.id)
    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png',{ maxZoom: 19 }).addTo(this.map)

    try {
      location = location.split(', ')
      this.map.setView([+location[0], +location[1]], 13)
      this.marker = L.marker([+location[0], +location[1]]).addTo(this.map)
    } catch {
      // in the future it will default to user location
      this.map.setView([50.037432, 22.004925], 5)
    }
  }
}