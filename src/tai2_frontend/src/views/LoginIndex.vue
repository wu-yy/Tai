<template>
  <div
    class="flex lg:flex-row-reverse lg:items-center lg:justify-center flex-col md:w-[80vw] w-full mx-auto overflow-y-auto"
    style="height: calc(100vh - 4rem);">
    <div>
      <div class="flex lg:mb-12 mb-8 text-base lg:text-xl text-white" v-show="locale === 'zh-cn'">
        <div class="mr-4 lg:mr-6 xl:mr-8 cursor-pointer" :class="tagIndex === 0 ? '' : 'opacity-50'"
          @click="tagIndex = 0">
          {{ $t('login.Email') }}
        </div>
        <div class="cursor-pointer" :class="tagIndex === 1 ? '' : 'opacity-50'" @click="tagIndex = 1">
          {{ $t('login.phone') }}
        </div>
      </div>
      <el-form ref="emailFormRef" :rules="locale === 'zh-cn' ? emailZhRules : emailRules" :model="emailData"
        class="lg:w-[500px] w-[80%] lg:m-0 lg:pt-0 mx-auto mb-12 pt-8" v-show="tagIndex === 0">
        <!-- <el-form-item prop="google">
          <div class="input-item">
            <div
              class="relative w-full lg:h-16 h-12 lg:text-xl text-base text-black text-center bg-white lg:rounded-2xl rounded-lg cursor-pointer"
              @click="toGoogle">
              <div class="flex items-center w-fit h-full mx-auto">
                <svg-icon icon-class="google" class-name="mr-4 w-5 h-5"></svg-icon>
                <div>Sign in with Google</div>
              </div>
              <div
                class="absolute lg:top-[5rem] top-[3.5rem] left-1/2 text-gray-500 lg:text-base text-xs -translate-x-1/2">
                {{ $t('login.or') }}</div>
            </div>
          </div>
        </el-form-item> -->
        <el-form-item prop="userName">
          <div class="input-item">
            <input type="text" v-model="emailData.userName" :placeholder="$t('login.email')" class="form-text">
          </div>
        </el-form-item>
        <el-form-item prop="password">
          <div class="input-item">
            <input type="password" v-model="emailData.password" :placeholder="$t('login.password')" class="form-text"
              autocomplete>
          </div>
        </el-form-item>
        <el-form-item>
          <div
            class="flex items-center justify-center w-full bg-[#292727] text-white lg:h-16 h-12 lg:text-xl text-base tracking-widest lg:rounded-2xl rounded-lg cursor-pointer"
            @click="toLogin">
            {{ $t('login.logIn') }}
          </div>
          <div class="absolute right-0 bottom-[-1.75rem] text-white cursor-pointer text-sm" @click="toRegister">
            {{ $t('login.noAccount') }}
          </div>
        </el-form-item>
      </el-form>
      <el-form ref="phoneFormRef" :rules="phoneRules" :model="phoneData"
        class="lg:w-[500px] w-[80%] lg:m-0 lg:pt-0 mx-auto mb-12 pt-8" v-show="tagIndex === 1">
        <el-form-item prop="phone">
          <div class="input-item">
            <input type="text" v-model="phoneData.phone" placeholder="手机号" class="form-text">
          </div>
        </el-form-item>
        <el-form-item prop="smscode">
          <div class="flex items-center w-full">
            <div class="flex-[5]">
              <input placeholder="验证码" v-model="phoneData.smscode" class="form-text">
            </div>
            <div class="flex-[3] ml-4 sm:ml-8">
              <el-button
                class="text-white text-center text-base lg:h-16 h-12 w-full border-0 shadow-none cursor-pointer"
                :disabled="loading" @click="getCode">
                {{ getCodeBtn }}
              </el-button>
            </div>
          </div>
        </el-form-item>
        <el-form-item>
          <div
            class="flex items-center justify-center w-full bg-[#292727] text-white lg:h-16 h-12 lg:text-xl text-base tracking-widest lg:rounded-2xl rounded-lg cursor-pointer"
            @click="toPhoneLogin">
            {{ $t('login.logIn') }}
          </div>
          <div class="absolute right-0 bottom-[-1.75rem] text-yellow cursor-pointer text-sm text-custom-yellow" @click="toRegister">
            {{ $t('login.noAccount') }}
          </div>
        </el-form-item>
      </el-form>
    </div>
    <div class="lg:w-1/2 w-full">
      <div class="lg:w-[80%] w-[90%] lg:mx-0 mx-auto text-black lg:text-2xl text-base leading-10">
        {{ $t('login.tips') }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, toRefs, ref, onBeforeUnmount, watch } from 'vue'
import { loginEmail, login, smscode } from "@/http/api/user";
import { setSession } from "@/utils/tools";
import { useUserStore } from '@/store'
import { useRouter } from 'vue-router'
import { trackEvent } from '@/utils/UmUtils'
import { ElMessage } from 'element-plus';
import { useI18n } from 'vue-i18n'

const emailFormRef = ref(null)
const phoneFormRef = ref(null)
const userStore = useUserStore()
const router = useRouter()
const tagIndex = ref(0)
const { locale } = useI18n()

const data = reactive({
  emailData: {},
  phoneData: {},
  loading: false,
  getCodeBtn: '验证码',
  codeSecond: 60,
  timer: null,
})
const { emailData, phoneData, loading, getCodeBtn } = toRefs(data)

watch(() => locale.value, (newVal) => {
  if (newVal === "en-us") {
    tagIndex.value = 0
  }
})

const checkPhone = (rule, value, callback) => {
  if (!value) {
    return callback(new Error('手机号不能为空'));
  } else {
    const reg = /^1[3|4|5|6|7|8|9][0-9]\d{8}$/
    if (reg.test(value)) {
      callback();
    } else {
      return callback(new Error('请输入正确的手机号'));
    }
  }
};

const emailRules = reactive({
  userName: [
    { required: true, message: 'Empty email', trigger: 'blur' }
  ],
  password: [
    { required: true, message: 'Empty password', trigger: 'blur' },
  ]
})

const emailZhRules = reactive({
  userName: [
    { required: true, message: '邮箱不能为空', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '密码不能为空', trigger: 'blur' },
  ]
})

const phoneRules = reactive({
  phone: [
    { required: true, message: '手机号为空', trigger: 'blur' },
    { validator: checkPhone, trigger: 'blur' }
  ],
  smscode: [
    { required: true, message: '验证码为空', trigger: 'blur' },
  ]
})

const toLogin = () => {
  console.log("toLogin 179......")
  emailFormRef.value.validate(isOk => {
    if (isOk) {
      if (!data.loading) {
        data.loading = true
        loginEmail({
          email: data.emailData.userName,
          password: data.emailData.password,
          appCode: 'nes'
        }).then(res => {
          setSession("authToken", res.data.neverendsart_session)
          setSession("userId", res.data.userId)
          setSession("userName", res.data.userName)
          console.log("登录session1:", res.data)
          console.log("登录session2:", res.data.neverendsart_session)
          userStore.setIsLogin(true)
          router.push('/')
          trackEvent('Um_Event_LoginSuc', '登录', '登录成功')
        }).catch(err => {
          console.log("187 error:", err)
          trackEvent('Um_Event_LoginFailed', '登录', err.message)
          if (err.errNo == 100005) {
            router.push('/register')
          } else {
            data.loading = false
          }
        })
      }
    }
  })
}

const getCode = () => {
  phoneFormRef.value.validateField(["phone"], isOk => {
    if (isOk) {
      data.loading = true
      data.timer = setInterval(() => {
        if (data.codeSecond > 0) {
          data.getCodeBtn = data.codeSecond--
        } else {
          data.getCodeBtn = 'Get Code'
          data.codeSecond = 60
          data.loading = false
          window.clearInterval(data.timer)
        }
      }, 1000)
      smscode({
        phone: data.phoneData.phone,
        sendType: 0
      }).then(() => {
        ElMessage({
          message: 'Send Code sucess',
          type: 'success',
        })
      })
    }
  })
}

const toPhoneLogin = () => {
  phoneFormRef.value.validate(isOk => {
    if (isOk) {
      if (!data.loginLoading) {
        data.loginLoading = true
        login({
          phone: data.phoneData.phone,
          smsCode: data.phoneData.smsCode,
          appCode: 'nes'
        }).then(res => {
          setSession("authToken", res.data.neverendsart_session)
          userStore.setIsLogin(true)
          router.push('/')
          trackEvent('Um_Event_LoginSuc', '登录', '登录成功')
        }).catch(err => {
          trackEvent('Um_Event_LoginFailed', '登录', err.message)
          if (err.errNo == 100005) {
            router.push('/register')
          } else {
            data.loading = false
          }
        })
      }
    }
  })
}

const toRegister = () => {
  router.push('/register')
}

// const toGoogle = () => {
//   trackEvent('Um_Event_Google_Login', 'google登录', '')
//   window.location.href = `https://oauth.neverendsart.${process.env.VUE_APP_GOOGLE_DOMAIN}/oauth?state=${process.env.VUE_APP_GOOGLE}`
// }

onBeforeUnmount(() => {
  if (data.timer) window.clearInterval(data.timer)
})

</script>

<style scoped lang="less">
.input-item {
  @apply flex w-full lg:h-16 h-12 bg-[#292727] lg:rounded-2xl rounded-lg;
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

.text-custom-yellow {
  color: #FFD700 !important;
}
</style>