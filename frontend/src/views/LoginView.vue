<template>
  <div class="auth-page">
    <div class="auth-bg"></div>
    <div class="auth-container">
      <div class="auth-logo">
        <div class="logo-icon">
          <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
            <circle cx="16" cy="16" r="14" fill="url(#grad)" />
            <path d="M10 16 L14 20 L22 12" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
            <defs><linearGradient id="grad" x1="0" y1="0" x2="32" y2="32"><stop stop-color="#3b82f6"/><stop offset="1" stop-color="#60a5fa"/></linearGradient></defs>
          </svg>
        </div>
        <span class="logo-text">HealthSync</span>
      </div>
      <p class="auth-tagline">Willkommen zurück 👋</p>

      <div class="auth-card">
        <h1>Anmelden</h1>
        <p class="auth-subtitle">Melde dich an, um dein Dashboard zu sehen.</p>

        <form @submit.prevent="handleLogin" novalidate>
          <div class="form-group">
            <label for="email">E-Mail-Adresse</label>
            <div class="input-wrapper">
              <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
              <input
                type="email"
                id="email"
                v-model="email"
                placeholder="name@beispiel.de"
                required
                autocomplete="email"
              />
            </div>
          </div>
          <div class="form-group">
            <label for="password">Passwort</label>
            <div class="input-wrapper">
              <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
              <input
                type="password"
                id="password"
                v-model="password"
                placeholder="Dein Passwort"
                required
                autocomplete="current-password"
              />
            </div>
          </div>

          <button type="submit" class="btn-primary" :disabled="loading">
            <span v-if="loading" class="spinner"></span>
            {{ loading ? 'Anmelden…' : 'Anmelden' }}
          </button>
        </form>

        <div v-if="message" :class="['msg', messageType]">{{ message }}</div>

        <p class="footer-link" style="margin-top:0.8rem;">
          <router-link to="/forgot-password">Passwort vergessen?</router-link>
        </p>
        <p class="footer-link">
          Noch kein Konto? <router-link to="/register">Jetzt registrieren</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const email = ref('')
const password = ref('')
const loading = ref(false)
const message = ref('')
const messageType = ref('')

async function handleLogin() {
  message.value = ''
  messageType.value = ''

  if (!email.value || !password.value) {
    message.value = 'Bitte alle Felder ausfüllen.'
    messageType.value = 'error'
    return
  }

  loading.value = true

  try {
    const res = await fetch('/api/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: email.value, password: password.value }),
    })
    const data = await res.json()

    if (res.ok) {
      localStorage.setItem('hs_token', data.token)
      localStorage.setItem('hs_user', JSON.stringify(data.user))
      router.push('/dashboard')
    } else {
      message.value = '⚠️ ' + data.error
      messageType.value = 'error'
    }
  } catch {
    message.value = '❌ Server nicht erreichbar. Läuft der Server?'
    messageType.value = 'error'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  position: relative;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%);
}

.auth-bg {
  position: fixed;
  inset: 0;
  background:
    radial-gradient(ellipse at 80% 50%, rgba(59, 130, 246, 0.08) 0%, transparent 60%),
    radial-gradient(ellipse at 20% 20%, rgba(96, 165, 250, 0.06) 0%, transparent 60%),
    radial-gradient(ellipse at 50% 80%, rgba(16, 185, 129, 0.05) 0%, transparent 60%);
  pointer-events: none;
}

.auth-container {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 440px;
  animation: fadeIn 0.5s ease;
}

.auth-logo {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  margin-bottom: 0.3rem;
}

.logo-icon {
  display: flex;
  align-items: center;
}

.logo-text {
  font-size: 1.6rem;
  font-weight: 900;
  background: linear-gradient(90deg, #3b82f6, #60a5fa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.auth-tagline {
  color: #94a3b8;
  font-size: 0.9rem;
  text-align: center;
  margin-bottom: 2rem;
}

.auth-card {
  background: #1e293b;
  border: 1px solid #334155;
  border-radius: 20px;
  padding: 2.5rem 2.2rem;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.4);
}

.auth-card h1 {
  font-size: 1.5rem;
  font-weight: 700;
  color: #f8fafc;
  margin-bottom: 0.3rem;
}

.auth-subtitle {
  color: #94a3b8;
  font-size: 0.88rem;
  margin-bottom: 2rem;
}

.form-group {
  margin-bottom: 1.2rem;
}

.form-group label {
  display: block;
  font-size: 0.82rem;
  font-weight: 600;
  color: #94a3b8;
  margin-bottom: 0.45rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.input-wrapper {
  position: relative;
}

.input-icon {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  color: #64748b;
  pointer-events: none;
}

.input-wrapper input {
  width: 100%;
  padding: 0.8rem 1rem 0.8rem 2.8rem;
  background: #0f172a;
  border: 1.5px solid #334155;
  border-radius: 10px;
  color: #f8fafc;
  font-size: 0.95rem;
  font-family: inherit;
  transition: border-color 0.2s, box-shadow 0.2s;
  outline: none;
}

.input-wrapper input:focus {
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}

.input-wrapper input::placeholder {
  color: #475569;
}

.btn-primary {
  width: 100%;
  padding: 0.85rem;
  margin-top: 0.6rem;
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  color: #ffffff;
  border: none;
  border-radius: 10px;
  font-size: 0.97rem;
  font-weight: 700;
  font-family: inherit;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.btn-primary:hover {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.spinner {
  display: inline-block;
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: #ffffff;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

.msg {
  margin-top: 1.2rem;
  padding: 0.75rem 1rem;
  border-radius: 10px;
  font-size: 0.88rem;
  font-weight: 500;
}

.msg.error {
  background: rgba(239, 68, 68, 0.12);
  border: 1px solid rgba(239, 68, 68, 0.3);
  color: #f87171;
}

.msg.success {
  background: rgba(16, 185, 129, 0.12);
  border: 1px solid rgba(16, 185, 129, 0.3);
  color: #34d399;
}

.footer-link {
  text-align: center;
  margin-top: 1.6rem;
  font-size: 0.87rem;
  color: #94a3b8;
}

.footer-link a {
  color: #60a5fa;
  text-decoration: none;
  font-weight: 600;
  transition: color 0.2s;
}

.footer-link a:hover {
  color: #93c5fd;
  text-decoration: underline;
}
</style>
