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
  }

  #setMarkerColor(marker) {
    let color = "";
    if (marker.price_category === 'cheapest') {
      color = "#008000";
    } else if (marker.price_category === 'expensive') {
      color = "#FF0000";
    } else if (marker.price_category === 'affordable') {
      color = "#0A4D71";
    };
    return color;
  };

  #generatePopupHTML(marker) {
    const color = this.#setMarkerColor(marker);
    return `<div style="border: 3px solid ${color}; padding: 10px; border-radius: 5px;">${marker.info_window_html}</div>`;
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popupHTML = this.#generatePopupHTML(marker);
      const popup = new mapboxgl.Popup().setHTML(popupHTML);
      // const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      new mapboxgl.Marker({"color": this.#setMarkerColor(marker)})
      .setLngLat([ marker.lng, marker.lat ])
      .setPopup(popup)
      .addTo(this.map)
    }
  )};

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds();
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  };

}
