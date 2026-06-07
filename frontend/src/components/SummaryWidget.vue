<template>
  <div class="summary-section">
    <!-- Summary Card -->
    <div class="summary-card">
      <h3 class="summary-title">Summary</h3>
      <div class="summary-rows">
        <div class="summary-row">
          <span class="summary-label">Heutige Schritte</span>
          <span class="summary-value">{{ stepsToday }}</span>
        </div>
        <div class="summary-row">
          <span class="summary-label">Durchschn. Herzrate</span>
          <span class="summary-value xp">{{ avgHr }}</span>
        </div>
        <div class="summary-row">
          <span class="summary-label">Letzte Schlafdauer</span>
          <span class="summary-value ach">{{ lastSleep }}</span>
        </div>
      </div>
    </div>

    <!-- Daily Tip -->
    <div class="daily-tip">
      <div class="tip-icon">💡</div>
      <div>
        <div class="tip-title">Tipp des Tages</div>
        <div class="tip-text">{{ tipText }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const summary = ref(null)
const loading = ref(true)

const stepsToday = computed(() => {
  if (!summary.value) return '—'
  const s = summary.value.steps
  return s != null ? s.toLocaleString('de-AT') : '—'
})

const avgHr = computed(() => {
  const avg = summary.value?.heart_rate?.avg
  return avg ? `${avg} BPM` : '—'
})

const lastSleep = computed(() => {
  const s = summary.value?.sleep
  if (!s || !s.total_sleep_minutes) return '—'
  const h = Math.floor(s.total_sleep_minutes / 60)
  const m = s.total_sleep_minutes % 60
  return `${h}h ${m}m`
})

const tipText = computed(() => {
  const steps = summary.value?.steps
  if (steps != null && steps < 5000) return 'Versuche heute mehr Schritte zu gehen – Ziel: 10.000!'
  const hr = summary.value?.heart_rate?.avg
  if (hr && hr > 100) return 'Deine Herzrate ist erhöht. Gönn dir etwas Ruhe.'
  const sleep = summary.value?.sleep?.total_sleep_minutes
  if (sleep && sleep < 360) return 'Du hast letzte Nacht wenig geschlafen. Versuche früher ins Bett zu gehen.'
  return 'Du machst das großartig! Bleib auf Kurs.'
})

onMounted(async () => {
  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/health/summary', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (res.ok) summary.value = await res.json()
  } catch {}
  loading.value = false
})
</script>

<style scoped>
.summary-section {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.summary-card {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.3rem;
}

.summary-title {
  font-size: 1rem;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 1rem;
}

.summary-rows {
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.65rem 0.8rem;
  background: #f8fafc;
  border-radius: 10px;
}

.summary-label {
  font-size: 0.82rem;
  color: #64748b;
  font-weight: 500;
}

.summary-value {
  font-size: 0.88rem;
  font-weight: 700;
  color: #0f172a;
  text-align: right;
}

.summary-value.xp { color: #10b981; }
.summary-value.ach { color: #f59e0b; }

.daily-tip {
  display: flex;
  align-items: center;
  gap: 0.8rem;
  background: linear-gradient(135deg, #eff6ff, #ecfdf5);
  border: 1px solid #dbeafe;
  border-radius: 16px;
  padding: 1rem 1.2rem;
}

.tip-icon {
  width: 40px;
  height: 40px;
  background: #3b82f6;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.1rem;
  flex-shrink: 0;
}

.tip-title {
  font-size: 0.85rem;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 0.15rem;
}

.tip-text {
  font-size: 0.78rem;
  color: #64748b;
  font-weight: 500;
}
</style>
