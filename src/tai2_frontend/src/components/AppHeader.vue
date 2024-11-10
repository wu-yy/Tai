<template>
  <div
    class="sticky top-0 bg-gradient-to-r from-yellow-400 via-blue-500 to-red-500 z-50 w-full h-16 lg:h-20 flex justify-between items-center px-6 lg:px-12 xl:px-16 text-white shadow-md">
    <!-- Logo 和标题部分 -->
    <div class="flex items-center">
      <img src="@/assets/img/logo.png" alt="" class="h-8 md:h-10 cursor-pointer mr-4" @click="toNav('/')">
    </div>

    <!-- 中间导航菜单部分 -->
    <div class="hidden md:flex items-center justify-center space-x-6">
      <div class="header-middle-item" @click="toNav('/')">{{ $t('header.hotel') }}</div>
      <div class="header-middle-item" @click="toNav('/chat')">{{ $t('header.chat') }}</div>
      <div class="header-middle-item" @click="() => { userStore.setGallery('explore'); toNav('/trade') }">{{ $t('header.trade') }}</div>
      <div class="header-middle-item" @click="toNav('/activity')">{{ $t('header.about') }}</div>
    </div>

    <!-- 右侧操作部分 -->
    <div class="flex items-center space-x-4">
      <!-- 登录和注册按钮 -->
      <div v-if="!userStore.getIsLogin" class="hidden md:flex space-x-4">
        <button class="header-right-item text-blue-700 font-semibold hover:text-red-500 transition duration-300" @click="toNav('/login')">
          {{ $t('header.logIn') }}
        </button>
        <!-- <button class="header-right-item text-blue-700 font-semibold hover:text-red-500 bg-yellow-300 px-4 py-2 rounded-md" @click="toNav('/register')">
          {{ $t('header.register') }}
        </button> -->
      </div>

      <div class="header-right-item relative" @click="toggleWalletMenu" v-clickOutside="closeWalletMenu">
        <span>{{ $t('header.connectWallet') }}</span>
        <!-- 钱包菜单 -->
        <div v-if="data.showWalletMenu" class="wallet-menu">
          <div class="header-right-menu" @click="toConnectPlug">Plug</div>
          <div class="header-right-menu" @click="toConnectCoinbase">Coinbase</div>
          <div class="header-right-menu" @click="toConnectMetaMask">MetaMask</div>
          <div class="header-right-menu" @click="toConnectTronLink">TronLink</div>
        </div>
      </div>

      <!-- 语言切换 -->
      <div class="header-right-item relative" @click="data.showLangMenu = !data.showLangMenu" v-clickOutside="closeLangMenu">
        <img v-if="data.lang === 'zh-cn'" src="@/assets/img/chinese.png" alt="" class="w-6 h-6">
        <img v-else-if="data.lang === 'en-us'" src="@/assets/img/english.png" alt="" class="w-6 h-6">
        <img v-else src="@/assets/img/english.png" alt="" class="w-6 h-6">
        <div class="absolute right-0 top-14 w-max bg-yellow-400 rounded-lg shadow-lg lg:p-3 p-1" v-show="data.showLangMenu">
          <div class="header-right-menu" @click="changeLang('en-us')">English</div>
          <div class="header-right-menu" @click="changeLang('zh-cn')">中文</div>
          <div class="header-right-menu" @click="changeLang('th-th')">ไทย</div>
        </div>
      </div>

      <!-- 菜单按钮，确保在所有屏幕上都可见 -->
      <div class="header-right-item relative" @click="data.showMenu = !data.showMenu" v-clickOutside="closeMenu">
      <img src="@/assets/img/menu.png" alt="" class="w-6 h-6 cursor-pointer">

      <!-- 折叠菜单 -->
      <div class="absolute right-0 top-14 w-max bg-yellow-400 rounded-lg shadow-lg lg:p-3 p-1" v-show="data.showMenu">
        <!-- 在手机上可见的所有选项 -->
        <div class="header-right-menu lg:hidden" @click="toNav('/')">{{ $t('header.hotel') }}</div>
        <div class="header-right-menu lg:hidden" @click="toNav('/chat')">{{ $t('header.chat') }}</div>
        <div class="header-right-menu lg:hidden" @click="toNav('/activity')">{{ $t('header.activity') }}</div>
        <div class="header-right-menu lg:hidden" @click="() => { userStore.setGallery('explore'); toNav('/') }">{{ $t('header.uphotel') }}</div>
        
        <!-- 在所有屏幕上可见的选项 -->
        <!-- <div class="header-right-menu" @click="toConnectOisy">{{ $t('header.oisy') }}</div>
        <div class="header-right-menu" @click="toConnectWallet">{{ $t('header.connectWallet') }}</div> -->
        <!-- <div class="header-right-item relative" @click="data.showWalletMenu = !data.showWalletMenu" v-clickOutside="closeWalletMenu">
            <span>{{ $t('header.connectWallet') }}</span>
            <div class="absolute right-0 top-14 w-max bg-yellow-400 rounded-lg shadow-lg lg:p-3 p-1" v-show="data.showWalletMenu">
              <div class="header-right-menu" @click="toConnectPlug">Plug</div>
              <div class="header-right-menu" @click="toConnectCoinbase">Coinbase</div>
              <div class="header-right-menu" @click="toConnectMetaMask">MetaMask</div>
              <div class="header-right-menu" @click="toConnectTronLink">TronLink</div>
            </div>
        </div> -->

        <div class="header-right-menu" @click="toNav('/profile')" v-if="userStore.getIsLogin">{{ $t('header.profile') }}</div>
        <div class="header-right-menu" @click="toNav('/register')" v-if="!userStore.getIsLogin">{{ $t('header.register') }}</div>
        <div class="header-right-menu" @click="loginOut" v-if="userStore.getIsLogin">{{ $t('header.logOut') }}</div>
        <div class="header-right-menu" @click="toNav('/login')" v-else>{{ $t('header.logIn') }}</div>
      </div>
    </div>

    </div>
  </div>
</template>


<script setup>
import { reactive, defineExpose, onMounted, watch, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { debounce } from 'lodash';
import { useUserStore } from "@/store";

import { logout } from "@/http/api/user";
import { loginInfo } from "@/http/api"
import { getSession, clearSession, setSession} from '@/utils/tools'
import { ClickOutside as vClickOutside } from 'element-plus'
import eventBus from '@/utils/eventBus';
import { AuthClient } from '@dfinity/auth-client';

import CoinbaseWalletSDK from '@coinbase/wallet-sdk';

const userStore = useUserStore()
const route = useRoute()
const router = useRouter()
const { locale } = useI18n()

const authClient = ref(null);
const isAuthenticated = ref(false);
const loading = ref(false);
const result = ref('');

const data = reactive({
  lang: "en-us",
  curPathName: "",
  showMenu: false,
  showLangMenu: false,
  showWalletMenu: false, // 新增用于钱包选择菜单的状态
})

watch(() => route.name, (newVal) => {
  data.curPathName = newVal
})

const toNav = (url) => {
  router.push(url)
}

watch(() => userStore.isLogin, () => {
  // loginInfo().then(res => {
  //   data.lastTime = res.data.time
  //   data.level = res.data.level
  // })
})

eventBus.on("refresh", () => {
  // loginInfo().then(res => {
  //   data.lastTime = res.data.time
  //   data.level = res.data.level
  // })
})

const initAuth = async () => {
  authClient.value = await AuthClient.create();
  isAuthenticated.value = await authClient.value.isAuthenticated();
};

const toConnectOisy = async () => {
  loading.value = true;

  if (!authClient.value) return;

  await new Promise((resolve, reject) => {
    authClient.value.login({
      identityProvider: 'https://identity.ic0.app',
      onSuccess: () => {
        isAuthenticated.value = true;
        loading.value = false;
        resolve(null);
      },
      onError: () => {
        loading.value = false;
        reject();
      }
    });
  });
};

const toConnectPlug = () => {
  (async () => {
    try {
      const publicKey = await window.ic.plug.requestConnect();
      console.log(`The connected user's public key is:`, publicKey);
    } catch (e) {
      console.log(e);
    }
    const result = await window.ic.plug.isConnected();
    console.log(`Plug connection is ${result}`);
    const sessionData = window.ic.plug.sessionManager.sessionData;
    console.log("87 sessionData", sessionData);
    localStorage.setItem('plug_authToken', sessionData.accountId)
    localStorage.setItem('plug_account', sessionData.accountId)
    userStore.setWalletConnected(true)
    userStore.setWalletAccount(sessionData.accountId)
  })();
}

const toggleWalletMenu = () => {
  data.showWalletMenu = !data.showWalletMenu;
};


const toConnectCoinbase = async () => {
  try {
    // 配置 Coinbase Wallet SDK
    const coinbaseWallet = new CoinbaseWalletSDK({
      appName: 'Tai', // 替换为你的应用名称
      appLogoUrl: 'https://example.com/your-logo.png', // 替换为你的 logo URL
      darkMode: false,
    });

    // 配置 Ethereum 网络 (例如 Mainnet)
    const ethereum = coinbaseWallet.makeWeb3Provider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID', 1);

    // 请求用户连接钱包
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });

    if (accounts && accounts.length > 0) {
      console.log('Coinbase Wallet connected:', accounts[0]);
      // 在这里保存用户的钱包地址，例如在 Vuex、Pinia 或 localStorage 中
    } else {
      console.error('No accounts found.');
    }
  } catch (error) {
    console.error('Failed to connect Coinbase Wallet:', error);
  }
};

const toConnectMetaMask = async () => {
  if (window.ethereum) {
    try {
      await window.ethereum.request({ method: 'eth_requestAccounts' });
      console.log('MetaMask connected');
    } catch (error) {
      console.error('Error connecting to MetaMask:', error);
    }
  } else {
    console.error('MetaMask is not installed');
  }
};

const toConnectTronLink = async () => {
  if (window.tronWeb && window.tronWeb.defaultAddress.base58) {
    console.log('TronLink connected');
  } else {
    console.error('TronLink is not installed or not connected');
  }
};

// 关闭钱包菜单的函数
const closeWalletMenu = () => {
  data.showWalletMenu = false;
};

// const changeLang = debounce(() => {
//   if (locale.value === "zh-cn") {
//     locale.value = "en-us"
//     data.lang = "en-us"
//     setSession("lang", "en-us")
//   } else {
//     locale.value = "zh-cn"
//     data.lang = "zh-cn"
//     setSession("lang", "zh-cn")
//   }
// }, 500, { leading: true, trailing: false })

const changeLang = debounce((lang) => {
  locale.value = lang;
  data.lang = lang;
  setSession("lang", lang);
}, 500, { leading: true, trailing: false })


const closeLangMenu = () => {
  if (data.showLangMenu) {
    data.showLangMenu = false;
  }
};

const closeMenu = () => {
  if (data.showMenu) {
    data.showMenu = false;
  }
};

const loginOut = debounce(async () => {
  logout({
    atomechoSession: getSession("session"),
  }).then(() => {
    if (authClient.value) {
      loading.value = true;
      authClient.value.logout();
      isAuthenticated.value = false;
      loading.value = false;
    }
    clearSession()
    userStore.setIsLogin(false)
    localStorage.setItem('plug_authToken', '')
    localStorage.setItem('plug_account', '')
    userStore.setWalletConnected(false)
    userStore.setWalletAccount('')
    data.lastTime = 0
    router.push('/')
  })
}, 2000, { leading: true, trailing: false })

defineExpose({
  data
})


onMounted(async () => {
  await initAuth();

  if (!userStore.walletConnected) {
    try {
      console.log("71 ---> userStore.walletConnected", userStore.walletConnected);
      const connected = await window.ic.plug.isConnected();
      console.log("73 connected", connected);
      if (connected) {
        const sessionData = window.ic.plug.sessionManager.sessionData;
        console.log("77 sessionData", sessionData);
        localStorage.setItem('plug_authToken', sessionData.accountId)
        localStorage.setItem('plug_account', sessionData.accountId)
        userStore.setWalletConnected(true)
        userStore.setWalletAccount(sessionData.accountId)
      } else {
        console.log("80 not connected");
      }
    } catch (error) {
      console.log("75 error", error);
    }
  } else {
    console.log("81 userStore.walletConnected", userStore.walletConnected);
  }

  data.lang = locale.value
  if (route.name) {
    data.curPathName = route.name
  }
  loginInfo().then(res => {
    // data.lastTime = res.data.time
    // data.level = res.data.level
    if (res.data.userId)
      userStore.isLogin = true;
    else
      userStore.isLogin = false;
  })
})
</script>

<style scoped lang="less">
.header-middle-item {
  @apply cursor-pointer font-semibold text-lg tracking-wide;
}
.header-right-item {
  @apply cursor-pointer font-semibold text-base;
}
.header-right-menu {
  @apply text-center p-2 text-base lg:text-lg text-blue-700 hover:text-red-500 transition duration-300;
}

.wallet-menu {
  position: absolute;
  top: 100%;
  right: 0;
  z-index: 100;
  background-color: #ffc107;
  border-radius: 5px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
  padding: 10px;
}

</style>