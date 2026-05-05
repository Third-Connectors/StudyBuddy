"use client";
import { motion } from "framer-motion";
import {
  BookOpen,
  Users,
  TrendingUp,
  Sparkles,
  ArrowUpRight,
  Clock,
  CheckCircle2,
  AlertTriangle,
  FileText,
  ChevronRight,
} from "lucide-react";
import Link from "next/link";

/* ── Mock data ── */
const STATS = [
  {
    label: "Total Soal",
    value: "128",
    change: "+12 minggu ini",
    icon: BookOpen,
    color: "var(--primary)",
    bg: "var(--primary-lighter)",
  },
  {
    label: "Total Siswa",
    value: "47",
    change: "+3 baru",
    icon: Users,
    color: "var(--secondary)",
    bg: "#D6F0DF",
  },
  {
    label: "Rata-rata Skor",
    value: "76%",
    change: "+4% vs bulan lalu",
    icon: TrendingUp,
    color: "#3B82F6",
    bg: "#EFF6FF",
  },
  {
    label: "Soal AI Generated",
    value: "34",
    change: "26% dari total",
    icon: Sparkles,
    color: "#8B5CF6",
    bg: "#F5F3FF",
  },
];

const RECENT_ACTIVITY = [
  {
    icon: CheckCircle2,
    color: "#16A34A",
    text: "Rina Putri menyelesaikan quiz Turunan",
    time: "5 menit lalu",
  },
  {
    icon: FileText,
    color: "var(--primary)",
    text: "Anda menambahkan 3 soal Logaritma baru",
    time: "1 jam lalu",
  },
  {
    icon: AlertTriangle,
    color: "#EAB308",
    text: "5 siswa gagal di soal Hukum Newton #3",
    time: "2 jam lalu",
  },
  {
    icon: CheckCircle2,
    color: "#16A34A",
    text: "Ahmad Fauzi menjawab 8/10 benar di Biologi",
    time: "3 jam lalu",
  },
  {
    icon: Sparkles,
    color: "#8B5CF6",
    text: "AI Generator membuat 5 soal Trigonometri",
    time: "Kemarin",
  },
];

const WEAK_TOPICS = [
  { topic: "Turunan Berantai", accuracy: 42, subject: "Matematika" },
  { topic: "Hukum Newton III", accuracy: 51, subject: "Fisika" },
  { topic: "Struktur Sel", accuracy: 58, subject: "Biologi" },
];

const TOP_STUDENTS = [
  { name: "Rina Putri", score: 92, streak: 14 },
  { name: "Ahmad Fauzi", score: 88, streak: 7 },
  { name: "Siti Aisyah", score: 85, streak: 21 },
];

const container = {
  hidden: {},
  visible: { transition: { staggerChildren: 0.06 } },
};
const item = {
  hidden: { opacity: 0, y: 16 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.4, ease: "easeOut" as const } },
};

export default function DashboardPage() {
  return (
    <div className="space-y-8">
      {/* ── Page Title ── */}
      <div>
        <h1 className="text-2xl font-extrabold text-[var(--foreground)]">
          Overview
        </h1>
        <p className="text-sm text-[var(--text-secondary)] font-medium mt-1">
          Selamat datang kembali! Berikut ringkasan aktivitas kelas Anda.
        </p>
      </div>

      {/* ── Stat Cards ── */}
      <motion.div
        variants={container}
        initial="hidden"
        animate="visible"
        className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4"
      >
        {STATS.map((stat, i) => (
          <motion.div
            key={i}
            variants={item}
            className="bg-[var(--surface)] rounded-2xl p-5 border border-[var(--divider)] hover:border-[var(--primary-light)] transition-colors duration-300 group"
            style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
          >
            <div className="flex items-start justify-between mb-4">
              <div
                className="w-10 h-10 rounded-xl flex items-center justify-center transition-transform duration-300 group-hover:scale-105"
                style={{ background: stat.bg, color: stat.color }}
              >
                <stat.icon size={18} />
              </div>
              <ArrowUpRight
                size={14}
                className="text-[var(--text-light)] group-hover:text-[var(--primary)] transition-colors"
              />
            </div>
            <p className="text-2xl font-extrabold text-[var(--foreground)]">
              {stat.value}
            </p>
            <p className="text-xs font-bold text-[var(--text-secondary)] mt-0.5">
              {stat.label}
            </p>
            <p className="text-[11px] font-medium text-[var(--text-light)] mt-2">
              {stat.change}
            </p>
          </motion.div>
        ))}
      </motion.div>

      {/* ── Main Content Grid ── */}
      <div className="grid grid-cols-1 xl:grid-cols-12 gap-6">
        {/* ── Left: Performance Summary + Weak Topics ── */}
        <div className="xl:col-span-8 space-y-6">
          {/* AI Insight Card */}
          <motion.div
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3 }}
            className="bg-[var(--secondary)] rounded-2xl p-6 text-white relative overflow-hidden"
          >
            <div className="relative z-10 flex items-start gap-4">
              <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center shrink-0">
                <Sparkles size={18} className="text-[var(--primary)]" />
              </div>
              <div>
                <h3 className="font-bold text-base mb-1">Insight AI</h3>
                <p className="text-white/60 text-sm font-medium leading-relaxed">
                  Siswa paling banyak kesulitan di soal <strong className="text-white/90">Turunan Berantai</strong> dan <strong className="text-white/90">Hukum Newton III</strong>. 
                  Pertimbangkan untuk membuat materi review atau latihan tambahan di topik ini.
                </p>
              </div>
            </div>
            <div className="absolute -right-10 -bottom-10 w-40 h-40 bg-[var(--primary)]/15 rounded-full blur-3xl" />
          </motion.div>

          {/* Weak Topics */}
          <div
            className="bg-[var(--surface)] rounded-2xl p-6 border border-[var(--divider)]"
            style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
          >
            <div className="flex items-center justify-between mb-5">
              <h3 className="font-bold text-[var(--foreground)]">
                Topik Perlu Perhatian
              </h3>
              <Link
                href="/dashboard/analytics"
                className="text-xs font-bold text-[var(--primary)] hover:underline flex items-center gap-1"
              >
                Lihat Semua <ChevronRight size={12} />
              </Link>
            </div>
            <div className="space-y-3">
              {WEAK_TOPICS.map((topic, i) => (
                <div
                  key={i}
                  className="flex items-center gap-4 p-4 rounded-xl bg-[var(--background)] border border-[var(--divider)]/50"
                >
                  <div className="w-10 h-10 rounded-xl bg-red-50 flex items-center justify-center">
                    <AlertTriangle size={16} className="text-red-500" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-bold text-[var(--foreground)] truncate">
                      {topic.topic}
                    </p>
                    <p className="text-xs font-medium text-[var(--text-light)]">
                      {topic.subject}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-lg font-extrabold text-red-500">
                      {topic.accuracy}%
                    </p>
                    <p className="text-[10px] font-bold text-[var(--text-light)] uppercase">
                      Akurasi
                    </p>
                  </div>
                  {/* Mini progress bar */}
                  <div className="w-20 h-2 bg-red-100 rounded-full overflow-hidden">
                    <div
                      className="h-full bg-red-400 rounded-full"
                      style={{ width: `${topic.accuracy}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Top Students */}
          <div
            className="bg-[var(--surface)] rounded-2xl p-6 border border-[var(--divider)]"
            style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
          >
            <div className="flex items-center justify-between mb-5">
              <h3 className="font-bold text-[var(--foreground)]">
                Siswa Terbaik Minggu Ini
              </h3>
              <Link
                href="/dashboard/students"
                className="text-xs font-bold text-[var(--primary)] hover:underline flex items-center gap-1"
              >
                Semua Siswa <ChevronRight size={12} />
              </Link>
            </div>
            <div className="space-y-3">
              {TOP_STUDENTS.map((s, i) => (
                <div
                  key={i}
                  className="flex items-center gap-4 p-4 rounded-xl bg-[var(--background)] border border-[var(--divider)]/50"
                >
                  <div
                    className="w-10 h-10 rounded-xl flex items-center justify-center text-white font-extrabold text-sm"
                    style={{
                      background:
                        i === 0
                          ? "var(--primary)"
                          : i === 1
                            ? "var(--secondary)"
                            : "#3B82F6",
                    }}
                  >
                    #{i + 1}
                  </div>
                  <div className="flex-1">
                    <p className="text-sm font-bold text-[var(--foreground)]">
                      {s.name}
                    </p>
                    <p className="text-xs font-medium text-[var(--text-light)]">
                      🔥 Streak {s.streak} hari
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-lg font-extrabold text-[var(--foreground)]">
                      {s.score}%
                    </p>
                    <p className="text-[10px] font-bold text-[var(--text-light)] uppercase">
                      Skor
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* ── Right: Activity Feed + Quick Actions ── */}
        <div className="xl:col-span-4 space-y-6">
          {/* Quick Actions */}
          <div
            className="bg-[var(--surface)] rounded-2xl p-6 border border-[var(--divider)]"
            style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
          >
            <h3 className="font-bold text-[var(--foreground)] mb-4">
              Aksi Cepat
            </h3>
            <div className="space-y-2">
              <Link
                href="/dashboard/generator"
                className="flex items-center gap-3 p-3.5 rounded-xl bg-[var(--primary-lighter)] border border-[var(--primary-light)] text-[var(--primary)] hover:bg-[var(--primary-light)] transition-colors group"
              >
                <Sparkles size={16} />
                <span className="font-bold text-sm">Generate Soal AI</span>
                <ChevronRight
                  size={14}
                  className="ml-auto opacity-0 group-hover:opacity-100 transition-opacity"
                />
              </Link>
              <Link
                href="/dashboard/bank-soal"
                className="flex items-center gap-3 p-3.5 rounded-xl bg-[var(--background)] border border-[var(--divider)] text-[var(--foreground)] hover:border-[var(--primary-light)] transition-colors group"
              >
                <BookOpen size={16} className="text-[var(--text-secondary)]" />
                <span className="font-bold text-sm">Kelola Bank Soal</span>
                <ChevronRight
                  size={14}
                  className="ml-auto opacity-0 group-hover:opacity-100 transition-opacity text-[var(--text-light)]"
                />
              </Link>
              <Link
                href="/dashboard/students"
                className="flex items-center gap-3 p-3.5 rounded-xl bg-[var(--background)] border border-[var(--divider)] text-[var(--foreground)] hover:border-[var(--primary-light)] transition-colors group"
              >
                <Users size={16} className="text-[var(--text-secondary)]" />
                <span className="font-bold text-sm">Lihat Siswa</span>
                <ChevronRight
                  size={14}
                  className="ml-auto opacity-0 group-hover:opacity-100 transition-opacity text-[var(--text-light)]"
                />
              </Link>
            </div>
          </div>

          {/* Recent Activity */}
          <div
            className="bg-[var(--surface)] rounded-2xl p-6 border border-[var(--divider)]"
            style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
          >
            <h3 className="font-bold text-[var(--foreground)] mb-4">
              Aktivitas Terbaru
            </h3>
            <div className="space-y-1">
              {RECENT_ACTIVITY.map((act, i) => (
                <div
                  key={i}
                  className="flex gap-3 p-3 rounded-xl hover:bg-[var(--background)] transition-colors"
                >
                  <div
                    className="w-8 h-8 rounded-lg flex items-center justify-center shrink-0"
                    style={{
                      background: `color-mix(in srgb, ${act.color} 12%, transparent)`,
                      color: act.color,
                    }}
                  >
                    <act.icon size={14} />
                  </div>
                  <div className="min-w-0">
                    <p className="text-[13px] font-medium text-[var(--foreground)] leading-snug">
                      {act.text}
                    </p>
                    <div className="flex items-center gap-1 mt-1">
                      <Clock size={10} className="text-[var(--text-light)]" />
                      <p className="text-[11px] font-medium text-[var(--text-light)]">
                        {act.time}
                      </p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
