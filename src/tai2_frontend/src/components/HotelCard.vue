<template>
  <div class="hotel-card">
    <img :src="data.hotel.image" alt="hotel.name" class="hotel-image" />
    <div class="hotel-info">
      <h3 class="hotel-name">{{ data.hotel.name }}</h3>
      <p class="hotel-price">{{ data.hotel.price }} {{ $t('hotelCard.unit')}}</p>
      <p class="hotel-rating">{{ $t('hotelCard.pingfen') }} {{ data.hotel.rating }} / 5</p>
    </div>
  </div>
</template>

<script setup>
// import { ref } from 'vue';
import { reactive } from 'vue';
const data = reactive({
  hotel: {}
});
// import { defineProps } from 'vue';

// const props = defineProps({
//   hotel: {
//     type: Object,
//     required: true
//   }
// });
</script>

<style scoped>
.hotel-card {
  display: flex;
  flex-direction: column;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border-radius: 12px;
  overflow: hidden;
  transition: transform 0.3s, box-shadow 0.3s;
  background: linear-gradient(to bottom, #ffcc00, #ff5733); /* 黄色到红色渐变，体现泰国国旗色 */
}
.hotel-card:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
}
.hotel-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-bottom: 4px solid #0033a0; /* 深蓝色边框，体现泰国国旗色 */
}
.hotel-info {
  padding: 15px;
  background-color: #fff;
}
.hotel-name {
  font-size: 1.5em;
  margin-bottom: 10px;
  color: #ffcc00; /* 黄色文本，体现泰国的皇室色 */
}
.hotel-price {
  font-size: 1.2em;
  color: #ff5733; /* 红色，体现泰国的国家力量 */
  margin-bottom: 5px;
}
.hotel-rating {
  color: #555;
  font-weight: bold;
}
</style>