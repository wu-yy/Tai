<template>
  <AppHeader></AppHeader>
  <div class="app">
    <router-view v-if="isRouterAlive"></router-view>
  </div>
</template>

<script setup>
import AppHeader from '@/components/AppHeader.vue'
import { ref, provide, nextTick } from 'vue';
import { useUserStore } from '@/store'

const isRouterAlive = ref(true);
const userStore = useUserStore()

// ERROR ResizeObserver loop completed with undelivered notifications.
const debounce = (fn, delay) => {
  let timer = null;
  return function () {
    let context = this;
    let args = arguments;
    clearTimeout(timer);
    timer = setTimeout(function () {
      fn.apply(context, args);

    }, delay);
  }
}
const _ResizeObserver = window.ResizeObserver;
window.ResizeObserver = class ResizeObserver extends _ResizeObserver {
  constructor(callback) {
    callback = debounce(callback, 16);
    super(callback);
  }
}
userStore.setIsLogin(!!localStorage.getItem('neverendsart_authToken'))

// plug钱包是不是链接了
userStore.setWalletConnected(!!localStorage.getItem('plug_authToken'))

provide("reload", () => {
  isRouterAlive.value = false;
  nextTick(() => {
    isRouterAlive.value = true;
  })
});

</script>

<style>
#app {
  font-family: Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
