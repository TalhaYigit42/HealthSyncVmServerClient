<template>
  <div class="achievements-widget">
    <h3 class="ach-title">
      <span>🏆</span> Achievements
    </h3>
    <div class="ach-list">
      <div v-for="ach in achievements" :key="ach.name" class="ach-item">
        <div :class="['ach-icon', ach.color]">{{ ach.emoji }}</div>
        <div class="ach-info">
          <div class="ach-name">{{ ach.name }}</div>
          <div class="ach-desc">{{ ach.description }}</div>
          <div v-if="!ach.completed && ach.progress !== null" class="ach-progress-row">
            <div class="ach-bar">
              <div class="ach-fill" :style="{ width: ach.progress + '%', background: ach.barColor }"></div>
            </div>
            <span class="ach-progress-text">{{ ach.progressText }}</span>
          </div>
        </div>
        <div v-if="ach.completed" class="ach-check">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" fill="#10b981"/><path d="M8 12l2.5 2.5L16 9" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const summary = ref(null)
const streak = ref(0)
const totalActiveDays = ref(0)
const activities = ref([])
const stepsWeekly = ref([])

const achievements = computed(() => {
  const steps = summary.value?.steps ?? 0
  const maxDailySteps = stepsWeekly.value.length
    ? Math.max(...stepsWeekly.value.map(d => d.steps || 0))
    : steps

  const hasWorkout = activities.value.length > 0
  const reached10kSteps = maxDailySteps >= 10000
  const streak7 = streak.value >= 7
  const totalAct = totalActiveDays.value

  return [
    {
      name: 'Erstes Workout',
      description: 'Schließe dein erstes Workout ab',
      emoji: '🏋️',
      color: 'orange',
      completed: hasWorkout,
      progress: hasWorkout ? null : 0,
      progressText: '0/1',
      barColor: '#f59e0b',
    },
    {
      name: '10k Schritte',
      description: '10.000 Schritte an einem Tag',
      emoji: '👣',
      color: 'green',
      completed: reached10kSteps,
      progress: reached10kSteps ? null : Math.min(100, (maxDailySteps / 10000) * 100),
      progressText: `${maxDailySteps.toLocaleString('de-AT')}/10.000`,
      barColor: '#10b981',
    },
    {
      name: '7-Tage Streak',
      description: '7 Tage in Folge aktiv sein',
      emoji: '🔥',
      color: 'yellow',
      completed: streak7,
      progress: streak7 ? null : Math.min(100, (streak.value / 7) * 100),
      progressText: `${streak.value}/7 Tage`,
      barColor: '#f59e0b',
    },
    {
      name: '30 aktive Tage',
      description: '30 Tage mit Aktivitätsdaten',
      emoji: '📅',
      color: 'blue',
      completed: totalAct >= 30,
      progress: totalAct >= 30 ? null : Math.min(100, (totalAct / 30) * 100),
      progressText: `${totalAct}/30 Tage`,
      barColor: '#3b82f6',
    },
  ]
})

onMounted(async () => {
  try {
    const token = localStorage.getItem('hs_token')
    const headers = { Authorization: `Bearer ${token}` }
    const [sumRes, streakRes, actRes, stepsRes] = await Promise.all([
      fetch('/api/health/summary', { headers }),
      fetch('/api/health/streak', { headers }),
      fetch('/api/health/activities', { headers }),
      fetch('/api/health/steps', { headers }),
    ])
    if (sumRes.ok) summary.value = await sumRes.json()
    if (streakRes.ok) {
      const d = await streakRes.json()
      streak.value = d.streak || 0
      totalActiveDays.value = d.total_active_days || 0
    }
    if (actRes.ok) activities.value = await actRes.json()
    if (stepsRes.ok) stepsWeekly.value = await stepsRes.json()
  } catch {}
})
</script>

<style scoped>
.achievements-widget {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.3rem;
}

.ach-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1rem;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 1rem;
}

.ach-list {
  display: flex;
  flex-direction: column;
  gap: 0.8rem;
}

.ach-item {
  display: flex;
  align-items: center;
  gap: 0.8rem;
  padding: 0.7rem;
  background: #f8fafc;
  border-radius: 12px;
  transition: all 0.2s;
}

.ach-item:hover {
  background: #f1f5f9;
}

.ach-icon {
  width: 40px;
  height: 40px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.1rem;
  flex-shrink: 0;
}

.ach-icon.yellow { background: #fef3c7; }
.ach-icon.orange { background: #ffedd5; }
.ach-icon.gray   { background: #f1f5f9; }
.ach-icon.green  { background: #dcfce7; }
.ach-icon.blue   { background: #dbeafe; }

.ach-info {
  flex: 1;
  min-width: 0;
}

.ach-name {
  font-size: 0.88rem;
  font-weight: 700;
  color: #0f172a;
}

.ach-desc {
  font-size: 0.75rem;
  color: #94a3b8;
}

.ach-progress-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.3rem;
}

.ach-bar {
  flex: 1;
  height: 5px;
  background: #e2e8f0;
  border-radius: 3px;
  overflow: hidden;
}

.ach-fill {
  height: 100%;
  border-radius: 3px;
  transition: width 1s ease;
}

.ach-progress-text {
  font-size: 0.7rem;
  color: #94a3b8;
  font-weight: 500;
}

.ach-check {
  flex-shrink: 0;
}
</style>
