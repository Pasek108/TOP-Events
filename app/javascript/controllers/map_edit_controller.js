import MapController from "controllers/map_controller"

export default class extends MapController {
  static targets = ["location", "map"]
  
  connect() {
    super.connect()
    this.map.on('click', this.onMapClick.bind(this))
  }

  onMapClick(e) {
    if (this.marker != null) this.marker.removeFrom(this.map)
    this.marker = L.marker([+e.latlng.lat, +e.latlng.lng]).addTo(this.map)
    this.locationTarget.value = `${e.latlng.lat}, ${e.latlng.lng}`
  }
}