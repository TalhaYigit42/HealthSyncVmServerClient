<template>
  <div class="dashboard-layout">
    <Sidebar :username="username" active-nav="Settings" />
    <main class="dashboard-main">

      <div class="dash-header">
        <div>
          <h1 class="page-title"><span class="page-icon">⚙️</span> Settings</h1>
          <p class="page-sub">Manage your profile, goals, and preferences.</p>
        </div>
      </div>

      <!-- Profile -->
      <div class="settings-section">
        <div class="section-header">
          <div class="section-icon profile-icon">👤</div>
          <div>
            <div class="section-title">Profile</div>
            <div class="section-sub">Your personal information</div>
          </div>
        </div>
        <div class="form-grid">
          <div class="form-group">
            <label>Full Name</label>
            <input type="text" :value="fullName" readonly />
          </div>
          <div class="form-group">
            <label>Email</label>
            <input type="email" :value="userEmail" readonly />
          </div>
        </div>
      </div>

      <!-- Health Goals -->
      <div class="settings-section">
        <div class="section-header">
          <div class="section-icon goals-icon">🎯</div>
          <div>
            <div class="section-title">Health Goals</div>
            <div class="section-sub">Set your daily targets</div>
          </div>
        </div>
        <div class="goals-grid">
          <div class="goal-card">
            <div class="goal-header">
              <div class="goal-icon steps">👟</div>
              <span class="goal-label">Daily Steps</span>
            </div>
            <input type="number" v-model.number="goals.daily_steps" min="1000" max="50000" />
            <div class="goal-rec">Empfehlung: 10.000 Schritte</div>
          </div>
          <div class="goal-card">
            <div class="goal-header">
              <div class="goal-icon sleep">🌙</div>
              <span class="goal-label">Sleep Hours</span>
            </div>
            <input type="number" v-model.number="goals.sleep_hours" min="4" max="12" step="0.5" />
            <div class="goal-rec">Empfehlung: 7–9 Stunden</div>
          </div>
          <div class="goal-card">
            <div class="goal-header">
              <div class="goal-icon cal">🔥</div>
              <span class="goal-label">Calories to Burn</span>
            </div>
            <input type="number" v-model.number="goals.daily_calories" min="100" max="3000" />
            <div class="goal-rec">Aktive Kalorien pro Tag</div>
          </div>
          <div class="goal-card">
            <div class="goal-header">
              <div class="goal-icon heart">❤️</div>
              <span class="goal-label">Target Resting HR</span>
            </div>
            <input type="number" v-model.number="goals.resting_hr" min="40" max="120" />
            <div class="goal-rec">Gesund: 60–100 BPM</div>
          </div>
        </div>
        <button class="btn-save-goals" @click="saveGoals" :disabled="goalsLoading">
          {{ goalsLoading ? 'Wird gespeichert...' : 'Ziele speichern' }}
        </button>
      </div>

      <!-- Notifications -->
      <div class="settings-section">
        <div class="section-header">
          <div class="section-icon notif-icon">🔔</div>
          <div>
            <div class="section-title">Notifications</div>
            <div class="section-sub">Manage your alerts and reminders</div>
          </div>
        </div>
        <div class="toggle-list">
          <div class="toggle-row">
            <div>
              <div class="toggle-name">Tägliche Erinnerungen</div>
              <div class="toggle-desc">Erhalte täglich um 8:00 Uhr eine E-Mail mit deinem Fortschritt</div>
            </div>
            <div :class="['toggle-switch', { on: goals.email_reminders }]" @click="toggleReminder">
              <div class="toggle-knob"></div>
            </div>
          </div>
          <div v-for="n in notifications" :key="n.name" class="toggle-row">
            <div>
              <div class="toggle-name">{{ n.name }}</div>
              <div class="toggle-desc">{{ n.desc }}</div>
            </div>
            <div :class="['toggle-switch', { on: n.on }]" @click="n.on = !n.on">
              <div class="toggle-knob"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Privacy & Security -->
      <div class="settings-section">
        <div class="section-header">
          <div class="section-icon privacy-icon">🔒</div>
          <div>
            <div class="section-title">Privacy &amp; Security</div>
            <div class="section-sub">Manage your data and privacy</div>
          </div>
        </div>
        <div class="action-list">
          <div class="action-row" @click="showPasswordModal = true">
            <div>
              <div class="action-name">Passwort ändern</div>
              <div class="action-desc">Aktualisiere dein Konto-Passwort</div>
            </div>
            <span class="action-arrow">›</span>
          </div>
          <div class="action-row" @click="exportData">
            <div>
              <div class="action-name">Daten exportieren (JSON)</div>
              <div class="action-desc">Alle Gesundheitsdaten als JSON herunterladen</div>
            </div>
            <span v-if="exportLoading" class="action-arrow loading-dot">...</span>
            <span v-else class="action-arrow">›</span>
          </div>
          <div class="action-row" @click="exportCSV">
            <div>
              <div class="action-name">Daten exportieren (CSV)</div>
              <div class="action-desc">Schritte, Schlaf, Herzrate & mehr als ZIP-Archiv</div>
            </div>
            <span v-if="csvLoading" class="action-arrow loading-dot">...</span>
            <span v-else class="action-arrow">›</span>
          </div>
          <div class="action-row danger" @click="showDeleteModal = true">
            <div>
              <div class="action-name danger-text">Account löschen</div>
              <div class="action-desc">Account und alle Daten dauerhaft löschen</div>
            </div>
            <span class="action-arrow danger-text">›</span>
          </div>
        </div>
      </div>

      <!-- Flash message -->
      <div v-if="flashMsg" :class="['flash', flashType]">{{ flashMsg }}</div>

      <button class="signout-btn" @click="handleLogout">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
        Abmelden
      </button>
    </main>
  </div>

  <!-- Change Password Modal -->
  <div v-if="showPasswordModal" class="modal-overlay" @click.self="showPasswordModal = false">
    <div class="modal">
      <div class="modal-header">
        <h3>Passwort ändern</h3>
        <button class="modal-close" @click="showPasswordModal = false">✕</button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label>Aktuelles Passwort</label>
          <input type="password" v-model="pwForm.current" placeholder="Aktuelles Passwort" />
        </div>
        <div class="form-group">
          <label>Neues Passwort</label>
          <input type="password" v-model="pwForm.newPw" placeholder="Neues Passwort (min. 6 Zeichen)" />
        </div>
        <div class="form-group">
          <label>Passwort bestätigen</label>
          <input type="password" v-model="pwForm.confirm" placeholder="Passwort wiederholen" />
        </div>
        <div v-if="pwError" class="field-error">{{ pwError }}</div>
      </div>
      <div class="modal-footer">
        <button class="btn-cancel" @click="showPasswordModal = false">Abbrechen</button>
        <button class="btn-primary" @click="changePassword" :disabled="pwLoading">
          {{ pwLoading ? 'Wird geändert...' : 'Speichern' }}
        </button>
      </div>
    </div>
  </div>

  <!-- Delete Account Modal -->
  <div v-if="showDeleteModal" class="modal-overlay" @click.self="showDeleteModal = false">
    <div class="modal">
      <div class="modal-header">
        <h3>Account löschen</h3>
        <button class="modal-close" @click="showDeleteModal = false">✕</button>
      </div>
      <div class="modal-body">
        <p class="delete-warning">Diese Aktion kann nicht rückgängig gemacht werden. Alle deine Gesundheitsdaten werden dauerhaft gelöscht.</p>
        <div class="form-group">
          <label>Passwort zur Bestätigung</label>
          <input type="password" v-model="deletePassword" placeholder="Dein Passwort" />
        </div>
        <div v-if="deleteError" class="field-error">{{ deleteError }}</div>
      </div>
      <div class="modal-footer">
        <button class="btn-cancel" @click="showDeleteModal = false">Abbrechen</button>
        <button class="btn-danger" @click="deleteAccount" :disabled="deleteLoading">
          {{ deleteLoading ? 'Wird gelöscht...' : 'Account löschen' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '../components/Sidebar.vue'

const router = useRouter()

const username = computed(() => {
  try { return JSON.parse(localStorage.getItem('hs_user') || '{}').first_name || 'User' }
  catch { return 'User' }
})

const fullName = computed(() => {
  try {
    const u = JSON.parse(localStorage.getItem('hs_user') || '{}')
    return ((u.first_name || '') + ' ' + (u.last_name || '')).trim() || 'User'
  } catch { return 'User' }
})

const userEmail = computed(() => {
  try { return JSON.parse(localStorage.getItem('hs_user') || '{}').email || '' }
  catch { return '' }
})

// Flash message
const flashMsg = ref('')
const flashType = ref('success')
function showFlash(msg, type = 'success') {
  flashMsg.value = msg
  flashType.value = type
  setTimeout(() => { flashMsg.value = '' }, 4000)
}

// Goals
const goalsLoading = ref(false)
const goals = reactive({
  daily_steps: 10000,
  sleep_hours: 8.0,
  daily_calories: 500,
  resting_hr: 60,
  email_reminders: false,
})

async function loadGoals() {
  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/goals', { headers: { Authorization: `Bearer ${token}` } })
    if (res.ok) {
      const data = await res.json()
      goals.daily_steps = data.daily_steps
      goals.sleep_hours = Number(data.sleep_hours)
      goals.daily_calories = data.daily_calories
      goals.resting_hr = data.resting_hr
      goals.email_reminders = data.email_reminders
    }
  } catch {}
}

async function saveGoals() {
  goalsLoading.value = true
  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/goals', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
      body: JSON.stringify(goals),
    })
    if (res.ok) {
      showFlash('Ziele erfolgreich gespeichert.', 'success')
    } else {
      showFlash('Fehler beim Speichern.', 'error')
    }
  } catch {
    showFlash('Netzwerkfehler.', 'error')
  }
  goalsLoading.value = false
}

async function toggleReminder() {
  goals.email_reminders = !goals.email_reminders
  await saveGoals()
}

onMounted(loadGoals)

// Change password
const showPasswordModal = ref(false)
const pwLoading = ref(false)
const pwError = ref('')
const pwForm = reactive({ current: '', newPw: '', confirm: '' })

async function changePassword() {
  pwError.value = ''
  if (!pwForm.current || !pwForm.newPw || !pwForm.confirm) {
    pwError.value = 'Alle Felder sind erforderlich.'
    return
  }
  if (pwForm.newPw !== pwForm.confirm) {
    pwError.value = 'Passwörter stimmen nicht überein.'
    return
  }
  if (pwForm.newPw.length < 6) {
    pwError.value = 'Neues Passwort muss mindestens 6 Zeichen haben.'
    return
  }
  pwLoading.value = true
  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/user/password', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
      body: JSON.stringify({ currentPassword: pwForm.current, newPassword: pwForm.newPw }),
    })
    const data = await res.json()
    if (res.ok) {
      showPasswordModal.value = false
      pwForm.current = pwForm.newPw = pwForm.confirm = ''
      showFlash('Passwort erfolgreich geändert.', 'success')
    } else {
      pwError.value = data.error || 'Fehler beim Ändern des Passworts.'
    }
  } catch {
    pwError.value = 'Netzwerkfehler. Bitte erneut versuchen.'
  }
  pwLoading.value = false
}

// Export data
const exportLoading = ref(false)
const csvLoading = ref(false)

async function exportCSV() {
  csvLoading.value = true
  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/user/export/csv', {
      headers: { Authorization: `Bearer ${token}` },
    })
    if (res.ok) {
      const blob = await res.blob()
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = 'healthsync-export.zip'
      a.click()
      URL.revokeObjectURL(url)
      showFlash('CSV-Export erfolgreich.', 'success')
    } else {
      showFlash('CSV-Export fehlgeschlagen.', 'error')
    }
  } catch {
    showFlash('Netzwerkfehler beim Export.', 'error')
  }
  csvLoading.value = false
}

async function exportData() {
  exportLoading.value = true
  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/user/export', {
      headers: { Authorization: `Bearer ${token}` },
    })
    if (res.ok) {
      const blob = await res.blob()
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = 'healthsync-export.json'
      a.click()
      URL.revokeObjectURL(url)
      showFlash('Daten erfolgreich exportiert.', 'success')
    } else {
      showFlash('Export fehlgeschlagen.', 'error')
    }
  } catch {
    showFlash('Netzwerkfehler beim Export.', 'error')
  }
  exportLoading.value = false
}

// Delete account
const showDeleteModal = ref(false)
const deletePassword = ref('')
const deleteLoading = ref(false)
const deleteError = ref('')

async function deleteAccount() {
  deleteError.value = ''
  if (!deletePassword.value) {
    deleteError.value = 'Bitte Passwort eingeben.'
    return
  }
  deleteLoading.value = true
  try {
    const token = localStorage.getItem('hs_token')
    const email = JSON.parse(localStorage.getItem('hs_user') || '{}').email
    const verifyRes = await fetch('/api/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password: deletePassword.value }),
    })
    if (!verifyRes.ok) {
      deleteError.value = 'Falsches Passwort.'
      deleteLoading.value = false
      return
    }
    const delRes = await fetch('/api/user', {
      method: 'DELETE',
      headers: { Authorization: `Bearer ${token}` },
    })
    if (delRes.ok) {
      localStorage.removeItem('hs_token')
      localStorage.removeItem('hs_user')
      router.push('/login')
    } else {
      const d = await delRes.json()
      deleteError.value = d.error || 'Löschen fehlgeschlagen.'
    }
  } catch {
    deleteError.value = 'Netzwerkfehler.'
  }
  deleteLoading.value = false
}

const notifications = reactive([
  { name: 'Achievement-Benachrichtigungen', desc: 'Benachrichtigungen wenn du Achievements freischaltest', on: true },
  { name: 'Schlaf-Erinnerungen',    desc: 'Schlafzeit-Erinnerungen für besseren Schlaf', on: true },
  { name: 'Aktivitäts-Erinnerungen',desc: 'Erinnerungen, den ganzen Tag aktiv zu bleiben', on: false },
])

function handleLogout() {
  localStorage.removeItem('hs_token')
  localStorage.removeItem('hs_user')
  router.push('/login')
}
</script>

<style scoped>
.dashboard-layout { display: flex; min-height: 100vh; background: #f8fafc; }
.dashboard-main { flex: 1; margin-left: 260px; padding: 2rem 2.5rem; overflow-x: hidden; max-width: 900px; }

.dash-header { margin-bottom: 1.8rem; }
.page-title { display: flex; align-items: center; gap: 0.5rem; font-size: 1.8rem; font-weight: 800; color: #0f172a; letter-spacing: -0.5px; margin-bottom: 0.25rem; }
.page-icon { font-size: 1.5rem; }
.page-sub { font-size: 0.9rem; color: #94a3b8; font-weight: 500; }

.settings-section { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 1.5rem; margin-bottom: 1.5rem; }
.section-header { display: flex; align-items: center; gap: 0.8rem; margin-bottom: 1.2rem; }
.section-icon { width: 42px; height: 42px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
.profile-icon { background: #eff6ff; }
.goals-icon   { background: #ecfdf5; }
.notif-icon   { background: #eff6ff; }
.privacy-icon { background: #f1f5f9; }
.section-title { font-size: 1.05rem; font-weight: 700; color: #0f172a; }
.section-sub   { font-size: 0.78rem; color: #94a3b8; font-weight: 500; }

.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
.form-group { display: flex; flex-direction: column; gap: 0.35rem; }
.form-group label { font-size: 0.78rem; font-weight: 600; color: #64748b; }
.form-group input { padding: 0.7rem 0.9rem; border: 1px solid #e2e8f0; border-radius: 10px; font-size: 0.9rem; font-weight: 500; color: #0f172a; background: #f8fafc; font-family: inherit; box-sizing: border-box; }
.form-group input:focus { outline: none; border-color: #3b82f6; background: #fff; }

.goals-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem; }
.goal-card { padding: 1rem; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 14px; }
.goal-header { display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem; }
.goal-icon { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; }
.goal-icon.steps { background: #eff6ff; }
.goal-icon.sleep { background: #eff6ff; }
.goal-icon.cal   { background: #fff7ed; }
.goal-icon.heart { background: #fef2f2; }
.goal-label { font-size: 0.88rem; font-weight: 700; color: #0f172a; }
.goal-card input { width: 100%; padding: 0.6rem 0.8rem; border: 1px solid #e2e8f0; border-radius: 10px; font-size: 0.9rem; font-weight: 600; color: #0f172a; background: #fff; font-family: inherit; box-sizing: border-box; margin-bottom: 0.3rem; transition: border-color 0.2s; }
.goal-card input:focus { outline: none; border-color: #3b82f6; }
.goal-rec { font-size: 0.7rem; color: #94a3b8; font-weight: 500; }

.btn-save-goals { width: 100%; padding: 0.75rem; border: none; border-radius: 12px; background: linear-gradient(135deg,#3b82f6,#2563eb); color: #fff; font-size: 0.9rem; font-weight: 700; cursor: pointer; font-family: inherit; transition: opacity 0.2s; }
.btn-save-goals:hover:not(:disabled) { opacity: 0.9; }
.btn-save-goals:disabled { opacity: 0.6; cursor: not-allowed; }

.toggle-list { display: flex; flex-direction: column; gap: 0.6rem; }
.toggle-row { display: flex; justify-content: space-between; align-items: center; padding: 0.9rem 1rem; background: #f8fafc; border: 1px solid #f1f5f9; border-radius: 14px; }
.toggle-name { font-size: 0.88rem; font-weight: 700; color: #0f172a; margin-bottom: 0.15rem; }
.toggle-desc { font-size: 0.75rem; color: #94a3b8; }
.toggle-switch { width: 44px; height: 24px; border-radius: 12px; background: #e2e8f0; position: relative; cursor: pointer; flex-shrink: 0; transition: background 0.3s; }
.toggle-switch.on { background: #3b82f6; }
.toggle-knob { width: 20px; height: 20px; border-radius: 50%; background: #fff; position: absolute; top: 2px; left: 2px; box-shadow: 0 1px 3px rgba(0,0,0,0.15); transition: transform 0.3s; }
.toggle-switch.on .toggle-knob { transform: translateX(20px); }

.action-list { display: flex; flex-direction: column; gap: 0.6rem; }
.action-row { display: flex; justify-content: space-between; align-items: center; padding: 0.9rem 1rem; background: #f8fafc; border: 1px solid #f1f5f9; border-radius: 14px; cursor: pointer; transition: all 0.2s; }
.action-row:hover { background: #f1f5f9; }
.action-row.danger { background: #fef2f2; border-color: #fecaca; }
.action-row.danger:hover { background: #fee2e2; }
.action-name { font-size: 0.88rem; font-weight: 700; color: #0f172a; margin-bottom: 0.15rem; }
.action-desc { font-size: 0.75rem; color: #94a3b8; }
.danger-text { color: #ef4444 !important; }
.action-arrow { font-size: 1.4rem; color: #94a3b8; font-weight: 300; }
.loading-dot { color: #3b82f6; font-size: 1rem; }

.flash { padding: 0.8rem 1.2rem; border-radius: 12px; font-size: 0.88rem; font-weight: 600; margin-bottom: 1rem; }
.flash.success { background: #dcfce7; color: #16a34a; border: 1px solid #bbf7d0; }
.flash.error   { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

.signout-btn { width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; color: #ef4444; font-size: 0.9rem; font-weight: 600; display: flex; align-items: center; justify-content: center; gap: 0.5rem; cursor: pointer; transition: all 0.2s; margin-bottom: 2rem; font-family: inherit; }
.signout-btn:hover { background: #fef2f2; border-color: #fecaca; }
.signout-btn svg { stroke: #ef4444; }

/* Modal */
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal { background: #fff; border-radius: 20px; padding: 1.5rem; width: 100%; max-width: 420px; box-shadow: 0 20px 60px rgba(0,0,0,0.15); }
.modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.2rem; }
.modal-header h3 { font-size: 1.1rem; font-weight: 700; color: #0f172a; }
.modal-close { border: none; background: none; font-size: 1.2rem; color: #94a3b8; cursor: pointer; padding: 0.2rem 0.5rem; border-radius: 6px; }
.modal-close:hover { background: #f1f5f9; color: #0f172a; }
.modal-body { display: flex; flex-direction: column; gap: 0.8rem; margin-bottom: 1.2rem; }
.modal-footer { display: flex; gap: 0.7rem; justify-content: flex-end; }

.btn-cancel { padding: 0.65rem 1.2rem; border: 1px solid #e2e8f0; border-radius: 10px; background: #fff; color: #64748b; font-size: 0.88rem; font-weight: 600; cursor: pointer; font-family: inherit; }
.btn-cancel:hover { background: #f8fafc; }
.btn-primary { padding: 0.65rem 1.2rem; border: none; border-radius: 10px; background: #3b82f6; color: #fff; font-size: 0.88rem; font-weight: 600; cursor: pointer; font-family: inherit; }
.btn-primary:hover:not(:disabled) { background: #2563eb; }
.btn-primary:disabled { opacity: 0.6; cursor: not-allowed; }
.btn-danger { padding: 0.65rem 1.2rem; border: none; border-radius: 10px; background: #ef4444; color: #fff; font-size: 0.88rem; font-weight: 600; cursor: pointer; font-family: inherit; }
.btn-danger:hover:not(:disabled) { background: #dc2626; }
.btn-danger:disabled { opacity: 0.6; cursor: not-allowed; }

.field-error { font-size: 0.82rem; color: #dc2626; font-weight: 500; padding: 0.5rem 0.7rem; background: #fef2f2; border-radius: 8px; }
.delete-warning { font-size: 0.88rem; color: #64748b; background: #fef2f2; border: 1px solid #fecaca; border-radius: 10px; padding: 0.8rem 1rem; line-height: 1.5; }

@media (max-width: 1200px) {
  .form-grid, .goals-grid { grid-template-columns: 1fr; }
}
</style>
