const { defineConfig } = require("@vue/cli-service");
const path = require("path");
const CompressionWebpackPlugin = require("compression-webpack-plugin");
const CspHtmlWebpackPlugin = require('csp-html-webpack-plugin');

function resolve(dir) {
	return path.join(__dirname, dir);
}

module.exports = defineConfig({
	transpileDependencies: true,
	productionSourceMap: false,
	outputDir: process.env.outputDir,
	configureWebpack: (config) => {
		const plugins = [];
		plugins.push(
			new CompressionWebpackPlugin({
				algorithm: "gzip",
				test: /\.js$|\.css$/,
				threshold: 10240,
			})
		);
		config.plugins = [...config.plugins, ...plugins];
	},
	configureWebpack: {
		plugins: [
		  new CspHtmlWebpackPlugin(
			{
			  'default-src': ["'self'"],
			  'img-src': ["'self'", 'data:', 'https://cdnfile.atomecho.cn'],
			  'script-src': ["'self'", "'unsafe-inline'"],
			  'style-src': ["'self'", "'unsafe-inline'"],
			  // 其他需要的指令
			},
			{
			  nonceEnabled: {
				'script-src': false,
				'style-src': false,
			  },
			}
		  ),
		],
	},
	chainWebpack: (config) => {
		config.plugin("html").tap((args) => {
			args[0].title = "tai";
			return args;
		});
		//最小化代码
		config.optimization.minimize(true);
		//分割代码
		config.optimization.splitChunks({
			chunks: "all",
		});
		//默认开启prefetch(预先加载模块)，提前获取用户未来可能会访问的内容 在首屏会把这十几个路由文件，都一口气下载了 所以我们要关闭这个功能模块
		config.plugins.delete("prefetch");
		config.module.rules.delete("svg"); // 重点:删除默认配置中处理svg
		config.module
			.rule("svg-sprite-loader") // rule 匹配规则
			.test(/\.svg$/) // 用正则匹配 文件
			.include // 包含
			.add(resolve("src/icons")) // 处理svg目录
			.end()
			// eslint-disable-next-line no-irregular-whitespace
			.use("svg-sprite-loader") //配置loader  use() 使用哪个loader
			.loader("svg-sprite-loader") // 加载loader
			.options({
				symbolId: "icon-[name]", // 将所有的.svg 集成到 symbol中，当使用 类名 icon-文件名
			});
	},
	devServer: {
		proxy: {
			"/serverApi": {
				target: "https://gateway.atomecho.cn/",
				// target: "http://192.168.10.85:8081/",
				pathRewrite: {
					"^/serverApi": "/",
				},
				changeOrigin: true,
				// onProxyRes(proxyRes) {
				// 	// 设置响应头，允许接收流数据
				// 	proxyRes.headers["transfer-encoding"] = "chunked";
				// 	proxyRes.headers["content-type"] = "application/octet-stream";
				// },
			},
		},
	},
});
