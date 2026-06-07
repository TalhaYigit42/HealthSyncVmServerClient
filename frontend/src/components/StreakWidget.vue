<template>
  <div class="streak-widget">
    <div class="streak-header">
      <div class="streak-fire">🔥</div>
      <div>
        <div class="streak-title">{{ streak }} Tage Streak!</div>
        <div class="streak-sub">{{ streakSub }}</div>
      </div>
    </div>
    <div class="streak-days">
      <div v-for="d in displayDays" :key="d.label" :class="['day-circle', { active: d.active }]">
        {{ d.label }}
      </div>
    </div>
    <div class="streak-bonus">{{ bonusText }}</div>
    <div class="streak-total">{{ totalActiveDays }} aktive Tage gesamt</div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const streak = ref(0)
const totalActiveDays = ref(0)
const last7 = ref([])

const DAY_LABELS = ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa']

const displayDays = computed(() =>
  last7.value.map(d => ({
    label: DAY_LABELS[new Date(d.date + 'T12:00:00Z').getUTCDay()],
    active: d.active
  }))
)

const streakSub = computed(() => {
  if (streak.value === 0) return 'Fang noch heute an!'
  if (streak.value < 3) return 'Guter Start!'
  if (streak.value < 7) return 'Weiter so!'
  return 'Unglaublich, mach weiter!'
})

const bonusText = computed(() => {
  const next = streak.value < 7 ? 7 : streak.value < 14 ? 14 : streak.value < 30 ? 30 : streak.value + 7
  return `+50 XP Bonus bei ${next} Tagen!`
})

onMounted(async () => {
  try {
    const token = localStorage.getItem('hs_token')
    const res = await fetch('/api/health/streak', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (res.ok) {
      const data = await res.json()
      streak.value = data.streak || 0
      totalActiveDays.value = data.total_active_days || 0
      last7.value = data.last7 || []
    }
  } catch {}
})
</script>

<style scoped>
.streak-widget {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.3rem;
}

.streak-header {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  margin-bottom: 1rem;
}

.streak-fire {
  width: 44px;
  height: 44px;
  background: #fef2f2;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.3rem;
}

.streak-title {
  font-size: 1rem;
  font-weight: 700;
  color: #0f172a;
}

.streak-sub {
  font-size: 0.78rem;
  color: #94a3b8;
  font-weight: 500;
}

.streak-days {
  display: flex;
  gap: 0.4rem;
  justify-content: center;
  margin-bottom: 0.9rem;
  flex-wrap: wrap;
}

.day-circle {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.78rem;
  font-weight: 700;
  background: #f1f5f9;
  color: #94a3b8;
  transition: all 0.3s;
}

.day-circle.active {
  background: linear-gradient(135deg, #f59e0b, #fbbf24);
  color: #ffffff;
  box-shadow: 0 2px 8px rgba(245, 158, 11, 0.3);
}

.streak-bonus {
  text-align: center;
  font-size: 0.75rem;
  color: #94a3b8;
  font-weight: 500;
  margin-bottom: 0.25rem;
}

.streak-total {
  text-align: center;
  font-size: 0.72rem;
  color: #b0bec5;
  font-weight: 500;
}
</style>
