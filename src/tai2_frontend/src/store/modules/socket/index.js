/**
 * create by zhangxiang on 2023-06-10 12:50
 * 类注释：
 * 备注：
 */
import {defineStore} from 'pinia'

export const useSocketStore = defineStore('socket-store', {
    state: () => {
        return {
            wsChat: {}, // 问题答案
            wsTaskNum: 0,
        }
    },
    getters: {
        getWsChat: (state) => {
            return state.wsChat
        },
        getWsTaskNum: (state) => {
            return state.wsTaskNum
        },
    },
    actions: {
        setWsChat(val) {
            this.wsChat = val
        },
        setWsTaskNum(val) {
            this.wsTaskNum = val
        },
    },
})
