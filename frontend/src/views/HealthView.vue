<template>
  <div class="dashboard-layout">
    <Sidebar :username="username" active-nav="Health" />
    <main class="dashboard-main">

      <!-- Header -->
      <div class="dash-header">
        <div>
          <h1 class="page-title">
            <span class="page-icon">❤️</span> Health Stats
          </h1>
          <p class="page-sub">Monitor your heart health and vital signs.</p>
        </div>
        <div class="badge health-badge">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.42 4.58a5.4 5.4 0 0 0-7.65 0l-.77.78-.77-.78a5.4 5.4 0 0 0-7.65 7.65l.78.77L12 20.65l7.65-7.65.77-.77a5.4 5.4 0 0 0 0-7.65z"/></svg>
          {{ heartHealthLabel }}
        </div>
      </div>

      <!-- Stat Cards -->
      <div class="stat-grid">
        <div class="health-card">
          <div class="hc-icon pink">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.42 4.58a5.4 5.4 0 0 0-7.65 0l-.77.78-.77-.78a5.4 5.4 0 0 0-7.65 7.65l.78.77L12 20.65l7.65-7.65.77-.77a5.4 5.4 0 0 0 0-7.65z"/></svg>
          </div>
          <div class="hc-label">Avg BPM Heute</div>
          <div class="hc-value">{{ hrStats.avg || '—' }}</div>
        </div>
        <div class="health-card">
          <div class="hc-icon green">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
          </div>
          <div class="hc-label">Ruhepuls</div>
          <div class="hc-value">{{ hrStats.resting || '—' }}</div>
        </div>
        <div class="health-card">
          <div class="hc-icon blue">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/></svg>
          </div>
          <div class="hc-label">Max BPM Heute</div>
          <div class="hc-value">{{ hrStats.max || '—' }}</div>
        </div>
        <div class="health-card">
          <div class="hc-icon gray">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
          </div>
          <div class="hc-label">Messungen Heute</div>
          <div class="hc-value">{{ hrStats.count || '—' }}</div>
        </div>
      </div>

      <!-- Middle Section: Heart Rate Chart + Zones -->
      <div class="mid-grid">
        <!-- Today's Heart Rate -->
        <div class="panel chart-panel">
          <div class="chart-header">
            <h3 class="panel-title-plain">Today's Heart Rate</h3>
  
          </div>
          <div class="chart-box">
            <canvas ref="hrChart" height="200"></canvas>
          </div>
        </div>

        <!-- Heart Rate Zones -->
        <div class="panel zones-panel">
          <h3 class="panel-title-plain">Heart Rate Zones</h3>
          <div class="zones-list">
            <div v-for="zone in hrZones" :key="zone.name" class="zone-item">
              <div class="zone-bar" :style="{ background: zone.color }"></div>
              <div class="zone-info">
                <div class="zone-name">{{ zone.name }}</div>
                <div class="zone-sub">{{ zone.sub }}</div>
              </div>
              <div class="zone-range">{{ zone.range }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Weekly HRV & Resting HR Chart -->
      <div class="panel chart-panel wide-panel">
        <h3 class="panel-title-plain">Weekly HRV &amp; Resting Heart Rate</h3>
        <div class="chart-box tall">
          <canvas ref="hrvChart" height="220"></canvas>
        </div>
      </div>

      <!-- Insight Cards -->
      <div class="insights-grid">
        <div v-for="ins in heartInsights" :key="ins.title" :class="['insight-card', ins.type]">
          <div :class="['insight-icon', ins.type + '-icon']">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/></svg>
          </div>
          <div>
            <div class="insight-title">{{ ins.title }}</div>
            <div class="insight-text">{{ ins.text }}</div>
          </div>
        </div>
        <div v-if="!heartInsights.length" class="insight-card gray" style="grid-column:1/-1">
          <div class="insight-icon gray-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
          </div>
          <div>
            <div class="insight-title">Herzrate Analyse</div>
            <div class="insight-text">Mehr Daten werden benötigt, um detaillierte Herzrate-Insights anzuzeigen.</div>
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

const hrChart = ref(null)
const hrvChart = ref(null)
let hrChartInst = null
let hrvChartInst = null
const hrStats = ref({ avg: null, resting: null, max: null, count: null })
const todayHR = ref([])
const weeklyHR = ref([])

const heartHealthLabel = computed(() => {
  const avg = hrStats.value.avg
  if (!avg) return 'Herzrate: Keine Daten'
  if (avg < 65) return 'Herzrate: Sehr gut'
  if (avg < 80) return 'Herzrate: Gut'
  if (avg < 100) return 'Herzrate: Normal'
  return 'Herzrate: Erhöht'
})

const heartInsights = computed(() => {
  const results = []
  if (weeklyHR.value.length >= 2) {
    const resting = weeklyHR.value.filter(r => r.resting).map(r => parseInt(r.resting)).filter(Boolean)
    if (resting.length >= 2) {
      const first = resting.slice(0, Math.ceil(resting.length / 2))
      const last  = resting.slice(Math.ceil(resting.length / 2))
      const avgFirst = Math.round(first.reduce((a, b) => a + b, 0) / first.length)
      const avgLast  = Math.round(last.reduce((a, b) => a + b, 0) / last.length)
      const diff = avgFirst - avgLast
      if (diff > 0) results.push({ type: 'green', title: 'Guter Fortschritt!', text: 'Dein Ruhepuls hat sich diese Woche um ' + diff + ' BPM verbessert – ein Zeichen besserer Herzfitness.' })
      else if (diff < 0) results.push({ type: 'gray', title: 'Herzrate-Trend', text: 'Dein Ruhepuls stieg diese Woche um ' + Math.abs(diff) + ' BPM. Achte auf ausreichend Schlaf und Erholung.' })
    }
    const avgs = weeklyHR.value.map(r => parseInt(r.avg_bpm)).filter(Boolean)
    if (avgs.length) {
      const avg = Math.round(avgs.reduce((a, b) => a + b, 0) / avgs.length)
      const label = avg < 80 ? 'im gesunden Bereich' : avg < 100 ? 'leicht erhöht' : 'erhöht'
      results.push({ type: avg < 100 ? 'gray' : 'gray', title: 'Wochendurchschnitt', text: 'Dein durchschnittlicher Herzwert diese Woche: ' + avg + ' BPM (' + label + ').' })
    }
  }
  return results
})

const username = computed(() => {
  try { return JSON.parse(localStorage.getItem('hs_user') || '{}').first_name || 'User' }
  catch { return 'User' }
})

const hrZones = [
  { name: 'Ruhe',      sub: 'Erholung & Schlaf',  range: '50-60 BPM',   color: '#bfdbfe' },
  { name: 'Leicht',    sub: 'Alltag',              range: '60-100 BPM',  color: '#86efac' },
  { name: 'Moderat',   sub: 'Fettverbrennung',     range: '100-140 BPM', color: '#3b82f6' },
  { name: 'Intensiv',  sub: 'Cardio',              range: '140-170 BPM', color: '#fb923c' },
  { name: 'Maximum',   sub: 'Höchstleistung',      range: '170-200 BPM', color: '#ef4444' },
]

const chartOptions = (extraOptions = {}) => ({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { display: false },
    tooltip: {
      backgroundColor: '#0f172a',
      titleFont: { family: 'Inter', weight: '600' },
      bodyFont: { family: 'Inter' },
      padding: 10,
      cornerRadius: 10,
    },
  },
  scales: {
    x: { grid: { display: false }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
    y: { grid: { color: '#f1f5f9' }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
  },
  ...extraOptions,
})

onMounted(async () => {
  await nextTick()

  const token = localStorage.getItem('hs_token')
  todayHR.value = []
  weeklyHR.value = []

  try {
    const res = await fetch('/api/health/heartrate', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (res.ok) {
      const data = await res.json()
      todayHR.value = data.today || []
      weeklyHR.value = data.weekly || []
    }
  } catch {}

  // Stats from weekly data (today might be empty if no reading yet today)
  const summaryRes = await fetch('/api/health/summary', { headers: { Authorization: `Bearer ${token}` } })
  if (summaryRes.ok) {
    const s = await summaryRes.json()
    hrStats.value = {
      avg: s.heart_rate?.avg,
      resting: s.heart_rate?.resting,
      max: s.heart_rate?.max,
      count: todayHR.value.length,
    }
  }

  // ─── Today's Heart Rate ────────────────────────────────────────────────────
  if (hrChart.value) {
    const labels = todayHR.value.map(r => new Date(r.hour).toLocaleTimeString('de-AT', { hour: '2-digit', minute: '2-digit' }))
    const values = todayHR.value.map(r => parseInt(r.avg_bpm))
    if (hrChartInst) { hrChartInst.destroy(); hrChartInst = null }
    hrChartInst = new Chart(hrChart.value.getContext('2d'), {
      type: 'line',
      data: {
        labels: labels.length ? labels : ['Keine Daten aktuell'],
        datasets: [{
          label: 'BPM',
          data: values.length ? values : [],
          borderColor: '#ef4444',
          backgroundColor: 'rgba(239, 68, 68, 0.08)',
          borderWidth: 2.5,
          pointRadius: 0,
          pointHoverRadius: 5,
          pointHoverBackgroundColor: '#ef4444',
          tension: 0.5,
          fill: true,
        }],
      },
      options: chartOptions({ plugins: { legend: { display: false }, tooltip: { callbacks: { label: ctx => ` ${ctx.parsed.y} BPM` } } } }),
    })
  }

  // ─── Weekly Resting HR ────────────────────────────────────────────────────
  if (hrvChart.value) {
    const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So']
    const labels = weeklyHR.value.map(r => days[new Date(String(r.day).slice(0,10) + 'T00:00:00').getUTCDay()] || String(r.day).slice(0,10))
    if (hrvChartInst) { hrvChartInst.destroy(); hrvChartInst = null }
    hrvChartInst = new Chart(hrvChart.value.getContext('2d'), {
      type: 'bar',
      data: {
        labels,
        datasets: [
          {
            label: 'Avg BPM',
            data: weeklyHR.value.map(r => parseInt(r.avg_bpm)),
            backgroundColor: '#3b82f6',
            borderRadius: 6,
            barPercentage: 0.5,
            order: 2,
          },
          {
            label: 'Ruhepuls',
            data: weeklyHR.value.map(r => parseInt(r.resting)),
            type: 'line',
            borderColor: '#fca5a5',
            backgroundColor: 'transparent',
            borderWidth: 2,
            pointRadius: 5,
            pointBackgroundColor: '#ffffff',
            pointBorderColor: '#fca5a5',
            pointBorderWidth: 2,
            tension: 0.4,
            yAxisID: 'y1',
            order: 1,
          },
        ],
      },
      options: {
        ...chartOptions(),
        interaction: { mode: 'index', intersect: false },
        plugins: {
          legend: { position: 'bottom', labels: { usePointStyle: true, pointStyle: 'circle', padding: 16, font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
          tooltip: { backgroundColor: '#0f172a', titleFont: { family: 'Inter', weight: '600' }, bodyFont: { family: 'Inter' }, padding: 10, cornerRadius: 10 },
        },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
          y: { grid: { color: '#f1f5f9' }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
          y1: { position: 'right', grid: { display: false }, ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' } },
        },
      },
    })
  }
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

.health-badge {
  display: flex; align-items: center; gap: 0.5rem;
  padding: 0.6rem 1.1rem; border-radius: 12px; font-size: 0.82rem; font-weight: 700;
  background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe;
}
.health-badge svg { stroke: #3b82f6; }

/* Stat Cards */
.stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 1.5rem; }

.health-card {
  background: #fff; border: 1px solid #e2e8f0; border-radius: 16px;
  padding: 1.2rem; position: relative; transition: all 0.2s;
}
.health-card:hover { transform: translateY(-2px); box-shadow: 0 8px 25px -5px rgba(0,0,0,0.08); }

.hc-icon {
  width: 44px; height: 44px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center; margin-bottom: 0.8rem;
}
.hc-icon.pink  { background: #fef2f2; } .hc-icon.pink svg  { stroke: #ef4444; }
.hc-icon.green { background: #ecfdf5; } .hc-icon.green svg { stroke: #10b981; }
.hc-icon.blue  { background: #eff6ff; } .hc-icon.blue svg  { stroke: #3b82f6; }
.hc-icon.gray  { background: #f8fafc; } .hc-icon.gray svg  { stroke: #64748b; }

.hc-trend {
  position: absolute; top: 1.1rem; right: 1.1rem;
  font-size: 0.75rem; font-weight: 700; padding: 0.18rem 0.5rem; border-radius: 20px;
}
.hc-trend.up   { background: #ecfdf5; color: #10b981; }
.hc-trend.down { background: #ecfdf5; color: #10b981; }

.hc-label { font-size: 0.78rem; color: #94a3b8; font-weight: 500; margin-bottom: 0.2rem; }
.hc-value { font-size: 2rem; font-weight: 800; color: #0f172a; letter-spacing: -1px; }
.hc-unit  { font-size: 1rem; font-weight: 600; color: #64748b; }

/* Mid Grid */
.mid-grid { display: grid; grid-template-columns: 1fr 280px; gap: 1.5rem; margin-bottom: 1.5rem; align-items: stretch; }

.panel { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 1.4rem; display: flex; flex-direction: column; }
.panel-title-plain { font-size: 1rem; font-weight: 700; color: #0f172a; margin-bottom: 1rem; flex-shrink: 0; }

.chart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; flex-shrink: 0; }
.chart-header .panel-title-plain { margin-bottom: 0; }
.chart-updated { display: flex; align-items: center; gap: 0.35rem; font-size: 0.75rem; color: #94a3b8; }
.chart-updated svg { stroke: #94a3b8; }

.chart-panel { flex: 1; }
.chart-box { flex: 1; min-height: 200px; position: relative; width: 100%; }
.chart-box.tall { min-height: 240px; }
.chart-box canvas { width: 100% !important; height: 100% !important; }

/* Zones */
.zones-panel { }
.zones-list { display: flex; flex-direction: column; gap: 0.6rem; }
.zone-item { display: flex; align-items: center; gap: 0.7rem; padding: 0.6rem 0; border-bottom: 1px solid #f8fafc; }
.zone-item:last-child { border-bottom: none; }

.zone-bar { width: 10px; height: 36px; border-radius: 4px; flex-shrink: 0; }
.zone-info { flex: 1; }
.zone-name { font-size: 0.88rem; font-weight: 700; color: #0f172a; }
.zone-sub  { font-size: 0.72rem; color: #94a3b8; }
.zone-range { font-size: 0.75rem; font-weight: 600; color: #64748b; white-space: nowrap; }

/* Wide Panel */
.wide-panel { margin-bottom: 1.5rem; }

/* Insights */
.insights-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }

.insight-card {
  background: #fff; border: 1px solid #e2e8f0; border-radius: 16px;
  padding: 1.3rem; display: flex; align-items: flex-start; gap: 1rem;
}

.insight-icon {
  width: 44px; height: 44px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.insight-icon.green-icon { background: #dcfce7; } .insight-icon.green-icon svg { stroke: #16a34a; }
.insight-icon.gray-icon  { background: #f1f5f9; } .insight-icon.gray-icon svg  { stroke: #64748b; }

.insight-title { font-size: 0.95rem; font-weight: 700; color: #0f172a; margin-bottom: 0.35rem; }
.insight-text  { font-size: 0.82rem; color: #64748b; line-height: 1.55; }
.highlight-blue { color: #3b82f6; font-weight: 600; }

/* Responsive */
@media (max-width: 1200px) {
  .stat-grid   { grid-template-columns: repeat(2, 1fr); }
  .mid-grid    { grid-template-columns: 1fr; }
  .insights-grid { grid-template-columns: 1fr; }
}
</style>
