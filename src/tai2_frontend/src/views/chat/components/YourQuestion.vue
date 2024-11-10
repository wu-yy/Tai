/**
* create by zhangxiang on 2023-06-19 14:01
* 类注释：
* 备注：
*/
<template>
  <div class="right-message" :class="{mobile:isMobile}">
    <div style="flex: 1"></div>
    <div class="message">
      <div style="display: flex">
        <div class="time" style="color: transparent">*</div>
        <div class="operation">
          <span class="again" @click="toEdit(item)">重新编辑</span>
        </div>
      </div>
      <div class="res">
        <mavon-editor
            v-model="newItem.arr[item.selectIndex].content"
            previewBackground="transparent"
            :boxShadow="false"
            defaultOpen="preview"
            :transition="false"
            :subfield="false"
            :toolbarsFlag="false"/>
      </div>
    </div>
    <div class="icon"></div>
  </div>
</template>

<script setup>
import {defineProps, computed, defineEmits, onMounted, ref} from 'vue'
import 'mavon-editor/dist/css/index.css'
import {mavonEditor} from 'mavon-editor'
import "@/icons";
import {currentMedia} from "@/utils/tools";

const props = defineProps({
  list: {
    type: Array,
    default: () => []
  },
  item: {
    type: Object,
    default: () => {

    }
  },
  index: {
    type: Number,
    default: -1
  },
  loading: {
    type: Boolean,
    default: false
  }
})
const isMobile = ref()
const emits = defineEmits(['toEdit'])
const newItem = computed(() => {
  return props.item
})

const toEdit = (item) => {
  emits('toEdit', item)
}


onMounted(() => {
  isMobile.value = currentMedia() === 'MP'
})

</script>

<style scoped lang="less">

.right-message {
  display: flex;

  .icon {
    background: radial-gradient(50% 50% at 50% 50%, #2e3eee 0%, rgba(251, 247, 230, 0) 100%);
    width: 3vh;
    height: 3vh;
    border-radius: 50%;
  }

  .message {
    margin-right: 10px;
    line-height: 30px;
    max-width: 70%;

    .time {
      font-family: 'PingFang SC';
      font-style: normal;
      font-weight: 400;
      flex: 1;
      text-align: right;
      margin-right: 10px;
      font-size: 12px;
      line-height: 20px;
      color: rgba(77, 94, 128, 0.4);
    }

    .operation {
      font-size: 12px;
      line-height: 20px;
      color: rgba(77, 94, 128, 0.4);
      cursor: pointer;

      .again {
        cursor: pointer;
        margin: 0 10px;
      }

      .again:hover {
        color: #555;
      }
    }


    .res {
      padding: 10px;
      min-width: 100px;
      border-radius: 15px;
      box-shadow: 0 2px 3px 0 rgba(0, 0, 0, 0.1);
      background: rgba(255, 255, 255, 0.4);
      backdrop-filter: blur(10px);
      position: relative;
    }
  }
}

.right-message:hover .message .operation {
  display: block;
  -webkit-animation: fade-in-fwd 0.6s cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
  animation: fade-in-fwd 0.6s cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
}

.operation {
  display: none
}

@-webkit-keyframes fade-in-fwd {
  0% {
    -webkit-transform: translateZ(-80px);
    transform: translateZ(-80px);
    opacity: 0;
  }
  100% {
    -webkit-transform: translateZ(0);
    transform: translateZ(0);
    opacity: 1;
  }
}

@keyframes fade-in-fwd {
  0% {
    -webkit-transform: translateZ(-80px);
    transform: translateZ(-80px);
    opacity: 0;
  }
  100% {
    -webkit-transform: translateZ(0);
    transform: translateZ(0);
    opacity: 1;
  }
}

/deep/ .v-note-wrapper {
  border: none !important;
  min-height: 30px;
  min-width: 30px;
  background: transparent;
}

/deep/ .v-note-wrapper .v-note-panel .v-note-show .v-show-content, .v-note-wrapper .v-note-panel .v-note-show .v-show-content-html {
  padding: 0 !important;
  line-height: 1.8 !important;
  overflow: hidden;
}

/deep/ .hljs {
  background: rgba(51, 97, 255, 0.1) !important;
  padding: 10px;
  border-radius: 10px;
  line-height: 1.9 !important;
  font-size: 15px !important;
}

/deep/ .markdown-body blockquote, .markdown-body dl, .markdown-body ol, .markdown-body p, .markdown-body pre, .markdown-body table, .markdown-body ul {
  margin-bottom: 0 !important;
}

:deep(.markdown-body) {
  font-size: 1.15rem !important;
}

.mobile {
  width: 96vw;

  .message {
    max-width: 80%;
    line-height: 1.8;
  }

  :deep(.markdown-body) {
    font-size: .9rem !important;
  }
}


</style>