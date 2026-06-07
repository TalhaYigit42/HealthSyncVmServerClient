<template>
  <div class="dashboard-layout">
    <Sidebar :username="username" active-nav="Achievements" />
    <main class="dashboard-main">

      <!-- Header -->
      <div class="dash-header">
        <div>
          <h1 class="page-title">
            <span class="page-icon">🏆</span> Achievements
          </h1>
          <p class="page-sub">Track your progress and unlock rewards.</p>
        </div>
      </div>

      <!-- Level Progress Card -->
      <div class="level-card">
        <div class="lc-left">
          <div class="lc-avatar">
            <span class="lc-level-num">{{ level }}</span>
            <div class="lc-badge">⚡</div>
          </div>
          <div class="lc-info">
            <div class="lc-name">{{ userTitle }}</div>
            <div class="lc-sub">Level {{ level }}</div>
          </div>
        </div>
        <div class="lc-center">
          <div class="lc-progress-label">
            <span>Progress to Level {{ level + 1 }}</span>
            <span class="lc-xp-text">{{ xpInLevel }} / 500 XP</span>
          </div>
          <div class="lc-bar">
            <div class="lc-bar-fill" :style="{ width: xpPct + '%' }"></div>
          </div>
          <div class="lc-until">{{ xpToNextLevel }} XP bis nächstes Level</div>
        </div>
        <div class="lc-right">
          <div class="lc-total-xp">
            <span class="lc-bolt">⚡</span>
            <span class="lc-total-val">{{ xpTotal.toLocaleString('de-AT') }}</span>
          </div>
          <div class="lc-total-label">Total XP Earned</div>
        </div>
      </div>

      <!-- Daily + Weekly Quests -->
      <div class="quests-grid">
        <!-- Daily Quests -->
        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title"><span>⏰</span> Daily Quests</h3>
            <span class="quest-count">{{ dailyCompletedCount }}/{{ dailyQuests.length }} completed</span>
          </div>
          <div class="quest-list">
            <div v-for="q in dailyQuests" :key="q.name" class="quest-row">
              <div class="qr-top">
                <span class="qr-name">{{ q.name }}</span>
                <span class="quest-xp">⚡ +{{ q.xp }} XP</span>
              </div>
              <div class="qr-bar-row">
                <div class="qr-bar">
                  <div class="qr-fill blue" :style="{ width: q.pct + '%' }"></div>
                </div>
                <span class="qr-pct">{{ q.pct }}%</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Weekly Quests -->
        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title"><span>🔥</span> Weekly Quests</h3>
            <span class="bonus-badge">Bonus XP!</span>
          </div>
          <div class="quest-list">
            <div v-for="q in weeklyQuests" :key="q.name" class="quest-row">
              <div class="qr-top">
                <span class="qr-name">{{ q.name }}</span>
                <span class="quest-xp gold">⚡ +{{ q.xp }} XP</span>
              </div>
              <div class="qr-bar-row">
                <div class="qr-bar">
                  <div class="qr-fill orange" :style="{ width: (q.current / q.goal * 100) + '%' }"></div>
                </div>
                <span class="qr-pct">{{ q.progressText }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Achievements Grid -->
      <div class="panel achievements-panel">
        <div class="panel-header">
          <h3 class="panel-title"><span>🏅</span> Achievements</h3>
          <span class="quest-count">{{ achievementsUnlocked }}/{{ achievements.length }} freigeschaltet</span>
        </div>
        <div class="achievements-grid">
          <div v-for="a in achievements" :key="a.name" :class="['ach-card', { locked: !a.unlocked && !a.progress }]">
            <div class="ach-header">
              <div :class="['ach-icon', a.rarity]">{{ a.icon }}</div>
              <span :class="['ach-rarity', a.rarity]">{{ a.rarityLabel }}</span>
            </div>
            <div class="ach-name">{{ a.name }}</div>
            <div class="ach-desc">{{ a.desc }}</div>
            <div v-if="a.unlocked" class="ach-check">✓</div>
            <div v-else-if="a.progress" class="ach-progress">
              <div class="ach-progress-bar">
                <div class="ach-progress-fill" :style="{ width: (a.current / a.goal * 100) + '%', background: a.rarity === 'epic' ? '#f59e0b' : '#f59e0b' }"></div>
              </div>
              <span class="ach-progress-text">{{ a.progressText }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Level Roadmap -->
      <div class="panel roadmap-panel">
        <h3 class="panel-title"><span>👑</span> Level Roadmap</h3>
        <div class="roadmap">
          <div v-for="(lvl, i) in roadmap" :key="lvl.level" class="roadmap-item">
            <div :class="['rm-circle', { active: lvl.active, reached: lvl.reached }]">
              <span>Lv.{{ lvl.level }}</span>
            </div>
            <div :class="['rm-label', { active: lvl.active }]">{{ lvl.title }}</div>
            <div v-if="i < roadmap.length - 1" :class="['rm-line', { filled: lvl.reached }]"></div>
          </div>
        </div>
      </div>

    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'

const username = computed(() => {
  try { return JSON.parse(localStorage.getItem('hs_user') || '{}').first_name || 'User' }
  catch { return 'User' }
})

const summary = ref(null)
const streakData = ref({ streak: 0, total_active_days: 0 })
const activities = ref([])
const weeklySteps = ref([])
const sleepSessions = ref([])

const totalActiveDays = computed(() => streakData.value.total_active_days || 0)
const xpTotal = computed(() => totalActiveDays.value * 100)
const level = computed(() => Math.floor(xpTotal.value / 500) + 1)
const xpInLevel = computed(() => xpTotal.value % 500)
const xpPct = computed(() => Math.round((xpInLevel.value / 500) * 100))
const xpToNextLevel = computed(() => 500 - xpInLevel.value)

const userTitle = computed(() => {
  const l = level.value
  if (l >= 20) return 'Champion'
  if (l >= 10) return 'Pro Athlete'
  if (l >= 5) return 'Fitness Fan'
  if (l >= 2) return 'Aktiver Nutzer'
  return 'Einsteiger'
})

const mostRecentDay = computed(() => {
  if (activities.value.length) return String(activities.value[0].start_time).slice(0, 10)
  return null
})

const STEPS_GOAL = 10000
const SLEEP_GOAL = 420

const dailyQuests = computed(() => {
  const steps = summary.value?.steps ?? 0
  const sleepMins = summary.value?.sleep?.total_sleep_minutes ?? 0
  const workouts = mostRecentDay.value
    ? activities.value.filter(a => String(a.start_time).slice(0, 10) === mostRecentDay.value).length
    : 0
  const sleepH = +(sleepMins / 60).toFixed(1)
  const goalH = +(SLEEP_GOAL / 60).toFixed(1)
  return [
    { name: goalH + ' Stunden schlafen', xp: 50, pct: Math.min(100, Math.round(sleepH / goalH * 100)) },
    { name: STEPS_GOAL.toLocaleString('de-AT') + ' Schritte', xp: 75, pct: Math.min(100, Math.round(steps / STEPS_GOAL * 100)) },
    { name: 'Workout abschließen', xp: 100, pct: workouts >= 1 ? 100 : 0 },
  ]
})

const dailyCompletedCount = computed(() => dailyQuests.value.filter(q => q.pct >= 100).length)

const totalWeeklySteps = computed(() => weeklySteps.value.reduce((s, d) => s + (parseInt(d.steps) || 0), 0))
const totalWeeklySleepMins = computed(() => {
  const map = new Map()
  sleepSessions.value.forEach(s => {
    const d = new Date(s.start_time)
    const key = d.getUTCHours() < 12
      ? new Date(d.getTime() - 86400000).toISOString().slice(0, 10)
      : d.toISOString().slice(0, 10)
    map.set(key, (map.get(key) || 0) + (s.total_sleep_minutes || 0))
  })
  return [...map.values()].slice(0, 7).reduce((s, v) => s + v, 0)
})

const weeklyQuests = computed(() => [
  { name: '49 Stunden schlafen diese Woche', xp: 200, current: +(totalWeeklySleepMins.value / 60).toFixed(1), goal: 49, progressText: (totalWeeklySleepMins.value / 60).toFixed(1) + '/49h' },
  { name: '70.000 Schritte diese Woche', xp: 300, current: totalWeeklySteps.value, goal: 70000, progressText: (totalWeeklySteps.value / 1000).toFixed(1) + 'k/70k' },
  { name: '3 Workouts abschließen', xp: 250,
    current: (() => {
      const weekStart = weeklySteps.value.length ? weeklySteps.value[0].day : null
      return weekStart ? activities.value.filter(a => String(a.start_time).slice(0, 10) >= weekStart).length : activities.value.length
    })(),
    get progressText() { return this.current + '/3' },
    goal: 3 },
])

const achievements = computed(() => {
  const maxDailySteps = weeklySteps.value.length ? Math.max(...weeklySteps.value.map(d => parseInt(d.steps) || 0)) : 0
  const streak = streakData.value.streak || 0
  const actDays = totalActiveDays.value
  return [
    { name: 'Erstes Workout', icon: '🏋️', desc: 'Schließe dein erstes Workout ab', unlocked: activities.value.length > 0, rarity: 'common', rarityLabel: 'Common', progress: activities.value.length === 0, current: activities.value.length, goal: 1, progressText: activities.value.length + '/1' },
    { name: '10k Schritte', icon: '👣', desc: '10.000 Schritte an einem Tag', unlocked: maxDailySteps >= 10000, rarity: 'common', rarityLabel: 'Common', progress: maxDailySteps < 10000, current: maxDailySteps, goal: 10000, progressText: maxDailySteps.toLocaleString('de-AT') + '/10.000' },
    { name: '7-Tage Streak', icon: '🔥', desc: '7 Tage in Folge aktiv sein', unlocked: streak >= 7, rarity: 'rare', rarityLabel: 'Rare', progress: streak < 7, current: streak, goal: 7, progressText: streak + '/7 Tage' },
    { name: '30 aktive Tage', icon: '📅', desc: '30 Tage mit Aktivitätsdaten', unlocked: actDays >= 30, rarity: 'rare', rarityLabel: 'Rare', progress: actDays < 30, current: actDays, goal: 30, progressText: actDays + '/30 Tage' },
    { name: 'Level 5 erreicht', icon: '⭐', desc: 'Erreiche Level 5', unlocked: level.value >= 5, rarity: 'epic', rarityLabel: 'Epic', progress: level.value < 5, current: level.value, goal: 5, progressText: 'Level ' + level.value + '/5' },
    { name: '100 aktive Tage', icon: '🏆', desc: '100 Tage mit Aktivitätsdaten', unlocked: actDays >= 100, rarity: 'legendary', rarityLabel: 'Legendary', progress: actDays < 100, current: actDays, goal: 100, progressText: actDays + '/100 Tage' },
  ]
})

const achievementsUnlocked = computed(() => achievements.value.filter(a => a.unlocked).length)

const roadmap = computed(() => {
  const lv = level.value
  return [
    { level: 1, title: 'Einsteiger', reached: lv >= 1, active: lv < 5 },
    { level: 5, title: 'Fitness Fan', reached: lv >= 5, active: lv >= 5 && lv < 10 },
    { level: 10, title: 'Athlet', reached: lv >= 10, active: lv >= 10 && lv < 20 },
    { level: 20, title: 'Champion', reached: lv >= 20, active: lv >= 20 && lv < 30 },
    { level: 30, title: 'Legende', reached: lv >= 30, active: lv >= 30 },
  ]
})

onMounted(async () => {
  try {
    const token = localStorage.getItem('hs_token')
    const headers = { Authorization: `Bearer ${token}` }
    const [sumRes, streakRes, actRes, stepsRes, sleepRes] = await Promise.all([
      fetch('/api/health/summary', { headers }),
      fetch('/api/health/streak', { headers }),
      fetch('/api/health/activities', { headers }),
      fetch('/api/health/steps', { headers }),
      fetch('/api/health/sleep', { headers }),
    ])
    if (sumRes.ok) summary.value = await sumRes.json()
    if (streakRes.ok) streakData.value = await streakRes.json()
    if (actRes.ok) activities.value = await actRes.json()
    if (stepsRes.ok) weeklySteps.value = await stepsRes.json()
    if (sleepRes.ok) sleepSessions.value = await sleepRes.json()
  } catch {}
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

/* Level Card */
.level-card {
  background: #fff; border: 1px solid #e2e8f0; border-radius: 16px;
  padding: 1.5rem; display: flex; align-items: center; gap: 1.5rem; margin-bottom: 1.5rem;
}

.lc-left { display: flex; align-items: center; gap: 1rem; flex-shrink: 0; }

.lc-avatar {
  width: 60px; height: 60px; border-radius: 16px;
  background: #f59e0b; display: flex; align-items: center; justify-content: center;
  position: relative;
}
.lc-level-num { font-size: 1.5rem; font-weight: 800; color: #fff; }
.lc-badge {
  position: absolute; bottom: -4px; right: -4px;
  width: 22px; height: 22px; border-radius: 50%; background: #3b82f6;
  display: flex; align-items: center; justify-content: center;
  font-size: 0.65rem; border: 2px solid #fff;
}

.lc-name { font-size: 1.1rem; font-weight: 800; color: #0f172a; }
.lc-sub { font-size: 0.78rem; color: #94a3b8; font-weight: 500; }

.lc-center { flex: 1; }
.lc-progress-label { display: flex; justify-content: space-between; margin-bottom: 0.35rem; }
.lc-progress-label span { font-size: 0.78rem; color: #64748b; font-weight: 500; }
.lc-xp-text { font-weight: 600; color: #3b82f6; }
.lc-bar { height: 10px; background: #e2e8f0; border-radius: 5px; overflow: hidden; }
.lc-bar-fill { height: 100%; background: linear-gradient(90deg, #3b82f6, #60a5fa); border-radius: 5px; transition: width 1.5s ease; }
.lc-until { font-size: 0.72rem; color: #94a3b8; margin-top: 0.3rem; }

.lc-right { text-align: right; flex-shrink: 0; }
.lc-total-xp { display: flex; align-items: center; gap: 0.3rem; justify-content: flex-end; }
.lc-bolt { font-size: 1.2rem; }
.lc-total-val { font-size: 1.8rem; font-weight: 800; color: #0f172a; letter-spacing: -1px; }
.lc-total-label { font-size: 0.75rem; color: #94a3b8; font-weight: 500; }

/* Quests Grid */
.quests-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem; }

.panel { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 1.4rem; }
.panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
.panel-title { display: flex; align-items: center; gap: 0.5rem; font-size: 1rem; font-weight: 700; color: #0f172a; margin: 0; }

.quest-count { font-size: 0.78rem; color: #94a3b8; font-weight: 500; }
.bonus-badge {
  font-size: 0.72rem; font-weight: 700; color: #f59e0b;
  background: #fffbeb; border: 1px solid #fde68a; padding: 0.2rem 0.6rem; border-radius: 20px;
}

/* Quest Rows */
.quest-list { display: flex; flex-direction: column; gap: 0.8rem; }
.quest-row { padding: 0.8rem 1rem; background: #f8fafc; border: 1px solid #f1f5f9; border-radius: 14px; }

.qr-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.4rem; }
.qr-name { font-size: 0.88rem; font-weight: 600; color: #0f172a; }
.quest-xp { font-size: 0.72rem; font-weight: 700; color: #3b82f6; background: #eff6ff; padding: 0.15rem 0.5rem; border-radius: 20px; }
.quest-xp.gold { color: #f59e0b; background: #fffbeb; }

.qr-bar-row { display: flex; align-items: center; gap: 0.6rem; }
.qr-bar { flex: 1; height: 8px; background: #e2e8f0; border-radius: 4px; overflow: hidden; }
.qr-fill { height: 100%; border-radius: 4px; transition: width 1s ease; }
.qr-fill.blue { background: linear-gradient(90deg, #3b82f6, #60a5fa); }
.qr-fill.orange { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
.qr-pct { font-size: 0.72rem; color: #94a3b8; font-weight: 600; white-space: nowrap; min-width: 36px; text-align: right; }

/* Achievements Grid */
.achievements-panel { margin-bottom: 1.5rem; }
.achievements-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; }

.ach-card {
  padding: 1.1rem; border-radius: 14px; border: 1px solid #e2e8f0;
  background: #fff; position: relative; transition: all 0.2s;
}
.ach-card:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,0.06); }
.ach-card.locked { opacity: 0.55; }

.ach-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.6rem; }
.ach-icon {
  width: 44px; height: 44px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center; font-size: 1.2rem;
}
.ach-icon.common    { background: #f1f5f9; }
.ach-icon.rare      { background: #eff6ff; }
.ach-icon.epic      { background: #fffbeb; }
.ach-icon.legendary { background: #f8fafc; }

.ach-rarity { font-size: 0.68rem; font-weight: 700; }
.ach-rarity.common    { color: #94a3b8; }
.ach-rarity.rare      { color: #3b82f6; }
.ach-rarity.epic      { color: #a855f7; }
.ach-rarity.legendary { color: #f59e0b; }

.ach-name { font-size: 0.88rem; font-weight: 700; color: #0f172a; margin-bottom: 0.2rem; }
.ach-desc { font-size: 0.72rem; color: #64748b; line-height: 1.45; margin-bottom: 0.5rem; }

.ach-check {
  display: inline-flex; align-items: center; justify-content: center;
  width: 24px; height: 24px; border-radius: 50%;
  background: #dcfce7; color: #10b981; font-weight: 700; font-size: 0.85rem;
}

.ach-progress { }
.ach-progress-bar { height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden; margin-bottom: 0.25rem; }
.ach-progress-fill { height: 100%; border-radius: 3px; transition: width 1s ease; }
.ach-progress-text { font-size: 0.7rem; color: #94a3b8; font-weight: 500; }

/* Level Roadmap */
.roadmap-panel { background: #fffbeb; border-color: #fde68a; margin-bottom: 1.5rem; }

.roadmap { display: flex; align-items: center; justify-content: center; gap: 0; padding: 1rem 0; }

.roadmap-item { display: flex; flex-direction: column; align-items: center; position: relative; }

.rm-circle {
  width: 58px; height: 58px; border-radius: 50%;
  border: 3px solid #e2e8f0; background: #fff;
  display: flex; align-items: center; justify-content: center;
  font-size: 0.78rem; font-weight: 700; color: #94a3b8;
  transition: all 0.3s;
}
.rm-circle.reached { border-color: #f59e0b; color: #0f172a; }
.rm-circle.active {
  border-color: #f59e0b; background: #f59e0b; color: #fff;
  box-shadow: 0 4px 15px rgba(245, 158, 11, 0.35);
  transform: scale(1.1);
}

.rm-label {
  font-size: 0.7rem; color: #94a3b8; font-weight: 500;
  margin-top: 0.4rem; text-align: center; white-space: nowrap;
}
.rm-label.active { color: #0f172a; font-weight: 700; }

.rm-line {
  position: absolute; top: 29px; left: 100%;
  width: 40px; height: 3px; background: #e2e8f0;
  z-index: 0;
}
.rm-line.filled { background: #f59e0b; }

/* Responsive */
@media (max-width: 1200px) {
  .level-card { flex-direction: column; align-items: stretch; }
  .lc-right { text-align: left; }
  .quests-grid { grid-template-columns: 1fr; }
  .achievements-grid { grid-template-columns: repeat(2, 1fr); }
  .roadmap { flex-wrap: wrap; gap: 1rem; }
  .rm-line { display: none; }
}
</style>
