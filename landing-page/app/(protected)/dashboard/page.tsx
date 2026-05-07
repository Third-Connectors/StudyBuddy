"use client";
import { useEffect, useState } from "react";
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
import { supabase } from "@/lib/supabase";

/* ── Animation variants ── */
const container = {
  hidden: {},
  visible: { transition: { staggerChildren: 0.06 } },
};
const item = {
  hidden: { opacity: 0, y: 16 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.4, ease: "easeOut" as const } },
};

export default function DashboardPage() {
  const [stats, setStats] = useState([
    { label: "Total Soal", value: "0", change: "Memuat...", icon: BookOpen, color: "var(--primary)", bg: "var(--primary-lighter)" },
    { label: "Total Siswa", value: "0", change: "Memuat...", icon: Users, color: "var(--secondary)", bg: "#D6F0DF" },
    { label: "Rata-rata Skor", value: "0%", change: "Memuat...", icon: TrendingUp, color: "#3B82F6", bg: "#EFF6FF" },
    { label: "XP Terkumpul", value: "0", change: "Seluruh siswa", icon: Sparkles, color: "#8B5CF6", bg: "#F5F3FF" },
  ]);

  const [activities, setActivities] = useState<any[]>([]);
  const [topStudents, setTopStudents] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  async function fetchDashboardData() {
    try {
      setIsLoading(true);

      // 1. Fetch Total Quizzes
      const { count: quizCount } = await supabase.from("quizzes").select("*", { count: "exact", head: true });

      // 2. Fetch Total Students
      const { count: studentCount } = await supabase.from("profiles").select("*", { count: "exact", head: true });

      // 3. Fetch Average Score & Total XP
      const { data: results } = await supabase.from("quiz_results").select("score");
      const avgScore = results && results.length > 0 
        ? Math.round(results.reduce((acc, curr) => acc + curr.score, 0) / results.length)
        : 0;

      const { data: profiles } = await supabase.from("profiles").select("xp, name").order("xp", { ascending: false }).limit(3);
      const totalXp = profiles?.reduce((acc, curr) => acc + (curr.xp || 0), 0) || 0;

      // 4. Fetch Recent Activity
      const { data: recentResults } = await supabase
        .from("quiz_results")
        .select(`
          score,
          created_at,
          profiles (name)
        `)
        .order("created_at", { ascending: false })
        .limit(5);

      setStats([
        { label: "Total Soal", value: String(quizCount || 0), change: "Update otomatis", icon: BookOpen, color: "var(--primary)", bg: "var(--primary-lighter)" },
        { label: "Total Siswa", value: String(studentCount || 0), change: "Siswa aktif", icon: Users, color: "var(--secondary)", bg: "#D6F0DF" },
        { label: "Rata-rata Skor", value: `${avgScore}%`, change: "Berdasarkan kuis terbaru", icon: TrendingUp, color: "#3B82F6", bg: "#EFF6FF" },
        { label: "Total XP Siswa", value: totalXp.toLocaleString(), change: "Akumulasi", icon: Sparkles, color: "#8B5CF6", bg: "#F5F3FF" },
      ]);

      setActivities(recentResults?.map(res => ({
        icon: CheckCircle2,
        color: "#16A34A",
        text: `${(res.profiles as any)?.name || "Siswa"} skor ${res.score}%`,
        time: new Date(res.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
      })) || []);

      setTopStudents(profiles?.map(p => ({
        name: p.name,
        score: p.xp, // Displaying XP as score for now
        streak: 0 // Mock streak as it's not in DB yet
      })) || []);

    } catch (error) {
      console.error("Error fetching dashboard data:", error);
    } finally {
      setIsLoading(false);
    }
  }
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
        {stats.map((stat, i) => (
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
                  Berdasarkan data kuis terbaru, rata-rata akurasi kelas berada di angka <strong className="text-white/90">{stats[2].value}</strong>. 
                  {activities.length > 0 ? ` Aktivitas terbaru menunjukkan ${(activities[0] as any).text} pada sesi terakhir.` : " Belum ada aktivitas kuis yang terekam hari ini."}
                </p>
              </div>
            </div>
            <div className="absolute -right-10 -bottom-10 w-40 h-40 bg-[var(--primary)]/15 rounded-full blur-3xl" />
          </motion.div>

          {/* Weak Topics - MOCKED for now as we need more complex logic for topic analysis */}
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
              {[
                { topic: "Turunan Berantai", accuracy: 42, subject: "Matematika" },
                { topic: "Hukum Newton III", accuracy: 51, subject: "Fisika" },
              ].map((topic, i) => (
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
                Siswa dengan XP Tertinggi
              </h3>
              <Link
                href="/dashboard/students"
                className="text-xs font-bold text-[var(--primary)] hover:underline flex items-center gap-1"
              >
                Semua Siswa <ChevronRight size={12} />
              </Link>
            </div>
            <div className="space-y-3">
              {topStudents.map((s, i) => (
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
                      Level {Math.floor(s.score / 1000) + 1}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-lg font-extrabold text-[var(--foreground)]">
                      {s.score.toLocaleString()}
                    </p>
                    <p className="text-[10px] font-bold text-[var(--text-light)] uppercase">
                      XP
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
              {activities.length > 0 ? activities.map((act, i) => (
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
              )) : (
                <p className="text-xs text-[var(--text-light)] p-4 text-center">Belum ada aktivitas baru</p>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
