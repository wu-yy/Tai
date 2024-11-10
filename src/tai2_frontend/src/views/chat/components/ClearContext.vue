/**
* create by zhangxiang on 2023-07-14 14:11
* 类注释：
* 备注：
*/
<template>
  <div class="order">
    <span class="line"></span>
    <span class="txt">上下文已清除</span>
    <span class="line"></span>
  </div>
</template>

<style scoped lang="less">

.order {
  height: 80px;
  line-height: 80px;
  text-align: center;
}

.order .line {
  display: inline-block;
  width: 10vw;
  vertical-align: middle;
  border-top: 3px dotted #ccc;
}

.order .txt {
  color: #303030;
  padding: 0 20px;
  vertical-align: middle;
  opacity: .5;
}
</style>