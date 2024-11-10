import { defineStore } from "pinia";
import { getSession, setSession } from "@/utils/tools";

export const useUserStore = defineStore("user-store", {
	state: () => {
		return {
			info:{},
			isLogin: null,
			gallery: getSession("gallery") === "mine" ? "mine" : "explore",
			userId: getSession("userId"),
			needLogin: false,
			walletConnected: !!localStorage.getItem('plug_authToken'),
			walletAccount: localStorage.getItem('plug_account')
		};
	},
	getters: {
		getIsLogin: (state) => {
			return state.isLogin;
		},
		getNeedLogin: (state) => {
            return state.needLogin
        },
		getGallery: (state) => {
			console.log("获取gallery:", state.gallery)
			return state.gallery;
		},
		getUserId: (state) => {
			return state.userId
		},
		getInfo: (state) => {
            return state.info
        },
		getWalletConnected: (state) => {
			return state.walletConnected
		},
		getWalletAccount: (state) => {
			return state.walletAccount
		}
	},
	actions: {
		setIsLogin(val) {
			this.isLogin = val;
		},
		setGallery(val) {
			console.log("设置gallery:", val)
			setSession("gallery", val);
			this.gallery = val;
		},
		setNeedLogin(val) {
            this.needLogin = val
        },
		setUserId(val) {
			setSession("userId", val)
			this.userId = val
		},
		setInfo(val) {
            this.info = val
        },
		setWalletConnected(val) {
			this.walletConnected = val
		},
		setWalletAccount(val) {
			this.walletAccount = val
		}
	},
});
