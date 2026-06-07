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
      <p class="auth-tagline">Fast geschafft 💪</p>

      <div class="auth-card">
        <div v-if="tokenInvalid" class="invalid-state">
          <div class="invalid-icon">❌</div>
          <h3>Link ungültig oder abgelaufen</h3>
          <p>Bitte fordere einen neuen Reset-Link an.</p>
          <router-link to="/forgot-password" class="btn-primary" style="display:block;text-align:center;margin-top:1.2rem;text-decoration:none;">Neuen Link anfordern</router-link>
        </div>

        <template v-else-if="!done">
          <h1>Neues Passwort</h1>
          <p class="auth-subtitle">Wähle ein neues sicheres Passwort für deinen Account.</p>

          <form @submit.prevent="handleSubmit" novalidate>
            <div class="form-group">
              <label for="password">Neues Passwort</label>
              <div class="input-wrapper">
                <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                <input :type="showPw ? 'text' : 'password'" id="password" v-model="password" placeholder="Mindestens 6 Zeichen" required />
                <button type="button" class="toggle-pw" @click="showPw = !showPw">{{ showPw ? '🙈' : '👁️' }}</button>
              </div>
            </div>
            <div class="form-group">
              <label for="confirm">Passwort bestätigen</label>
              <div class="input-wrapper">
                <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                <input :type="showPw ? 'text' : 'password'" id="confirm" v-model="confirm" placeholder="Passwort wiederholen" required />
              </div>
            </div>

            <div class="strength-bar" v-if="password">
              <div class="strength-fill" :style="{ width: strengthPct + '%', background: strengthColor }"></div>
            </div>
            <div class="strength-label" v-if="password">{{ strengthLabel }}</div>

            <button type="submit" class="btn-primary" :disabled="loading">
              <span v-if="loading" class="spinner"></span>
              {{ loading ? 'Wird gespeichert…' : 'Passwort speichern' }}
            </button>
          </form>

          <div v-if="message" :class="['msg', 'error']">{{ message }}</div>
        </template>

        <div v-else class="success-state">
          <div class="success-icon">✅</div>
          <h3>Passwort gesetzt!</h3>
          <p>Dein Passwort wurde erfolgreich geändert.</p>
          <router-link to="/login" class="btn-primary" style="display:block;text-align:center;margin-top:1.2rem;text-decoration:none;">Jetzt anmelden</router-link>
        </div>

        <p v-if="!done && !tokenInvalid" class="footer-link">
          <router-link to="/login">← Zurück zum Login</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const token = ref('')
const password = ref('')
const confirm = ref('')
const loading = ref(false)
const message = ref('')
const done = ref(false)
const tokenInvalid = ref(false)
const showPw = ref(false)

onMounted(() => {
  token.value = route.query.token || ''
  if (!token.value) tokenInvalid.value = true
})

const strengthPct = computed(() => {
  const p = password.value
  if (!p) return 0
  let s = 0
  if (p.length >= 6) s += 25
  if (p.length >= 10) s += 25
  if (/[A-Z]/.test(p)) s += 25
  if (/[0-9!@#$%^&*]/.test(p)) s += 25
  return s
})

const strengthColor = computed(() => {
  if (strengthPct.value <= 25) return '#ef4444'
  if (strengthPct.value <= 50) return '#f97316'
  if (strengthPct.value <= 75) return '#eab308'
  return '#22c55e'
})

const strengthLabel = computed(() => {
  if (strengthPct.value <= 25) return 'Schwach'
  if (strengthPct.value <= 50) return 'Mittel'
  if (strengthPct.value <= 75) return 'Gut'
  return 'Stark 💪'
})

async function handleSubmit() {
  message.value = ''
  if (!password.value || !confirm.value) { message.value = 'Bitte alle Felder ausfüllen.'; return }
  if (password.value !== confirm.value) { message.value = 'Passwörter stimmen nicht überein.'; return }
  if (password.value.length < 6) { message.value = 'Passwort muss mindestens 6 Zeichen haben.'; return }

  loading.value = true
  try {
    const res = await fetch('/api/auth/reset-password', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ token: token.value, password: password.value }),
    })
    const data = await res.json()
    if (res.ok) {
      done.value = true
    } else {
      if (data.error?.includes('Ungültig') || data.error?.includes('abgelaufen') || data.error?.includes('verwendet')) {
        tokenInvalid.value = true
      } else {
        message.value = data.error || 'Fehler. Bitte erneut versuchen.'
      }
    }
  } catch {
    message.value = 'Server nicht erreichbar.'
  }
  loading.value = false
}
</script>

<style scoped>
.auth-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem; position: relative; background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%); }
.auth-bg { position: fixed; inset: 0; background: radial-gradient(ellipse at 80% 50%, rgba(59,130,246,0.08) 0%, transparent 60%), radial-gradient(ellipse at 20% 20%, rgba(96,165,250,0.06) 0%, transparent 60%); pointer-events: none; }
.auth-container { position: relative; z-index: 1; width: 100%; max-width: 440px; animation: fadeIn 0.5s ease; }
.auth-logo { display: flex; align-items: center; justify-content: center; gap: 0.6rem; margin-bottom: 0.3rem; }
.logo-text { font-size: 1.6rem; font-weight: 900; background: linear-gradient(90deg,#3b82f6,#60a5fa); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.auth-tagline { color: #94a3b8; font-size: 0.9rem; text-align: center; margin-bottom: 2rem; }
.auth-card { background: #1e293b; border: 1px solid #334155; border-radius: 20px; padding: 2.5rem 2.2rem; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.4); }
.auth-card h1 { font-size: 1.5rem; font-weight: 700; color: #f8fafc; margin-bottom: 0.3rem; }
.auth-subtitle { color: #94a3b8; font-size: 0.88rem; margin-bottom: 2rem; }
.form-group { margin-bottom: 1.2rem; }
.form-group label { display: block; font-size: 0.82rem; font-weight: 600; color: #94a3b8; margin-bottom: 0.45rem; text-transform: uppercase; letter-spacing: 0.5px; }
.input-wrapper { position: relative; }
.input-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #64748b; pointer-events: none; }
.input-wrapper input { width: 100%; padding: 0.8rem 2.8rem; background: #0f172a; border: 1.5px solid #334155; border-radius: 10px; color: #f8fafc; font-size: 0.95rem; font-family: inherit; transition: border-color 0.2s; outline: none; box-sizing: border-box; }
.input-wrapper input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.15); }
.input-wrapper input::placeholder { color: #475569; }
.toggle-pw { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; font-size: 1rem; padding: 0.2rem; }
.strength-bar { height: 4px; background: #334155; border-radius: 2px; margin: -0.5rem 0 0.3rem; overflow: hidden; }
.strength-fill { height: 100%; border-radius: 2px; transition: all 0.3s; }
.strength-label { font-size: 0.75rem; color: #64748b; margin-bottom: 1rem; }
.btn-primary { width: 100%; padding: 0.85rem; margin-top: 0.6rem; background: linear-gradient(135deg,#3b82f6,#2563eb); color: #fff; border: none; border-radius: 10px; font-size: 0.97rem; font-weight: 700; font-family: inherit; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; justify-content: center; gap: 0.5rem; }
.btn-primary:hover:not(:disabled) { background: linear-gradient(135deg,#2563eb,#1d4ed8); transform: translateY(-1px); box-shadow: 0 4px 12px rgba(59,130,246,0.4); }
.btn-primary:disabled { opacity: 0.6; cursor: not-allowed; }
.spinner { display: inline-block; width: 16px; height: 16px; border: 2px solid rgba(255,255,255,0.3); border-top-color: #fff; border-radius: 50%; animation: spin 0.6s linear infinite; }
.success-state, .invalid-state { text-align: center; padding: 1rem 0; }
.success-icon, .invalid-icon { font-size: 3rem; margin-bottom: 0.8rem; }
.success-state h3, .invalid-state h3 { color: #f8fafc; font-size: 1.2rem; margin-bottom: 0.5rem; }
.success-state p, .invalid-state p { color: #94a3b8; font-size: 0.88rem; }
.msg { margin-top: 1.2rem; padding: 0.75rem 1rem; border-radius: 10px; font-size: 0.88rem; font-weight: 500; background: rgba(239,68,68,0.12); border: 1px solid rgba(239,68,68,0.3); color: #f87171; }
.footer-link { text-align: center; margin-top: 1.6rem; font-size: 0.87rem; }
.footer-link a { color: #60a5fa; text-decoration: none; font-weight: 600; }
.footer-link a:hover { color: #93c5fd; text-decoration: underline; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
@keyframes spin { to { transform: rotate(360deg); } }
</style>
