<template>
  <div class="tips-widget">
    <h3 class="tips-title">
      <span>💡</span> Gesundheitstipps
    </h3>
    <div v-if="loading" class="tips-loading">Lade Tipps...</div>
    <div v-else-if="tips.length === 0" class="tips-empty">Keine Tipps verfügbar.</div>
    <div v-else class="tips-list">
      <div
        v-for="tip in tips"
        :key="tip.id"
        :class="['tip-card', tip.severity]"
      >
        <div class="tip-header">
          <span class="tip-cat-icon">{{ categoryIcon(tip.category) }}</span>
          <span :class="['tip-severity', tip.severity]">{{ severityLabel(tip.severity) }}</span>
        </div>
        <div class="tip-text">{{ tip.tip }}</div>
        <div class="tip-category">{{ categoryLabel(tip.category) }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const tips = ref([])
const loading = ref(true)

function categoryIcon(cat) {
  const icons = {
    steps: '👣',
    heart_rate: '❤️',
    sleep: '🌙',
    oxygen: '🫁',
    activity: '🏃',
  }
  return icons[cat] || '💡'
}

function categoryLabel(cat) {
  const labels = {
    steps: 'Schritte',
    heart_rate: 'Herzrate',
    sleep: 'Schlaf',
    oxygen: 'Sauerstoff',
    activity: 'Aktivität',
  }
  return labels[cat] || cat
}

function severityLabel(sev) {
  const labels = {
    critical: 'Kritisch',
    warning: 'Warnung',
    info: 'Info',
  }
  return labels[sev] || sev
}

onMounted(async () => {
  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/health/tips', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (res.ok) tips.value = await res.json()
  } catch {}
  loading.value = false
})
</script>

<style scoped>
.tips-widget {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.3rem;
}

.tips-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1rem;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 1rem;
}

.tips-loading,
.tips-empty {
  font-size: 0.85rem;
  color: #94a3b8;
  text-align: center;
  padding: 1rem 0;
}

.tips-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.tip-card {
  border-radius: 12px;
  padding: 0.85rem 1rem;
  border: 1px solid transparent;
  transition: all 0.2s;
}

.tip-card:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.tip-card.critical {
  background: #fef2f2;
  border-color: #fecaca;
}

.tip-card.warning {
  background: #fff7ed;
  border-color: #fed7aa;
}

.tip-card.info {
  background: #eff6ff;
  border-color: #bfdbfe;
}

.tip-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 0.4rem;
}

.tip-cat-icon {
  font-size: 1.1rem;
}

.tip-severity {
  font-size: 0.7rem;
  font-weight: 700;
  padding: 0.15rem 0.5rem;
  border-radius: 20px;
}

.tip-severity.critical {
  background: #fee2e2;
  color: #dc2626;
}

.tip-severity.warning {
  background: #ffedd5;
  color: #ea580c;
}

.tip-severity.info {
  background: #dbeafe;
  color: #2563eb;
}

.tip-text {
  font-size: 0.85rem;
  color: #0f172a;
  font-weight: 500;
  line-height: 1.5;
  margin-bottom: 0.25rem;
}

.tip-category {
  font-size: 0.72rem;
  color: #94a3b8;
  font-weight: 500;
}
</style>
