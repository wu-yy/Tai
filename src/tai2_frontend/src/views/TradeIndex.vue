<template>
    <div class="container">
      <button @click="showModal = true" class="upload-button">{{ $t('trade.uploadButton') }}</button>
  
      <div class="card">
        <table>
          <thead>
            <tr>
              <th>{{ $t('trade.rank') }}</th>
              <th>{{ $t('trade.hotel') }}</th>
              <th>{{ $t('trade.trend') }}</th>
              <th>{{ $t('trade.floorPrice') }}</th>
              <th>{{ $t('trade.volume') }}</th>
              <th>{{ $t('trade.long') }}</th>
              <th>{{ $t('trade.short') }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="hotel in hotels" :key="hotel.rank">
              <td>{{ hotel.rank }}</td>
              <td>
                <div class="hotel-info">
                  <img :src="hotel.image" :alt="hotel.name[currentLang]" class="hotel-image" />
                  <div>
                    <div class="hotel-name">{{ hotel.name[currentLang] }}</div>
                    <div v-if="hotel.verified" class="verified">{{ $t('trade.verified') }}</div>
                  </div>
                </div>
              </td>
              <td><canvas :id="`chart-${hotel.rank}`" class="trend-chart"></canvas></td>
              <td>{{ currencyFormatter(hotel.floorPrice) }}</td>
              <td>{{ currencyFormatter(hotel.volume) }}</td>
              <td>
                <button class="trade-button short">Short</button>
              </td>
              <td>
                <button class="trade-button long">{{ $t('trade.long') }}</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  
      <div v-if="showModal" class="modal" @click.self="showModal = false">
        <div class="modal-content">
          <span @click="showModal = false" class="close">&times;</span>
          <h2>{{ $t('trade.uploadButton') }}</h2>
          <form @submit.prevent="submitForm">
            <label>{{ $t('trade.hotel') }}:</label>
            <input v-model="form.name" type="text" required />
  
            <label>{{ $t('trade.floorPrice') }}:</label>
            <input v-model="form.price" type="number" required />
  
            <label>{{ $t('trade.description') }}:</label>
            <textarea v-model="form.description" required></textarea>
  
            <label>Image URL:</label>
            <input v-model="form.image" type="url" required />
  
            <button type="submit">{{ $t('trade.submit') }}</button>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { useI18n } from 'vue-i18n';
  import Chart from 'chart.js/auto';
  
  const { locale } = useI18n();
  const currentLang = locale.value;
  
  const hotels = ref([
    {
      rank: 1,
      name: { 'zh-cn': "山水度假酒店", 'en-us': "Landscape Resort Hotel", 'th-th': "โรงแรมรีสอร์ทวิวทิวทัศน์" },
      image: "https://cdnfile.atomecho.cn/tai/hotel_1.png",
      verified: true,
      floorPrice: 688,
      volume: 234500,
    },
    {
      rank: 2,
      name: { 'zh-cn': "城市豪华公寓", 'en-us': "City Luxury Apartments", 'th-th': "อพาร์ทเมนท์หรูในเมือง" },
      image: "https://cdnfile.atomecho.cn/tai/hotel_2.png",
      verified: true,
      floorPrice: 888,
      volume: 198000,
    },
    {
      rank: 3,
      name: { 'zh-cn': "海景民宿", 'en-us': "Sea View Homestay", 'th-th': "โฮมสเตย์วิวทะเล" },
      image: "https://cdnfile.atomecho.cn/tai/hotel_3.png",
      verified: false,
      floorPrice: 528,
      volume: 167300,
    },
    {
      rank: 4,
      name: { 'zh-cn': "森林木屋度假村", 'en-us': "Forest Cabin Resort", 'th-th': "รีสอร์ทกระท่อมในป่า" },
      image: "https://cdnfile.atomecho.cn/tai/hotel_4.png",
      verified: true,
      floorPrice: 1288,
      volume: 456700,
    },
    {
      rank: 5,
      name: { 'zh-cn': "古镇客栈", 'en-us': "Ancient Town Inn", 'th-th': "โรงแรมในเมืองโบราณ" },
      image: "https://cdnfile.atomecho.cn/tai/hotel_5.png",
      verified: false,
      floorPrice: 468,
      volume: 145200,
    },
  ]);
  
  const showModal = ref(false);
  const form = ref({ name: '', price: '', description: '', image: '' });
  
  function currencyFormatter(value) {
    return new Intl.NumberFormat(currentLang === 'en-us' ? 'en-US' : currentLang === 'th-th' ? 'th-TH' : 'zh-CN', {
      style: 'currency',
      currency: currentLang === 'en-us' ? 'USD' : currentLang === 'th-th' ? 'THB' : 'CNY',
    }).format(value);
  }
  
  function submitForm() {
    console.log("Form submitted:", form.value);
    showModal.value = false;
  }
  
  onMounted(() => {
    hotels.value.forEach((hotel) => {
      const ctx = document.getElementById(`chart-${hotel.rank}`);
      new Chart(ctx, {
        type: 'line',
        data: {
          labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          datasets: [
            {
              data: Array.from({ length: 6 }, () => Math.floor(Math.random() * 100)),
              borderColor: '#ff0000',
              backgroundColor: 'rgba(255, 0, 0, 0.1)',
              tension: 0.4,
              pointRadius: 0,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: {
            x: { display: false },
            y: { display: false },
          },
        },
      });
    });
  });
  </script>
  
  <style scoped>
  .container {
    max-width: 1000px;
    margin: 40px auto;
    padding: 0 20px;
  }
  
  .card {
    background-color: #ffffff;
    border-radius: 18px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 0 0 5px #ffc107;
    overflow: hidden;
    border: 2px solid #ffc107;
  }
  
  table {
    width: 100%;
    border-collapse: collapse;
  }
  
  th, td {
    padding: 16px;
    text-align: left;
    border-bottom: 1px solid #d2d2d7;
  }
  
  th {
    font-weight: 600;
    color: white;
    text-transform: uppercase;
    font-size: 12px;
    background-color: #2196f3;
  }
  
  .hotel-info {
    display: flex;
    align-items: center;
  }
  
  .hotel-image {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    margin-right: 16px;
    object-fit: cover;
  }
  
  .hotel-name {
    font-weight: 500;
  }
  
  .verified {
    display: flex;
    align-items: center;
    color: #4caf50;
    font-size: 12px;
    margin-top: 4px;
  }
  
  .verified::before {
    content: '✓';
    margin-right: 4px;
  }
  
  .trend-chart {
    width: 100px;
    height: 60px;
    max-height: 60px;
    background-color: rgba(255, 255, 255, 0.8);
    border-radius: 5px;
    padding: 5px;
  }
  
  .upload-button {
    background-color: #2196f3;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 10px 20px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin-bottom: 20px;
  }
  
  .upload-button:hover {
    background-color: #d7e935;
    color: rgb(45, 15, 194);
  }
  
  .modal {
    display: block;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.4);
  }
  
  .modal-content {
    background-color: #fefefe;
    margin: 15% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
    max-width: 500px;
    border-radius: 10px;
  }
  
  .close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
  }
  
  .close:hover,
  .close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
  }
  
  .modal-content h2 {
    margin-top: 0;
    color: #2196f3;
  }
  
  .modal-content form {
    display: flex;
    flex-direction: column;
  }
  
  .modal-content label {
    margin-top: 10px;
  }
  
  .modal-content input,
  .modal-content textarea {
    margin-top: 5px;
    padding: 5px;
    border: 1px solid #ddd;
    border-radius: 4px;
  }
  
  .modal-content button {
    margin-top: 20px;
    padding: 10px;
    background-color: #2196f3;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  
  .modal-content button:hover {
    background-color: #d7e935;
    color: rgb(45, 15, 194);
  }
  
  .trade-button {
    padding: 6px 12px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
    transition: background-color 0.3s ease;
  }
  
  .trade-button.long {
    background-color: #d7e935;
    color: rgb(45, 15, 194);
  }
  
  .trade-button.short {
    background-color: #d7e935;
    color: rgb(45, 15, 194);
  }
  
  .trade-button:hover {
    opacity: 0.8;
  }
  </style>