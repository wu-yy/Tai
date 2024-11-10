<template>
    <div class="left-message" :class="{ mobile: isMobile }">
        <div class="icon"></div>
        <div class="message">
            <div class="agent-flex">
                <div class="time">{{ item.time }}</div>
                <div class="operation">
                    <span class="copy" @click="toCopy(item)">{{ $t('modelAnswer.copy') }}</span>
                    <span class="again" @click="toRetry(item, index)">{{ $t('modelAnswer.again') }}</span>
                </div>
            </div>
            <div class="res">
                <div v-if="userStore.info.isAdmin && newItem.arr[item.selectIndex].toolResult"
                     @click="newItem.arr[item.selectIndex].showTool = !newItem.arr[item.selectIndex].showTool"
                     class="progrss">
                    执行过程
                    <el-icon style="margin-left: 5px">
                        <ArrowDownBold v-show="!newItem.arr[item.selectIndex].showTool"/>
                        <ArrowUpBold v-show="newItem.arr[item.selectIndex].showTool"/>
                    </el-icon>
                    <div v-if="newItem.arr[item.selectIndex].showTool" class="detail">
                        <div v-for="(tool, index) in newItem.arr[item.selectIndex].toolResult"
                             style="margin-bottom: 20px" :key="index">
                            {{ tool.content }}
                        </div>
                    </div>
                </div>
                <mavon-editor ref="refEditor" v-show="newItem.arr[item.selectIndex].content"
                              v-model="newItem.arr[item.selectIndex].content" previewBackground="transparent"
                              :boxShadow="false"
                              defaultOpen="preview" :subfield="false" :transition="false" :toolbarsFlag="false"/>
                <!--提示语-->
                <div style="font-size: 16px;margin-top: 30px;color:#999"
                     v-show="index === list.length - 1 && newItem.arr[item.selectIndex].recommend">
                    {{ $t('modelAnswer.tip') }}
                    <span style="cursor: pointer" @click="toNewQuestion(newItem.arr[item.selectIndex].recommend)">
                        {{ newItem.arr[item.selectIndex].recommend }}
                    </span>
                    <span style="margin-top: 5px;margin-left: 3px;"
                          :class="{ 'content': loading && index === list.length - 1 }"></span>
                </div>
                <!-- 标记与 -->
                <!-- <div
                        v-show="index < list.length - 1 || (!loading && item.tag !== 'first' && newItem.arr[item.selectIndex].content !== '')"
                        style="font-size: 13px;margin-top: 10px;color:#999">
                    <span style="font-size: 10px">以上内容为AI生成，不代表开发者立场，请勿删除或修改本标记</span>
                </div> -->
                <loading v-if="index === list.length - 1 && loading && newItem.arr[item.selectIndex].content === ''"/>
                <span
                        v-if="!(index === list.length - 1 && loading && newItem.arr[item.selectIndex].content === '') && !newItem.arr[item.selectIndex].recommend"
                        :style="{ left: pos.x + 'px', top: pos.y + 'px' }"
                        :class="{ 'content': loading && index === list.length - 1 }"></span>
            </div>

            <div class="agent-flex">
                <!--点赞-->
                <div v-if="(index > 0 && !loading) || (index > 0 && index < list.length - 1)"
                     style="padding: 5px 0 0 5px ">
                    <svg-icon :icon-class="item.arr[item.selectIndex].markAction === 1 ? 'Frame-17' : 'Frame-13'"
                              style="width: 18px;height: 18px;margin-right: 20px" @click="setLike(item, 0, index)">
                    </svg-icon>
                    <svg-icon :icon-class="item.arr[item.selectIndex].markAction === 2 ? 'Frame-14' : 'Frame-16'"
                              style="width: 18px;height: 18px;margin-right: 20px" @click="setLike(item, 1, index)">
                    </svg-icon>
                </div>
                <!-- 转音频-->
                <!--                <div style="line-height: 40px;cursor: pointer;color:#4D5E80"-->
                <!--                     v-if="index===list.length-1&&!loading&&!item.arr[item.selectIndex].url"-->
                <!--                     @click="textGenAudio(item,index)">-->
                <!--                    转音频-->
                <!--                </div>-->
                <!--音频播放-->
                <!--                     v-if="item.arr[item.selectIndex].url&&!item.arr[item.selectIndex].loading"-->
                <div style="padding: 5px 0 0 0 "
                     v-if="index===list.length-1&&!loading&&userStore.info.isAdmin&&!item.arr[item.selectIndex].loading"
                     @click="toPlay(item)">
                    <svg-icon icon-class="play" style="width: 18px;height: 18px"></svg-icon>
                </div>
                <!--音频暂停-->
                <div style="padding: 5px 0 0 0 "
                     v-if="index===list.length-1&&!loading&&userStore.info.isAdmin&&item.arr[item.selectIndex].loading"
                     @click="toStop(item)">
                    <svg-icon icon-class="stop" style="width: 18px;height: 18px"></svg-icon>
                </div>
                <!--音频加载-->
                <loading style="margin-top: 5px" v-if="userStore.info.isAdmin&&item.arr[item.selectIndex].transition"/>
                <div style="flex: 1"></div>
                <div v-if="item.len > 1" style="margin-top: 5px">
                    <el-icon class="almidd" @click="setIndex(item, -1)">
                        <ArrowLeft/>
                    </el-icon>
                    <span class="almidd"> {{ item.selectIndex + 1 }} / {{ item.len }}</span>
                    <el-icon class="almidd" @click="setIndex(item, +1)">
                        <ArrowRight/>
                    </el-icon>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>

import {defineProps, computed, defineEmits, ref, reactive, onMounted, onUpdated} from 'vue'
import Loading from '@/components/Loading/LoadingIndex.vue'
import {copyToClip, currentMedia, getLastDom} from "@/utils/tools";
import {ElMessage} from "element-plus";
import {markAnswerLike} from "@/http/api";
import {useUserStore} from "@/store";
import 'mavon-editor/dist/css/index.css'
import {mavonEditor} from 'mavon-editor'
// import {drawWare} from "@/hooks/record";


const emits = defineEmits(['toRetry', 'toNewQuestion', 'toPlay', 'toStop'])
const refEditor = ref(null)
const isMobile = ref()
const userStore = useUserStore()

const props = defineProps({
    info: {
        type: Object,
        default: () => {
        }
    },
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
    },
    myAudio: {
        type: Audio,
        default: null
    }
})

const newItem = computed(() => {
    return props.item
})

const toPlay = (item) => {
    item.arr[item.selectIndex].loading = true
    emits('toPlay', item)
}

const toStop = (item) => {
    item.arr[item.selectIndex].loading = false
    emits('toStop')
}

const toNewQuestion = (text) => {
    emits('toNewQuestion', text)
}

// const textGenAudio = (item, index) => {
//     item.arr[item.selectIndex].transition = true
//     answerGenAudio({
//         content: item.arr[item.selectIndex].content,
//         answerId: item.arr[item.selectIndex].id
//     }).then(res => {
//         item.arr[item.selectIndex].transition = false
//         item.arr[item.selectIndex].url = res.data.url
//     }).catch(() => {
//         item.arr[item.selectIndex].transition = false
//     })
// }

// const addCopyBtn = () => {
//     if (refEditor.value) {
//         const content = refEditor.value.$el.getElementsByClassName('v-show-content')[0]
//         const precodes = content.getElementsByTagName('pre')
//         const arr = Array.from(precodes)
//         arr.forEach((element, index) => {
//             const btn = element.getElementsByClassName('code-block-header__copy')[0]
//             if (btn) {
//                 console.log(btn, index)
//                 btn.addEventListener('click', function (e) {
//                     const code = element.getElementsByClassName('code-code')[0]  // code 标签
//                     const codeText = code.innerText
//                     copyToClip(codeText)
//                     ElMessage.success('复制成功')
//                 })
//             }

//         })
//     }
// }


const toCopy = (item) => {
    copyToClip(item.arr[item.selectIndex].content)
    ElMessage.success('复制成功')
}

const toRetry = (item, index) => {
    emits('toRetry', item, index)
}

const setLike = (item, order, index) => {
    let type = -1;
    if (order === 0) {
        type = item.arr[item.selectIndex].markAction === 1 ? 3 : 1
    } else {
        type = item.arr[item.selectIndex].markAction === 2 ? 4 : 2
    }
    markAnswerLike({
        questionId: props.list[index - 1].id,
        answerId: item.arr[item.selectIndex].id,
        type,
        source: 2,
        agentId: props.info.agentId
    }).then(() => {
        if (order === 0) {
            item.arr[item.selectIndex].markAction = item.arr[item.selectIndex].markAction === 1 ? 0 : 1
        } else {
            item.arr[item.selectIndex].markAction = item.arr[item.selectIndex].markAction === 2 ? 0 : 2
        }
    })
}

const setIndex = (item, type) => {
    if (type > 0) {
        if (item.selectIndex < item.len - 1) {
            item.selectIndex++
        }
    } else {
        if (item.selectIndex > 0) {
            item.selectIndex--
        }
    }
}

const pos = reactive({x: 0, y: 0})

function updateCursor() {
    // addCopyBtn()
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
    pos.y = rect.top - domRect.top + 21 + (userStore.info.isAdmin && newItem.value.arr[props.item.selectIndex].toolResult ? 50 : 0)
}

onMounted(() => {
    updateCursor()
    isMobile.value = currentMedia() === 'MP'
})

onUpdated(() => {
    updateCursor()
})

</script>

<style scoped lang="less">
.left-message {
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
    min-width: 230px;
    margin-left: 10px;
    line-height: 30px;
    max-width: 70%;
    //overflow-x: hidden;

    .time {
      font-family: 'PingFang SC';
      font-style: normal;
      flex: 1;
      font-weight: 400;
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

      .copy:hover,
      .again:hover {
        color: #555;
      }
    }

    .res {
      padding: 20px;
      border-radius: 15px;
      font-size: 14px;
      box-shadow: 0 2px 3px 0 rgba(0, 0, 0, 0.1);
      background: rgba(255, 255, 255, 0.4);
      backdrop-filter: blur(10px);
      position: relative;

      .progrss {
        cursor: pointer;
        margin-right: 20px;
        background: rgba(242, 238, 228, 1);
        width: fit-content;
        padding: 10px 15px;
        border-radius: 10px;
        color: rgba(0, 0, 0, 0.4);

        .detail {
          line-height: 25px;
          background: #333;
          color: white;
          padding: 10px 5px;
          border-radius: 5px;
          margin-top: 10px;
        }
      }

      :deep(.hljs) {
        background: #f6f8fa !important;
        padding: 10px 10px 10px 10px;
        border-radius: 20px;
        line-height: 1.3 !important;
        font-size: 18px !important;
      }

      .content {
        position: absolute;
        width: 5px;
        height: 18px;
        background: #333;
        animation: blink 0.8s infinite;
        opacity: 0;
        z-index: 1600;
      }

      @keyframes blink {
        from {
          opacity: 0;
        }

        to {
          opacity: 1;
        }
      }
    }

    .almidd {
      vertical-align: middle
    }
  }
}

.left-message:hover .message .operation {
  display: block;
  -webkit-animation: fade-in-fwd 0.6s cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
  animation: fade-in-fwd 0.6s cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
}

.operation {
  display: none
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

/deep/ .v-note-wrapper .v-note-panel .v-note-show .v-show-content,
.v-note-wrapper .v-note-panel .v-note-show .v-show-content-html {
  padding: 0 !important;
  line-height: 1.8 !important;
  overflow: hidden;
}


/deep/ .markdown-body blockquote,
.markdown-body dl,
.markdown-body ol,
.markdown-body p,
.markdown-body pre,
.markdown-body table,
.markdown-body ul {
  margin-bottom: 0 !important;
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

:deep(pre) {
  border-radius: 10px;
}

:deep(.markdown-body code) {
  font-size: 16px;
  line-height: 30px;
}

:deep(.markdown-body) {
  font-size: 1.15rem !important;
}

.mobile {
  width: 90vw;

  .message {
    max-width: 90%;
    line-height: 1.8;

    .res {

      .operation {
        display: block;
      }
    }
  }

  :deep(.markdown-body) {
    font-size: .9rem !important;
  }
}
</style>