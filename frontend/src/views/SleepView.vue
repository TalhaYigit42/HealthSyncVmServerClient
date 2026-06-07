<template>
  <div class="dashboard-layout">
    <Sidebar :username="username" active-nav="Sleep" />
    <main class="dashboard-main">

      <!-- Header -->
      <div class="dash-header">
        <div>
          <h1 class="page-title">
            <span class="page-icon">🌙</span> Sleep Analysis
          </h1>
          <p class="page-sub">Track your sleep patterns and improve your rest quality.</p>
        </div>
        <div class="badge xp-badge">⚡ +{{ sleepXp }} XP This Week</div>
      </div>

      <!-- Stat Cards -->
      <div class="stat-grid">
        <div class="sleep-stat-card">
          <div class="sleep-stat-icon">⏱️</div>
          <div class="sleep-stat-label">Avg Duration</div>
          <div class="sleep-stat-value blue">{{ avgDuration }}</div>
        </div>
        <div class="sleep-stat-card">
          <div class="sleep-stat-icon deep">🌑</div>
          <div class="sleep-stat-label">Deep Sleep</div>
          <div class="sleep-stat-value blue">{{ avgDeep }}</div>
        </div>
        <div class="sleep-stat-card">
          <div class="sleep-stat-icon rem">⚡</div>
          <div class="sleep-stat-label">REM Sleep</div>
          <div class="sleep-stat-value green">{{ avgRem }}</div>
        </div>
        <div class="sleep-stat-card">
          <div class="sleep-stat-icon score">↗</div>
          <div class="sleep-stat-label">Sleep Score</div>
          <div class="sleep-stat-value dark">{{ avgScore }}</div>
        </div>
      </div>

      <!-- Main Content Grid -->
      <div class="content-grid">

        <!-- Left Column -->
        <div class="content-left">
          <!-- Sleep Quests -->
          <div class="panel">
            <h3 class="panel-title"><span>🌙</span> Sleep Quests</h3>
            <div class="quest-list">
              <div v-for="quest in sleepQuests" :key="quest.name" :class="['quest-item', { completed: quest.completed }]">
                <div :class="['quest-icon', { done: quest.completed }]">
                  <span v-if="quest.completed">✓</span>
                  <span v-else>{{ quest.icon }}</span>
                </div>
                <div class="quest-body">
                  <div class="quest-top">
                    <span :class="['quest-name', { strikethrough: quest.completed }]">{{ quest.name }}</span>
                    <span class="quest-xp">⚡ +{{ quest.xp }} XP</span>
                  </div>
                  <div class="quest-bar-row">
                    <div class="quest-bar">
                      <div class="quest-fill" :style="{ width: Math.min(100, quest.current / quest.goal * 100) + '%', background: quest.completed ? '#10b981' : '#3b82f6' }"></div>
                    </div>
                    <span class="quest-progress">{{ quest.progressText }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Last Night -->
          <div class="panel last-night-panel">
            <h3 class="panel-title"><span>🛏️</span> Last Night</h3>
            <div v-if="lastNight" class="last-night-rows">
              <div class="ln-row">
                <span class="ln-label">Schlafbeginn</span>
                <span class="ln-value">{{ formatTime(lastNight.start_time) }}</span>
              </div>
              <div class="ln-row">
                <span class="ln-label">Aufwachzeit</span>
                <span class="ln-value">{{ formatTime(lastNight.end_time) }}</span>
              </div>
              <div class="ln-row">
                <span class="ln-label">Total Sleep</span>
                <span class="ln-value blue">{{ formatMinutes(lastNight.total_sleep_minutes) }}</span>
              </div>
              <div class="ln-row">
                <span class="ln-label">Sleep Quality</span>
                <span :class="['ln-value', qualityClass(lastNight.sleep_quality_score)]">{{ qualityLabel(lastNight.sleep_quality_score) }}</span>
              </div>
            </div>
            <div v-else class="no-data">Keine Daten</div>
            <div v-if="lastNight" class="quality-bar-wrap">
              <div class="quality-bar">
                <div class="quality-bar-fill" :style="{ width: (lastNight.sleep_quality_score || 0) + '%' }"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- Right Column -->
        <div class="content-right">
          <!-- Weekly Sleep Stages Chart -->
          <div class="panel chart-panel">
            <h3 class="panel-title-plain">Weekly Sleep Stages</h3>
            <div class="chart-box">
              <canvas ref="stagesChart" height="220"></canvas>
            </div>
          </div>

          <!-- Monthly Trend Chart -->
          <div class="panel chart-panel">
            <h3 class="panel-title-plain">Sleep Trend (last 14 nights)</h3>
            <div class="chart-box">
              <canvas ref="trendChart" height="180"></canvas>
            </div>
          </div>
        </div>
      </div>

      <!-- Sleep Tips -->
      <div class="tips-panel">
        <h3 class="panel-title-plain">Sleep Tips</h3>
        <div class="tips-grid">
          <div v-for="tip in sleepTips" :key="tip.title" class="tip-card">
            <div class="tip-title">{{ tip.title }}</div>
            <div class="tip-text">{{ tip.text }}</div>
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
  Chart,
  BarController, BarElement,
  LineController, LineElement, PointElement,
  CategoryScale, LinearScale,
  Tooltip, Legend, Filler
} from 'chart.js'

Chart.register(
  BarController, BarElement,
  LineController, LineElement, PointElement,
  CategoryScale, LinearScale,
  Tooltip, Legend, Filler
)

const stagesChart = ref(null)
const trendChart = ref(null)

const sleepSessions = ref([])

const username = computed(() => {
  try {
    return JSON.parse(localStorage.getItem('hs_user') || '{}').first_name || 'User'
  } catch { return 'User' }
})

function getNightDate(startTime) {
  const d = new Date(startTime)
  if (d.getUTCHours() < 12) {
    const prev = new Date(d)
    prev.setUTCDate(prev.getUTCDate() - 1)
    return prev.toISOString().slice(0, 10)
  }
  return d.toISOString().slice(0, 10)
}

const lastNight = computed(() => {
  if (!sleepSessions.value.length) return null
  const nightKey = getNightDate(sleepSessions.value[0].start_time)
  const nights = sleepSessions.value.filter(s => getNightDate(s.start_time) === nightKey)
  const total = nights.reduce((sum, s) => sum + (s.total_sleep_minutes || 0), 0)
  const scores = nights.map(s => s.sleep_quality_score).filter(Boolean)
  return {
    start_time: nights[nights.length - 1]?.start_time,
    end_time: nights[0]?.end_time,
    total_sleep_minutes: total,
    deep_minutes: nights.reduce((sum, s) => sum + (s.deep_minutes || 0), 0),
    rem_minutes: nights.reduce((sum, s) => sum + (s.rem_minutes || 0), 0),
    light_minutes: nights.reduce((sum, s) => sum + (s.light_minutes || 0), 0),
    sleep_quality_score: scores.length ? Math.round(scores.reduce((a, b) => a + b, 0) / scores.length) : 0,
  }
})

function avg(arr) {
  const valid = arr.filter(v => v != null && v > 0)
  return valid.length ? valid.reduce((a, b) => a + b, 0) / valid.length : 0
}

const allNights = computed(() => {
  const map = new Map()
  for (const s of sleepSessions.value) {
    const key = getNightDate(s.start_time)
    if (!map.has(key)) map.set(key, [])
    map.get(key).push(s)
  }
  return [...map.values()].map(sessions => {
    const sc = sessions.map(x => x.sleep_quality_score).filter(Boolean)
    return {
      key: getNightDate(sessions[0].start_time),
      total_sleep_minutes: sessions.reduce((s,x) => s+(x.total_sleep_minutes||0), 0),
      deep_minutes:        sessions.reduce((s,x) => s+(x.deep_minutes||0), 0),
      rem_minutes:         sessions.reduce((s,x) => s+(x.rem_minutes||0), 0),
      light_minutes:       sessions.reduce((s,x) => s+(x.light_minutes||0), 0),
      sleep_quality_score: sc.length ? Math.round(sc.reduce((a,b)=>a+b,0)/sc.length) : 0,
    }
  })
})

const avgDuration = computed(() => {
  const a = avg(allNights.value.map(n => n.total_sleep_minutes))
  return a ? (a / 60).toFixed(1) + 'h' : '—'
})
const avgDeep = computed(() => {
  const a = avg(allNights.value.map(n => n.deep_minutes))
  return a ? (a / 60).toFixed(1) + 'h' : '—'
})
const avgRem = computed(() => {
  const a = avg(allNights.value.map(n => n.rem_minutes))
  return a ? (a / 60).toFixed(1) + 'h' : '—'
})
const avgScore = computed(() => {
  const a = avg(allNights.value.map(n => n.sleep_quality_score))
  return a ? Math.round(a) : '—'
})

const sleepXp = computed(() => {
  return Math.min(allNights.value.length, 7) * 15
})

const SLEEP_GOAL_MIN = 420 // 7h

const sleepQuests = computed(() => {
  const last = lastNight.value
  const totalMins = last?.total_sleep_minutes ?? 0
  const score = last?.sleep_quality_score ?? 0
  const goalH = (SLEEP_GOAL_MIN / 60).toFixed(0)
  const currentH = +(totalMins / 60).toFixed(1)

  return [
    {
      name: `${goalH} Stunden schlafen`,
      icon: '🌙',
      xp: 50,
      current: currentH,
      goal: parseFloat(goalH),
      progressText: `${currentH}/${goalH} h`,
      completed: totalMins >= SLEEP_GOAL_MIN,
    },
    {
      name: 'Sleep Score über 80',
      icon: '⭐',
      xp: 40,
      current: score,
      goal: 80,
      progressText: `${score}/80`,
      completed: score >= 80,
    },
    {
      name: '7 Nächte Schlafdaten',
      icon: '🛏️',
      xp: 100,
      current: allNights.value.length,
      goal: 7,
      progressText: `${allNights.value.length}/7`,
      completed: allNights.value.length >= 7,
    },
  ]
})

function formatTime(dt) {
  if (!dt) return '—'
  const d = new Date(dt)
  return String(d.getUTCHours()).padStart(2, '0') + ':' + String(d.getUTCMinutes()).padStart(2, '0')
}

function formatMinutes(m) {
  if (!m) return '—'
  return `${Math.floor(m / 60)}h ${m % 60}m`
}

function qualityLabel(score) {
  if (!score) return '—'
  if (score >= 85) return 'Sehr gut'
  if (score >= 70) return 'Gut'
  if (score >= 50) return 'Mittel'
  return 'Schlecht'
}

function qualityClass(score) {
  if (!score) return ''
  if (score >= 70) return 'green'
  if (score >= 50) return 'blue'
  return ''
}

const sleepTips = [
  { title: 'Regelmäßiger Schlafrhythmus', text: 'Geh jeden Tag zur gleichen Zeit schlafen und steh auf.' },
  { title: 'Kein Bildschirm vor dem Schlafen', text: 'Vermeide Bildschirme 1 Stunde vor dem Schlafengehen.' },
  { title: 'Kühles Schlafzimmer', text: 'Halte dein Schlafzimmer auf 18–20°C für optimalen Schlaf.' },
]

let stagesInst = null
let trendInst = null

function buildCharts() {
  // Last 7 consecutive calendar nights (true week view)
  const currentNightKey = getNightDate(new Date().toISOString())
  const nightDataMap = new Map(allNights.value.map(n => [n.key, n]))
  const weekKeys = []
  for (let i = 6; i >= 0; i--) {
    const d = new Date(currentNightKey + 'T12:00:00Z')
    d.setUTCDate(d.getUTCDate() - i)
    weekKeys.push(d.toISOString().slice(0, 10))
  }
  const stageLabels = weekKeys.map(key => {
    const d = new Date(key + 'T12:00:00Z')
    d.setUTCDate(d.getUTCDate() + 1); return ['So','Mo','Di','Mi','Do','Fr','Sa'][d.getUTCDay()]
  })
  const nightDeep  = weekKeys.map(k => { const n = nightDataMap.get(k); return n ? +(n.deep_minutes/60).toFixed(2) : 0 })
  const nightRem   = weekKeys.map(k => { const n = nightDataMap.get(k); return n ? +(n.rem_minutes/60).toFixed(2) : 0 })
  const nightLight = weekKeys.map(k => { const n = nightDataMap.get(k); return n ? +(n.light_minutes/60).toFixed(2) : 0 })

  if (stagesChart.value) {
    if (stagesInst) stagesInst.destroy()
    stagesInst = new Chart(stagesChart.value.getContext('2d'), {
      type: 'bar',
      data: {
        labels: stageLabels.length ? stageLabels : ['Mo','Di','Mi','Do','Fr','Sa','So'],
        datasets: [
          {
            label: 'Deep Sleep',
            data: nightDeep,
            backgroundColor: '#3b82f6',
            borderRadius: 0,
            stack: 'sleep',
          },
          {
            label: 'REM',
            data: nightRem,
            backgroundColor: '#86efac',
            stack: 'sleep',
          },
          {
            label: 'Light Sleep',
            data: nightLight,
            backgroundColor: '#bfdbfe',
            stack: 'sleep',
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
            labels: { usePointStyle: true, pointStyle: 'circle', padding: 14, font: { size: 11, family: 'Inter', weight: '500' }, color: '#64748b' },
          },
          tooltip: { backgroundColor: '#0f172a', titleFont: { family: 'Inter', weight: '600' }, bodyFont: { family: 'Inter' }, padding: 10, cornerRadius: 10 },
        },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' }, stacked: true },
          y: { grid: { color: '#f1f5f9' }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' }, stacked: true },
        },
      },
    })
  }

  // Trend: group by night, last 14 nights
  const trendNightMap = new Map()
  for (const s of sleepSessions.value) {
    const key = getNightDate(s.start_time)
    if (!trendNightMap.has(key)) trendNightMap.set(key, { key, sessions: [] })
    trendNightMap.get(key).sessions.push(s)
  }
  const last14nights = [...trendNightMap.values()].slice(0, 14).reverse()
  const trendLabels = last14nights.map(n => {
    const d = new Date(n.key + 'T12:00:00Z')
    return String(d.getUTCDate()).padStart(2,'0') + '.' + String(d.getUTCMonth()+1).padStart(2,'0') + '.'
  })
  const trendTotalH = last14nights.map(n => +(n.sessions.reduce((s,x) => s+(x.total_sleep_minutes||0),0)/60).toFixed(2))
  const trendScore = last14nights.map(n => {
    const scores = n.sessions.map(x => x.sleep_quality_score).filter(Boolean)
    return scores.length ? Math.round(scores.reduce((a,b)=>a+b,0)/scores.length) : null
  })

  if (trendChart.value) {
    if (trendInst) trendInst.destroy()
    trendInst = new Chart(trendChart.value.getContext('2d'), {
      type: 'bar',
      data: {
        labels: trendLabels.length ? trendLabels : ['—'],
        datasets: [
          {
            label: 'Schlaf (h)',
            data: trendTotalH,
            backgroundColor: '#bfdbfe',
            borderRadius: 6,
            barPercentage: 0.5,
            order: 2,
          },
          {
            label: 'Sleep Score',
            data: trendScore,
            type: 'line',
            borderColor: '#3b82f6',
            backgroundColor: 'transparent',
            borderWidth: 2,
            pointRadius: 5,
            pointBackgroundColor: '#ffffff',
            pointBorderColor: '#3b82f6',
            pointBorderWidth: 2,
            tension: 0.4,
            yAxisID: 'y1',
            order: 1,
            spanGaps: true,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: { mode: 'index', intersect: false },
        plugins: {
          legend: { display: false },
          tooltip: {
            backgroundColor: '#ffffff', titleColor: '#0f172a', bodyColor: '#3b82f6',
            borderColor: '#e2e8f0', borderWidth: 1,
            titleFont: { family: 'Inter', weight: '700', size: 12 },
            bodyFont: { family: 'Inter', size: 12 },
            padding: 12, cornerRadius: 10,
            callbacks: { label: (ctx) => ctx.dataset.label + ' : ' + ctx.parsed.y },
          },
        },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 10, family: 'Inter' }, color: '#94a3b8', maxRotation: 45 } },
          y: { grid: { color: '#f1f5f9' }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
          y1: { position: 'right', max: 100, grid: { display: false }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
        },
      },
    })
  }
}

onMounted(async () => {
  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/health/sleep', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (res.ok) sleepSessions.value = await res.json()
  } catch {}
  await nextTick()
  buildCharts()
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
  overflow-x: hidden;
}

/* Header */
.dash-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1.8rem;
}

.page-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.8rem;
  font-weight: 800;
  color: #0f172a;
  letter-spacing: -0.5px;
  margin-bottom: 0.25rem;
}

.page-icon { font-size: 1.5rem; }

.page-sub {
  font-size: 0.9rem;
  color: #94a3b8;
  font-weight: 500;
}

.xp-badge {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.55rem 1rem;
  border-radius: 12px;
  font-size: 0.82rem;
  font-weight: 700;
  background: #ecfdf5;
  color: #059669;
  border: 1px solid #a7f3d0;
  white-space: nowrap;
}

/* Stat Grid */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.sleep-stat-card {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.3rem 1.2rem;
  transition: all 0.2s;
}

.sleep-stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px -5px rgba(0,0,0,0.08);
}

.sleep-stat-icon {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: #eff6ff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
  margin-bottom: 0.8rem;
}

.sleep-stat-label {
  font-size: 0.78rem;
  color: #94a3b8;
  font-weight: 500;
  margin-bottom: 0.2rem;
}

.sleep-stat-value {
  font-size: 2rem;
  font-weight: 800;
  letter-spacing: -1px;
}

.sleep-stat-value.blue  { color: #3b82f6; }
.sleep-stat-value.green { color: #10b981; }
.sleep-stat-value.dark  { color: #0f172a; }

/* Content Grid */
.content-grid {
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
}

.content-left {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.content-right {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* Panels */
.panel {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.3rem;
}

.panel-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1rem;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 1rem;
}

.panel-title-plain {
  font-size: 1rem;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 1rem;
}

/* Quest Items */
.quest-list {
  display: flex;
  flex-direction: column;
  gap: 0.7rem;
}

.quest-item {
  display: flex;
  align-items: center;
  gap: 0.8rem;
  padding: 0.75rem;
  background: #f8fafc;
  border: 1px solid #f1f5f9;
  border-radius: 14px;
  transition: all 0.2s;
}

.quest-item.completed {
  background: #f0fdf4;
  border-color: #bbf7d0;
}

.quest-icon {
  width: 40px;
  height: 40px;
  min-width: 40px;
  border-radius: 12px;
  background: #eff6ff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1rem;
}

.quest-icon.done {
  background: #dcfce7;
  color: #10b981;
  font-weight: 700;
  font-size: 1.1rem;
}

.quest-body { flex: 1; min-width: 0; }

.quest-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.35rem;
}

.quest-name {
  font-size: 0.85rem;
  font-weight: 600;
  color: #0f172a;
}

.quest-name.strikethrough {
  text-decoration: line-through;
  color: #94a3b8;
}

.quest-xp {
  font-size: 0.72rem;
  font-weight: 700;
  color: #10b981;
  background: #dcfce7;
  padding: 0.15rem 0.45rem;
  border-radius: 20px;
  white-space: nowrap;
}

.quest-bar-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.quest-bar {
  flex: 1;
  height: 6px;
  background: #e2e8f0;
  border-radius: 3px;
  overflow: hidden;
}

.quest-fill {
  height: 100%;
  border-radius: 3px;
  transition: width 1s ease;
}

.quest-progress {
  font-size: 0.7rem;
  color: #94a3b8;
  font-weight: 500;
  white-space: nowrap;
}

/* Last Night Panel */
.no-data {
  font-size: 0.85rem;
  color: #94a3b8;
  text-align: center;
  padding: 1rem 0;
}

.last-night-rows {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin-bottom: 0.8rem;
}

.ln-row {
  display: flex;
  justify-content: space-between;
  padding: 0.5rem 0;
  border-bottom: 1px solid #f1f5f9;
}

.ln-row:last-child { border-bottom: none; }

.ln-label {
  font-size: 0.85rem;
  color: #64748b;
}

.ln-value {
  font-size: 0.88rem;
  font-weight: 700;
  color: #0f172a;
}

.ln-value.blue  { color: #3b82f6; }
.ln-value.green { color: #10b981; }

.quality-bar-wrap { margin-top: 0.3rem; }

.quality-bar {
  height: 8px;
  background: #e2e8f0;
  border-radius: 4px;
  overflow: hidden;
}

.quality-bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #10b981, #34d399);
  border-radius: 4px;
  transition: width 1s ease;
}

/* Charts */
.chart-panel {
  overflow: hidden;
}

.chart-box {
  height: 220px;
  position: relative;
}

/* Sleep Tips */
.tips-panel {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.3rem;
}

.tips-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
}

.tip-card {
  background: #f0fdf4;
  border: 1px solid #bbf7d0;
  border-radius: 14px;
  padding: 1rem 1.1rem;
  transition: all 0.2s;
}

.tip-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(16,185,129,0.1);
}

.tip-title {
  font-size: 0.9rem;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 0.35rem;
}

.tip-text {
  font-size: 0.8rem;
  color: #64748b;
  line-height: 1.5;
}

/* Responsive */
@media (max-width: 1200px) {
  .stat-grid { grid-template-columns: repeat(2, 1fr); }
  .content-grid { grid-template-columns: 1fr; }
  .tips-grid { grid-template-columns: 1fr; }
}
</style>
