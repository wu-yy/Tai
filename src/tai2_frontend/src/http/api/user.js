/**
 * create by zhangxiang on 2023-06-14 10:41
 * 类注释：
 * 备注：
 */

import Http from "@/http/http";

/**
 * 手机登录
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const login = (data) => {
	return Http.post("/user/login", data);
};

/**
 * 手机验证码
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const smscode = (data) => {
	return Http.post("/user/send-smscode", data);
};
/**
 * 退出登录
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const logout = (data) => {
	return Http.post("/user/logout", data);
};

export const getUserInfo = (data) => {
    return Http.post('/user/user-info', data)
}
/**
 * 邮箱登录
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const loginEmail = (param) => {
	return Http.post("/user/login-email", param);
};

/**
 * 邮箱注册
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const registerEmail = (param) => {
	return Http.post("/user/register-email", param);
};

/**
 * 注册邮箱验证码
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const sendEmailCode = (param) => {
	return Http.post("/user/send-emailcode", param);
};

/**
 * 获取用户唯一邀请码
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const genInviteCode = (param) => {
	return Http.post("/user/center/gen-invite-code", param);
};

/**
 * 获取支付状态 pc微信3分钟失效
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const payStatus = (param) => {
	return Http.get("/user/pay/pay-status?tradeNo=" + param);
};

/**
 * 阿里支付-pc
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const pcAli = (params) => {
	return Http.get("/user/pay/ali/pay-web", { params: params });
};

/**
 * 微信支付获取二维码-pc
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const pcWechat = (params) => {
	return Http.get("/user/pay/wx/pay-code", { params });
};

/**
 * icp 支付
 */
export const pcIcp = (params) => {
	return Http.get("/user/pay/icp/pay-code", { params });
};

/**
 * stripe支付
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const stripePayUrl = (params) => {
	return Http.get("/user/pay/stripe/pay-url?goodsId=" + params);
};

/**
 * 付费商品列表
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const goodsList = () => {
	return Http.get("/user/pay/goods-list?app=nes");
};
