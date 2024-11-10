/**
* create by zhangxiang on 2023-08-21 17:19
* 类注释：录音
* 备注：
*/
<template>
    <div v-show="loading" style="height:30px;width:70px;margin-right: 10px" ref="waveRef"></div>
    <div v-if="!loading" style=" margin-right: 10px;
            cursor: pointer;
            margin-top: 3px;">
        <svg-icon icon-class="audio" @click="recOpen"></svg-icon>
    </div>
    <div v-else style=" margin-right: 10px;
            cursor: pointer;
            margin-top: 3px;">
        <svg-icon icon-class="stop" @click="recStop"></svg-icon>
    </div>
</template>

<script setup>
import {ref, defineEmits} from 'vue'
import record from "@/hooks/record";
import {ElMessage} from "element-plus";
import {audioToText} from '@/http/api/index'

const waveRef = ref(null)
const loading = ref(false)

function recOpen() {
    loading.value = true
    record.getPermission((permission,) => {
        if (permission.status === 'fail') {
            ElMessage.warning(permission.data);
        } else {
            record.startRecorder();
        }
    }, waveRef)
}

const emits = defineEmits(['recordMessage'])

function recStop() {
    record.stopRecorder(function (res) {
        loading.value = false
        const fromData = new FormData()
        fromData.append('file', res.blob)
        audioToText(fromData).then(res => {
            emits('recordMessage', res.data.content)
        })
    })
}
</script>

<style scoped lang="less">
.record {
  position: relative;
  display: flex;
}
</style>