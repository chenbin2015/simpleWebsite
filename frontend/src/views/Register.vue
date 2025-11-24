<template>
  <div class="register-page">
    <div class="register-container">
      <div class="register-left">
        <div class="register-brand">
          <Logo />
          <h2>加入我们</h2>
          <p>注册账户，开始您的网站建设之旅</p>
          <ul class="benefits-list">
            <li>✓ 免费注册，立即开始</li>
            <li>✓ 丰富的模板库</li>
            <li>✓ 专业的技术支持</li>
            <li>✓ 安全可靠的服务</li>
          </ul>
        </div>
      </div>
      <div class="register-right">
        <el-card class="register-card" shadow="always">
          <template #header>
            <div class="card-header">
              <h3>用户注册</h3>
            </div>
          </template>
          
          <el-form
            ref="registerFormRef"
            :model="registerForm"
            :rules="registerRules"
            label-width="0"
            size="large"
          >
            <el-form-item prop="username">
              <el-input
                v-model="registerForm.username"
                placeholder="请输入用户名（3-20个字符）"
                clearable
              >
                <template #prefix>
                  <el-icon><User /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item prop="email">
              <el-input
                v-model="registerForm.email"
                placeholder="请输入邮箱地址"
                clearable
              >
                <template #prefix>
                  <el-icon><Message /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item prop="password">
              <el-input
                v-model="registerForm.password"
                type="password"
                placeholder="请输入密码（6-20个字符）"
                show-password
                clearable
              >
                <template #prefix>
                  <el-icon><Lock /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item prop="confirmPassword">
              <el-input
                v-model="registerForm.confirmPassword"
                type="password"
                placeholder="请再次输入密码"
                show-password
                clearable
                @keyup.enter="handleRegister"
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
                @click="handleRegister"
                style="width: 100%"
                size="large"
              >
                立即注册
              </el-button>
            </el-form-item>
            
            <el-form-item>
              <div class="login-link">
                <span>已有账号？</span>
                <el-link type="primary" @click="goToLogin">立即登录</el-link>
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
import { User, Message, Lock } from '@element-plus/icons-vue'
import Logo from '../components/Logo.vue'

export default {
  name: 'Register',
  components: {
    Logo,
    User,
    Message,
    Lock
  },
  data() {
    const validateConfirmPassword = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入密码'))
      } else if (value !== this.registerForm.password) {
        callback(new Error('两次输入的密码不一致'))
      } else {
        callback()
      }
    }
    
    const validateEmail = (rule, value, callback) => {
      const emailPattern = /^[a-zA-Z0-9_+&*-]+(?:\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$/
      if (value === '') {
        callback(new Error('请输入邮箱地址'))
      } else if (!emailPattern.test(value)) {
        callback(new Error('邮箱格式不正确'))
      } else {
        callback()
      }
    }
    
    return {
      registerForm: {
        username: '',
        email: '',
        password: '',
        confirmPassword: ''
      },
      registerRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
        ],
        email: [
          { required: true, validator: validateEmail, trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, validator: validateConfirmPassword, trigger: 'blur' }
        ]
      },
      loading: false
    }
  },
  methods: {
    async handleRegister() {
      this.$refs.registerFormRef.validate(async (valid) => {
        if (!valid) {
          return false
        }
        
        this.loading = true
        try {
          const response = await request.post('/user/register', {
            username: this.registerForm.username,
            email: this.registerForm.email,
            password: this.registerForm.password,
            confirmPassword: this.registerForm.confirmPassword
          })
          
          if (response.success) {
            ElMessage.success(response.message)
            setTimeout(() => {
              this.$router.push('/login')
            }, 1500)
          } else {
            ElMessage.error(response.message)
          }
        } catch (error) {
          ElMessage.error(error.message || '注册失败，请稍后重试')
        } finally {
          this.loading = false
        }
      })
    },
    goToLogin() {
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
.register-page {
  min-height: calc(100vh - 140px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 24px;
  background: linear-gradient(135deg, #ECF0F1 0%, #BDC3C7 100%);
}

.register-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 60px;
  max-width: 1000px;
  width: 100%;
  align-items: center;
}

.register-left {
  color: #2C3E50;
}

.register-brand {
  text-align: center;
}

.register-brand h2 {
  font-size: 36px;
  margin: 24px 0 16px;
  font-weight: 600;
}

.register-brand p {
  font-size: 18px;
  opacity: 0.9;
  margin-bottom: 32px;
}

.benefits-list {
  list-style: none;
  text-align: left;
  max-width: 300px;
  margin: 0 auto;
}

.benefits-list li {
  font-size: 16px;
  margin: 12px 0;
  opacity: 0.9;
}

.register-right {
  display: flex;
  justify-content: center;
}

.register-card {
  width: 100%;
  max-width: 450px;
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

.login-link {
  width: 100%;
  text-align: center;
  font-size: 14px;
}

.login-link span {
  margin-right: 8px;
  color: #606266;
}

@media (max-width: 768px) {
  .register-container {
    grid-template-columns: 1fr;
    gap: 40px;
  }
  
  .register-left {
    display: none;
  }
}
</style>
