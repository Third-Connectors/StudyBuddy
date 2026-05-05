"use client";
import { useState } from "react";
import { motion } from "framer-motion";
import { TrendingUp, AlertTriangle, CheckCircle2, Award, ArrowUpRight, BarChart3, Users } from "lucide-react";

const TOPICS = [
  { id: 1, name: "Turunan Aljabar", successRate: 78, category: "Matematika", difficulty: "Medium" },
  { id: 2, name: "Logaritma Dasar", successRate: 92, category: "Matematika", difficulty: "Easy" },
  { id: 3, name: "Hukum Newton II", successRate: 65, category: "Fisika", difficulty: "Medium" },
  { id: 4, name: "Struktur Sel Tumbuhan", successRate: 88, category: "Biologi", difficulty: "Easy" },
  { id: 5, name: "Ejaan Sesuai PUEBI", successRate: 95, category: "B. Indonesia", difficulty: "Easy" },
  { id: 6, name: "Trigonometri Lanjutan", successRate: 42, category: "Matematika", difficulty: "Hard" },
  { id: 7, name: "Teori Kinetik Gas", successRate: 51, category: "Fisika", difficulty: "Hard" },
  { id: 8, name: "Ikatan Ion & Kovalen", successRate: 71, category: "Kimia", difficulty: "Medium" },
];

const PERFORMANCE_HEATMAP = Array.from({ length: 20 }, (_, i) => ({
  id: i + 1,
  score: Math.floor(Math.random() * 45) + (i % 3 === 0 ? 30 : 55),
}));

export default function AnalyticsPage() {
  const [selectedTopic, setSelectedTopic] = useState<any>(null);

  return (
    <div className="space-y-6">
      {/* ── Title ── */}
      <div>
        <h1 className="text-2xl font-extrabold text-[var(--foreground)]">Analytics & Performance</h1>
        <p className="text-sm text-[var(--text-secondary)] font-medium mt-1">
          Analisis mendalam terhadap tingkat pemahaman siswa untuk setiap materi.
        </p>
      </div>

      {/* ── Summary Stat Cards ── */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-[var(--surface)] p-5 rounded-2xl border border-[var(--divider)] flex items-center justify-between" style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}>
          <div>
            <p className="text-xs font-bold text-[var(--text-light)] uppercase tracking-wider mb-1">Rata-rata Akurasi</p>
            <p className="text-3xl font-extrabold text-[var(--foreground)]">76%</p>
          </div>
          <div className="w-12 h-12 rounded-xl bg-green-50 flex items-center justify-center text-green-500">
            <TrendingUp size={20} />
          </div>
        </div>
        <div className="bg-[var(--surface)] p-5 rounded-2xl border border-[var(--divider)] flex items-center justify-between" style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}>
          <div>
            <p className="text-xs font-bold text-[var(--text-light)] uppercase tracking-wider mb-1">Topik Dikuasai</p>
            <p className="text-3xl font-extrabold text-[var(--foreground)]">5/8</p>
          </div>
          <div className="w-12 h-12 rounded-xl bg-[var(--primary-lighter)] flex items-center justify-center text-[var(--primary)]">
            <Award size={20} />
          </div>
        </div>
        <div className="bg-[var(--surface)] p-5 rounded-2xl border border-[var(--divider)] flex items-center justify-between" style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}>
          <div>
            <p className="text-xs font-bold text-[var(--text-light)] uppercase tracking-wider mb-1">Perlu Review</p>
            <p className="text-3xl font-extrabold text-red-500">3</p>
          </div>
          <div className="w-12 h-12 rounded-xl bg-red-50 flex items-center justify-center text-red-500">
            <AlertTriangle size={20} />
          </div>
        </div>
      </div>

      {/* ── Main Content Grid ── */}
      <div className="grid grid-cols-1 xl:grid-cols-12 gap-6">
        {/* ── Left Column: Heatmap ── */}
        <div className="xl:col-span-7 bg-[var(--surface)] p-6 rounded-2xl border border-[var(--divider)]" style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}>
          <div className="flex justify-between items-center mb-6">
            <div>
              <h3 className="font-bold text-[var(--foreground)]">Student Success Heatmap</h3>
              <p className="text-xs text-[var(--text-secondary)] font-medium">Visualisasi tingkat keberhasilan siswa pada setiap soal.</p>
            </div>
            <div className="flex items-center gap-4 text-xs font-bold text-[var(--text-secondary)]">
              <span className="flex items-center gap-1"><span className="w-2.5 h-2.5 bg-red-500 rounded" /> &lt; 60%</span>
              <span className="flex items-center gap-1"><span className="w-2.5 h-2.5 bg-yellow-500 rounded" /> 60-80%</span>
              <span className="flex items-center gap-1"><span className="w-2.5 h-2.5 bg-green-500 rounded" /> &gt; 80%</span>
            </div>
          </div>

          <div className="grid grid-cols-5 sm:grid-cols-10 gap-2 mb-6">
            {PERFORMANCE_HEATMAP.map((data) => {
              let bg = "bg-green-500";
              if (data.score < 60) bg = "bg-red-500";
              else if (data.score < 80) bg = "bg-yellow-500";

              return (
                <div
                  key={data.id}
                  onClick={() => setSelectedTopic(data)}
                  className={`aspect-square rounded-xl ${bg} opacity-85 hover:opacity-100 transition-all cursor-pointer flex items-center justify-center text-white font-extrabold text-sm shadow-sm hover:scale-105 select-none`}
                >
                  {data.id}
                </div>
              );
            })}
          </div>

          <div className="p-4 bg-[var(--background)] border border-[var(--divider)]/50 rounded-xl flex items-start gap-3">
            <BarChart3 size={16} className="text-[var(--primary)] shrink-0 mt-0.5" />
            <p className="text-xs font-medium text-[var(--text-secondary)] leading-relaxed">
              <strong>Info:</strong> Klik pada salah satu nomor soal di atas untuk melihat detail keberhasilan siswa serta tingkat kesulitan soal tersebut.
            </p>
          </div>
        </div>

        {/* ── Right Column: Insights & Topics ── */}
        <div className="xl:col-span-5 space-y-4">
          <div className="bg-[var(--surface)] p-6 rounded-2xl border border-[var(--divider)]" style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}>
            <h3 className="font-bold text-[var(--foreground)] mb-4">Materi dengan Akurasi Terendah</h3>
            <div className="space-y-3">
              {TOPICS.filter(t => t.successRate < 70).map((topic, i) => (
                <div key={i} className="p-4 rounded-xl border border-red-100 bg-red-50/40 flex items-center gap-4">
                  <div className="w-10 h-10 rounded-xl bg-red-50 flex items-center justify-center text-red-500">
                    <AlertTriangle size={18} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <h4 className="text-sm font-bold text-[var(--foreground)] truncate">{topic.name}</h4>
                    <p className="text-xs font-medium text-[var(--text-light)]">{topic.category} • {topic.difficulty}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-lg font-extrabold text-red-500">{topic.successRate}%</p>
                    <p className="text-[8px] font-bold text-[var(--text-light)] uppercase">Akurasi</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div className="bg-[var(--surface)] p-6 rounded-2xl border border-[var(--divider)]" style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}>
            <h3 className="font-bold text-[var(--foreground)] mb-4">Materi yang Telah Dikuasai</h3>
            <div className="space-y-3">
              {TOPICS.filter(t => t.successRate >= 85).map((topic, i) => (
                <div key={i} className="p-4 rounded-xl border border-green-100 bg-green-50/40 flex items-center gap-4">
                  <div className="w-10 h-10 rounded-xl bg-green-50 flex items-center justify-center text-green-500">
                    <CheckCircle2 size={18} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <h4 className="text-sm font-bold text-[var(--foreground)] truncate">{topic.name}</h4>
                    <p className="text-xs font-medium text-[var(--text-light)]">{topic.category} • {topic.difficulty}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-lg font-extrabold text-green-600">{topic.successRate}%</p>
                    <p className="text-[8px] font-bold text-[var(--text-light)] uppercase">Akurasi</p>
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
