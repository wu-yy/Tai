<template>
    <div class="web3-hotel-page">
      <h1>{{ $t('activity.title') }}</h1>
      
      <div class="features">
        <div class="feature" v-for="(feature, index) in features" :key="index">
          <h3>{{ feature.title[currentLang] }}</h3>
          <p>{{ feature.description[currentLang] }}</p>
        </div>
      </div>

      <div class="gallery">
        <h2>{{ $t('activity.hotel') }}</h2>
        <div class="image-row" v-for="(row, index) in imageRows" :key="index">
          <img v-for="(image, imageIndex) in row" :src="image" :alt="'Hotel Image ' + imageIndex" class="gallery-image" :key="imageIndex" />
        </div>
      </div>

    </div>
  </template>
  
  <script setup>
  import { ref, watch } from 'vue';
  import { useI18n } from 'vue-i18n';
  
  const { locale } = useI18n();
  const currentLang = ref(locale.value);
  
  // 监听 locale 变化
  watch(locale, (newLocale) => {
    currentLang.value = newLocale;
  });
  
  const features = [
      {
          title: {
              'zh-cn': "资源丰富",
              'en-us': "Abundant Resources",
              'th-th': "ทรัพยากรที่หลากหลาย"
          },
          description: {
              'zh-cn': "我们整合了携程、去哪儿、Booking等平台的酒店资源，为您提供更全面的选择。",
              'en-us': "We integrate hotel resources from platforms like Ctrip, Qunar, and Booking to provide you with a wider selection.",
              'th-th': "เราได้รวบรวมทรัพยากรจากแพลตฟอร์มโรงแรม เช่น Ctrip, Qunar, และ Booking เพื่อให้คุณมีทางเลือกที่หลากหลายมากขึ้น"
          }
      },
      {
          title: {
              'zh-cn': "智能 AI 对话搜索",
              'en-us': "AI-Powered Smart Search",
              'th-th': "การค้นหาอัจฉริยะด้วย AI"
          },
          description: {
              'zh-cn': "支持智能 AI 对话，您可以通过对话方式快速搜索到合适的酒店，极大提升便捷性。",
              'en-us': "Supports smart AI conversations, allowing you to quickly find suitable hotels with convenient dialog-based search.",
              'th-th': "รองรับการสนทนาด้วย AI ช่วยให้คุณสามารถค้นหาโรงแรมได้อย่างสะดวกรวดเร็ว"
          }
      },
      {
          title: {
              'zh-cn': "免除税费",
              'en-us': "Tax-Free",
              'th-th': "ปลอดภาษี"
          },
          description: {
              'zh-cn': "Tai平台免除税费，为用户和酒店双方提供更多实惠。",
              'en-us': "The Tai platform is tax-free, providing more benefits for both users and hotels.",
              'th-th': "แพลตฟอร์มโรงแรม Web3 ไม่มีภาษี มอบความคุ้มค่าให้กับทั้งผู้ใช้และโรงแรม"
          }
      },
      {
          title: {
              'zh-cn': "酒店资源可交易",
              'en-us': "Hotel Resources are Tradable",
              'th-th': "ทรัพยากรของโรงแรมสามารถซื้อขายได้"
          },
          description: {
              'zh-cn': "好的酒店资源可以自由交易，酒店方与顾客均可从中受益。",
              'en-us': "Quality hotel resources are freely tradable, benefiting both hotel operators and customers.",
              'th-th': "ทรัพยากรโรงแรมที่มีคุณภาพสามารถซื้อขายได้ ซึ่งเป็นประโยชน์ต่อทั้งโรงแรมและลูกค้า"
          }
      },
      {
          title: {
              'zh-cn': "支持地图搜索",
              'en-us': "Map-Based Search",
              'th-th': "การค้นหาบนแผนที่"
          },
          description: {
              'zh-cn': "用户可以在地图上直观搜索到目标酒店，实现便捷预定。",
              'en-us': "Users can visually search for hotels on the map for convenient booking.",
              'th-th': "ผู้ใช้สามารถค้นหาโรงแรมบนแผนที่ได้อย่างสะดวกเพื่อการจองที่ง่ายดาย"
          }
      }
  ];
  
  const images = [
      // '@/assets/img/activity_1.png',
      // '@/assets/img/activity_2.png',
      // '@/assets/img/activity_3.png',
      new URL('@/assets/img/activity_1.png', import.meta.url).href,
      new URL('@/assets/img/activity_2.png', import.meta.url).href,
      new URL('@/assets/img/activity_3.png', import.meta.url).href
  ];
  
  // 将图片分成每行3张
  const imageRows = ref([]);
  for (let i = 0; i < images.length; i += 3) {
    imageRows.value.push(images.slice(i, i + 3));
  }
  </script>
  
  <style scoped>
  .web3-hotel-page {
    max-width: 1200px;
    margin: 0 auto;
    padding: 30px;
    font-family: 'Sukhumvit Set', Arial, sans-serif;
    background-color: #fff5e1;
    color: #333;
  }
  
  h1 {
    text-align: center;
    color: #d62929; /* 红色 */
    font-size: 2.5rem;
    font-weight: bold;
    margin-bottom: 40px;
  }
  
  .features {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    margin-bottom: 40px;
  }
  
  .feature {
    flex: 1 1 calc(50% - 20px);
    background-color: #fff3d4; /* 浅黄色背景 */
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
    border-left: 8px solid #ffd700; /* 金色左边框 */
    transition: transform 0.2s;
  }
  
  .feature:hover {
    transform: translateY(-5px);
  }
  
  .feature h3 {
    color: #1a73e8; /* 蓝色标题 */
    font-size: 1.25rem;
    font-weight: bold;
  }
  
  .feature p {
    color: #555;
    font-size: 1rem;
    margin-top: 10px;
  }
  
  .gallery {
    margin-top: 50px;
  }
  
  .gallery h2 {
    text-align: center;
    color: #d62929; /* 红色 */
    font-size: 2rem;
    margin-bottom: 30px;
  }
  
  .image-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
  }
  
  .gallery-image {
    width: calc(33% - 10px);
    border-radius: 10px;
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
    object-fit: cover;
    border: 4px solid #ffd700; /* 金色边框 */
    transition: transform 0.3s;
  }
  
  .gallery-image:hover {
    transform: scale(1.05);
  }
  </style>
  