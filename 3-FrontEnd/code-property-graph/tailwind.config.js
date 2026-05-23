/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        graph: {
          class: '#6366f1',
          interface: '#10b981',
          record: '#f59e0b',
          enum: '#ef4444',
          domain: '#8b5cf6',
          application: '#3b82f6',
          infrastructure: '#14b8a6',
          api: '#f97316',
        },
      },
      fontFamily: {
        sans: ['Plus Jakarta Sans', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
    },
  },
  plugins: [],
}
