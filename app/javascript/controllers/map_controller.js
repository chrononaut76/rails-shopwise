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

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      // setMarkerColor((marker) => {
      //   if (marker.price_category === 'cheapest') {
      //     "#0000ff";
      //   } else if (marker.price_category === 'expensive') {
      //     "#ff0000";
      //   } else if (marker.price_category === 'mid_range') {
      //     "#0A4D71";
      //   };
      // })
      // const color = setMarkerColor(marker);


      new mapboxgl.Marker({"color": "#0A4D71" })
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)

        // .setMarkerColor({"color": color})
}
    )};

    #fitMapToMarkers() {
      const bounds = new mapboxgl.LngLatBounds();
      this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
    };

    // #setMarkerColor() {
    //   if (marker.price_category === 'cheapest') {
    //     color = "#0000ff";
    //   } else if (marker.price_category === 'expensive') {
    //     color = "#ff0000";
    //   } else (marker.price_category === 'mid_range') ;{
    //     color = "#0A4D71";
    //   };
    // }
  }
