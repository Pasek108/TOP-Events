import { Controller } from "@hotwired/stimulus"
import "leaflet"

export default class extends Controller {
  static targets = ["map", "location"]
  static values = { editable: Boolean }

  tileProvider = {
    url: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    zoomBounds: { min: 0, max: 19 },
    // https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Zoom_levels
    // https://wiki.openstreetmap.org/wiki/Zoom_levels
  }

  connect() {
    this.map = this.createMap(this.mapTarget.id)
    this.marker = this.markLocation(this.locationTarget.value)

    const villageOrSuburbanZoomLevel = 13
    this.zoomAndCenterOnMarker(villageOrSuburbanZoomLevel)

    const isMapEditable = this.editableValue
    if (isMapEditable) this.map.on("click", this.markNewLocation.bind(this))
  }

  createMap(mapElementId) {
    const tileLayerOptions = {
      minZoom: this.tileProvider.zoomBounds.min,
      maxZoom: this.tileProvider.zoomBounds.max,
      attribution: this.tileProvider.attribution,
    }

    const mapDefaultOptions = {
      center: [52, 19], // approximate center of Poland (latitude, longitude)
      zoom: 6,          // zoom level to display all of Poland
      minZoom: this.tileProvider.zoomBounds.min,
      maxZoom: this.tileProvider.zoomBounds.max,
      attributionControl: true,
    }

    const map = L.map(mapElementId, mapDefaultOptions)
    L.tileLayer(this.tileProvider.url, tileLayerOptions).addTo(map)

    return map
  }

  markLocation(locationStr) {
    const marker = this.createMarker(locationStr)
    if (marker != null) marker.addTo(this.map)

    return marker
  }

  zoomAndCenterOnMarker(zoomLevel) {
    if (this.marker == null) return

    const markerPosition = this.marker.getLatLng()
    const zoomPosition = [markerPosition.lat, markerPosition.lng]

    this.map.setView(zoomPosition, zoomLevel)
  }

  createMarker(locationStr) {
    const location = this.getLatLng(locationStr)
    return location != null ? L.marker(location) : null
  }

  getLatLng(locationStr) {
    if (!locationStr) return null

    const location = locationStr.split(", ").map(Number)

    if (location.length !== 2) return null
    if (location.some(isNaN)) return null

    return location
  }

  markNewLocation(e) {
    const newLocationStr = `${e.latlng.lat}, ${e.latlng.lng}`
    this.locationTarget.value = newLocationStr

    if (this.marker != null) this.marker.setLatLng(e.latlng)
    else this.marker = this.markLocation(newLocationStr)
  }
}
