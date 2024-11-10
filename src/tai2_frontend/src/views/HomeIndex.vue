<template>
  <div class="home-page">
    <div class="banner">
      <!-- <video class="banner-video" autoplay muted loop>
        <source src="@/assets/mp4/video_th.mp4" type="video/mp4" />
        Your browser does not support the video tag.
      </video> -->
      <!-- <video class="banner-video" autoplay muted loop>
        <source src="@/assets/mp4/video_th.mp4" type="video/mp4" />
        Your browser does not support the video tag.
      </video> -->
      <!-- <img src="https://cdnfile.atomecho.cn/tai/home_backend_1.png" alt="Scenic Background" class="background-image" /> -->
      <img src="@/assets/img/home_backend_1.png" alt="Scenic Background" class="background-image" />

      <div class="banner-overlay">
        <h1>{{ $t('home.sologan') }}</h1>
        <p>{{ $t('home.promotion') }}</p>
        <SearchBar v-if="!isMobile" @search="onSearch" />
      </div>
    </div>

    <!-- 在小屏幕上显示在视频下方 -->
    <SearchBar v-if="isMobile" @search="onSearch" class="mobile-search-bar" />

    <div class="recommended-hotels section">
      <h2>{{ $t('home.recommend') }}</h2>
      <div class="hotel-cards">
        <div v-for="hotel in recommendedHotels" :key="hotel.id" class="hotel-card">
          <HotelCard :hotel="hotel" />
        </div>
      </div>
    </div>

    <div class="special-offers section">
      <h2>{{ $t('home.feature1') }}</h2>
      <div class="hotel-cards">
        <div v-for="offer in specialOffers" :key="offer.id" class="hotel-card">
          <HotelCard :hotel="offer" />
        </div>
      </div>
    </div>

    <div class="hotel-carousel section">
      <h2>{{$t('home.feature2')}}</h2>
      <div class="carousel">
        <div v-for="image in carouselImages" :key="image.id" class="carousel-item">
          <img :src="image.src" :alt="image.alt" class="carousel-image" />
        </div>
      </div>
    </div> 

    <div class="icp-payment section">
      <h2>{{ $t('home.icp1') }}</h2>
      <p>{{ $t('home.icp2') }}</p>
    </div>

    <footer class="footer">
      <div class="footer-content">
        <div class="footer-section">
          <h3>{{ $t('home.about') }}</h3>
          <p>{{ $t('home.about1') }}</p>
        </div>
        <div class="footer-section">
          <h3>{{ $t('home.contact') }}</h3>
          <p>{{ $t('home.contact1') }}</p>
        </div>
        <div class="footer-section">
          <h3>{{ $t('home.policy') }}</h3>
          <p>{{ $t('home.policy1') }}</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { useRouter } from 'vue-router';
import SearchBar from '@/components/SearchBar.vue';
import HotelCard from '@/components/HotelCard.vue';

const recommendedHotels = ref([]);
const specialOffers = ref([]);
const carouselImages = ref([]);
const router = useRouter();

// 判断屏幕是否为小屏幕的响应式变量
const isMobile = ref(window.innerWidth <= 768);

const handleResize = () => {
  isMobile.value = window.innerWidth <= 768;
};

onMounted(() => {
  window.addEventListener('resize', handleResize);
});

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize);
});

function onSearch(params) {
  router.push({ name: 'SearchResults', query: params });
}
</script>

<style scoped>
.home-page {
  font-family: "-apple-system", BlinkMacSystemFont, "Helvetica Neue", Helvetica, Arial, sans-serif;
  padding: 0px;
  background-color: #f0f8ff;
}

.banner {
  position: relative;
  /* display: flex; */
  /* align-items: center;  */
  /* justify-content: space-between; */

  height: auto; /* 设置为整个视图高度 */
  /* margin-bottom: 0; */
  margin-bottom: 0;
}

.banner-video {
  width: 100%;
  /* height: auto; */
  object-fit: cover;
}

.banner-overlay {
  position: absolute;
  /* position: relative; */
  width: 100%; /* 右边文本和搜索框占 50% 的宽度 */
  height: 100%;
  padding: 20px; /* 增加一些内边距 */
  top: 0;
  left: 0;
  min-height: auto;
  padding: 10px; /* 减少 padding 确保内容更贴合顶部 */
  background: rgba(32, 32, 32, 0.4);
  color: #ffcc00;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center; /* 调整为从顶部开始对齐 */
  text-align: left; /* 文本左对齐 */
  box-sizing: border-box;
}

.background-image {
    margin: 0;
    padding: 0;
    border: none;
    display: block;
    width: 100%;
    height: auto;
    object-fit: cover;
}

.banner-overlay h1 {
  font-size: 2rem;
  font-weight: bold;
  margin-bottom: 10px;
}

.banner-overlay p {
  font-size: 1.2rem;
  margin-bottom: 20px;
}


.recommended-hotels h2 {
  margin-top: 0;
  margin-bottom: 10px; /* 设置合适的间隔 */
}

.section {
  margin-bottom: 20px;
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
  transition: transform 0.3s, box-shadow 0.3s;
  background: linear-gradient(to bottom, #ffcc00, #ff5733);
}

.hotel-card:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
}

.hotel-card .hotel-card-content {
  padding: 15px;
  background-color: #fff;
}

.carousel {
  display: flex;
  overflow-x: auto;
  gap: 20px;
}

.carousel-item {
  flex: 0 0 auto;
  width: 300px;
  height: 200px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.carousel-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.icp-payment {
  text-align: center;
  background-color: #ffcc00;
  padding: 20px;
  border-radius: 12px;
  color: #333;
  font-weight: bold;
}

.footer {
  background-color: #333;
  color: #fff;
  padding: 20px;
  margin-top: 40px;
}

.footer-content {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.footer-section {
  flex: 1;
  margin-bottom: 10px;
}

.footer-section h3 {
  font-size: 1.2rem;
  margin-bottom: 10px;
}

.footer-section p {
  font-size: 1rem;
}

/* Mobile specific styling for SearchBar below the video */
.mobile-search-bar {
  margin-top: 20px;
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
}



/* 控制大屏幕的 video 和 banner-overlay 高度 */
@media (min-width: 769px) {
  .banner-video {
    /* height: 50%; */
    max-height: 500px; /* 设置最大高度 */
  }

  .banner-overlay {
    top: 0; /* 使 sologan 和搜索框悬浮在视频中间 */
    height: 100%; 
    transform: none;
  }
}

/* 控制小屏幕的 video 和 banner-overlay 高度 */
@media (max-width: 768px) {
  .banner {
    /* max-height: 300px; */
    height: auto; /* 根据内容自动调整高度 */
  }

  .banner-video {
    /* height: 50%;  */
    max-height: 300px; /* 小屏幕下的视频最大高度 */
    /* max-height: 300px; */
    /* object-fit: cover; */
  }

  .banner-overlay {
    position: relative;
    padding: 10px;
    min-height: auto; /* 取消高度限制，让其根据内容自动调整 */
    top: auto;
    transform: none;
  }

  .banner-overlay h1 {
    font-size: 1.5rem;
    margin-bottom: 8px;
  }

  .banner-overlay p {
    font-size: 1rem;
    margin-bottom: 15px;
  }

  .mobile-search-bar {
    margin-top: 20px;
    width: 100%;
    max-width: 800px;
    margin: 0 auto;
  }
}

</style>
