<template>
  <div class="booking-confirmation-page">
    <h1>预订确认</h1>
    <form @submit.prevent="confirmBooking" class="confirmation-form">
      <div class="form-group">
        <label>姓名</label>
        <input v-model="bookingInfo.name" required class="input-field" />
      </div>
      <div class="form-group">
        <label>邮箱</label>
        <input v-model="bookingInfo.email" type="email" required class="input-field" />
      </div>
      <div class="form-group">
        <label>支付信息</label>
        <input v-model="bookingInfo.payment" required class="input-field" />
      </div>
      <button type="submit" class="confirm-button">确认预订</button>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import axios from 'axios';

const bookingInfo = ref({
  name: '',
  email: '',
  payment: ''
});
const router = useRouter();
const route = useRoute();

function confirmBooking() {
  const roomId = route.query.roomId;
  axios.post('/api/bookings', { ...bookingInfo.value, roomId }).then(response => {
    console.log("response:", response)
    router.push('/confirmation-success');
  });
}
</script>

<style scoped>
.booking-confirmation-page {
  font-family: Arial, sans-serif;
  padding: 20px;
  max-width: 600px;
  margin: 0 auto;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border-radius: 8px;
}
.confirmation-form {
  display: flex;
  flex-direction: column;
}
.form-group {
  margin-bottom: 20px;
}
.input-field {
  padding: 10px;
  font-size: 1em;
  border: 1px solid #ddd;
  border-radius: 8px;
}
.confirm-button {
  background-color: #ff6f61;
  color: white;
  border: none;
  padding: 10px;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.confirm-button:hover {
  background-color: #e65c50;
}
</style>