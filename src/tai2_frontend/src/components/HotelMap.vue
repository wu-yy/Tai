<template>
  <div class="map-container">
    <input
      v-model="address"
      @input="onPlaceChanged"
      ref="autocomplete"
      class="input-field"
      placeholder="Enter an address"
    />
    <div ref="mapContainer" class="map"></div>
  </div>
</template>

<script>
import { onMounted, ref } from 'vue';

export default {
  setup() {
    const address = ref("");
    const map = ref(null);
    const autocomplete = ref(null);
    const mapContainer = ref(null);

    const initializeMap = () => {
      const center = { lat: 13.7563, lng: 100.5018 }; // 曼谷的经纬度

      // Initialize the map
      map.value = new window.google.maps.Map(mapContainer.value, {
        center,
        zoom: 13,
      });

      // Initialize the autocomplete input
      const autocompleteService = new window.google.maps.places.Autocomplete(
        autocomplete.value
      );
      autocompleteService.bindTo("bounds", map.value);

      autocompleteService.addListener("place_changed", () => {
        const place = autocompleteService.getPlace();
        if (!place.geometry || !place.geometry.location) return;

        map.value.panTo(place.geometry.location);
        map.value.setZoom(15);
      });
    };

    onMounted(() => {
      // Load Google Maps API and initialize the map
      if (!window.google || !window.google.maps) {
        const script = document.createElement("script");
        script.src = `https://maps.googleapis.com/maps/api/js?key=AIzaSyBVcGDIEfsC49sjM1ARkV5z-G0LcKu_YsU&libraries=places`;
        script.async = true;
        script.defer = true;
        script.onload = initializeMap;
        document.head.appendChild(script);
      } else {
        initializeMap();
      }
    });

    return {
      address,
      mapContainer,
      autocomplete,
    };
  },
};
</script>

<style scoped>
.map-container {
  width: 100%;
  height: 500px;
  position: relative;
}

.input-field {
  width: 250px;
  padding: 10px;
  margin-bottom: 10px;
  border: 2px solid #ffcc00;
  border-radius: 8px;
  position: absolute;
  top: 15px;
  right: 15px; /* 将输入框移到右上角 */
  z-index: 10;
  font-size: 1rem;
  background-color: rgba(255, 255, 255, 0.9);
  color: #333;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  transition: border-color 0.3s, box-shadow 0.3s;
}

.input-field:focus {
  border-color: #3a7bd5; /* 蓝色聚焦效果 */
  box-shadow: 0 0 10px rgba(58, 123, 213, 0.5);
  outline: none;
}

.map {
  width: 100%;
  height: 100%;
  border-radius: 8px;
}
</style>
