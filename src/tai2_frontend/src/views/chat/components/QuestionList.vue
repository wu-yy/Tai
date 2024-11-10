/**
* create by zhangxiang on 2023-07-20 09:32
* 类注释：
* 备注：
*/
<template>
  <div class="question-list" :class="{mobile:data.isMobile}">
    <div class="icon"></div>
    <div class="message">
      <div class="res">
        <div class="title">问卷列表</div>
        <el-row :gutter="20">
          <el-col class="item" :xs="12" :sm="8" v-for="item in data.list"
                  :key="item.surveyId" @click="loadDetail(item.surveyId)">
            {{ item.surveyName }}
          </el-col>
        </el-row>
      </div>
    </div>
  </div>
</template>

<script setup>
import {onMounted, reactive, defineEmits} from 'vue'
import {surveyList} from "@/http/api";
import {currentMedia} from "@/utils/tools";

const data = reactive({
  list: [],
  info: {},
  isMobile: false
})

const emits = defineEmits(['loadQuestionDetail'])

const loadDetail = (id) => {
  emits('loadQuestionDetail', id)
}

function loadData() {
  surveyList().then(res => {
    data.list = res.data.list
  })
}

onMounted(() => {
  loadData()
  data.isMobile = currentMedia() === 'MP'
})
</script>

<style scoped lang="less">
.question-list {
  display: flex;
  width: calc(66.6vw);
  position: relative;

  .icon {
    background: radial-gradient(50% 50% at 50% 50%, #E3B557 0%, rgba(251, 247, 230, 0) 100%);
    width: 3vh;
    height: 3vh;
    border-radius: 50%;
  }

  .message {
    margin-left: 10px;
    line-height: 30px;
    width: 70%;

    .res {
      padding: 20px;
      border-radius: 15px;
      font-size: 1.1rem;
      box-shadow: 0 2px 3px 0 rgba(0, 0, 0, 0.1);
      background: rgba(217, 217, 217, 0.3);
      position: relative;

      .title {
        font-size: 1.4rem;
        line-height: 1.6;
        margin-bottom: 10px;
        text-align: center;
      }

      .item {
        cursor: pointer;
        border-right: 1px solid white;
        padding-left: 20px !important;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
        line-height: 60px;
      }

      .item:nth-child(3n) {
        border-right: 1px solid transparent;

      }
    }
  }
}

.mobile {
  width: 90vw;

  .message {
    width: 90%;

    .res {
      .item {
        cursor: pointer;
        border-right: 1px solid white;
        padding-left: 10px !important;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
        line-height: 40px;
        font-size: 0.8rem;

      }

      .item:nth-child(3n) {
        border-right: 1px solid white;
      }

      .item:nth-child(2n) {
        border-right: 1px solid transparent !important;
      }
    }
  }
}
</style>