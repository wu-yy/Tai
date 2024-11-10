<template>
  <div
    class="flex lg:flex-row-reverse lg:items-center lg:justify-center flex-col lg:w-[80vw] w-full mx-auto overflow-y-auto"
    style="height: calc(100vh - 4rem);">
    <el-form ref="ruleFormRef" :rules="locale === 'zh-cn' ? zhRules : rules" :model="formData"
      class="lg:w-[500px] w-[80%] lg:m-0 lg:pt-0 mx-auto mb-12 pt-8">
      <el-form-item prop="userName">
        <div class="input-item">
          <input type="text" v-model="formData.userName" :placeholder="$t('login.email')" class="form-text">
        </div>
      </el-form-item>
      <el-form-item prop="password">
        <div class="input-item">
          <input type="password" v-model="formData.password" :placeholder="$t('login.password')" class="form-text">
        </div>
      </el-form-item>
      <el-form-item prop="repeatPassword">
        <div class="input-item">
          <input type="password" v-model="formData.repeatPassword" :placeholder="$t('login.confirm')" class="form-text">
        </div>
      </el-form-item>
      <el-form-item prop="identity_code">
        <div class="flex w-full">
          <div class="basis-8/12">
            <input type="text" v-model="formData.identity_code" :placeholder="$t('login.code')" class="form-text">
          </div>
          <div class="basis-4/12 lg:ml-10 ml-4">
            <el-button class="text-black text-center text-base lg:h-16 h-12 w-full border-0 shadow-none cursor-pointer"
              :disabled="loading" @click="getCode">
              {{ getCodeBtn }}
            </el-button>
          </div>
        </div>
      </el-form-item>
      <el-form-item prop="shareCode">
        <div class="input-item">
          <input type="text" v-model="formData.shareCode" :placeholder="$t('login.invitation')"
            class="form-text text-sm">
        </div>
      </el-form-item>
      <el-form-item>
        <div
          class="flex items-center justify-center w-full bg-[#292727] text-white lg:h-16 h-12 lg:text-xl text-base tracking-widest lg:rounded-2xl rounded-lg cursor-pointer"
          @click="toRegister">
          {{ $t('login.signUp') }}
        </div>
        <div class="absolute right-0 bottom-[-1.75rem] text-white cursor-pointer text-sm" @click="toLogin">
          {{ $t('login.noAccount') }}
        </div>
      </el-form-item>
    </el-form>
    <div class="lg:w-1/2 w-full">
      <div class="lg:w-[80%] w-[90%] lg:mx-0 mx-auto text-black lg:text-2xl text-base lg:leading-10">
        {{ $t('login.tips') }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, toRefs, ref, onMounted, watch } from 'vue'
import { sendEmailCode, registerEmail } from "@/http/api/user";
import { ElMessage } from 'element-plus'
import { setSession } from "@/utils/tools";
import { useUserStore } from '@/store'
import { useRouter, useRoute } from 'vue-router'
import { trackEvent } from '@/utils/UmUtils'
import { useI18n } from 'vue-i18n'

const { locale } = useI18n()
const ruleFormRef = ref(null)
const userStore = useUserStore()
const router = useRouter()
const route = useRoute()

onMounted(() => {
  data.formData.shareCode = route.query.code || ''
  if (locale.value === 'zh-cn') {
    data.getCodeBtn = '获取验证码'
  } else {
    data.getCodeBtn = 'get verification code'
  }
})

const data = reactive({
  formData: {},
  loading: false,
  signLoading: false,
  getCodeBtn: 'get verification code',
  codeSecond: 60,
  timer: null,
})

watch(() => locale.value, (newVal) => {
  if (data.getCodeBtn === 'get verification code' && newVal === 'zh-cn') {
    data.getCodeBtn = '获取验证码'
  } else if (data.getCodeBtn === '获取验证码' && newVal === 'en-us') {
    data.getCodeBtn = 'get verification code'
  }
})

const checkPassword = (rule, value, callback) => {
  if (!value) {
    return callback();
  } else {
    if (value.length >= 6) {
      callback();
    } else {
      if (locale.value === 'zh-cn') {
        return callback(new Error('密码长度不能少于6位数'));
      } else {
        return callback(new Error('Password length must not be less than 6'));
      }
    }
  }
}

const checkRepeat = (rule, value, callback) => {
  if (!value) {
    return callback();
  } else {
    if (value === data.formData.password) {
      callback();
    } else {
      if (locale.value === 'zh-cn') {
        return callback(new Error('两次输入的密码不一致'));
      } else {
        return callback(new Error('Incorrect password'));
      }
    }
  }
}

// const checkEmail = (rule, value, callback) => {
//   if (!value) {
//     return callback();
//   } else {
//     const reg = /^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
//     if (reg.test(value)) {
//       callback();
//     } else {
//       if (locale.value === 'zh-cn') {
//         return callback(new Error('错误的邮箱格式'));
//       } else {
//         return callback(new Error('Incorrect email'));
//       }
//     }
//   }
// }

const rules = reactive({
  userName: [
    { required: true, message: 'Empty email', trigger: 'blur' }
  ],
  identity_code: [
    { required: true, message: 'Empty code', trigger: 'blur' },
  ],
  password: [
    { required: true, message: 'Empty password', trigger: 'blur' },
    { validator: checkPassword, trigger: 'blur' }
  ],
  repeatPassword: [
    { required: true, message: 'Enter your password again', trigger: 'blur' },
    { validator: checkRepeat, trigger: 'blur' }
  ]
})

const zhRules = reactive({
  userName: [
    { required: true, message: '邮箱为空', trigger: 'blur' }
  ],
  identity_code: [
    { required: true, message: '验证码为空', trigger: 'blur' },
  ],
  password: [
    { required: true, message: '密码为空', trigger: 'blur' },
    { validator: checkPassword, trigger: 'blur' }
  ],
  repeatPassword: [
    { required: true, message: '请再次输入你的密码', trigger: 'blur' },
    { validator: checkRepeat, trigger: 'blur' }
  ]
})

let timer = null
const getCode = () => {
  ruleFormRef.value.validateField(["userName"], isOk => {
    if (isOk) {
      data.loading = true
      timer = setInterval(() => {
        if (data.codeSecond > 0) {
          data.getCodeBtn = data.codeSecond--
        } else {
          if (locale.value === 'zh-cn') {
            data.getCodeBtn = '获取验证码'
          } else {
            data.getCodeBtn = 'get verification code'
          }
          data.codeSecond = 60
          data.loading = false
          window.clearInterval(timer)
        }
      }, 1000)
      sendEmailCode({
        email: data.formData.userName,
        appCode: 'nes'
      }).then(() => {
        if (locale.value === 'zh-cn') {
          ElMessage({
            message: '验证码发送成功',
            type: 'success',
          })
        } else {
          ElMessage({
            message: 'Verification code is sent successfully',
            type: 'success',
          })
        }
      })
    }
  })
}

const toRegister = () => {
  ruleFormRef.value.validate(isOk => {
    if (isOk) {
      if (!data.signLoading) {
        data.signLoading = true
        registerEmail({
          password: data.formData.password,
          email: data.formData.userName,
          vCode: data.formData.identity_code,
          inviteCode: data.formData.shareCode,
          defaultLogin: true,
          appCode: 'nes'
        }).then(res => {
          setSession('authToken', res.data.neverendsart_session)
          userStore.setIsLogin(true)
          router.push('/')
          trackEvent('Um_Event_RegisterSuc', '注册', '注册成功')
        }).catch(err => {
          trackEvent('Um_Event_RegisterFailed', '注册', err.message)
          if (err.errNo == 100007) {
            router.push('/login')
          } else {
            data.signLoading = false
          }
        })
      }
    }
  })
}

const toLogin = () => {
  router.push('/login')
}

const { formData, loading, getCodeBtn } = toRefs(data)

</script>

<style scoped lang="less">
.input-item {
//   @apply flex w-full lg:h-16 h-12 bg-[#292727] lg:rounded-2xl rounded-lg;
    // @apply flex w-full lg:h-16 h-12 bg-[#20B2AA] lg:rounded-2xl rounded-lg; /* 湖蓝色 */
    @apply flex w-full lg:h-16 h-12 bg-[#FF0000] lg:rounded-2xl rounded-lg; /* 红色 */
}

.form-text {
  @apply w-full lg:h-16 h-12 lg:text-xl text-base lg:rounded-2xl rounded-lg text-white bg-[#292727] pl-4;
}

:deep(.el-form-item) {
  @apply lg:mb-12 mb-8 lg:h-16 h-12;
}

:deep(.el-form-item:last-child) {
  @apply mb-0;
}

:deep(.el-form-item__error) {
  @apply mt-2 mb-4 ml-4;
}

:deep(.el-button) {
  @apply rounded-xl;
  background-color: transparent !important;
}
</style>