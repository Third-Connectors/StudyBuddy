"use client";
import { useState } from "react";
import { motion } from "framer-motion";
import { Search, TrendingUp, TrendingDown, Flame } from "lucide-react";

const STUDENTS = [
  { id: 1, name: "Rina Putri", grade: "12 IPA 1", score: 92, streak: 14, quiz: 28, trend: "up", active: "Hari ini" },
  { id: 2, name: "Ahmad Fauzi", grade: "12 IPA 1", score: 88, streak: 7, quiz: 24, trend: "up", active: "Hari ini" },
  { id: 3, name: "Siti Aisyah", grade: "12 IPA 2", score: 85, streak: 21, quiz: 32, trend: "up", active: "Kemarin" },
  { id: 4, name: "Budi Santoso", grade: "12 IPA 1", score: 79, streak: 3, quiz: 18, trend: "down", active: "Kemarin" },
  { id: 5, name: "Dewi Lestari", grade: "12 IPA 2", score: 76, streak: 5, quiz: 22, trend: "up", active: "2 hari lalu" },
  { id: 6, name: "Rizki Pratama", grade: "12 IPA 1", score: 72, streak: 0, quiz: 15, trend: "down", active: "3 hari lalu" },
  { id: 7, name: "Anisa Rahma", grade: "12 IPA 2", score: 68, streak: 2, quiz: 20, trend: "down", active: "Hari ini" },
  { id: 8, name: "Maya Sari", grade: "12 IPA 2", score: 91, streak: 10, quiz: 30, trend: "up", active: "Hari ini" },
];

const COLORS = ["var(--primary)", "var(--secondary)", "#3B82F6", "#8B5CF6", "#EC4899", "#10B981", "#F59E0B", "#6366F1"];

export default function StudentsPage() {
  const [search, setSearch] = useState("");
  const [sortBy, setSortBy] = useState<"score"|"name"|"streak">("score");

  const filtered = STUDENTS.filter(s => s.name.toLowerCase().includes(search.toLowerCase()))
    .sort((a, b) => sortBy === "score" ? b.score - a.score : sortBy === "streak" ? b.streak - a.streak : a.name.localeCompare(b.name));

  const avg = Math.round(STUDENTS.reduce((s, x) => s + x.score, 0) / STUDENTS.length);
  const activeToday = STUDENTS.filter(s => s.active === "Hari ini").length;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-extrabold text-[var(--foreground)]">Daftar Siswa</h1>
        <p className="text-sm text-[var(--text-secondary)] font-medium mt-1">Pantau perkembangan dan aktivitas belajar siswa Anda.</p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        {[["Total Siswa", STUDENTS.length, "var(--foreground)"], ["Rata-rata Skor", avg + "%", "var(--foreground)"], ["Aktif Hari Ini", activeToday, "var(--primary)"]].map(([label, val, color], i) => (
          <div key={i} className="bg-[var(--surface)] rounded-2xl p-5 border border-[var(--divider)]" style={{boxShadow: "0 1px 8px var(--card-shadow)"}}>
            <p className="text-xs font-bold text-[var(--text-light)] uppercase tracking-wider mb-1">{label as string}</p>
            <p className="text-3xl font-extrabold" style={{color: color as string}}>{String(val)}</p>
          </div>
        ))}
      </div>

      <div className="bg-[var(--surface)] rounded-2xl p-5 border border-[var(--divider)] flex flex-col sm:flex-row gap-4" style={{boxShadow: "0 1px 8px var(--card-shadow)"}}>
        <div className="relative flex-1">
          <Search size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-[var(--text-light)]" />
          <input value={search} onChange={e => setSearch(e.target.value)} placeholder="Cari nama siswa..." className="w-full pl-11 pr-4 py-2.5 bg-[var(--background)] border border-[var(--divider)] rounded-xl text-sm font-medium outline-none focus:border-[var(--primary)] transition-colors" />
        </div>
        <div className="flex gap-2">
          {([["score","Skor"],["streak","Streak"],["name","Nama"]] as const).map(([k,l]) => (
            <button key={k} onClick={() => setSortBy(k)} className={`px-4 py-2 rounded-xl text-xs font-bold transition-all border ${sortBy === k ? "bg-[var(--primary)] text-white border-[var(--primary)]" : "bg-[var(--background)] text-[var(--text-secondary)] border-[var(--divider)]"}`}>{l}</button>
          ))}
        </div>
      </div>

      <div className="space-y-3">
        {filtered.map((s, i) => (
          <motion.div key={s.id} initial={{opacity:0,y:10}} animate={{opacity:1,y:0}} transition={{delay:i*0.03}} className="bg-[var(--surface)] rounded-2xl p-5 border border-[var(--divider)] hover:border-[var(--primary-light)] transition-colors" style={{boxShadow: "0 1px 8px var(--card-shadow)"}}>
            <div className="flex items-center gap-4">
              <div className="w-11 h-11 rounded-xl flex items-center justify-center text-white font-extrabold text-sm shrink-0" style={{background: COLORS[i % COLORS.length]}}>{s.name.split(" ").map(n=>n[0]).join("").slice(0,2)}</div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  <p className="text-sm font-bold text-[var(--foreground)] truncate">{s.name}</p>
                  {s.streak >= 7 && <div className="flex items-center gap-0.5 px-1.5 py-0.5 bg-[var(--primary-lighter)] rounded-md"><Flame size={10} className="text-[var(--primary)]" /><span className="text-[10px] font-bold text-[var(--primary)]">{s.streak}</span></div>}
                </div>
                <p className="text-xs font-medium text-[var(--text-light)]">{s.grade} • {s.active}</p>
              </div>
              <div className="hidden sm:flex items-center gap-6">
                <div className="text-center"><p className="text-xs font-medium text-[var(--text-light)]">Quiz</p><p className="text-sm font-extrabold">{s.quiz}</p></div>
                <div className="text-center"><p className="text-xs font-medium text-[var(--text-light)]">Streak</p><p className="text-sm font-extrabold">{s.streak}</p></div>
              </div>
              <div className={`w-14 h-14 rounded-xl flex flex-col items-center justify-center ${s.score >= 85 ? "bg-green-50" : s.score >= 70 ? "bg-yellow-50" : "bg-red-50"}`}>
                <p className={`text-lg font-extrabold leading-none ${s.score >= 85 ? "text-green-600" : s.score >= 70 ? "text-yellow-600" : "text-red-500"}`}>{s.score}</p>
                <p className="text-[8px] font-bold text-[var(--text-light)] uppercase mt-0.5">Skor</p>
              </div>
              {s.trend === "up" ? <TrendingUp size={16} className="text-green-500" /> : <TrendingDown size={16} className="text-red-400" />}
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
