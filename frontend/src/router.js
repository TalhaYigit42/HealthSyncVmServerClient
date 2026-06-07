import { createRouter, createWebHistory } from 'vue-router'

import LoginView from './views/LoginView.vue'
import ForgotPasswordView from './views/ForgotPasswordView.vue'
import ResetPasswordView from './views/ResetPasswordView.vue'
import RegisterView from './views/RegisterView.vue'
import DashboardView from './views/DashboardView.vue'
import SleepView from './views/SleepView.vue'
import HealthView from './views/HealthView.vue'
import ActivityView from './views/ActivityView.vue'
import AchievementsView from './views/AchievementsView.vue'
import SettingsView from './views/SettingsView.vue'
import ImportView from './views/ImportView.vue'

const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', name: 'Login', component: LoginView, meta: { guest: true } },
  { path: '/forgot-password', name: 'ForgotPassword', component: ForgotPasswordView, meta: { guest: true } },
  { path: '/reset-password', name: 'ResetPassword', component: ResetPasswordView, meta: { guest: true } },
  { path: '/register', name: 'Register', component: RegisterView, meta: { guest: true } },
  { path: '/dashboard', name: 'Dashboard', component: DashboardView, meta: { requiresAuth: true } },
  { path: '/sleep', name: 'Sleep', component: SleepView, meta: { requiresAuth: true } },
  { path: '/health', name: 'Health', component: HealthView, meta: { requiresAuth: true } },
  { path: '/activity', name: 'Activity', component: ActivityView, meta: { requiresAuth: true } },
  { path: '/achievements', name: 'Achievements', component: AchievementsView, meta: { requiresAuth: true } },
  { path: '/settings', name: 'Settings', component: SettingsView, meta: { requiresAuth: true } },
  { path: '/import',   name: 'Import',   component: ImportView,   meta: { requiresAuth: true } },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

// Navigation Guard
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('hs_token')

  if (to.meta.requiresAuth && !token) {
    next('/login')
  } else if (to.meta.guest && token) {
    next('/dashboard')
  } else {
    next()
  }
})

export default router
