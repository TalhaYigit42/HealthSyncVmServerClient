<template>
  <div class="weekly-overview">
    <h3 class="weekly-title">Weekly Overview</h3>
    <div class="weekly-stats">
      <div class="weekly-stat">
        <div class="weekly-icon sleep">🌙</div>
        <div class="weekly-value">{{ totalSleep }}</div>
        <div class="weekly-label">Total Sleep</div>
      </div>
      <div class="weekly-stat">
        <div class="weekly-icon steps">👣</div>
        <div class="weekly-value">{{ totalSteps }}</div>
        <div class="weekly-label">Total Steps</div>
      </div>
      <div class="weekly-stat">
        <div class="weekly-icon heart">❤️</div>
        <div class="weekly-value">{{ avgBpm }}</div>
        <div class="weekly-label">Avg BPM</div>
      </div>
    </div>
    <div class="chart-container">
      <canvas ref="chartCanvas" height="180"></canvas>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import {
  Chart,
  BarController,
  BarElement,
  LineController,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale,
  Tooltip,
  Legend,
  Filler
} from 'chart.js'

Chart.register(
  BarController, BarElement,
  LineController, LineElement, PointElement,
  CategoryScale, LinearScale,
  Tooltip, Legend, Filler
)

const chartCanvas = ref(null)
const weeklyData = ref([])
const sleepData = ref([])

const totalSteps = computed(() => {
  const sum = weeklyData.value.reduce((a, d) => a + (d.steps || 0), 0)
  if (sum === 0) return '—'
  return sum >= 1000 ? (sum / 1000).toFixed(0) + 'K' : sum
})

const totalSleep = computed(() => {
  const map = new Map()
  sleepData.value.forEach(s => {
    const dt = new Date(s.start_time)
    const key = dt.getUTCHours() < 12
      ? new Date(dt.getTime() - 86400000).toISOString().slice(0, 10)
      : dt.toISOString().slice(0, 10)
    map.set(key, (map.get(key) || 0) + (s.total_sleep_minutes || 0))
  })
  const sum = [...map.values()].reduce((a, v) => a + v, 0)
  if (sum === 0) return '—'
  return (sum / 60).toFixed(1) + 'h'
})

const avgBpm = computed(() => {
  const bpms = weeklyData.value.filter(d => d.avg_bpm).map(d => d.avg_bpm)
  if (!bpms.length) return '—'
  return Math.round(bpms.reduce((a, b) => a + b, 0) / bpms.length)
})

let chartInstance = null

async function loadData() {
  try {
    const token = localStorage.getItem('hs_token')
    const headers = { Authorization: `Bearer ${token}` }
    const [weeklyRes, sleepRes] = await Promise.all([
      fetch('/api/health/weekly', { headers }),
      fetch('/api/health/sleep', { headers }),
    ])
    if (weeklyRes.ok) weeklyData.value = await weeklyRes.json()
    if (sleepRes.ok) sleepData.value = await sleepRes.json()
  } catch {}
}

function buildChart() {
  if (!chartCanvas.value) return
  if (chartInstance) { chartInstance.destroy(); chartInstance = null }

  const days = weeklyData.value
  const dayLabels = days.map(d => {
    const date = new Date(d.day + 'T00:00:00')
    return ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'][date.getUTCDay()]
  })

  const stepsKData = days.map(d => d.steps ? +(d.steps / 1000).toFixed(1) : null)
  const bpmData = days.map(d => d.avg_bpm || null)

  // Build sleep hours per day using night boundary (wake-up day)
  const sleepByWakeDay = {}
  sleepData.value.forEach(s => {
    if (!s.start_time) return
    const dt = new Date(s.start_time)
    const nightKey = dt.getUTCHours() < 12
      ? new Date(dt.getTime() - 86400000).toISOString().slice(0, 10)
      : dt.toISOString().slice(0, 10)
    const wakeDate = new Date(nightKey + 'T12:00:00Z')
    wakeDate.setUTCDate(wakeDate.getUTCDate() + 1)
    const wakeDay = wakeDate.toISOString().slice(0, 10)
    sleepByWakeDay[wakeDay] = (sleepByWakeDay[wakeDay] || 0) + (s.total_sleep_minutes || 0)
  })
  const sleepHData = days.map(d => {
    const mins = sleepByWakeDay[d.day]
    return mins ? +(mins / 60).toFixed(1) : null
  })

  const ctx = chartCanvas.value.getContext('2d')
  chartInstance = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: dayLabels,
      datasets: [
        {
          label: 'Sleep (h)',
          data: sleepHData,
          backgroundColor: 'rgba(59, 130, 246, 0.7)',
          borderRadius: 6,
          borderSkipped: false,
          barPercentage: 0.5,
          order: 2,
        },
        {
          label: 'Steps (k)',
          data: stepsKData,
          backgroundColor: 'rgba(16, 185, 129, 0.7)',
          borderRadius: 6,
          borderSkipped: false,
          barPercentage: 0.5,
          order: 3,
        },
        {
          label: 'Heart Rate',
          data: bpmData,
          type: 'line',
          borderColor: '#ef4444',
          backgroundColor: 'rgba(239, 68, 68, 0.05)',
          borderWidth: 2,
          pointRadius: 4,
          pointBackgroundColor: '#ef4444',
          pointBorderColor: '#ffffff',
          pointBorderWidth: 2,
          tension: 0.4,
          fill: true,
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
        legend: {
          display: true,
          position: 'bottom',
          labels: {
            usePointStyle: true,
            pointStyle: 'circle',
            padding: 16,
            font: { size: 11, family: 'Inter', weight: '500' },
            color: '#94a3b8',
          },
        },
        tooltip: {
          backgroundColor: '#0f172a',
          titleFont: { family: 'Inter', weight: '600' },
          bodyFont: { family: 'Inter' },
          padding: 10,
          cornerRadius: 10,
          displayColors: true,
        },
      },
      scales: {
        x: {
          grid: { display: false },
          ticks: { font: { size: 11, family: 'Inter', weight: '500' }, color: '#94a3b8' },
        },
        y: {
          position: 'left',
          grid: { color: '#f1f5f9' },
          ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' },
        },
        y1: {
          position: 'right',
          grid: { display: false },
          ticks: { font: { size: 11, family: 'Inter' }, color: '#94a3b8' },
        },
      },
    },
  })
}

onMounted(async () => {
  await loadData()
  await nextTick()
  buildChart()
})
</script>

<style scoped>
.weekly-overview {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.4rem;
}

.weekly-title {
  font-size: 1.05rem;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 1rem;
}

.weekly-stats {
  display: flex;
  gap: 1rem;
  margin-bottom: 1.2rem;
}

.weekly-stat {
  flex: 1;
  text-align: center;
  padding: 0.8rem 0.5rem;
  border-radius: 12px;
}

.weekly-stat:nth-child(1) { background: #eff6ff; }
.weekly-stat:nth-child(2) { background: #ecfdf5; }
.weekly-stat:nth-child(3) { background: #fef2f2; }

.weekly-icon {
  font-size: 1.3rem;
  margin-bottom: 0.3rem;
}

.weekly-value {
  font-size: 1.4rem;
  font-weight: 800;
  color: #0f172a;
}

.weekly-label {
  font-size: 0.72rem;
  color: #94a3b8;
  font-weight: 500;
}

.chart-container {
  height: 220px;
  position: relative;
}

.chart-container canvas {
  width: 100% !important;
}
</style>
