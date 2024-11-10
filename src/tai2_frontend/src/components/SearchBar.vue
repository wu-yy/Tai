<template>
  <div class="search-bar">
    <select v-model="searchType" class="select-field">
      <option value="chat">{{ $t('searchBar.smartChat') }}</option>
      <option value="place">{{ $t('searchBar.placeSearch') }}</option>
    </select>
    <input v-model="searchQuery" :placeholder="$t('searchBar.placeholder')" class="input-field" />
    <button @click="onSearch" class="search-button">{{ $t('searchBar.key') }}</button>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const searchQuery = ref('');
const searchType = ref('chat'); // 默认选项为智能聊天
const router = useRouter();

const onSearch = () => {
  if (searchQuery.value.trim() !== '') {
    if (searchType.value === 'place') {
      router.push({ name: 'placeSearch', query: { input: searchQuery.value } });
    } else if (searchType.value === 'chat') {
      router.push({ name: 'chat', query: { input: searchQuery.value } });
    }
  }
};
</script>

<style scoped>
.search-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  background: #f5f7fa;
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
}

.select-field {
  display: inline-block; /* 显式设置为 inline-block 确保显示 */
  padding: 12px;
  font-size: 1em;
  border: 2px solid #ccc;
  border-radius: 8px;
  background: #fff;
  cursor: pointer;
  width: 150px; /* 固定宽度 */
}

.input-field {
  padding: 12px;
  font-size: 1em;
  border: 3px solid #ccc;
  border-radius: 8px;
  flex: 1;
  transition: border-color 0.3s, box-shadow 0.3s;
  color: #000; /* 设置文字颜色为黑色 */
}
.input-field:focus {
  border-color: #3a7bd5;
  box-shadow: 0 0 10px rgba(58, 123, 213, 0.5);
  outline: none;
}

.search-button {
  background-color: #3a7bd5;
  color: white;
  border: none;
  padding: 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.3s;
  font-weight: bold;
  white-space: nowrap;
}
.search-button:hover {
  background-color: #2d6aa6;
  transform: scale(1.05);
}

/* 手机版本支持 */
@media (max-width: 768px) {
  .search-bar {
    flex-direction: column;
    gap: 10px;
    padding: 15px;
  }
  .select-field, .input-field, .search-button {
    width: 100%; /* 在手机上元素占满整行 */
  }
}
</style>
