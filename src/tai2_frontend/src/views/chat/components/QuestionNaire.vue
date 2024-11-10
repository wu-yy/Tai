/**
* create by zhangxiang on 2023-07-18 17:02
* 类注释：
* 备注：
*/
<template>
  <div class="question-detail" :class="{mobile:data.isMobile}">
    <div class="icon"></div>
    <div class="message">
      <div class="agent-flex">
        <div class="time">{{ item.time }}</div>
      </div>
      <div class="res">
        <div class="title">{{ data.info.surveyName }}</div>
        <div class="dis">{{ data.info.surveyPreface }}</div>
        <el-form
            ref="refForm"
            :disabled="!!showJson.list"
            :model="formData"
            label-position="top"
            scroll-to-error
            :rules="data.rules">
          <el-form-item
              v-for="(item,index) in data.list"
              :key="item.questionId"
              :label="`${index+1}、${item.question}`"
              :prop="item.questionId">
            <template v-if="item.type==='radio'">
              <el-radio-group v-model="formData[item.questionId]">
                <el-radio v-for="radio in item.options" :key="radio.id" :label="radio.id">
                  {{ radio.content }}
                </el-radio>
              </el-radio-group>
            </template>
            <template v-if="item.type==='multiple'">
              <el-checkbox-group v-model="formData[item.questionId]">
                <el-checkbox v-for="radio in item.options" :key="radio.id" :label="radio.id">
                  {{ radio.content }}
                </el-checkbox>
              </el-checkbox-group>
            </template>
            <template v-if="item.type==='blanks'">
              <el-input v-model="formData[item.questionId]" type="textarea" :autosize="{maxRows:8,minRows:3}">
              </el-input>
            </template>
          </el-form-item>
          <div style="text-align: center" v-show="!data.estimate">
            <el-button type="primary" @click="toSubmit" class="button-submit">提交</el-button>
          </div>
          <el-form-item v-if="data.estimate">
            <div style="margin-left: 20px;font-size: 1.1rem">{{ data.estimate }}</div>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script setup>
import {defineProps, onMounted, reactive, ref, toRefs} from 'vue'
import {currentMedia} from "@/utils/tools";
import {surveyDetail, surveySubmit} from "@/http/api";
import {ElMessage} from "element-plus";
import {cloneDeep} from "lodash";

const props = defineProps({
  id: {
    type: Number,
    default: -1
  },
  agentInfo: {
    type: Object,
    default: () => {
    }
  },
  item: {
    type: Object,
    default: () => {
    }
  },
  showJson: {
    type: Object,
    default: () => {
    }
  }
})

const refForm = ref()

const data = reactive({
  list: [],
  info: {},
  rules: {},
  surveyIntro: '',
  formData: {},
  isMobile: false,
  scoreResult: {},
  estimate: "",
})

const {formData} = toRefs(data)

// 加载数据
function loadData() {
  surveyDetail({surveyId: props.id}).then(res => {
    data.info = res.data
    data.surveyIntro = res.data.surveyIntro
    const list = res.data.questions.map(item => {
      return {
        ...item,
        questionId: 'questionId_' + item.questionId
      }
    })
    list.forEach(item => {
      let rule = {}
      let message = item.question
      switch (item.type) {
        case 'radio':
          rule = {required: true, message: `请选择 ${message}`, trigger: 'change'}
          break
        case 'multiple':
          rule = {required: true, message: `请选择 ${message}`, trigger: 'change'}
          break
        case 'blanks':
          rule = {required: true, message: `请输入 ${message}`, trigger: 'blur'}
          break
      }
      data.rules[item.questionId] = [rule]
    })
    data.list = list
  })
}

//提交结果
function toSubmit() {
  refForm.value.validate((val, fields) => {
    console.log(fields)
    if (val) {
      const arr = []
      data.list.forEach(item => {
        const newData = data.formData[item.questionId]
        let answer = ''
        if (item.type === 'multiple') {
          answer = newData.join(',')
        } else {
          answer = newData
        }
        arr.push({
          questionId: parseInt(item.questionId.replace('questionId_', '')),
          type: item.type,
          optionId: answer
        })
      })
      surveySubmit({
        agentId: props.agentInfo.agentId,
        surveyId: props.id,
        answer: arr,
        showJson: {list: data.list, formData: data.formData}
      }).then(res => {
        data.scoreResult = res.data
        data.estimate = res.data.estimate
      })
    } else {
      ElMessage.error('您还有必填项没有填写')
    }
  })
}

//滚动到校验错误位置
// const moveToErr = () => {
//   nextTick(() => {
//     const isError = document.getElementsByClassName('is-error')
//     if (isError.length) isError[0].scrollIntoView({block: 'center', behavior: 'smooth'})
//   })
// }

onMounted(() => {
  if (!(props.showJson?.list)) {
    loadData()
  } else {
    data.list = cloneDeep(props.showJson.list)
    data.formData = cloneDeep(props.showJson.formData)
    data.estimate = props.showJson.result
  }
  data.isMobile = currentMedia() === 'MP'
})

</script>

<style scoped lang="less">

.question-detail {
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

    .time {
      font-family: 'PingFang SC';
      font-style: normal;
      flex: 1;
      font-weight: 400;
      font-size: 12px;
      line-height: 20px;
      color: rgba(77, 94, 128, 0.4);
    }

    .res {
      padding: 20px;
      border-radius: 15px;
      box-shadow: 0 2px 3px 0 rgba(0, 0, 0, 0.1);
      background: rgba(255, 255, 255, 0.4);
      position: relative;

      .title {
        font-size: 1.4rem;
        line-height: 1.6;
        margin-bottom: 10px;
        text-align: center;
      }

      .dis {
        line-height: 30px;
        margin-bottom: 30px;
      }
    }
  }

  :deep(.el-form-item__label) {
    font-size: 1.1rem !important;
  }

  :deep(.el-radio) {
    --el-radio-font-size: 1.1rem !important;
  }

  :deep(.el-form-item) {
    margin-bottom: 25px;
  }
}

.button-submit {
  padding: 20px 50px !important;
  border-radius: 25px !important;
  background: #16330F !important;
}

.mobile {
  width: 90vw;

  .message {
    width: 90%;
  }
}

</style>