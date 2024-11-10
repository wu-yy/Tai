/**
 * create by Administrator on 2024/1/12 12:17
 * 类注释：
 * 备注：
 */

export default class AudioUtils {
    static instance = null;

    static get Instance() {
        if (!this.instance) {
            this.instance = new AudioUtils()
        }
        return this.instance
    }

    audio = null
    list = []
    playIndex = 0
    loading = false
    callBack = null

    init(callBack) {
        this.audio = new Audio()
        this.callBack = callBack
        this.audio.addEventListener('timeupdate', () => {
            if (this.audio.ended) {
                this.play()
            }
        })
    }

    addCache(src) {
        // this.list.push("data:audio/wav;base64," + src)
        this.list.push(src)
        console.log('长度', this.list.length)
    }

    addList(src) {
        this.list = src
    }

    play() {
        if (this.playIndex === this.list.length - 1 && this.loading) {
            setTimeout(() => {
                this.play()
            }, 100)
            return;
        }
        if (this.playIndex > this.list.length - 1) {
            this.playIndex = 0
            this.list = []
            this.callBack(true)
            return
        }
        console.log("playIndex", this.playIndex)
        this.audio.src = this.list[this.playIndex]
        this.audio.play()
        this.playIndex++
    }

    stop() {
        this.playIndex = 0
        this.list = []
        this.audio.pause()
    }
}