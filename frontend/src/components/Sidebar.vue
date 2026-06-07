<template>
  <aside class="sidebar">
    <div class="sidebar-logo">
      <div class="logo-circle">
        <svg width="24" height="24" viewBox="0 0 32 32" fill="none">
          <circle cx="16" cy="16" r="14" fill="url(#sideGrad)" />
          <path d="M10 16 L14 20 L22 12" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
          <defs><linearGradient id="sideGrad" x1="0" y1="0" x2="32" y2="32"><stop stop-color="#3b82f6"/><stop offset="1" stop-color="#60a5fa"/></linearGradient></defs>
        </svg>
      </div>
      <div>
        <div class="logo-name">HealthSync</div>
        <div class="logo-sub">Gamified Wellness</div>
      </div>
    </div>

    <div class="user-profile">
      <div class="avatar">{{ userInitial }}</div>
      <div class="user-info">
        <div class="user-name">{{ username }}</div>
        <div class="user-title">{{ userTitle }}</div>
      </div>
    </div>

    <div class="level-section">
      <div class="level-row">
        <span class="level-label">Level {{ level }}</span>
        <span class="level-xp">{{ xpInLevel }}/500 XP</span>
      </div>
      <div class="level-bar">
        <div class="level-fill" :style="{ width: xpPct + '%' }"></div>
      </div>
    </div>

    <div class="streak-row">
      <div class="streak-item">
        <span class="streak-icon">🔥</span>
        <div>
          <div class="streak-label">Streak</div>
          <div class="streak-value">{{ streak }} Tage</div>
        </div>
      </div>
      <div class="streak-item">
        <div>
          <div class="streak-label">Heute</div>
          <div class="streak-value xp-value">+{{ xpToday }} XP</div>
        </div>
      </div>
    </div>

    <nav class="sidebar-nav">
      <router-link
        v-for="item in navItems"
        :key="item.name"
        :to="item.to"
        :class="['nav-item', { active: activeNav === item.name }]"
      >
        <span class="nav-icon" v-html="item.icon"></span>
        <span>{{ item.name }}</span>
        <span v-if="activeNav === item.name" class="nav-dot"></span>
      </router-link>
    </nav>

    <button class="logout-btn" @click="handleLogout">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
      <span>Abmelden</span>
    </button>
  </aside>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const props = defineProps({
  username: { type: String, default: 'User' },
  activeNav: { type: String, default: 'Dashboard' },
})

const router = useRouter()
const streak = ref(0)
const totalActiveDays = ref(0)
const stepsToday = ref(0)

const userInitial = computed(() => props.username.charAt(0).toUpperCase())

const xpTotal = computed(() => totalActiveDays.value * 100)
const level = computed(() => Math.floor(xpTotal.value / 500) + 1)
const xpInLevel = computed(() => xpTotal.value % 500)
const xpPct = computed(() => Math.round((xpInLevel.value / 500) * 100))
const xpToday = computed(() => Math.floor(stepsToday.value / 100))

const userTitle = computed(() => {
  const l = level.value
  if (l >= 20) return 'Champion'
  if (l >= 10) return 'Pro Athlete'
  if (l >= 5) return 'Fitness Fan'
  if (l >= 2) return 'Aktiver Nutzer'
  return 'Einsteiger'
})

onMounted(async () => {
  try {
    const token = localStorage.getItem('hs_token')
    const headers = { Authorization: `Bearer ${token}` }
    const [streakRes, sumRes] = await Promise.all([
      fetch('/api/health/streak', { headers }),
      fetch('/api/health/summary', { headers }),
    ])
    if (streakRes.ok) {
      const d = await streakRes.json()
      streak.value = d.streak || 0
      totalActiveDays.value = d.total_active_days || 0
    }
    if (sumRes.ok) {
      const d = await sumRes.json()
      stepsToday.value = d.steps || 0
    }
  } catch {}
})

const navItems = [
  { name: 'Dashboard',    to: '/dashboard',    icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>' },
  { name: 'Sleep',        to: '/sleep',        icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>' },
  { name: 'Health',       to: '/health',       icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.42 4.58a5.4 5.4 0 0 0-7.65 0l-.77.78-.77-.78a5.4 5.4 0 0 0-7.65 7.65l.78.77L12 20.65l7.65-7.65.77-.77a5.4 5.4 0 0 0 0-7.65z"/></svg>' },
  { name: 'Activity',     to: '/activity',     icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>' },
  { name: 'Achievements', to: '/achievements', icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="7"/><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/></svg>' },
  { name: 'Import',      to: '/import',       icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>' },
  { name: 'Settings',     to: '/settings',     icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>' },
]

function handleLogout() {
  localStorage.removeItem('hs_token')
  localStorage.removeItem('hs_user')
  router.push('/login')
}
</script>

<style scoped>
.sidebar {
  width: var(--sidebar-width, 260px);
  height: 100vh;
  background: #ffffff;
  border-right: 1px solid var(--border, #e2e8f0);
  display: flex;
  flex-direction: column;
  padding: 1.5rem 1rem;
  position: fixed;
  left: 0;
  top: 0;
  overflow-y: auto;
  z-index: 100;
}

.sidebar-logo {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  padding: 0 0.5rem;
  margin-bottom: 1.5rem;
}

.logo-circle {
  width: 40px;
  height: 40px;
  border-radius: 12px;
  background: linear-gradient(135deg, #eff6ff, #dbeafe);
  display: flex;
  align-items: center;
  justify-content: center;
}

.logo-name { font-size: 1.15rem; font-weight: 800; color: #0f172a; letter-spacing: -0.3px; }
.logo-sub  { font-size: 0.72rem; color: #94a3b8; font-weight: 500; }

.user-profile {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  padding: 0.8rem;
  background: #f8fafc;
  border-radius: 14px;
  margin-bottom: 0.8rem;
}

.avatar {
  width: 40px;
  height: 40px;
  border-radius: 12px;
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 1rem;
}

.user-name  { font-weight: 700; font-size: 0.9rem; color: #0f172a; }
.user-title { font-size: 0.75rem; color: #3b82f6; font-weight: 600; }

.level-section { padding: 0 0.5rem; margin-bottom: 0.8rem; }

.level-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.35rem;
}

.level-label { font-size: 0.78rem; font-weight: 700; color: #0f172a; }
.level-xp   { font-size: 0.72rem; color: #94a3b8; font-weight: 500; }

.level-bar { height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden; }
.level-fill {
  height: 100%;
  background: linear-gradient(90deg, #3b82f6, #60a5fa);
  border-radius: 3px;
  transition: width 1s ease;
}

.streak-row {
  display: flex;
  justify-content: space-between;
  padding: 0.6rem 0.5rem;
  margin-bottom: 0.8rem;
}

.streak-item { display: flex; align-items: center; gap: 0.4rem; }
.streak-icon { font-size: 1.1rem; }
.streak-label { font-size: 0.72rem; color: #94a3b8; font-weight: 500; }
.streak-value { font-size: 0.85rem; font-weight: 700; color: #0f172a; }
.xp-value { color: #10b981; }

.sidebar-nav {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.7rem 0.8rem;
  border-radius: 12px;
  color: #64748b;
  font-size: 0.9rem;
  font-weight: 500;
  transition: all 0.2s;
  position: relative;
  text-decoration: none;
}

.nav-item:hover { background: #f1f5f9; color: #0f172a; }

.nav-item.active {
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  color: #ffffff;
  font-weight: 600;
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

.nav-item.active :deep(svg) { stroke: #ffffff; }

.nav-icon { display: flex; align-items: center; justify-content: center; width: 22px; height: 22px; }

.nav-dot {
  width: 8px;
  height: 8px;
  background: #60a5fa;
  border-radius: 50%;
  margin-left: auto;
  border: 2px solid #ffffff;
}

.logout-btn {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  padding: 0.7rem 0.8rem;
  border: none;
  background: none;
  color: #94a3b8;
  font-size: 0.88rem;
  font-weight: 500;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s;
  margin-top: 0.5rem;
}

.logout-btn:hover { background: #fef2f2; color: #ef4444; }
.logout-btn:hover svg { stroke: #ef4444; }
</style>
