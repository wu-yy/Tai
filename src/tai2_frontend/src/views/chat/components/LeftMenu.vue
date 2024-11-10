/**
* create by zhangxiang on 2023-07-06 11:39
* 类注释：
* 备注：
*/
<template>
  <div class="menu">
    <div class="div-img" v-if="info.agentId===190&&userStore.info.isAdmin">
      <video v-show="!data.showPlay" src="@/assets/mp4/idle.mp4" class="img"
             autoplay loop muted
             style="border-radius: 10px"></video>
      <video v-show="data.showPlay" src="@/assets/mp4/speak_long.mp4" class="img"
             autoplay loop muted
             style="border-radius: 10px"></video>
    </div>
    <div class="div-img" v-else>
      <img class="img" :src="info.image"/>
    </div>
    <div class="bottom">
      <svg-icon icon-class="question" class-name="icon"></svg-icon>
      <ul class="list">
        <li
            v-for="(item, index) in info.agentCases"
            :key="item.questionDetail"
            :class="!index && data.play ? 'toUp' : ''"
            @click="toSearch(item)"
            @mouseenter="mouseEnter" @mouseleave="mouseLeave">
          {{ item.questionDetail }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import {computed, defineProps, onMounted, reactive, defineEmits, defineExpose} from 'vue'
import SvgIcon from "@/components/SvgIcon/SvgIconIndex.vue";
import {useUserStore} from '@/store'

const userStore = useUserStore()

const props = defineProps({
  info: {
    type: Object,
    default: () => {
    }
  }
})

const ulList = computed(() => {
  return props.info.agentCases
})

const emits = defineEmits(['toSearch'])
let timer = null
const data = reactive({
  play: false,
  showPlay: false
})

const toSearch = (item) => {
  emits('toSearch', item.questionDetail)
}

onMounted(() => {
  scrollMove();
})
const showSpeck = (val) => {
  data.showPlay = val
}

const scrollMove = () => {
  data.play = true; //开始播放
  timer = setInterval(() => {  //创建并执行定时器
    if (ulList.value) {
      ulList.value.push(ulList.value[0]); //将第一条数据塞到最后一个
      ulList.value.shift(); //删除第一条数据
    }
  }, 3000);
}

defineExpose({
  showSpeck
});

//鼠标进入
const mouseEnter = () => {
  clearInterval(timer);
}

//鼠标离开
const mouseLeave = () => {
  scrollMove();
}

</script>

<style scoped lang="less">
.menu {
  position: relative;
  height: calc(100vh - 70px);

  .img {
    height: 70vh;
    //width: 29vw;
    margin-top: 5vh;
    margin-left: 2.5vw;
  }

  .bottom {
    height: 120px;
    width: 100%;
    position: absolute;
    top: 78vh;
    left: 5vw;
    font-size: 1.1rem !important;

    .icon {
      width: 50px;
      height: 50px;
      position: absolute;
      left: -50px;
      z-index: 20;
      top: 0px;
      transform: rotate(-30deg);
    }

    .toUp {
      margin-top: -120px; /*关键样式*/
      transition: all 1.5s; /*关键样式*/
    }

    .list {
      list-style: none;
      text-align: center;
      overflow: hidden; /*关键样式*/
      height: 120px; /*关键样式*/
      padding: 0;
      margin: 0;
    }

    li {
      text-align: left;
      height: 120px; /*关键样式*/
      line-height: 40px; /*关键样式*/
      overflow: hidden;
      cursor: pointer;
      text-overflow: ellipsis;
      display: -webkit-box;
      -webkit-line-clamp: 3;
      padding-right: 7vw;
      -webkit-box-orient: vertical;
    }
  }
}
</style>