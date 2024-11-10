import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import ElementPlus from "element-plus";
import "element-plus/dist/index.css";
import zhCn from "element-plus/dist/locale/zh-cn.mjs";
import "./assets/css/index.css";


// import './index.scss';
// import App from './App.vue';
const app = createApp(App);
app.use(ElementPlus, {
	locale: zhCn,
});

// step1
import * as ElementPlusIconsVue from "@element-plus/icons-vue";
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
	app.component(key, component);
}

// 这里debug
// import "@/icons/index"; // 将src/icons/index.js引入

import SvgIcon from "./components/SvgIcon/SvgIconIndex.vue"; // 引入SvgIcon.vue
import { setupStore } from "./store";

import directive from "./directive"; // directive
directive(app);

import i18n from "./language";
app.use(i18n);

setupStore(app);
app.use(router);
app.component("svg-icon", SvgIcon);
app.mount('#app');

