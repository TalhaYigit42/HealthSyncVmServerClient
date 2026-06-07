<template>
  <div :class="['stat-card', variant]">
    <div class="stat-header">
      <div :class="['stat-icon-wrap', variant]">
        <span class="stat-icon">{{ icon }}</span>
      </div>
      <div class="stat-trend" v-if="trend">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/></svg>
        <span>{{ trend }}</span>
      </div>
    </div>
    <div class="stat-label">{{ label }}</div>
    <div class="stat-value" :style="{ color: valueColor }">{{ value }}</div>
    <div class="stat-sub">{{ subtitle }}</div>

    <!-- Mini line chart -->
    <div class="stat-mini-chart" v-if="chartData.length > 0 && chartType === 'line'">
      <svg :viewBox="'0 0 ' + svgWidth + ' ' + svgHeight" class="mini-svg">
        <defs>
          <linearGradient :id="'fill-' + variant" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" :stop-color="valueColor" stop-opacity="0.2"/>
            <stop offset="100%" :stop-color="valueColor" stop-opacity="0"/>
          </linearGradient>
        </defs>
        <path :d="areaPath" :fill="'url(#fill-' + variant + ')'" />
        <path :d="linePath" fill="none" :stroke="valueColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
      </svg>
    </div>

    <!-- Mini bar chart -->
    <div class="stat-mini-bars" v-if="chartData.length > 0 && chartType === 'bar'">
      <div
        v-for="(val, i) in chartData"
        :key="i"
        class="mini-bar"
        :style="{
          height: barHeight(val) + '%',
          background: valueColor,
          opacity: i === chartData.length - 1 ? 1 : 0.5,
          animationDelay: (i * 80) + 'ms'
        }"
      ></div>
    </div>

    <!-- XP Progress bar -->
    <div class="stat-xp-bar" v-if="chartType === 'progress'">
      <div class="xp-bar-track">
        <div class="xp-bar-fill" :style="{ width: Math.min(100, xpGoal > 0 ? xpCurrent / xpGoal * 100 : 0) + '%', background: valueColor }"></div>
      </div>
      <div class="xp-bar-labels">
        <span>{{ xpCurrent }} XP</span>
        <span>{{ xpGoal }} XP</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  label: String,
  value: String,
  subtitle: String,
  trend: String,
  icon: String,
  variant: { type: String, default: 'sleep' },
  chartData: { type: Array, default: () => [] },
  chartType: { type: String, default: 'line' }, // 'line', 'bar', 'progress'
  xpCurrent: { type: Number, default: 0 },
  xpGoal:    { type: Number, default: 500 },
})

const svgWidth = 140
const svgHeight = 40

const valueColor = computed(() => {
  const colors = {
    sleep: '#3b82f6',
    heart: '#ef4444',
    steps: '#10b981',
    xp: '#f59e0b',
  }
  return colors[props.variant] || '#3b82f6'
})

const points = computed(() => {
  if (!props.chartData.length) return []
  const data = props.chartData
  const max = Math.max(...data)
  const min = Math.min(...data)
  const range = max - min || 1
  return data.map((val, i) => ({
    x: (i / (data.length - 1)) * svgWidth,
    y: svgHeight - ((val - min) / range) * (svgHeight - 6) - 3,
  }))
})

const linePath = computed(() => {
  if (!points.value.length) return ''
  return points.value.map((p, i) => `${i === 0 ? 'M' : 'L'}${p.x},${p.y}`).join(' ')
})

const areaPath = computed(() => {
  if (!points.value.length) return ''
  const line = linePath.value
  return `${line} L${svgWidth},${svgHeight} L0,${svgHeight} Z`
})

function barHeight(val) {
  const max = Math.max(...props.chartData)
  if (!max) return 0
  return (val / max) * 100
}
</script>

<style scoped>
.stat-card {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.2rem;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px -5px rgba(0, 0, 0, 0.1);
}

.stat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.6rem;
}

.stat-icon-wrap {
  width: 40px;
  height: 40px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.15rem;
}

.stat-icon-wrap.sleep { background: #eff6ff; }
.stat-icon-wrap.heart { background: #fef2f2; }
.stat-icon-wrap.steps { background: #ecfdf5; }
.stat-icon-wrap.xp    { background: #fffbeb; }

.stat-trend {
  display: flex;
  align-items: center;
  gap: 0.2rem;
  font-size: 0.75rem;
  font-weight: 600;
  color: #10b981;
  background: #ecfdf5;
  padding: 0.2rem 0.5rem;
  border-radius: 20px;
}

.stat-trend svg { stroke: #10b981; }

.stat-label {
  font-size: 0.78rem;
  color: #94a3b8;
  font-weight: 500;
  margin-bottom: 0.15rem;
}

.stat-value {
  font-size: 1.6rem;
  font-weight: 800;
  letter-spacing: -0.5px;
  margin-bottom: 0.1rem;
}

.stat-sub {
  font-size: 0.72rem;
  color: #94a3b8;
  font-weight: 500;
}

/* Mini Line Chart (SVG) */
.stat-mini-chart {
  margin-top: 0.6rem;
  height: 40px;
}

.mini-svg {
  width: 100%;
  height: 100%;
}

/* Mini Bar Chart */
.stat-mini-bars {
  display: flex;
  align-items: flex-end;
  gap: 3px;
  height: 40px;
  margin-top: 0.6rem;
}

.mini-bar {
  flex: 1;
  border-radius: 3px 3px 0 0;
  min-height: 4px;
  animation: barGrow 0.6s ease forwards;
}

@keyframes barGrow {
  from { transform: scaleY(0); transform-origin: bottom; }
  to   { transform: scaleY(1); transform-origin: bottom; }
}

/* XP Progress Bar */
.stat-xp-bar {
  margin-top: 0.6rem;
}

.xp-bar-track {
  height: 8px;
  background: #e2e8f0;
  border-radius: 4px;
  overflow: hidden;
}

.xp-bar-fill {
  height: 100%;
  border-radius: 4px;
  transition: width 1.5s ease;
}

.xp-bar-labels {
  display: flex;
  justify-content: space-between;
  margin-top: 0.3rem;
  font-size: 0.68rem;
  color: #94a3b8;
  font-weight: 500;
}
</style>
