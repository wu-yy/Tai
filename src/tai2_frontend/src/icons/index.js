// const req = require.context('./svg', true, /\.svg$/)
// const requireAll = requireContext => requireContext.keys().map(requireContext)
// requireAll(req)

// // 使用 import.meta.glob 替代 require.context
const svgModules = import.meta.glob('./svg/*.svg', { eager: true });

// 模拟 requireAll 功能，遍历并加载所有 SVG 模块
const requireAll = modules => Object.keys(modules).map(key => modules[key]);

requireAll(svgModules);
