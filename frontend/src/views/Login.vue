<template>
  <div class="login-page">
    <div class="login-container">
      <div class="login-left">
        <div class="login-brand">
          <Logo />
          <h2>欢迎回来</h2>
          <p>登录您的账户，开始构建专业网站</p>
        </div>
      </div>
      <div class="login-right">
        <el-card class="login-card" shadow="always">
          <template #header>
            <div class="card-header">
              <h3>用户登录</h3>
            </div>
          </template>
          
          <el-form
            ref="loginFormRef"
            :model="loginForm"
            :rules="loginRules"
            label-width="0"
            size="large"
          >
            <el-form-item prop="username">
              <el-input
                v-model="loginForm.username"
                placeholder="请输入用户名"
                clearable
              >
                <template #prefix>
                  <el-icon><User /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                placeholder="请输入密码"
                show-password
                clearable
                @keyup.enter="handleLogin"
              >
                <template #prefix>
                  <el-icon><Lock /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item>
              <el-button
                type="primary"
                :loading="loading"
                @click="handleLogin"
                style="width: 100%"
                size="large"
              >
                登录
              </el-button>
            </el-form-item>
            
            <el-form-item>
              <div class="register-link">
                <span>还没有账号？</span>
                <el-link type="primary" @click="goToRegister">立即注册</el-link>
              </div>
            </el-form-item>
          </el-form>
        </el-card>
      </div>
    </div>
  </div>
</template>

<script>
import request from '../utils/request'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'
import Logo from '../components/Logo.vue'

export default {
  name: 'Login',
  components: {
    Logo,
    User,
    Lock
  },
  data() {
    return {
      loginForm: {
        username: '',
        password: ''
      },
      loginRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ]
      },
      loading: false
    }
  },
  methods: {
    async handleLogin() {
      this.$refs.loginFormRef.validate(async (valid) => {
        if (!valid) {
          return false
        }
        
        this.loading = true
        try {
          const response = await request.post('/user/login', {
            username: this.loginForm.username,
            password: this.loginForm.password
          })
          
          if (response.success) {
            ElMessage.success(response.message)
            // 存储token和用户信息
            localStorage.setItem('token', response.token)
            localStorage.setItem('user', JSON.stringify(response.user))
            // 存储token过期时间（24小时后）
            const expireTime = Date.now() + 24 * 60 * 60 * 1000
            localStorage.setItem('tokenExpire', expireTime.toString())
            this.$router.push('/')
          } else {
            ElMessage.error(response.message)
          }
        } catch (error) {
          ElMessage.error(error.message || '登录失败，请稍后重试')
        } finally {
          this.loading = false
        }
      })
    },
    goToRegister() {
      this.$router.push('/register')
    }
  }
}
</script>

<style scoped>
.login-page {
  min-height: calc(100vh - 140px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 24px;
  background: linear-gradient(135deg, #ECF0F1 0%, #BDC3C7 100%);
}

.login-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 60px;
  max-width: 1000px;
  width: 100%;
  align-items: center;
}

.login-left {
  color: #2C3E50;
}

.login-brand {
  text-align: center;
}

.login-brand h2 {
  font-size: 36px;
  margin: 24px 0 16px;
  font-weight: 600;
}

.login-brand p {
  font-size: 18px;
  opacity: 0.9;
}

.login-right {
  display: flex;
  justify-content: center;
}

.login-card {
  width: 100%;
  max-width: 420px;
  border-radius: 12px;
}

.card-header {
  text-align: center;
}

.card-header h3 {
  margin: 0;
  font-size: 24px;
  color: #303133;
  font-weight: 600;
}

.register-link {
  width: 100%;
  text-align: center;
  font-size: 14px;
}

.register-link span {
  margin-right: 8px;
  color: #606266;
}

@media (max-width: 768px) {
  .login-container {
    grid-template-columns: 1fr;
    gap: 40px;
  }
  
  .login-left {
    display: none;
  }
}
</style>
