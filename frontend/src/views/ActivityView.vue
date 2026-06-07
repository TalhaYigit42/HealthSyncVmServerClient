<template>
  <div class="dashboard-layout">
    <Sidebar :username="username" active-nav="Activity" />
    <main class="dashboard-main">

      <!-- Header -->
      <div class="dash-header">
        <div>
          <h1 class="page-title">
            <span class="page-icon">👟</span> Activity Tracking
          </h1>
          <p class="page-sub">Track your steps, workouts, and daily activity.</p>
        </div>
        <div class="badge xp-badge">⚡ {{ xpToday }} XP Today</div>
      </div>

      <!-- Stat Cards with circular progress -->
      <div class="stat-grid">
        <div v-for="stat in statCards" :key="stat.label" class="activity-card">
          <div class="ac-left">
            <div :class="['ac-icon', stat.variant]">{{ stat.icon }}</div>
            <div>
              <div class="ac-label">{{ stat.label }}</div>
              <div class="ac-value">{{ stat.value }}</div>
            </div>
          </div>
          <svg class="ring" width="48" height="48" viewBox="0 0 48 48">
            <circle cx="24" cy="24" r="20" fill="none" stroke="#e2e8f0" stroke-width="3"/>
            <circle cx="24" cy="24" r="20" fill="none" :stroke="stat.color" stroke-width="3"
              stroke-linecap="round"
              :stroke-dasharray="125.6"
              :stroke-dashoffset="125.6 - (125.6 * Math.min(stat.pct, 100) / 100)"
              transform="rotate(-90 24 24)"
            />
            <text x="24" y="26" text-anchor="middle" font-size="10" font-weight="700" :fill="stat.color">{{ Math.min(stat.pct, 100) }}%</text>
          </svg>
        </div>
      </div>

      <!-- Middle: Weekly Steps Chart + Activity Quests -->
      <div class="mid-grid">
        <!-- Weekly Steps -->
        <div class="panel chart-panel">
          <div class="chart-header">
            <h3 class="panel-title-plain">Weekly Steps</h3>
            <div class="chart-legend">
              <span class="legend-dot green"></span> Steps
              <span class="legend-dot blue"></span> Goal
            </div>
          </div>
          <div class="chart-box">
            <canvas ref="stepsChart" height="220"></canvas>
          </div>
        </div>

        <!-- Activity Quests -->
        <div class="panel quests-panel">
          <h3 class="panel-title"><span>🏆</span> Activity Quests</h3>
          <div class="quest-list">
            <div v-for="q in quests" :key="q.name" :class="['quest-item', { completed: q.completed }]">
              <div :class="['quest-icon', { done: q.completed }]">
                <span v-if="q.completed">✓</span>
                <span v-else>{{ q.icon }}</span>
              </div>
              <div class="quest-body">
                <div class="quest-top">
                  <span :class="['quest-name', { strikethrough: q.completed }]">{{ q.name }}</span>
                  <span class="quest-xp">⚡ +{{ q.xp }} XP</span>
                </div>
                <div class="quest-bar-row">
                  <div class="quest-bar">
                    <div class="quest-fill" :style="{ width: Math.min(100, q.current / q.goal * 100) + '%', background: q.completed ? '#10b981' : '#3b82f6' }"></div>
                  </div>
                  <span class="quest-progress">{{ q.progressText }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Workouts (recent activities) -->
      <div class="lower-grid">
        <div class="panel chart-panel">
          <h3 class="panel-title-plain">Weekly Steps Overview</h3>
          <div class="chart-box">
            <canvas ref="activityChart" height="180"></canvas>
          </div>
        </div>

        <div class="panel workouts-panel">
          <h3 class="panel-title"><span>🏋️</span> Letzte Workouts</h3>
          <div v-if="activities.length === 0" class="no-data">Keine Daten</div>
          <div v-else class="workout-list">
            <div v-for="w in activities.slice(0, 5)" :key="w.start_time" class="workout-item">
              <div class="workout-info">
                <div class="workout-name">{{ formatActivityType(w.activity_type) }}</div>
                <div class="workout-meta">
                  <span>🕐 {{ w.duration_minutes }} min</span>
                  <span v-if="w.calories">🔥 {{ w.calories }} kcal</span>
                </div>
              </div>
              <div class="workout-right">
                <span class="workout-time">{{ formatTime(w.start_time) }}</span>
                <span class="workout-badge intensity" :class="w.intensity_level">{{ w.intensity_level || '—' }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- This Week's Progress -->
      <div class="panel progress-banner">
        <h3 class="panel-title"><span>📈</span> This Week's Progress</h3>
        <div class="progress-grid">
          <div v-for="p in weekProgress" :key="p.label" class="progress-item">
            <div class="progress-val">{{ p.value }}</div>
            <div class="progress-label">{{ p.label }}</div>
          </div>
        </div>
      </div>

    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import {
  Chart, BarController, BarElement,
  LineController, LineElement, PointElement,
  CategoryScale, LinearScale, Tooltip, Legend, Filler
} from 'chart.js'

Chart.register(
  BarController, BarElement,
  LineController, LineElement, PointElement,
  CategoryScale, LinearScale, Tooltip, Legend, Filler
)

const stepsChart = ref(null)
const activityChart = ref(null)

const summary = ref(null)
const weeklySteps = ref([])
const activities = ref([])

const mostRecentActDay = computed(() => {
  if (activities.value.length) return String(activities.value[0].start_time).slice(0, 10)
  const stepsWithData = weeklySteps.value.filter(d => d.steps > 0)
  if (stepsWithData.length) return stepsWithData[stepsWithData.length - 1].day
  return new Date().toISOString().slice(0, 10)
})

const username = computed(() => {
  try { return JSON.parse(localStorage.getItem('hs_user') || '{}').first_name || 'User' }
  catch { return 'User' }
})

const STEPS_GOAL = 10000

const statCards = computed(() => {
  const steps = summary.value?.steps ?? 0
  const calories = activities.value
    .filter(a => String(a.start_time).slice(0, 10) === mostRecentActDay.value)
    .reduce((sum, a) => sum + (a.calories || 0), 0)
  const activeMin = activities.value
    .filter(a => String(a.start_time).slice(0, 10) === mostRecentActDay.value)
    .reduce((sum, a) => sum + (a.duration_minutes || 0), 0)
  const workoutCount = activities.value
    .filter(a => String(a.start_time).slice(0, 10) === mostRecentActDay.value)
    .length

  return [
    { label: 'Steps Today', value: steps ? steps.toLocaleString('de-AT') : '—', icon: '👟', pct: steps ? Math.round(steps / STEPS_GOAL * 100) : 0, color: '#3b82f6', variant: 'steps' },
    { label: 'Calories',    value: calories ? calories + ' kcal' : '—', icon: '🔥', pct: calories ? Math.round(calories / 500 * 100) : 0, color: '#f59e0b', variant: 'cal' },
    { label: 'Active Time', value: activeMin ? activeMin + ' min' : '—', icon: '⏱️', pct: activeMin ? Math.round(activeMin / 60 * 100) : 0, color: '#3b82f6', variant: 'time' },
    { label: 'Workouts',    value: workoutCount || '—', icon: '🏋️', pct: workoutCount ? 100 : 0, color: '#10b981', variant: 'work' },
  ]
})

const xpToday = computed(() => {
  const steps = summary.value?.steps ?? 0
  return '+' + Math.round(steps / 100)
})

const quests = computed(() => {
  const steps = summary.value?.steps ?? 0
  const calories = activities.value
    .filter(a => String(a.start_time).slice(0, 10) === mostRecentActDay.value)
    .reduce((sum, a) => sum + (a.calories || 0), 0)
  const activeMin = activities.value
    .filter(a => String(a.start_time).slice(0, 10) === mostRecentActDay.value)
    .reduce((sum, a) => sum + (a.duration_minutes || 0), 0)
  const workouts = activities.value
    .filter(a => String(a.start_time).slice(0, 10) === mostRecentActDay.value)
    .length

  return [
    { name: 'Walk 10,000 steps', icon: '👟', xp: 75, current: steps, goal: STEPS_GOAL, progressText: `${(steps/1000).toFixed(1)}k/10.0k`, completed: steps >= STEPS_GOAL },
    { name: 'Burn 500 calories',  icon: '🔥', xp: 60, current: calories, goal: 500, progressText: `${calories}/500 kcal`, completed: calories >= 500 },
    { name: '60 min active time', icon: '⏱️', xp: 50, current: activeMin, goal: 60, progressText: `${activeMin}/60 min`, completed: activeMin >= 60 },
    { name: 'Complete a workout', icon: '🏋️', xp: 100, current: workouts, goal: 1, progressText: `${workouts}/1`, completed: workouts >= 1 },
  ]
})

const weekProgress = computed(() => {
  const totalSteps = weeklySteps.value.reduce((s, d) => s + (parseInt(d.steps) || 0), 0)
  const weekStart = weeklySteps.value.length ? weeklySteps.value[0].day : null
  const weekActs = weekStart ? activities.value.filter(a => String(a.start_time).slice(0, 10) >= weekStart) : activities.value
  const totalCal = weekActs.reduce((s, a) => s + (a.calories || 0), 0)
  const totalMin = weekActs.reduce((s, a) => s + (a.duration_minutes || 0), 0)
  const workoutCount = weekActs.length

  const h = Math.floor(totalMin / 60)
  const m = totalMin % 60

  return [
    { value: totalSteps ? totalSteps.toLocaleString('de-AT') : '—', label: 'Total Steps' },
    { value: totalCal ? totalCal.toLocaleString('de-AT') : '—', label: 'Calories Burned' },
    { value: totalMin ? `${h}h ${m}m` : '—', label: 'Active Time' },
    { value: workoutCount || '—', label: 'Workouts' },
  ]
})

function formatActivityType(t) {
  if (!t) return 'Aktivität'
  return t.charAt(0).toUpperCase() + t.slice(1).replace(/_/g, ' ')
}

function formatTime(dt) {
  if (!dt) return '—'
  return new Date(dt).toLocaleTimeString('de-AT', { hour: '2-digit', minute: '2-digit' })
}

let stepsChartInst = null
let actChartInst = null

function buildCharts() {
  // Weekly Steps Bar Chart
  if (stepsChart.value) {
    if (stepsChartInst) stepsChartInst.destroy()
    const labels = weeklySteps.value.map(d => {
      const date = new Date(d.day + 'T00:00:00')
      return ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'][date.getUTCDay()]
    })
    const data = weeklySteps.value.map(d => parseInt(d.steps) || 0)
    const goalData = weeklySteps.value.map(() => STEPS_GOAL)

    stepsChartInst = new Chart(stepsChart.value.getContext('2d'), {
      type: 'bar',
      data: {
        labels: labels.length ? labels : ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
        datasets: [
          {
            label: 'Steps',
            data: data.length ? data : Array(7).fill(0),
            backgroundColor: 'rgba(16, 185, 129, 0.35)',
            borderRadius: 6,
            borderSkipped: false,
            barPercentage: 0.55,
            order: 2,
          },
          {
            label: 'Goal',
            data: goalData.length ? goalData : Array(7).fill(STEPS_GOAL),
            type: 'line',
            borderColor: '#3b82f6',
            borderWidth: 2,
            borderDash: [6, 4],
            pointRadius: 0,
            fill: false,
            order: 1,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: { backgroundColor: '#0f172a', titleFont: { family: 'Inter', weight: '600' }, bodyFont: { family: 'Inter' }, padding: 10, cornerRadius: 10 },
        },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
          y: { grid: { color: '#f1f5f9' }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
        },
      },
    })
  }

  // Activity (steps per day) area chart
  if (activityChart.value) {
    if (actChartInst) actChartInst.destroy()
    const labels = weeklySteps.value.map(d => {
      const date = new Date(d.day + 'T00:00:00')
      return ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'][date.getUTCDay()]
    })
    const data = weeklySteps.value.map(d => parseInt(d.steps) || 0)

    actChartInst = new Chart(activityChart.value.getContext('2d'), {
      type: 'line',
      data: {
        labels: labels.length ? labels : ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
        datasets: [{
          label: 'Schritte',
          data: data.length ? data : Array(7).fill(0),
          borderColor: '#ef4444',
          backgroundColor: 'rgba(239, 68, 68, 0.08)',
          borderWidth: 2.5,
          pointRadius: 0,
          pointHoverRadius: 5,
          pointHoverBackgroundColor: '#ef4444',
          tension: 0.5,
          fill: true,
          spanGaps: true,
        }],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: { backgroundColor: '#0f172a', titleFont: { family: 'Inter', weight: '600' }, bodyFont: { family: 'Inter' }, padding: 10, cornerRadius: 10 },
        },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
          y: { grid: { color: '#f1f5f9' }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
        },
      },
    })
  }
}

onMounted(async () => {
  try {
    const token = localStorage.getItem('hs_token')
    const headers = { Authorization: `Bearer ${token}` }
    const [sumRes, stepsRes, actRes] = await Promise.all([
      fetch('/api/health/summary', { headers }),
      fetch('/api/health/steps', { headers }),
      fetch('/api/health/activities', { headers }),
    ])
    if (sumRes.ok) summary.value = await sumRes.json()
    if (stepsRes.ok) weeklySteps.value = await stepsRes.json()
    if (actRes.ok) activities.value = await actRes.json()
  } catch {}
  await nextTick()
  buildCharts()
})
</script>

<style scoped>
.dashboard-layout { display: flex; min-height: 100vh; background: #f8fafc; }
.dashboard-main { flex: 1; margin-left: 260px; padding: 2rem 2.5rem; overflow-x: hidden; }

/* Header */
.dash-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.8rem; }
.page-title { display: flex; align-items: center; gap: 0.5rem; font-size: 1.8rem; font-weight: 800; color: #0f172a; letter-spacing: -0.5px; margin-bottom: 0.25rem; }
.page-icon { font-size: 1.5rem; }
.page-sub { font-size: 0.9rem; color: #94a3b8; font-weight: 500; }
.xp-badge {
  display: flex; align-items: center; gap: 0.4rem;
  padding: 0.55rem 1rem; border-radius: 12px; font-size: 0.82rem; font-weight: 700;
  background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; white-space: nowrap;
}

/* Stat Grid */
.stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 1.5rem; }

.activity-card {
  background: #fff; border: 1px solid #e2e8f0; border-radius: 16px;
  padding: 1.2rem; display: flex; align-items: center; justify-content: space-between;
  transition: all 0.2s;
}
.activity-card:hover { transform: translateY(-2px); box-shadow: 0 8px 25px -5px rgba(0,0,0,0.08); }

.ac-left { display: flex; align-items: center; gap: 0.8rem; }
.ac-icon {
  width: 44px; height: 44px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center; font-size: 1.2rem;
}
.ac-icon.steps { background: #eff6ff; }
.ac-icon.cal   { background: #fff7ed; }
.ac-icon.time  { background: #eff6ff; }
.ac-icon.work  { background: #ecfdf5; }

.ac-label { font-size: 0.78rem; color: #94a3b8; font-weight: 500; margin-bottom: 0.15rem; }
.ac-value { font-size: 1.5rem; font-weight: 800; color: #0f172a; letter-spacing: -0.5px; }

.ring { flex-shrink: 0; }

/* Mid Grid */
.mid-grid { display: grid; grid-template-columns: 1fr 340px; gap: 1.5rem; margin-bottom: 1.5rem; align-items: stretch; }

.panel { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 1.4rem; display: flex; flex-direction: column; }
.panel-title-plain { font-size: 1rem; font-weight: 700; color: #0f172a; margin-bottom: 1rem; flex-shrink: 0; }
.panel-title { display: flex; align-items: center; gap: 0.5rem; font-size: 1rem; font-weight: 700; color: #0f172a; margin-bottom: 1rem; }

.chart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; flex-shrink: 0; }
.chart-header .panel-title-plain { margin-bottom: 0; }

.chart-legend { display: flex; align-items: center; gap: 0.5rem; font-size: 0.75rem; color: #94a3b8; font-weight: 500; }
.legend-dot { width: 8px; height: 8px; border-radius: 50%; display: inline-block; }
.legend-dot.green { background: rgba(16,185,129,0.5); }
.legend-dot.blue  { background: #3b82f6; }

.chart-panel { flex: 1; }
.chart-box { flex: 1; min-height: 200px; position: relative; width: 100%; }
.chart-box canvas { width: 100% !important; height: 100% !important; }

/* Quests */
.quest-list { display: flex; flex-direction: column; gap: 0.7rem; }

.quest-item {
  display: flex; align-items: center; gap: 0.8rem;
  padding: 0.75rem; background: #f8fafc; border: 1px solid #f1f5f9;
  border-radius: 14px; transition: all 0.2s;
}
.quest-item.completed { background: #f0fdf4; border-color: #bbf7d0; }

.quest-icon {
  width: 40px; height: 40px; min-width: 40px; border-radius: 12px;
  background: #eff6ff; display: flex; align-items: center; justify-content: center; font-size: 1rem;
}
.quest-icon.done { background: #dcfce7; color: #10b981; font-weight: 700; font-size: 1.1rem; }

.quest-body { flex: 1; min-width: 0; }
.quest-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.35rem; }
.quest-name { font-size: 0.85rem; font-weight: 600; color: #0f172a; }
.quest-name.strikethrough { text-decoration: line-through; color: #94a3b8; }
.quest-xp { font-size: 0.72rem; font-weight: 700; color: #10b981; background: #dcfce7; padding: 0.15rem 0.45rem; border-radius: 20px; white-space: nowrap; }

.quest-bar-row { display: flex; align-items: center; gap: 0.5rem; }
.quest-bar { flex: 1; height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden; }
.quest-fill { height: 100%; border-radius: 3px; transition: width 1s ease; }
.quest-progress { font-size: 0.7rem; color: #94a3b8; font-weight: 500; white-space: nowrap; }

/* Lower Grid */
.lower-grid { display: grid; grid-template-columns: 1fr 340px; gap: 1.5rem; margin-bottom: 1.5rem; align-items: stretch; }

/* Workouts */
.no-data { font-size: 0.85rem; color: #94a3b8; text-align: center; padding: 1rem 0; }
.workout-list { display: flex; flex-direction: column; gap: 0.8rem; }
.workout-item {
  display: flex; justify-content: space-between; align-items: center;
  padding: 1rem; background: #f8fafc; border: 1px solid #f1f5f9; border-radius: 14px;
}
.workout-name { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 0.3rem; }
.workout-meta { display: flex; gap: 0.8rem; font-size: 0.78rem; color: #64748b; }

.workout-right { display: flex; flex-direction: column; align-items: flex-end; gap: 0.3rem; }
.workout-time { font-size: 0.78rem; color: #94a3b8; font-weight: 500; }
.workout-badge {
  font-size: 0.7rem; font-weight: 600; padding: 0.2rem 0.5rem; border-radius: 8px;
}
.workout-badge.low { background: #dcfce7; color: #16a34a; }
.workout-badge.medium { background: #fef9c3; color: #ca8a04; }
.workout-badge.high { background: #fef2f2; color: #ef4444; }
.workout-badge.intensity { background: #eff6ff; color: #2563eb; }

/* Progress Banner */
.progress-banner { margin-bottom: 1.5rem; background: #f0fdf4; border-color: #bbf7d0; }
.progress-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; }

.progress-item {
  text-align: center; padding: 1rem 0.5rem;
  background: #fafffe; border-radius: 14px;
}
.progress-val { font-size: 1.6rem; font-weight: 800; color: #0f172a; letter-spacing: -0.5px; margin-bottom: 0.2rem; }
.progress-label { font-size: 0.78rem; color: #64748b; font-weight: 500; }

/* Responsive */
@media (max-width: 1200px) {
  .stat-grid { grid-template-columns: repeat(2, 1fr); }
  .mid-grid, .lower-grid { grid-template-columns: 1fr; }
  .progress-grid { grid-template-columns: repeat(2, 1fr); }
}
</style>
