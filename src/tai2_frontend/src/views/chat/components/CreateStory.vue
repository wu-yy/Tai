<template>
  <div class="story-container" :class="{mobile:data.isMobile}">
    <div class="icon"></div>
    <div class="message">
      <div class="res">
        <div class="title">生成故事</div>
        <el-form
            class="story-form"
            ref="formDataRef"
            :disabled="!!data.result"
            :model="formData"
            :rules="rules"
            hide-required-asterisk>
          <el-form-item prop="childName">
            <template #label>宝宝角色</template>
            <el-row style="width: 100%;">
              <el-col :xs="15" :sm="18">
                <el-input placeholder="请输入宝宝角色" class="form-input" v-model="formData.childName"></el-input>
              </el-col>
              <el-col :xs="9" :sm="6" v-if="!data.result">
                <div class="form-button">随机生成</div>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item prop="parentName">
            <template #label>家长角色</template>
            <el-row style="width: 100%;">
              <el-col :xs="15" :sm="18">
                <el-input placeholder="请输入家长角色" class="form-input" v-model="formData.parentName"></el-input>
              </el-col>
              <el-col :xs="9" :sm="6" v-if="!data.result">
                <div class="form-button">随机生成</div>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item prop="describe">
            <template #label>故事描述</template>
            <el-row style="width: 100%;">
              <el-col :xs="15" :sm="18">
                <el-input type="textarea"
                          placeholder="请输入故事描述"
                          style="width: 100%"
                          v-model="formData.describe"
                          :rows="3"></el-input>
              </el-col>
              <el-col :xs="9" :sm="6" v-if="!data.result">
                <div class="form-button">随机生成</div>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item prop="time">
            <template #label>故事时长</template>
            <el-row class="story-time">
              <el-col :xs="8" :sm="6">
                <div class="time" @click="chooseTime(3)" :class="formData.time === 3?'active':''"
                     style="margin-right: 10%;">3分钟
                </div>
              </el-col>
              <el-col :xs="8" :sm="6">
                <div class="time" @click="chooseTime(5)" :class="formData.time === 5?'active':''"
                     style="margin: 0 5% 0;">5分钟
                </div>
              </el-col>
              <el-col :xs="8" :sm="6">
                <div class="time" @click="chooseTime(8)" :class="formData.time === 8?'active':''"
                     style="margin-left: 10%;">8分钟
                </div>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="finishCreate(formDataRef)" class="submit-button" v-if="!data.result">
              生成
            </el-button>
          </el-form-item>
        </el-form>

        <div class="order" v-if="!!data.result||data.loading">
          <span class="line"></span>
          <span class="txt">故事内容</span>
          <span class="line"></span>
        </div>

        <div class="model-answer">
          <mavon-editor
              ref="refEditor"
              v-show="data.result"
              v-model="data.result"
              previewBackground="transparent"
              :boxShadow="false"
              defaultOpen="preview"
              :subfield="false"
              :transition="false"
              :toolbarsFlag="false"/>
          <span
              :style="{left:pos.x+'px',top:pos.y+'px'}"
              class="content"></span>

          <loading v-if="data.loading&&data.result===''"/>
        </div>


      </div>
    </div>
  </div>
</template>

<script setup>
import {onMounted, reactive, defineEmits, ref, defineProps, onUpdated, toRefs, nextTick} from 'vue'
import axios from "axios";
import {currentMedia, getLastDom} from "@/utils/tools";
import 'mavon-editor/dist/css/index.css'
import {mavonEditor} from 'mavon-editor'
import Loading from '@/components/Loading/LoadingIndex.vue'

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
const emits = defineEmits(['scrollBottom'])

const formDataRef = ref()
const refEditor = ref()
const data = reactive({
  isMobile: false,
  result: '',
  loading: false,
  formData: {
    time: 3,
  }
})

const {formData} = toRefs(data)

const rules = reactive({
  childName: [
    {required: true, message: '请输入宝宝的角色', trigger: 'blur'},
  ],
  parentName: [
    {required: true, message: '请输入家长的角色', trigger: 'blur'},
  ],
  describe: [
    {required: false, message: '请输入故事描述', trigger: 'blur'},
  ]
})

const chooseTime = (time) => {
  data.formData.time = time;
}

const pos = reactive({x: 0, y: 0})

function updateCursor() {
  const content = refEditor.value.$el.getElementsByClassName('v-show-content')[0]
  const lastText = getLastDom(content)
  const textNode = document.createTextNode('\u200b')
  if (lastText) {
    lastText.parentElement.appendChild(textNode)
  } else {
    content.appendChild(textNode)
  }
  const domRect = content.getBoundingClientRect()
  const rage = document.createRange()
  rage.setStart(textNode, 0)
  rage.setEnd(textNode, 0)
  const rect = rage.getBoundingClientRect()
  pos.x = rect.left - domRect.left + 22;
  pos.y = rect.top - domRect.top + 21

  console.log(pos)
}

const finishCreate = (formEl) => {
  formEl.validate((valid, fields) => {
    console.log(fields)
    if (valid) {
      data.loading = true
      nextTick(() => {
        emits('scrollBottom')
      })
      axios.post('/serverApi/agent/story/generate', {
        agentId: props.agentInfo.agentId,
        roleNames: [data.formData.childName, data.formData.parentName],
        summary: data.formData.summary,
        duration: data.formData.time,
        showJson: {formData: data.formData}
      }, {
        onDownloadProgress({event}) {
          const xhr = event.target
          const {responseText} = xhr
          const lastIndex = responseText.lastIndexOf('\n', responseText.length - 2)
          let chunk = responseText
          if (lastIndex !== -1)
            chunk = responseText.substring(lastIndex)
          try {
            const value = JSON.parse(chunk)
            if (value.summary_id) {
              setResponse(value)
            }
          } catch (e) {
            console.log(e)
          }
        }
      })
    }
  })
}

const setResponse = (value) => {
  data.loading = value.status === 'RUNNING';
  let content = JSON.parse(value.answer).answer_text ? JSON.parse(value.answer).answer_text : ''
  // const id = value.answer_id
  data.result = content
  emits('scrollBottom')
}

onMounted(() => {
  updateCursor()
  if (props.showJson?.result) {
    data.formData = {...props.showJson.formData}
    data.result = props.showJson.result
  }
  data.isMobile = currentMedia() === 'MP'
})

onUpdated(() => {
  updateCursor()
})

</script>

<style scoped lang="less">
.story-container {
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

      .story-form {
        width: 70%;
        margin-left: 15%;

        .form-input {
          display: inline-block;
          width: 100%;
        }

        .form-textarea {
          border: rgb(96, 98, 102);
          width: 100%;
          box-sizing: border-box;
          line-height: 30px;
          color: rgb(96, 98, 102);
          padding: 0 11px 0 11px;
        }

        .form-button {
          margin-left: 10%;
          display: inline-block;
          background: #16330F;
          color: #fff;
          text-align: center;
          font-size: 0.6rem;
          padding: 0 0.4rem 0;
        }

        .story-time {
          width: 100%;

          .time {
            display: inline-block;
            width: 90%;
            border: 1px solid #000;
            text-align: center;
            cursor: pointer;
          }

          .time:last-child {
            margin-right: 0;
          }

          .active {
            background: #E3B557;
          }
        }

        .submit-button {
          padding: 20px 50px;
          border-radius: 25px;
          background: #16330F;
          margin: 0 auto;
        }
      }

      .order {
        height: 80px;
        line-height: 80px;
        text-align: center;
      }

      .order .line {
        display: inline-block;
        width: 10vw;
        vertical-align: middle;
        border-top: 3px dotted #ccc;
      }

      .order .txt {
        color: #303030;
        padding: 0 20px;
        vertical-align: middle;
        opacity: .5;
      }

      .model-answer {
        position: relative;

        .content {
          position: absolute;
          width: 100px;
          height: 18px;
          background: red;
          animation: blink 0.8s infinite;
          opacity: 0;
          z-index: 30000;
        }

      }
    }
  }
}


.mobile {
  width: 90vw;

  .message {
    width: 90%;

    .res {
      .story-form {
        margin-left: 0;
        width: 100%;
      }
    }
  }
}

:deep(.el-input__wrapper) {
  width: 100%;
}

:deep(.v-note-wrapper) {
  border: none !important;
  min-height: 0;
  min-width: 30px;
  background: transparent;
}

:deep(.v-note-show) {
  position: relative !important;
}

/deep/ .v-note-wrapper .v-note-panel .v-note-show .v-show-content, .v-note-wrapper .v-note-panel .v-note-show .v-show-content-html {
  padding: 0 !important;
  line-height: 1.8 !important;
  overflow: hidden;
}


/deep/ .markdown-body blockquote, .markdown-body dl, .markdown-body ol, .markdown-body p, .markdown-body pre, .markdown-body table, .markdown-body ul {
  margin-bottom: 0 !important;
}
</style>