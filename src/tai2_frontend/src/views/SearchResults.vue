<template>
  <div class="search-results-page">
    <SearchBar @search="fetchHotels" />
    <div class="hotel-list section">
      <div class="hotel-cards">
        <div v-for="hotel in hotels" :key="hotel.id" class="hotel-card">
          <HotelCard :hotel="hotel" />
        </div>
      </div>
    </div>
    <div class="map-view section">
      <HotelMap :hotels="hotels" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import axios from 'axios';
import SearchBar from '@/components/SearchBar.vue';
import HotelCard from '@/components/HotelCard.vue';
import HotelMap from '@/components/HotelMap.vue';

const hotels = ref([]);
const route = useRoute();

function fetchHotels(params) {
  axios.get('/api/hotels', { params }).then(response => {
    hotels.value = response.data;
  });
}

onMounted(() => {
  fetchHotels(route.query);
});
</script>


<style scoped>
.search-results-page {
  font-family: Arial, sans-serif;
  padding: 20px;
}
.section {
  margin-bottom: 40px;
}
.hotel-cards {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}
.hotel-card {
  width: calc(33.333% - 20px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border-radius: 8px;
  overflow: hidden;
  transition: transform 0.3s;
}
.hotel-card:hover {
  transform: scale(1.05);
}
</style>