<template>
  <div class="dashboard-layout">
    <Sidebar :username="username" active-nav="Import" />
    <main class="dashboard-main">

      <div class="dash-header">
        <div>
          <h1 class="page-title"><span class="page-icon">📥</span> CSV Import</h1>
          <p class="page-sub">Lade deine Gesundheitsdaten direkt als CSV-Dateien hoch.</p>
        </div>
      </div>

      <!-- Info card -->
      <div class="info-card">
        <div class="info-icon">ℹ️</div>
        <div>
          <div class="info-title">Welche Dateien werden unterstützt?</div>
          <div class="info-text">CSV-Exporte aus Samsung Health oder Google Health Connect. Die Dateien werden anhand des Namens automatisch erkannt: <strong>Puls</strong>, <strong>Schritte</strong>, <strong>Schlaf</strong>, <strong>Sauerstoff</strong>, <strong>Aktivitäten</strong> / <strong>Training</strong> / <strong>Walking</strong>.</div>
        </div>
      </div>

      <!-- Drop zone -->
      <div
        class="drop-zone"
        :class="{ 'drag-over': isDragging, 'has-files': stagedFiles.length > 0 }"
        @dragover.prevent="isDragging = true"
        @dragleave.prevent="isDragging = false"
        @drop.prevent="handleDrop"
        @click="triggerFileInput"
      >
        <input ref="fileInput" type="file" multiple accept=".csv" class="hidden-input" @change="handleFileChange" />
        <div class="drop-inner">
          <div class="drop-icon">{{ stagedFiles.length > 0 ? '📋' : '📤' }}</div>
          <div class="drop-title">
            {{ stagedFiles.length > 0 ? stagedFiles.length + ' Datei(en) bereit' : 'CSV-Dateien hier ablegen' }}
          </div>
          <div class="drop-sub">
            {{ stagedFiles.length > 0 ? 'Weitere Dateien hinzufügen oder Importieren klicken' : 'oder klicken zum Auswählen' }}
          </div>
        </div>
      </div>

      <!-- Staged file list -->
      <div v-if="stagedFiles.length > 0" class="file-list">
        <div class="file-list-header">
          <span class="fh-title">Dateien zum Import</span>
          <button class="btn-clear" @click="stagedFiles = []">Alle entfernen</button>
        </div>
        <div v-for="(f, i) in stagedFiles" :key="i" class="file-row">
          <div :class="['file-cat-badge', categoryClass(f.name)]">{{ categoryLabel(f.name) }}</div>
          <span class="file-name">{{ f.name }}</span>
          <span class="file-size">{{ formatBytes(f.size) }}</span>
          <button class="file-remove" @click="stagedFiles.splice(i, 1)">✕</button>
        </div>
      </div>

      <!-- Action -->
      <div v-if="stagedFiles.length > 0" class="action-bar">
        <button class="btn-import" :disabled="importing" @click="runImport">
          <span v-if="importing">⏳ Wird importiert...</span>
          <span v-else">📥 Jetzt importieren</span>
        </button>
      </div>

      <!-- Result -->
      <div v-if="result" :class="['result-card', result.success ? 'result-ok' : 'result-err']">
        <div class="result-icon">{{ result.success ? '✅' : '❌' }}</div>
        <div>
          <div class="result-title">{{ result.success ? 'Import erfolgreich!' : 'Import fehlgeschlagen' }}</div>
          <div class="result-msg">{{ result.message || result.error }}</div>
          <div v-if="result.imported && result.imported.length" class="result-detail">
            <strong>Importiert:</strong>
            <span v-for="f in result.imported" :key="f.name" class="result-tag ok">{{ f.name }}</span>
          </div>
          <div v-if="result.skipped && result.skipped.length" class="result-detail">
            <strong>Übersprungen (unbekannt):</strong>
            <span v-for="f in result.skipped" :key="f" class="result-tag skip">{{ f }}</span>
          </div>
        </div>
      </div>

      <!-- History section -->
      <div class="settings-section" style="margin-top:2rem;">
        <div class="section-header">
          <div class="section-icon history-icon">📊</div>
          <div>
            <div class="section-title">Daten-Übersicht</div>
            <div class="section-sub">Aktuell in der Datenbank gespeicherte Einträge</div>
          </div>
        </div>
        <div class="stats-grid">
          <div v-for="s in dbStats" :key="s.label" class="stat-box">
            <div class="stat-icon">{{ s.icon }}</div>
            <div class="stat-val">{{ s.count !== null ? s.count.toLocaleString() : '—' }}</div>
            <div class="stat-label">{{ s.label }}</div>
            <div class="stat-latest">{{ s.latest ? 'Zuletzt: ' + s.latest : '' }}</div>
          </div>
        </div>
      </div>

    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import Sidebar from '../components/Sidebar.vue'

const username = computed(() => {
  try { return JSON.parse(localStorage.getItem('hs_user') || '{}').first_name || 'User' } catch { return 'User' }
})

const isDragging  = ref(false)
const stagedFiles = ref([])
const importing   = ref(false)
const result      = ref(null)
const fileInput   = ref(null)

const dbStats = ref([
  { label: 'Herzrate-Messungen', icon: '❤️',  count: null, latest: null },
  { label: 'Schritte',           icon: '👟',  count: null, latest: null },
  { label: 'Schlaf-Sessions',    icon: '🌙',  count: null, latest: null },
  { label: 'Aktivitäten',        icon: '🏃',  count: null, latest: null },
  { label: 'Sauerstoff',         icon: '🫁',  count: null, latest: null },
])

onMounted(fetchStats)

async function fetchStats() {
  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/import/stats', { headers: { Authorization: `Bearer ${token}` } })
    if (res.ok) {
      const d = await res.json()
      dbStats.value = d
    }
  } catch {}
}

function triggerFileInput() {
  fileInput.value?.click()
}

function handleDrop(e) {
  isDragging.value = false
  addFiles([...e.dataTransfer.files])
}

function handleFileChange(e) {
  addFiles([...e.target.files])
  e.target.value = ''
}

function addFiles(files) {
  const csvFiles = files.filter(f => f.name.toLowerCase().endsWith('.csv'))
  const existing = new Set(stagedFiles.value.map(f => f.name))
  for (const f of csvFiles) {
    if (!existing.has(f.name)) stagedFiles.value.push(f)
  }
}

function categoryLabel(filename) {
  const f = filename.toLowerCase()
  if (f.includes('aktivit') || f.includes('walking') || f.includes('training') || f.includes('running')) return 'Aktivitäten'
  if (f.includes('puls') || f.includes('heart')) return 'Puls'
  if (f.includes('schlaf') || f.includes('sleep')) return 'Schlaf'
  if (f.includes('schritt') || f.includes('step')) return 'Schritte'
  if (f.includes('sauerstoff') || f.includes('oxygen') || f.includes('spo2')) return 'SpO₂'
  return '?'
}

function categoryClass(filename) {
  const f = filename.toLowerCase()
  if (f.includes('aktivit') || f.includes('walking') || f.includes('training') || f.includes('running')) return 'cat-activity'
  if (f.includes('puls') || f.includes('heart')) return 'cat-hr'
  if (f.includes('schlaf') || f.includes('sleep')) return 'cat-sleep'
  if (f.includes('schritt') || f.includes('step')) return 'cat-steps'
  if (f.includes('sauerstoff') || f.includes('oxygen') || f.includes('spo2')) return 'cat-oxy'
  return 'cat-unknown'
}

function formatBytes(b) {
  if (b < 1024) return b + ' B'
  if (b < 1048576) return (b / 1024).toFixed(1) + ' KB'
  return (b / 1048576).toFixed(1) + ' MB'
}

async function runImport() {
  if (importing.value || stagedFiles.value.length === 0) return
  importing.value = true
  result.value = null

  const formData = new FormData()
  for (const f of stagedFiles.value) formData.append('files', f)

  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/import/csv', {
      method: 'POST',
      headers: { Authorization: `Bearer ${token}` },
      body: formData,
    })
    const data = await res.json()
    result.value = data
    if (data.success) {
      stagedFiles.value = []
      await fetchStats()
    }
  } catch {
    result.value = { success: false, error: 'Netzwerkfehler. Bitte erneut versuchen.' }
  }

  importing.value = false
}
</script>

<style scoped>
.dashboard-layout { display: flex; min-height: 100vh; background: #f8fafc; }
.dashboard-main { flex: 1; margin-left: 260px; padding: 2rem 2.5rem; overflow-x: hidden; max-width: 900px; }

.dash-header { margin-bottom: 1.8rem; }
.page-title { display: flex; align-items: center; gap: 0.5rem; font-size: 1.8rem; font-weight: 800; color: #0f172a; letter-spacing: -0.5px; margin-bottom: 0.25rem; }
.page-icon { font-size: 1.5rem; }
.page-sub { font-size: 0.9rem; color: #94a3b8; font-weight: 500; }

.info-card { display: flex; align-items: flex-start; gap: 0.8rem; background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 14px; padding: 1rem 1.2rem; margin-bottom: 1.5rem; }
.info-icon { font-size: 1.2rem; flex-shrink: 0; margin-top: 1px; }
.info-title { font-size: 0.88rem; font-weight: 700; color: #1e40af; margin-bottom: 0.25rem; }
.info-text { font-size: 0.82rem; color: #3b82f6; line-height: 1.5; }
.info-text strong { color: #1e40af; }

.drop-zone {
  border: 2px dashed #cbd5e1;
  border-radius: 18px;
  padding: 3rem 2rem;
  text-align: center;
  cursor: pointer;
  transition: all 0.2s;
  background: #fff;
  margin-bottom: 1.2rem;
}
.drop-zone:hover, .drop-zone.drag-over { border-color: #3b82f6; background: #eff6ff; }
.drop-zone.has-files { border-color: #10b981; background: #f0fdf4; }
.hidden-input { display: none; }
.drop-inner { pointer-events: none; }
.drop-icon { font-size: 2.5rem; margin-bottom: 0.6rem; }
.drop-title { font-size: 1.1rem; font-weight: 700; color: #0f172a; margin-bottom: 0.25rem; }
.drop-sub { font-size: 0.85rem; color: #94a3b8; }

.file-list { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden; margin-bottom: 1rem; }
.file-list-header { display: flex; justify-content: space-between; align-items: center; padding: 0.8rem 1.2rem; border-bottom: 1px solid #f1f5f9; }
.fh-title { font-size: 0.88rem; font-weight: 700; color: #0f172a; }
.btn-clear { font-size: 0.78rem; color: #94a3b8; background: none; border: none; cursor: pointer; font-family: inherit; }
.btn-clear:hover { color: #ef4444; }

.file-row { display: flex; align-items: center; gap: 0.8rem; padding: 0.7rem 1.2rem; border-bottom: 1px solid #f8fafc; }
.file-row:last-child { border-bottom: none; }
.file-cat-badge { font-size: 0.7rem; font-weight: 700; padding: 0.2rem 0.55rem; border-radius: 6px; white-space: nowrap; }
.cat-hr       { background: #fef2f2; color: #dc2626; }
.cat-steps    { background: #eff6ff; color: #2563eb; }
.cat-sleep    { background: #f5f3ff; color: #7c3aed; }
.cat-activity { background: #ecfdf5; color: #059669; }
.cat-oxy      { background: #fff7ed; color: #ea580c; }
.cat-unknown  { background: #f1f5f9; color: #94a3b8; }
.file-name { flex: 1; font-size: 0.85rem; color: #0f172a; font-weight: 500; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.file-size { font-size: 0.75rem; color: #94a3b8; white-space: nowrap; }
.file-remove { background: none; border: none; color: #cbd5e1; cursor: pointer; font-size: 0.85rem; padding: 0.2rem; }
.file-remove:hover { color: #ef4444; }

.action-bar { display: flex; justify-content: flex-end; margin-bottom: 1.5rem; }
.btn-import { padding: 0.8rem 2rem; background: linear-gradient(135deg, #3b82f6, #2563eb); color: #fff; border: none; border-radius: 14px; font-size: 0.95rem; font-weight: 700; cursor: pointer; font-family: inherit; transition: all 0.2s; box-shadow: 0 4px 12px rgba(59,130,246,0.3); }
.btn-import:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(59,130,246,0.4); }
.btn-import:disabled { opacity: 0.6; cursor: not-allowed; }

.result-card { display: flex; gap: 0.9rem; border-radius: 16px; padding: 1.2rem 1.4rem; margin-bottom: 1.5rem; }
.result-ok  { background: #f0fdf4; border: 1px solid #bbf7d0; }
.result-err { background: #fef2f2; border: 1px solid #fecaca; }
.result-icon { font-size: 1.5rem; flex-shrink: 0; }
.result-title { font-size: 1rem; font-weight: 700; color: #0f172a; margin-bottom: 0.2rem; }
.result-msg { font-size: 0.85rem; color: #64748b; margin-bottom: 0.5rem; }
.result-detail { font-size: 0.8rem; color: #64748b; margin-top: 0.3rem; display: flex; flex-wrap: wrap; align-items: center; gap: 0.3rem; }
.result-detail strong { color: #0f172a; }
.result-tag { padding: 0.15rem 0.5rem; border-radius: 6px; font-size: 0.75rem; font-weight: 500; }
.result-tag.ok   { background: #dcfce7; color: #16a34a; }
.result-tag.skip { background: #f1f5f9; color: #64748b; }

.settings-section { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 1.5rem; margin-bottom: 1.5rem; }
.section-header { display: flex; align-items: center; gap: 0.8rem; margin-bottom: 1.2rem; }
.section-icon { width: 42px; height: 42px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
.history-icon { background: #eff6ff; }
.section-title { font-size: 1.05rem; font-weight: 700; color: #0f172a; }
.section-sub { font-size: 0.78rem; color: #94a3b8; font-weight: 500; }

.stats-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 1rem; }
.stat-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 14px; padding: 1rem; text-align: center; }
.stat-icon { font-size: 1.5rem; margin-bottom: 0.4rem; }
.stat-val { font-size: 1.3rem; font-weight: 800; color: #0f172a; }
.stat-label { font-size: 0.72rem; color: #64748b; font-weight: 600; margin-top: 0.2rem; }
.stat-latest { font-size: 0.68rem; color: #94a3b8; margin-top: 0.2rem; }

@media (max-width: 900px) {
  .stats-grid { grid-template-columns: repeat(2, 1fr); }
}
</style>
