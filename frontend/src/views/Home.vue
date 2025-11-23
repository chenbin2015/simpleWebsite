<template>
  <div class="home">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>{{ $t('hello') }}</span>
        </div>
      </template>
      <el-button type="primary" @click="fetchData" :loading="loading">
        {{ $t('getData') }}
      </el-button>
      <div v-if="data" class="data-display">
        <el-alert
          :title="$t('dataFromBackend')"
          type="success"
          :description="JSON.stringify(data, null, 2)"
          show-icon
          :closable="false"
        />
      </div>
      <div v-if="error" class="error-display">
        <el-alert
          :title="error"
          type="error"
          show-icon
          :closable="false"
        />
      </div>
    </el-card>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Home',
  data() {
    return {
      data: null,
      error: null,
      loading: false
    }
  },
  methods: {
    async fetchData() {
      this.loading = true
      this.error = null
      this.data = null
      
      try {
        const response = await axios.get('/api/hello')
        this.data = response.data
      } catch (err) {
        this.error = err.message || '请求失败'
        console.error('Error fetching data:', err)
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.home {
  max-width: 800px;
  margin: 0 auto;
}

.box-card {
  margin-top: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.data-display,
.error-display {
  margin-top: 20px;
}

.data-display pre {
  white-space: pre-wrap;
  word-wrap: break-word;
}
</style>

