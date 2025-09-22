import { Controller } from "@hotwired/stimulus"
import "leaflet"

export default class extends Controller {
  static targets = ["map", "latitude", "longitude", "locationName"]
  static values = { editable: Boolean }

  tileProvider = {
    url: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    zoomBounds: { min: 0, max: 19 },
    // https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Zoom_levels
    // https://wiki.openstreetmap.org/wiki/Zoom_levels
  }

  connected = false
  map = null
  marker = null

  connect() {
    this.map = this.createMap(this.mapTarget.id)
    this.marker = this.markLocation({
      latitude: this.latitudeTarget.value,
      longitude: this.longitudeTarget.value,
      locationName: this.locationNameTarget.value,
    })

    this.connected = true
  }

  createMap(mapElementId) {
    const isMapEditable = this.editableValue

    const mapDefaultOptions = {
      center: [52, 19], // approximate center of Poland (latitude, longitude)
      zoom: 6,          // zoom level to display all of Poland
      minZoom: this.tileProvider.zoomBounds.min,
      maxZoom: this.tileProvider.zoomBounds.max,
      attributionControl: true,
    }

    const map = L.map(mapElementId, mapDefaultOptions)
    map.on("popupopen", this.centerPopup.bind(this))
    map.on("click", isMapEditable ? this.markNewLocation.bind(this) : () => {})

    const tileLayer = this.createTileLayer()
    tileLayer.addTo(map)

    return map
  }

  createTileLayer() {
    const tileLayerOptions = {
      minZoom: this.tileProvider.zoomBounds.min,
      maxZoom: this.tileProvider.zoomBounds.max,
      attribution: this.tileProvider.attribution,
    }

    return L.tileLayer(this.tileProvider.url, tileLayerOptions)
  }

  markLocation({ latitude, longitude, locationName }) {
    const isMapEditable = this.editableValue

    if (latitude === "" || longitude === "") return null
    if (!isMapEditable && locationName === "") return null

    if (!isMapEditable) {
      const villageOrSuburbanZoomLevel = 13
      this.map.setZoom(villageOrSuburbanZoomLevel)
    }

    const marker = L.marker([latitude, longitude])
    marker.addTo(this.map)

    const markerPopup = this.createMarkerPopup({ locationName, latitude, longitude })
    marker.bindPopup(markerPopup)
    marker.openPopup()

    return marker
  }

  centerPopup(e) {
    // get pixel location of popup anchor on the map
    const popupAnchor = this.map.project(e.target._popup._latlng)

    // get height of popup container, subtract half of it from popup anchor Y axis
    const popupHeight = e.target._popup._container.clientHeight
    popupAnchor.y -= popupHeight / 2

    // pan to new center
    this.map.panTo(this.map.unproject(popupAnchor), { animate: this.connected })
  }

  updatePopupContent() {
    const latitude = this.latitudeTarget.value
    const longitude = this.longitudeTarget.value
    const locationName = this.locationNameTarget.value

    const popupContent = this.createMarkerPopupText({ locationName, latitude, longitude })
    this.marker.setPopupContent(popupContent)
  }

  createMarkerPopup({ locationName, latitude, longitude }) {
    const popupContent = this.createMarkerPopupText({ locationName, latitude, longitude })
    return L.popup({ maxWidth: 200, maxHeight: 150 }).setContent(popupContent)
  }

  createMarkerPopupText({ locationName, latitude, longitude }) {
    let popupContent = ""
    popupContent += `<b>${locationName}</b><br>`
    popupContent += `<a href="https://www.google.com/maps/?q=${latitude},${longitude}" target="_blank" >View on Google Maps</a>.`

    return popupContent
  }

  markNewLocation(e) {
    this.latitudeTarget.value = e.latlng.lat
    this.longitudeTarget.value = e.latlng.lng

    if (this.marker != null) this.map.removeLayer(this.marker)
    this.marker = this.markLocation({
      latitude: e.latlng.lat,
      longitude: e.latlng.lng,
      locationName: this.locationNameTarget.value,
    })
  }
}
