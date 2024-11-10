<template>
  <div class="chat" :class="{ mobile: isMobile }" ref="rightDetail">
    <div class="detail">
      <div class="left-video" v-if="!isMobile">
      <video autoplay loop muted playsinline class="background-video">
        <!-- <source src="../../assets/mp4/idle.mp4" type="video/mp4"> -->
        <source :src="videoSrc" type="video/mp4">
        Your browser does not support the video tag.
      </video>
      <!-- <left-menu ref="refLeftMenu" :info="info" @toSearch="toSearch"></left-menu> -->
      </div>

      <div class="right">
          <template v-if="data.showShangLogo&&isMobile">
              <div style="text-align: center;margin-top: 25vh">
                  <img style="width: 65vw" src="../../assets/img/shang-logo.png">
                  <div style="margin-top: 1rem">
                  xxxxxx
                  </div>
                  <div style="margin-top: 1rem">
                  xxxx
                  </div>
              </div>
      </template>
      <template v-else>
          <div class="list" :class="{ 'smooth-scroll': data.smoothScroll }" ref="scrollRef">
            <scroll-loading v-if="data.historyLoading"/>
            <div v-for="(item, index) in list" :key="index" class="item">
              <model-answer ref="refModelAnswer" v-if="item.type === 2" :item="item" :list="list"
                            :index="index"
                            :loading="loading" :info="info"
                            @toNewQuestion="toNewQuestion"
                            @toStop="toStop" @toPlay="toPlay" @toRetry="toRetry"/>
              <your-question v-if="item.type === 1" :item="item" ref="refModelAnswer" :list="list"
                             :index="index"
                             :loading="loading" @toEdit="toEdit"></your-question>
              <clear-context v-if="item.type === 3"/>
              <QuestionList v-if="item.type === 4" @loadQuestionDetail="loadQuestionDetail"/>
              <Questionnaire v-if="item.type === 6" :item="item" :agentInfo="info" :id="item.id"
                             :showJson="item.showJson"/>
              <CreateStory v-if="item.type === 16" :item="item" :agentInfo="info" :id="item.id"
                           :showJson="item.showJson" @scrollBottom="scrollToBottomIfAtBottom"/>
            </div>
          </div>
          <div class="bottom-input">
            <div class="h-full">
                        <textarea class="text-input" spellcheck="false" ref="refInput" :disabled="loading"
                                  v-model="inputValue" @keydown.enter="toSend($event)"
                                  :placeholder="isMobile ? '' : $t('chat.placeholder')"
                                  type="textarea"></textarea>
              <div class="all-btn">
                <div style="display: flex">
                  <!--                                <record @recordMessage="recordMessage"></record>-->
                  <svg-icon class="icons" icon-class="del" @click="splitNew()"></svg-icon>
                  <svg-icon class="icons" icon-class="drill" @click="showMoreType(6)"
                            v-if="data.info.own"></svg-icon>
                  <el-button @click="send" type="primary"
                             style="background: linear-gradient(0deg, #16330F, #16330F),linear-gradient(0deg, #FDF7E1, #FDF7E1);border-radius: 10px">
                    {{ $t('chat.send') }}
                  </el-button>
                </div>
              </div>
            </div>
          </div>
        </template>
      </div>
    </div>
    <Share ref="refShare"></Share>
  </div>
</template>

<script setup>
import {reactive, toRefs, onMounted, onUnmounted, ref, nextTick, computed} from 'vue'
// import LeftMenu from '@/views/chat/components/LeftMenu.vue'
import Share from '@/views/chat/components/ShareIndex.vue'
import ModelAnswer from '@/views/chat/components/ModelAnswer.vue'
import YourQuestion from '@/views/chat/components/YourQuestion.vue'
import ScrollLoading from '@/components/Loading/ScrollLoading.vue'
import ClearContext from '@/views/chat/components/ClearContext.vue'
import Questionnaire from '@/views/chat/components/QuestionNaire.vue'
import QuestionList from '@/views/chat/components/QuestionList.vue'
import CreateStory from '@/views/chat/components/CreateStory.vue'
// import Header from "@/components/AppHeader.vue";
// import Record from './components/RecordIndex'
import {useRoute} from 'vue-router'
import {useScroll} from '@/hooks/useScorll'
import {currentMedia, getUID} from '@/utils/tools'
import {answerGenAudio, dialHistory, splitContext, startDial} from "@/http/api";
import axios from "axios";
import SvgIcon from "@/components/SvgIcon/SvgIconIndex.vue";
// import {ElMessage} from "element-plus";
// import {Watermark} from '@pansy/watermark';
import {useUserStore} from '@/store'
import audioUtils from "@/utils/audioUtils"
import { useI18n } from 'vue-i18n';

const { locale } = useI18n();

const userStore = useUserStore()
const route = useRoute();

const {scrollRef, scrollToBottom, scrollToTo, scrollToBottomIfAtBottom} = useScroll()
const refInput = ref()
const refShare = ref()
const rightDetail = ref()
const isMobile = ref()
const refLeftMenu = ref()
const refModelAnswer = ref()
const data = reactive({
  list: [],
  inputValue: "",
  loading: false,
  historyLoading: false,
  info: {},
  isRetry: false,
  total: 0,
  page: 1,
  contentHeight: 0,
  smoothScroll: true,
  audio: null,
  audioPlayItem: {},
  audioPlaying: false,
  AudioUtils: null,
  canPlay: true,
  showShangLogo: false,//小殇logo展示
})

// const audioPlay = () => {
//   data.canPlay = !data.canPlay
//   if (!data.canPlay) {
//     data.audio.stop()
//   }
//   localStorage.setItem("canPlay", data.canPlay)
// }

// const videoSrc = computed(() => {
//   switch (locale.value) {
//     case 'zh-cn':
//       return require('@/assets/mp4/video_zh.mp4');
//     case 'en-us':
//       return require('@/assets/mp4/video_eng.mp4');
//     case 'th-th':
//       return require('@/assets/mp4/video_th.mp4');
//     default:
//       return require('@/assets/mp4/video_eng.mp4');
//   }
// });

const videoSrc = computed(() => {
  switch (locale.value) {
    case 'zh-cn':
      return 'https://cdnfile.atomecho.cn/tai/video_zh.mp4';
    case 'en-us':
      return 'https://cdnfile.atomecho.cn/tai/video_eng.mp4';
    case 'th-th':
      return 'https://cdnfile.atomecho.cn/tai/video_th.mp4';
    default:
      return 'https://cdnfile.atomecho.cn/tai/video_eng.mp4';
  }
});


// const dayjs = require('dayjs')
import dayjs from 'dayjs';

// const route = useRoute()
// const router = useRouter()

const initAudio = () => {
  data.audio = audioUtils.Instance
  data.audio.init((e) => {
    console.log(e)
    const item = data.list[data.list.length - 1]
    item.arr[item.selectIndex].loading = false
    refLeftMenu.value.showSpeck(false)
  })
}
/**
 * 语音文字
 * @param val
 */
// const recordMessage = (val) => {
//   data.inputValue = val
// }

const toPlay = (item) => {
  item.arr[item.selectIndex].transition = true
  answerGenAudio({
    content: item.arr[item.selectIndex].content,
    agentId: data.info.agentId
  }).then(res => {
    item.arr[item.selectIndex].transition = false
    data.audio.stop()
    data.audio.addCache(res.data.url)
    data.audio.play()
    refLeftMenu.value.showSpeck(true)
  }).catch(() => {
    item.arr[item.selectIndex].transition = false
  })

}

const toStop = () => {
  data.audio.stop()
  refLeftMenu.value.showSpeck(false)

}

const formatDay = (time) => {
  return dayjs(time).format('YYYY-MM-DD HH:mm:ss')
}

//展示问卷按钮
// const showSurvey = computed(() => {
//   return data.info.agentParam?.toolbox?.includes('survey')
// })

//展示问卷按钮
// const showStory = computed(() => {
//   return data.info.agentParam?.toolbox?.includes('story')
// })

const doScroll = async (event) => {
  const scrollTop = event.target.scrollTop
  data.contentHeight = event.target.scrollHeight
  if (scrollTop === 0) {
    if (data.total > data.list.length) {
      await loadHistory()
      const newHeight = event.target.scrollHeight
      data.smoothScroll = false
      scrollToTo(newHeight - data.contentHeight)
      await nextTick(() => {
        data.smoothScroll = true
      })
    }
  }
}

const showMoreType = (type) => {
  if (data.loading) {
    return
  }
  const height = scrollRef.value.scrollHeight
  data.list.push({
    type
  })
  setTimeout(() => {
    scrollRef.value.scrollTop = height
  }, 500)
}

/**
 * 添加新问卷
 * @param id
 */
const loadQuestionDetail = (id) => {
  const height = scrollRef.value.scrollHeight
  data.list.push({
    type: 6,
    id: id,
    time: formatDay(new Date()),
    showJson: {}
  })
  setTimeout(() => {
    scrollRef.value.scrollTop = height
  }, 500)
}

// const showShare = () => {
//   refShare.value.showDialog = true
// }

const toNewQuestion = (text) => {
  data.inputValue = text
  send()
}

// const toSearch = (text) => {
//   data.inputValue = text
//   nextTick(() => {
//     refInput.value.focus()
//   })
// }

/**
 * 设置消息内容
 * @param value
 */
const setResponse = (value) => {
  data.loading = value.status === 'RUNNING';
  data.audio.loading = data.loading;
  if (value.answerAudioQueue && value.answerAudioQueue.length) {
    data.audio.addList(value.answerAudioQueue)
  }
  if (value.answerAudioQueue && data.audioPlaying) {
    data.audioPlaying = false
    data.audio.play()
    refLeftMenu.value.showSpeck(true)
  }
  const recommend = value.recommend_question && JSON.parse(value.recommend_question).answer_text ? JSON.parse(value.recommend_question).answer_text : ''
  if (!value.answer) {
    return
  }
  let content = JSON.parse(value.answer).answer_text ? JSON.parse(value.answer).answer_text : ''
  const id = value.answer_id

  const time = formatDay(new Date())
  if (data.isRetry) {
    const last = data.list[data.list.length - 1]
    const selectIndex = last.arr.length - 1
    last.arr[last.arr.length - 1] = {
      content,
      recommend,
      time,
      id,
      loading: userStore.info.isAdmin && data.canPlay
    }
    updateChat({
      arr: last.arr,
      type: 2,
      len: last.arr.length,
      selectIndex: selectIndex,
      time,
      id
    })
  } else {
    updateChat({
      arr: [{
        content,
        time,
        id,
        recommend,
        loading: userStore.info.isAdmin && data.canPlay
      }],
      type: 2,
      selectIndex: 0,
      time,
      id
    })
    updateQuestion(value.question_id)
  }
  scrollToBottomIfAtBottom()
  if (!data.loading) {
    data.isRetry = false
    nextTick(() => {
      refInput.value.focus()
    })
  }
}

/**
 * 清空上下文消息
 */
const splitNew = () => {
  const questionList = data.list.filter(item => [1, 2, 3].includes(item.type))
  if (data.loading) {
    return
  }
  if (questionList[questionList.length - 1].type === 3) {
    return;
  }
  if (questionList.length < 2) {
    return;
  }
  const last = questionList[questionList.length - 2]
  splitContext({
    agentId: data.info.agentId,
    lastQuestionId: last.id
  }).then(() => {
    addChat({
      arr: [],
      type: 3,
      len: 0,
      selectIndex: 0,
      time: formatDay(new Date()),
      id: getUID()
    })
    scrollToBottom()
  })
}

/**
 * 加载详情
 * @returns {Promise<void>}
 */
const loadData = async () => { 
  // let agentId = "1364074816844699b8b9906aa69843f0"
  let agentId = "3bd4bd1926764320880da4089a297015"
  let res = await startDial({uniqueCode: agentId})
  data.info = res.data
  data.showShangLogo = false
  await loadHistory()
  scrollToBottom()

  if (route.query.input) {
    data.inputValue = route.query.input;
    send();
  }
}

/**
 * 加载历史
 * @returns {Promise<void>}
 */
const loadHistory = async () => {
  data.historyLoading = true
  const res = await dialHistory({
    agentId: data.info.agentId,
    pageNo: data.page,
    pageSize: 10
  })
  data.total = res.data.total
  data.historyLoading = false
  if (res.data.list?.length) {
    const list = res.data.list.map(item => {
      const type = item[0].type
      // item[0].url = '//m8.music.126.net/21180815163607/04976f67866d4b4d11575ab418904467/ymusic/515a/5508/520b/f0cf47930abbbb0562c9ea61707c4c0b.mp3?infoId=92001'
      let newData = {}
      if ([1, 2, 3].includes(type)) {
        newData = {
          type,
          arr: item,
          selectIndex: item.length - 1,
          time: formatDay(item[item.length - 1].contentTime * 1000),
          id: item[item.length - 1].id,
          len: item.length
        }
      } else if ([6, 16].includes(type)) {
        const showJson = item[0].showJson
        newData = {
          type,
          time: formatDay(item[item.length - 1].contentTime * 1000),
          showJson
        }
      }
      return newData
    })
    if (data.page === 1) {
      data.list = list
      if (data.list.length === 0) {
        data.list.unshift(getFirstMessage())
      }
    } else {
      data.list.unshift(...list)
    }
  } else {
    if (data.list.length === 0)
      data.list = [getFirstMessage()]
  }
  data.page++
}

const getFirstMessage = () => {
  return {
    time: formatDay(new Date()),
    type: 2,
    selectIndex: 0,
    tag: 'first',
    arr: [{content: '您好，请输入你想预定的酒店位置、日期、房型、人数的关键词'}]
  }
}

/**
 * 重新编辑
 * @param item
 */
const toEdit = (item) => {
  data.inputValue = item.arr[0].content
  nextTick(() => {
    refInput.value.focus()
  })
}

/**
 * 封装发送的message
 * @param id
 * @param messages
 * @returns {{content_type: number, Content: string, task_type: string}}
 */
// const setSendMessage = (id) => {
//   const questionList = data.list.filter(item => [1, 2, 3].includes(item.type))
//   const agentParam = data.info.agentParam
//   const maxTokenNum = agentParam.maxTokenNum ? agentParam.maxTokenNum : 512
//   const contextNum = agentParam.contextNum ? agentParam.contextNum : 5
//   const temperature = agentParam.temperature ? agentParam.temperature : 0.3
//   const startIndex = questionList.findLastIndex(item => item.type === 3)
//   const isFirst = questionList.length < 10
//   let list = []
//   if (startIndex !== -1) {
//     list = questionList.slice(startIndex + 1);
//   } else {
//     list = questionList
//   }
//   if (isFirst && startIndex === -1) {
//     list = list.filter((item, index) => index > 0)
//   }
//   const messages = list
//       .slice(0, -1)
//       .slice(-contextNum)
//       .map((item) => {
//         if (item.type === 2) {
//           return {role: 'Assistant', content: item.arr[item.selectIndex].content}
//         } else {
//           return {role: 'Human', content: item.arr[item.selectIndex].content}
//         }
//       })
//   return {
//     agentId: data.info.agentId,
//     atomechoSession: getSession(),
//     summaryId: getUID(),
//     data: {
//       input: JSON.stringify({
//         messages,
//         id: getUID(),
//         temperature,
//         max_new_tokens: maxTokenNum,
//         model: 'atomgpt_talk',
//       }),
//       chat_type: 'text',
//       question: messages[messages.length - 1].content,
//       questionId: id
//     },
//   }
// }
/**
 * 点击发送
 * @param event
 */
const toSend = (event) => {
  if (event.keyCode === 13) {
    if (!event.shiftKey) {
      event.preventDefault();
      if (!data.inputValue) {
        return
      }
      if (!data.inputValue.replace(/\n/g, '')) {
        return;
      }
      send()
    }
  }
}

// const askQueue = async () => {
//   try {
//     const res = await queryAskQueue({
//       agentId: data.info.agentId
//     })
//     return res.data.waitTasks
//   } catch (e) {
//     return 0
//   }
// }

/**
 * 发送消息
 */
const send = async () => {
  // const waitTasks = await askQueue()
  // if (waitTasks > 0) {
  //   ElMessage.warning('您前面还有' + waitTasks + '人在等待，请稍后再试')
  //   return
  // }
  if (!data.inputValue) {
    return
  }
  const id = getUID()
  addChat({
    arr: [{content: data.inputValue, time: formatDay(new Date())}],
    selectIndex: 0,
    type: 1,
    time: formatDay(new Date()),
    id: id,
  })
  addChat({
    arr: [{content: '', time: formatDay(new Date())}],
    selectIndex: 0,
    type: 2,
    time: formatDay(new Date()),
    id: id,
  })
  data.loading = true
  const sendData = {
    agentId: data.info.agentId,
    questionId: 0,
    question: data.inputValue,
    needVoice: userStore.info.isAdmin && data.canPlay,
  }
  sendMessage(sendData)
  scrollToBottom()
  data.inputValue = ''
}

/**
 * 发送请求
 * @param sendData
 */
const sendMessage = (sendData) => {
  const token = localStorage.getItem('neverendsart_authToken'); // 获取 token
  // data.audio.stop()
  // data.audioPlaying = true
  axios.post('https://icp.neverends.studio/serverApi/agent/ask-question', sendData, {
  // axios.post('/serverApi/agent/chat', sendData, {
    headers: {
      // "no-sign": true,
      ...(token ? { 'Authorization': `Bearer ${token}` } : {}),
    },
    onDownloadProgress({event}) {
      const xhr = event.target
      const {responseText} = xhr
      const lastIndex = responseText.lastIndexOf('data:', responseText.length - 2)
      let chunk = responseText
      if (lastIndex !== -1)
        chunk = responseText.substring(lastIndex).replace('data:', '')
      try {
        const value = JSON.parse(chunk)
        if (value.summary_id)
          setResponse(value)
      } catch (e) {
        // console.log("------err-------", chunk)
      }
    }
  })
}

/**
 * 重新发送
 * @param item
 * @param index
 */
const toRetry = (item, index) => {
  if (data.loading) {
    return
  }
  data.isRetry = true
  data.list = data.list.slice(0, index + 1)
  const id = data.list[data.list.length - 2].id
  const arr = [...data.list[data.list.length - 1].arr]
  arr.push({
    content: '',
    time: formatDay(new Date()),
  })
  const newData = {
    arr: arr,
    type: 2,
    len: arr.length,
    selectIndex: data.list[data.list.length - 1].arr.length,
    time: formatDay(new Date()),
    id: id
  }
  updateChat(newData)
  data.loading = true
  // const sendData = setSendMessage(id)
  const sendData = {
    agentId: data.info.agentId,
    questionId: id,
    question: data.list[index - 1].arr[0].content,
  }
  sendMessage(sendData)
}


const addChat = (message) => {
  data.list.push(message)
}

const updateChat = (message) => {
  data.list[data.list.length - 1] = message
}

const updateQuestion = (id) => {
  data.list[data.list.length - 2].id = id
}
// let waterMark = null
// const initWatermark = () => {
//   console.log(userStore.info)
//   waterMark = new Watermark({
//     gapX: 200,
//     gapY: 200,
//     offsetLeft: 0,
//     offsetTop: 0,
//     width: 200,
//     height: 200,
//     opacity: 0.10,
//     rotate: -22,
//     fontSize: 15,
//     fontStyle: 'normal',
//     fontVariant: 'normal',
//     fontWeight: '300',
//     fontColor: '#000',
//     fontFamily: 'sans-serif',
//     textAlign: 'center',
//     textBaseline: 'alphabetic',
//     monitor: true,
//     zIndex: 99999,
//     mode: 'interval',
//     pack: true,
//     blindFontSize: 16,
//     blindOpacity: 0.005,
//     text: [userStore.info.userId, 'AI生成内容仅供参考'],
//     blindText: userStore.info.userId,
//   });
// }

// onMounted(() => {
//   // 从 route.query.input 获取输入内容并自动填入对话框并发送请求
//   if (route.query.input) {
//     data.inputValue = route.query.input;
//     send();
//   }
// });

onMounted(() => {
  // initWatermark()
  loadData()
  initAudio()
  data.canPlay = localStorage.getItem("canPlay") ? localStorage.getItem("canPlay") === "true" : true
  isMobile.value = currentMedia() === 'MP'
  refInput.value.focus()
  rightDetail.value.style.height = window.innerHeight - 65 + 'px'
  if (scrollRef.value)
    scrollRef.value.addEventListener('scroll', doScroll)
})

onUnmounted(() => {
  if (scrollRef.value)
    scrollRef.value.removeEventListener('scroll', doScroll)
  // waterMark.destroy()
})


const {list, inputValue, loading, info} = toRefs(data)
</script>

<style scoped lang="less">
.chat {
  width: 100vw;
  background: linear-gradient(to bottom, #1a1f36, #2e3a59);
  position: relative;
  height: calc(100vh - 70px);
  color: #ffffff;

  .back {
    position: absolute;
    top: 20px;
    left: 30px;
    cursor: pointer;
    z-index: 100;
  }

  .share {
    position: absolute;
    top: 20px;
    right: 30px;
    cursor: pointer;
    z-index: 100;
    width: 18px;
    height: 18px;
  }

  .icon-button {
    position: absolute;
    top: 10px;
    right: 60px;
    cursor: pointer;
    z-index: 100;
    width: 18px;
    padding: 10px;
    border-radius: 50%;
    background: radial-gradient(59.37% 59.37% at 50% 50%, rgba(249, 227, 26, 0.4) 0%, rgba(251, 255, 34, 0) 100%);
    height: 18px;
  }

  .detail {
    width: 100vw;
    display: flex;

    .left-video {
      position: relative;
      flex: 1;
      overflow: hidden;

      .background-video {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }

    .right {
      position: relative;
      height: calc(100vh - 70px);
      flex: 2;
      padding-left: 2vw;

      .list {
        overflow-y: scroll;
        height: calc(100vh - 75px - 15vh);
        padding-right: 5vw;

        .item {
          margin-bottom: 20px;
        }
      }

      .smooth-scroll {
        scroll-behavior: smooth;
      }

      .bottom-input {
        position: absolute;
        bottom: 0;
        left: calc(6vh + 10px);
        height: 15vh;
        width: 66vw;
        background: rgba(77, 94, 128, 0.3);
        border-radius: 10px;
        padding: 10px;

        .h-full {
          height: 100%;
          width: 100%;
          position: relative;

          .text-input {
            height: 11vh;
            overflow-y: scroll;
            caret-color: #00e0ff;
            font-size: 1.2rem;
            outline: 1px solid transparent;
            outline-offset: 2px;
            line-height: 1.75rem;
            background-color: transparent;
            border-style: none;
            resize: none;
            width: 100%;
            font-family: inherit;
            font-weight: inherit;
            color: #ffffff;
            margin: 0;
            padding: 0;
          }

          .all-btn {
            position: absolute;
            bottom: 0;
            right: 0;

            .icons {
              margin-right: 10px;
              cursor: pointer;
              margin-top: 3px;
            }
          }
        }
      }
    }
  }
}

.send-button {
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  border-radius: 10px;
  font-weight: bold;
  color: #ffffff;
}

.mobile {
  height: 100%;

  .detail {
    height: 100%;

    .right {
      position: relative;
      height: calc(100% - 10px);
      padding-left: 2vw;

      .list {
        padding-right: 0vw;
        overflow: hidden;
        height: calc(100% - 80px);
        overflow-y: scroll;

        .item {
          margin-bottom: 20px;
        }
      }

      .icon {
        cursor: pointer;
        position: absolute;
        left: 3%;
        bottom: calc(75px - 2.8vh);
        background: radial-gradient(50% 50% at 50% 50%, #9Db09c 0%, rgba(251, 247, 230, 0) 100%);
        width: 3vh;
        height: 3vh;
        border-radius: 50%;
      }
      .bottom-input {
        height: 75px;
        bottom: 0;
        left: calc(10% + 20px);
        width: 80%;

        .h-full {
          height: 100%;
          width: 100%;

          .text-input {
            height: 75px;
            font-size: .9rem;
            width: 90%;
          }
        }
      }

      .record {
        position: absolute;
        right: 5vw;
        bottom: 45px;
      }
    }
  }
}
</style>
