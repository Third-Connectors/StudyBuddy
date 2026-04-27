# 🌌 Study Buddy Web Ecosystem Architecture

Designed by **Antigravity (Creative Full-Stack Architect)**. 

This architecture balances high-fidelity creative frontend with a high-utility B2B portal using Next.js 14, Tailwind CSS, and Framer Motion.

## 📁 Directory Structure

```text
landing-page/
├── app/
│   ├── (public)/              # Landing Page Routes (SEO optimized)
│   │   ├── page.tsx           # Home / Hero
│   │   ├── playground/        # AI Interactive Demo
│   │   └── layout.tsx         # Navbar & Footer
│   ├── (protected)/           # Teacher Portal (B2B)
│   │   ├── dashboard/         # Main Overview
│   │   ├── bank-soal/         # Question Management
│   │   └── layout.tsx         # Sidebar & Auth Protection
│   ├── globals.css            # Custom Design System Tokens
│   └── layout.tsx             # Root Provider & Fonts
├── components/
│   ├── ui/                    # Generic Premium UI (Buttons, Cards, Inputs)
│   ├── landing/               # Specific Creative Components
│   │   ├── HeroFluid.tsx      # Fluid Distortion Header
│   │   ├── AiChatDemo.tsx     # Socratic Tutor Playground
│   │   └── SdgSection.tsx     # Animated SDG Impact
│   └── dashboard/             # B2B Specific Components
│       ├── Sidebar.tsx        # Navigation
│       ├── AiGenForm.tsx      # AI Question Generator
│       └── AnalyticsGrid.tsx  # Heatmaps & Stats
├── lib/
│   ├── supabase.ts            # Shared Client for Data
│   └── animations.ts          # Framer Motion Variants
└── public/
    └── mockups/               # App Screenshots & 3D Assets
```

## 🎨 Design System

### Typography
- **Headlines:** `Space Grotesk` (Bold, Modern, Tech)
- **Body:** `Inter` (Readable, Clean)

### Color Palette
- **Primary:** `#F97316` (Study Buddy Orange)
- **Secondary:** `#FFF6E5` (Cream Background)
- **Accent:** `#0F172A` (Deep Navy for contrast)
- **Glass:** `rgba(255, 255, 255, 0.6)` with backdrop-blur

## 🎭 Animation Strategy
1. **Hero:** Fluid liquid distortion using SVG filters + Framer Motion `animate` property on path data.
2. **Scrolling:** Scroll-triggered entry animations (fade-up, slide-in) with `viewport` observer.
3. **Dashboard:** Snappy transitions, micro-interactions on hover (scale 1.02), and skeleton loaders for AI processing states.
