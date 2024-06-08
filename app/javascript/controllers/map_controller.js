import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    });
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.#setupPopupInteraction()
  }

  #setMarkerColor(marker) {
    let color = "";
    if (marker.price_category === 'cheapest') {
      color = "#008000";
    } else if (marker.price_category === 'expensive') {
      color = "#FF0000";
    } else if (marker.price_category === 'affordable') {
      color = "#0A4D71";
    }
    return color;
  }

  #generatePopupHTML(marker) {
    return marker.info_window_html;
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popupHTML = this.#generatePopupHTML(marker);

      new mapboxgl.Marker({ "color": this.#setMarkerColor(marker) })
        .setLngLat([marker.lng, marker.lat])
        .getElement()
        .addEventListener('click', () => this.#showPopup(popupHTML))
        .addTo(this.map);
    });
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds();
    this.markersValue.forEach(marker => bounds.extend([marker.lng, marker.lat]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  #setupPopupInteraction() {
    const popupClose = document.getElementById('popup-close');
    popupClose.addEventListener('click', this.#hidePopup.bind(this));
  }

  #showPopup(content) {
    const popupBody = document.getElementById('popup-body');
    popupBody.innerHTML = content;
    const popup = document.getElementById('map-popup');
    popup.classList.remove('hidden');
    popup.classList.add('show');
  }

  #hidePopup() {
    const popup = document.getElementById('map-popup');
    popup.classList.remove('show');
    popup.classList.add('hidden');
  }
}
