<template>
  <div class="hotel-details-page">
    <div class="hotel-details">
      <img :src="hotel.image" alt="hotel.name" class="hotel-image" />
      <h1 class="hotel-name">{{ hotel.name }}</h1>
      <p class="hotel-description">{{ hotel.description }}</p>
      <ul class="hotel-facilities">
        <li v-for="facility in hotel.facilities" :key="facility">{{ facility }}</li>
      </ul>
      <div class="room-types">
        <div v-for="room in hotel.rooms" :key="room.id" class="room-type">
          <p>{{ room.type }} - {{ room.price }}元/晚</p>
          <button @click="bookRoom(room)" class="book-button">预订</button>
        </div>
      </div>
    </div>
  </div>
</template>


<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from 'axios';

const hotel = ref({});
const route = useRoute();
const router = useRouter();

function bookRoom(room) {
  router.push({ name: 'BookingConfirmation', query: { roomId: room.id } });
}

onMounted(() => {
  const hotelId = route.params.id;
  axios.get(`/api/hotels/${hotelId}`).then(response => {
    hotel.value = response.data;
  });
});
</script>


<style scoped>
.hotel-details-page {
  font-family: Arial, sans-serif;
  padding: 20px;
}
.hotel-image {
  width: 100%;
  height: auto;
  border-radius: 8px;
  margin-bottom: 20px;
}
.hotel-name {
  font-size: 2em;
  margin-bottom: 10px;
}
.hotel-description {
  margin-bottom: 20px;
}
.hotel-facilities {
  list-style-type: none;
  padding: 0;
  margin-bottom: 20px;
}
.room-type {
  margin-bottom: 20px;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
}

.book-button {
  background-color: #ff6f61;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
}
.book-button:hover {
  background-color: #e65c50;
}
</style>