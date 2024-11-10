
import { createRouter, createWebHistory } from "vue-router";

import {store} from "@/store";
import {useUserStore} from "@/store";
import {getUserInfo} from "@/http/api/user";

// import {getSession} from "@/utils/tools";

import Home from '@/views/HomeIndex.vue';
import SearchResults from '@/views/SearchResults.vue';
import HotelDetails from '@/views/HotelDetails.vue';
import Login from '@/views/LoginIndex.vue';
import Register from '@/views/RegisterIndex.vue';
import BookingConfirmation from '@/views/BookingConfirmation.vue';
import Profile from '@/views/ProfileIndex.vue';
import HotelMap from '@/components/HotelMap.vue';
import Trade from '@/views/TradeIndex.vue';
import Activity from '@/views/ActivityIndex.vue';

const userStore = useUserStore(store);

const constantRoutes =  [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/search-results',
      name: 'SearchResults',
      component: SearchResults
    },
    {
      path: '/hotel/:id',
      name: 'HotelDetails',
      component: HotelDetails
    },
    {
      path: '/trade',
      name: 'Trade',
      component: Trade
    },
    {
      path: '/activity',
      name: 'Activity',
      component: Activity
    },
    {
      path: '/login',
      name: 'Login',
      component: Login
    },
    {
        path : '/register',
        name: 'Register',
        component: Register
    },
    {
      path: '/booking-confirmation',
      name: 'BookingConfirmation',
      component: BookingConfirmation
    }
  ]

export const routes = [
  ...constantRoutes,
  {
    path: '/chat',
    name: 'chat',
    component: () => import('@/views/chat/ChatIndex.vue'),
  },
  {
    path: '/placeSearch',
    name: 'placeSearch',
    component: () => HotelMap,
  },
  {
    path: '/profile',
    name: 'profile',
    omponent: () => Profile,
  },
];

const router = createRouter({
	history: createWebHistory(),
	routes,
});

router.beforeEach((to, from, next) => {
  console.log("68 login", userStore.isLogin);
  if (userStore.isLogin) {
    const token = localStorage.getItem('neverendsart_authToken')
    if (token) {
      getUserInfo({
          neverendsSession: token,
          appCode: "nes",
      }).then((res) => {
          userStore.setInfo(res.data);
          next();
      }).catch(() => {
          next({
              path: '/login',
              query: {redirect: to.fullPath}  // 将跳转的路由path作为参数，登录成功后跳转到该路由
          });
      });
    } else {
      next({
        path: '/login',
        query: {redirect: to.fullPath}  // 将跳转的路由path作为参数，登录成功后跳转到该路由
      });
    }
  } else {
      if (constantRoutes.some((item) => item.path === to.path)) {
          next();
      } else {
          next({
              path: '/login',
              query: {redirect: to.fullPath}  // 将跳转的路由path作为参数，登录成功后跳转到该路由
          });
      }
  }
});

router.afterEach((to) => {
	// 一定要再afterEach中判断而不是beforeEach，因为beforeEach在点击返回之后获取到的值不准确，每返回一次，会获取到延后一次的to、history
	if (window.history.state && window.history.state.forward) {
		// 或者判断 to.forward,window.history.state.forward是vue-router写入的，当返回或前进的时候才会有值
		to.meta.isBack = true;
	} else {
		to.meta.isBack = false;
	}
});


export default router;