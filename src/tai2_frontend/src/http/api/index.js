import Http from "../http";


/**
 * 获取分类列表
 * @returns {Promise<AxiosResponse<any>>}
 */
export const agentList = (data) => {
    return Http.post('/agent/list', data)
}
export const startDial = (params) => {
    return Http.get('/agent/start-dial', {params: params})
}

/**
 * 答案生成音频
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const answerGenAudio = (data) => {
    return Http.post('/agent/answer-gen-audio', data)
}


/**
 * agent-分隔会话
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const splitContext = (data) => {
    return Http.post('/agent/split-context', data)
}


/**
 * 请求任务队列查询
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const queryAskQueue = (params) => {
    return Http.get('/agent/query-ask-queue', {params: params})
}

export const dialHistory = (data) => {
    return Http.post('/agent/dial-history', data)
}

/**
 * 问卷列表
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const surveyList = () => {
    return Http.get('/agent/survey/list')
}


/**
 * 问卷详情
 * @param parmas
 * @returns {Promise<AxiosResponse<any>>}
 */
export const surveyDetail = (params) => {
    return Http.get('/agent/survey/detail', {params: params})
}


/**
 * 问卷详情
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const surveySubmit = (data) => {
    return Http.post('/agent/survey/submit', data)
}


/**
 * 模型答案标注
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const markAnswerLike = (data) => {
    return Http.post('/agent/mark-answer-like', data)
}

/**
 * 用户信息
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const loginInfo = (params) => {
	return Http.get("/nes/login-info", { params: params });
};

/**
 * 艺术家-列表
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const artistList = (params) => {
	return Http.post("/nes/artist-list-page", params);
};

/**
 * 艺术家-列表V2
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const artistListV2 = (params) => {
	return Http.post("/nes/artist-list-page-V2", params);
};

/**
 * gallery-视频删除
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const generateDelete = (params) => {
	return Http.post("/nes/generate-delete", params);
};

/**
 * 生成列表
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const generateList = (params) => {
	return Http.post("/nes/generate-list", params);
};

/**
 * 
 * 生成NFT 
 */
export const makeNFT = (params) => {
	return Http.post("/nes/create-nft", params);
}

// 公开或者取消公开
export const makePublic = (params) => {
	return Http.post("/nes/update-public", params);
}

/**
 * text to video生成
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const nesGenerate = (data) => {
	return Http.post("/nes/generate", data);
};

/**
 * 参数列表
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const nesDicts = (data) => {
	return Http.get("/nes/dicts", data);
};

/**
 * 当前video生成进度查询
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const search = (data) => {
	return Http.post("/nes/generate-query", data);
};

/**
 * 随机prompt
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const randPrompt = (params) => {
	return Http.get("/nes/rand-prompt", { params: params });
};

/**
 * image to video生成
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const picGenerate = (params) => {
	return Http.post("/nes/pic-generate", params, {
		"Content-Type": "multipart/form-data",
	});
};

/**
 * video to video生成
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const videoGenerate = (params) => {
	return Http.post("/nes/video2video", params);
};

/**
 * 文件上传
 * @param data
 * @returns {Promise<AxiosResponse<any>>}
 */
export const fileUpload = (params) => {
	return Http.post("/base/file/upload", params, {
		"Content-Type": "multipart/form-data",
	});
};
