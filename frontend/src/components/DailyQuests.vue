<template>
  <div class="quests-section">
    <div class="quests-header">
      <div class="quests-title">
        <span class="quests-icon">🎯</span>
        <h3>Daily Quests</h3>
      </div>
      <span class="quests-count">{{ completedCount }}/{{ quests.length }} completed</span>
    </div>
    <div class="quests-list">
      <div
        v-for="quest in quests"
        :key="quest.name"
        :class="['quest-item', { completed: quest.completed }]"
      >
        <div :class="['quest-icon-wrap', quest.type]">
          <span v-if="quest.completed" class="quest-check">✓</span>
          <span v-else class="quest-emoji">{{ quest.icon }}</span>
        </div>
        <div class="quest-content">
          <div class="quest-top">
            <span :class="['quest-name', { done: quest.completed }]">{{ quest.name }}</span>
            <span class="quest-xp">⚡ +{{ quest.xp }} XP</span>
          </div>
          <div class="quest-bar-row">
            <div class="quest-bar">
              <div
                :class="['quest-fill', quest.type]"
                :style="{ width: Math.min(100, quest.current / quest.goal * 100) + '%' }"
              ></div>
            </div>
            <span class="quest-progress">{{ quest.progressText }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const summary = ref(null)
const activities = ref([])

const STEPS_GOAL = 10000
const SLEEP_GOAL = 420   // 7h in minutes
const WORKOUT_GOAL = 1

const quests = computed(() => {
  const steps = summary.value?.steps ?? 0
  const sleepMins = summary.value?.sleep?.total_sleep_minutes ?? 0
  const workoutCount = activities.value.filter(a => {
    const d = new Date(a.start_time)
    const today = new Date().toISOString().slice(0, 10)
    return d.toISOString().slice(0, 10) === today
  }).length

  const sleepH = +(sleepMins / 60).toFixed(1)
  const sleepGoalH = +(SLEEP_GOAL / 60).toFixed(1)

  return [
    {
      name: `Schlafe ${sleepGoalH} Stunden`,
      icon: '🌙',
      type: 'sleep',
      xp: 50,
      current: sleepH,
      goal: sleepGoalH,
      progressText: `${sleepH}/${sleepGoalH} h`,
      completed: sleepMins >= SLEEP_GOAL,
    },
    {
      name: `${STEPS_GOAL.toLocaleString('de-AT')} Schritte gehen`,
      icon: '👣',
      type: 'steps',
      xp: 75,
      current: steps,
      goal: STEPS_GOAL,
      progressText: `${(steps / 1000).toFixed(1)}k/${(STEPS_GOAL / 1000).toFixed(0)}k Schritte`,
      completed: steps >= STEPS_GOAL,
    },
    {
      name: 'Workout abschließen',
      icon: '🏋️',
      type: 'workout',
      xp: 100,
      current: workoutCount,
      goal: WORKOUT_GOAL,
      progressText: `${workoutCount}/${WORKOUT_GOAL} Session`,
      completed: workoutCount >= WORKOUT_GOAL,
    },
  ]
})

const completedCount = computed(() => quests.value.filter(q => q.completed).length)

onMounted(async () => {
  try {
    const token = localStorage.getItem('hs_token')
    const headers = { Authorization: `Bearer ${token}` }
    const [sumRes, actRes] = await Promise.all([
      fetch('/api/health/summary', { headers }),
      fetch('/api/health/activities', { headers }),
    ])
    if (sumRes.ok) summary.value = await sumRes.json()
    if (actRes.ok) activities.value = await actRes.json()
  } catch {}
})
</script>

<style scoped>
.quests-section {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.4rem;
}

.quests-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.quests-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.quests-title h3 {
  font-size: 1.05rem;
  font-weight: 700;
  color: #0f172a;
}

.quests-icon { font-size: 1.1rem; }

.quests-count {
  font-size: 0.8rem;
  color: #94a3b8;
  font-weight: 500;
}

.quests-list {
  display: flex;
  flex-direction: column;
  gap: 0.7rem;
}

.quest-item {
  display: flex;
  align-items: center;
  gap: 0.9rem;
  padding: 0.9rem 1rem;
  background: #f8fafc;
  border: 1px solid #f1f5f9;
  border-radius: 14px;
  transition: all 0.2s;
}

.quest-item:hover {
  border-color: #e2e8f0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.quest-item.completed {
  background: #f0fdf4;
  border-color: #bbf7d0;
}

.quest-icon-wrap {
  width: 40px;
  height: 40px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1rem;
  flex-shrink: 0;
}

.quest-icon-wrap.sleep { background: #eff6ff; }
.quest-icon-wrap.steps { background: #ecfdf5; }
.quest-icon-wrap.heart { background: #fef2f2; }
.quest-icon-wrap.workout { background: #ecfdf5; }

.quest-check {
  color: #10b981;
  font-weight: 700;
  font-size: 1.1rem;
}

.quest-content {
  flex: 1;
  min-width: 0;
}

.quest-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.4rem;
}

.quest-name {
  font-size: 0.88rem;
  font-weight: 600;
  color: #0f172a;
}

.quest-name.done {
  text-decoration: line-through;
  color: #94a3b8;
}

.quest-xp {
  font-size: 0.75rem;
  font-weight: 700;
  color: #10b981;
  background: #ecfdf5;
  padding: 0.15rem 0.5rem;
  border-radius: 20px;
  white-space: nowrap;
}

.quest-bar-row {
  display: flex;
  align-items: center;
  gap: 0.6rem;
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

.quest-fill.sleep  { background: linear-gradient(90deg, #3b82f6, #60a5fa); }
.quest-fill.steps  { background: linear-gradient(90deg, #3b82f6, #60a5fa); }
.quest-fill.heart  { background: linear-gradient(90deg, #3b82f6, #60a5fa); }
.quest-fill.workout { background: linear-gradient(90deg, #10b981, #34d399); }

.quest-progress {
  font-size: 0.72rem;
  color: #94a3b8;
  font-weight: 500;
  white-space: nowrap;
}
</style>
