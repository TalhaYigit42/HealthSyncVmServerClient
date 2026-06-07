<template>
  <div class="dashboard-layout">
    <Sidebar :username="username" active-nav="Dashboard" />
    <main class="dashboard-main">
      <!-- Header -->
      <div class="dash-header">
        <div>
          <h1 class="greeting">{{ greeting }}, {{ username }}!</h1>
          <p class="greeting-sub">Du machst das super! Bleib dran.</p>
        </div>
        <div class="header-badges">
          <div class="badge streak-badge">
            <span>🔥</span> {{ streakDays }} Tage Streak
          </div>
          <div class="badge xp-badge">
            <span>⚡</span> {{ xpToday }} XP Today
          </div>
        </div>
      </div>

      <!-- Stat Cards -->
      <div class="stat-grid">
        <StatCard
          label="Sleep Score"
          :value="sleepValue"
          :subtitle="sleepSubtitle"
          icon="🌙"
          variant="sleep"
          chartType="line"
          :chartData="sleepChartData"
        />
        <StatCard
          label="Heart Rate"
          :value="hrValue"
          :subtitle="hrSubtitle"
          icon="❤️"
          variant="heart"
          chartType="line"
          :chartData="hrChartData"
        />
        <StatCard
          label="Daily Steps"
          :value="stepsValue"
          subtitle="Ziel: 10.000"
          icon="👣"
          variant="steps"
          chartType="bar"
          :chartData="stepsChartData"
        />
        <StatCard
          label="Progress"
          :value="'Level ' + xpLevel"
          :subtitle="xpInLevel + ' / 500 XP'"
          icon="⭐"
          variant="xp"
          chartType="progress"
          :xpCurrent="xpInLevel"
          :xpGoal="500"
        />
      </div>

      <!-- Content Grid -->
      <div class="content-grid">
        <!-- Left Column: Quests + Weekly -->
        <div class="content-left">
          <DailyQuests />
          <WeeklyOverview />
        </div>

        <!-- Right Column: Streak + Tips + Achievements + Summary -->
        <div class="content-right">
          <StreakWidget />
          <TipsWidget />
          <AchievementsWidget />
          <SummaryWidget />
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import StatCard from '../components/StatCard.vue'
import DailyQuests from '../components/DailyQuests.vue'
import StreakWidget from '../components/StreakWidget.vue'
import AchievementsWidget from '../components/AchievementsWidget.vue'
import WeeklyOverview from '../components/WeeklyOverview.vue'
import SummaryWidget from '../components/SummaryWidget.vue'
import TipsWidget from '../components/TipsWidget.vue'

const sleepChartData = computed(() => {
  if (!weeklyData.value.length || !sleepWeekly.value.length) return []
  const byWakeDay = {}
  sleepWeekly.value.forEach(s => {
    if (!s.start_time) return
    const dt = new Date(s.start_time)
    const nightKey = dt.getUTCHours() < 12
      ? new Date(dt.getTime() - 86400000).toISOString().slice(0, 10)
      : dt.toISOString().slice(0, 10)
    const wakeDate = new Date(nightKey + 'T12:00:00Z')
    wakeDate.setUTCDate(wakeDate.getUTCDate() + 1)
    const wakeDay = wakeDate.toISOString().slice(0, 10)
    byWakeDay[wakeDay] = (byWakeDay[wakeDay] || 0) + (s.total_sleep_minutes || 0)
  })
  return weeklyData.value.map(d => byWakeDay[d.day] ? +(byWakeDay[d.day] / 60).toFixed(1) : 0)
})
const hrChartData = computed(() => weeklyData.value.map(d => d.avg_bpm || 0))
const stepsChartData = computed(() => weeklyData.value.map(d => d.steps ? +(d.steps / 1000).toFixed(1) : 0))
const xpTotalDash = computed(() => Math.floor(weeklyData.value.reduce((s, d) => s + (d.steps || 0), 0) / 100))
const xpLevel = computed(() => Math.floor(xpTotalDash.value / 500) + 1)
const xpInLevel = computed(() => xpTotalDash.value % 500)

const greeting = computed(() => {
  const h = new Date().getHours()
  if (h < 12) return 'Guten Morgen'
  if (h < 18) return 'Guten Tag'
  return 'Guten Abend'
})

const username = computed(() => {
  try {
    const user = JSON.parse(localStorage.getItem('hs_user') || '{}')
    return user.first_name || 'User'
  } catch { return 'User' }
})

const summary = ref(null)
const streakDays = ref(0)
const weeklyData = ref([])
const sleepWeekly = ref([])

const sleepValue = computed(() => {
  if (!summary.value?.sleep) return '—'
  return (summary.value.sleep.total_sleep_minutes / 60).toFixed(1) + 'h'
})
const sleepSubtitle = computed(() => {
  if (!summary.value?.sleep) return 'Keine Daten'
  const q = summary.value.sleep.sleep_quality_score
  return q ? `${q}/100 Qualität` : 'Letzte Nacht'
})
const hrValue = computed(() => {
  const avg = summary.value?.heart_rate?.avg
  return avg ? `${avg} BPM` : '—'
})
const hrSubtitle = computed(() => {
  const r = summary.value?.heart_rate?.resting
  return r ? `Ruhepuls: ${r} BPM` : 'Keine Daten'
})
const stepsValue = computed(() => {
  const s = summary.value?.steps
  return s != null ? s.toLocaleString('de-AT') : '—'
})

const xpToday = computed(() => {
  const steps = summary.value?.steps
  if (steps == null) return '—'
  return '+' + Math.round(steps / 100)
})

onMounted(async () => {
  try {
    const token = localStorage.getItem('hs_token')
    const headers = { Authorization: `Bearer ${token}` }
    const [sumRes, streakRes, weeklyRes, sleepRes] = await Promise.all([
      fetch('/api/health/summary', { headers }),
      fetch('/api/health/streak', { headers }),
      fetch('/api/health/weekly', { headers }),
      fetch('/api/health/sleep', { headers }),
    ])
    if (sumRes.ok) summary.value = await sumRes.json()
    if (streakRes.ok) {
      const d = await streakRes.json()
      streakDays.value = d.streak || 0
    }
    if (weeklyRes.ok) weeklyData.value = await weeklyRes.json()
    if (sleepRes.ok) sleepWeekly.value = await sleepRes.json()
  } catch {}
})
</script>

<style scoped>
.dashboard-layout {
  display: flex;
  min-height: 100vh;
  background: #f8fafc;
}

.dashboard-main {
  flex: 1;
  margin-left: 260px;
  padding: 2rem 2.5rem;
  max-width: 100%;
  overflow-x: hidden;
}

/* Header */
.dash-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1.8rem;
  animation: fadeIn 0.5s ease;
}

.greeting {
  font-size: 1.8rem;
  font-weight: 800;
  color: #0f172a;
  letter-spacing: -0.5px;
  margin-bottom: 0.2rem;
}

.greeting-sub {
  font-size: 0.92rem;
  color: #94a3b8;
  font-weight: 500;
}

.header-badges {
  display: flex;
  gap: 0.7rem;
  flex-shrink: 0;
}

.badge {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.55rem 1rem;
  border-radius: 12px;
  font-size: 0.82rem;
  font-weight: 700;
  white-space: nowrap;
}

.streak-badge {
  background: #fff7ed;
  color: #ea580c;
  border: 1px solid #fed7aa;
}

.xp-badge {
  background: #ecfdf5;
  color: #059669;
  border: 1px solid #a7f3d0;
}

/* Stat Grid */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
  margin-bottom: 1.5rem;
  animation: fadeIn 0.6s ease;
}

/* Content Grid */
.content-grid {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 1.5rem;
  animation: fadeIn 0.7s ease;
}

.content-left {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.content-right {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* Responsive */
@media (max-width: 1200px) {
  .stat-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .content-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .dashboard-main {
    margin-left: 0;
    padding: 1.5rem;
  }
  .dash-header {
    flex-direction: column;
    gap: 1rem;
  }
  .stat-grid {
    grid-template-columns: 1fr;
  }
  .header-badges {
    flex-wrap: wrap;
  }
}
</style>
