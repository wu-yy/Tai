/**
* create by zhangxiang on 2023-07-10 13:12
* 类注释：
* 备注：
*/
<template>
  <el-dialog
      append-to-body
      v-model="showDialog"
      class="login"
      :width="isMobile?'95%':'450px'"
      :close-on-click-modal="false">
    <template #header>
      <div style="text-align: center;line-height:35px;font-size: 18px">
        分享给朋友
      </div>
    </template>
    <div style="text-align: center" class="link">
      <span>https://agent.atomecho.cn/</span>
      <svg-icon icon-class="copy" class-name="copy" @click="toCopy"></svg-icon>
    </div>
  </el-dialog>
</template>

<script setup>
import {defineExpose, onMounted, reactive, ref, toRefs} from "vue";
import {copyToClip, currentMedia} from "@/utils/tools";
import {ElMessage} from "element-plus";

const data = reactive({
  showDialog: false,
})
const {showDialog} = toRefs(data)
const isMobile = ref(false)

const toCopy = () => {
  copyToClip('https://agent.atomecho.cn/')
  ElMessage.success('复制成功')
}
defineExpose({
  showDialog
})

onMounted(() => {
  isMobile.value = currentMedia() === 'MP'
})

</script>

<style scoped lang="less">
.link {
  font-family: Inter;
  font-size: 1.4rem;
  font-weight: 400;
  text-align: center;
  vertical-align: middle;

  .copy {
    cursor: pointer;
    margin-left: 10px;
    vertical-align: middle;
    width: 18px;
    height: 18px;
  }
}
</style>