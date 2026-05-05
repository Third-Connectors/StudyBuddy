"use client";
import { useState } from "react";
import { motion } from "framer-motion";
import {
  Search,
  Filter,
  Plus,
  BookOpen,
  Trash2,
  Edit3,
  ChevronDown,
  CheckCircle2,
} from "lucide-react";

const MOCK_QUESTIONS = [
  { id: 1, subject: "Matematika", topic: "Turunan", question: "Turunan pertama dari f(x) = 3x² + 5x - 7 adalah...", difficulty: "Medium", accuracy: 78, created: "2 hari lalu" },
  { id: 2, subject: "Matematika", topic: "Logaritma", question: "Jika 2^x = 64, maka nilai x adalah...", difficulty: "Easy", accuracy: 92, created: "3 hari lalu" },
  { id: 3, subject: "Fisika", topic: "Hukum Newton", question: "Sebuah benda bermassa 2kg ditarik gaya 10N. Percepatannya adalah...", difficulty: "Medium", accuracy: 65, created: "5 hari lalu" },
  { id: 4, subject: "Biologi", topic: "Sel", question: "Organel sel yang berfungsi sebagai tempat respirasi sel adalah...", difficulty: "Easy", accuracy: 88, created: "1 minggu lalu" },
  { id: 5, subject: "B. Indonesia", topic: "Ejaan", question: "Penulisan kata baku yang benar adalah...", difficulty: "Easy", accuracy: 95, created: "1 minggu lalu" },
  { id: 6, subject: "Matematika", topic: "Trigonometri", question: "Nilai sin 30° + cos 60° adalah...", difficulty: "Easy", accuracy: 82, created: "2 minggu lalu" },
  { id: 7, subject: "Fisika", topic: "Gelombang", question: "Frekuensi gelombang dengan periode 0.02s adalah...", difficulty: "Hard", accuracy: 45, created: "2 minggu lalu" },
  { id: 8, subject: "Kimia", topic: "Ikatan Kimia", question: "Ikatan yang terjadi antara atom logam dan nonlogam disebut...", difficulty: "Medium", accuracy: 71, created: "3 minggu lalu" },
];

const SUBJECTS = ["Semua", "Matematika", "Fisika", "Biologi", "Kimia", "B. Indonesia"];

function DifficultyBadge({ level }: { level: string }) {
  const styles = {
    Easy: "bg-green-50 text-green-600 border-green-100",
    Medium: "bg-yellow-50 text-yellow-600 border-yellow-100",
    Hard: "bg-red-50 text-red-600 border-red-100",
  }[level] || "bg-gray-50 text-gray-600";

  return (
    <span className={`px-2.5 py-0.5 rounded-lg text-[10px] font-bold uppercase border ${styles}`}>
      {level}
    </span>
  );
}

export default function BankSoalPage() {
  const [searchQuery, setSearchQuery] = useState("");
  const [activeSubject, setActiveSubject] = useState("Semua");

  const filteredQuestions = MOCK_QUESTIONS.filter((q) => {
    const matchSearch =
      q.question.toLowerCase().includes(searchQuery.toLowerCase()) ||
      q.topic.toLowerCase().includes(searchQuery.toLowerCase());
    const matchSubject =
      activeSubject === "Semua" || q.subject === activeSubject;
    return matchSearch && matchSubject;
  });

  return (
    <div className="space-y-6">
      {/* ── Header ── */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-extrabold text-[var(--foreground)]">
            Bank Soal
          </h1>
          <p className="text-sm text-[var(--text-secondary)] font-medium mt-1">
            Kelola semua soal yang Anda buat dan yang di-generate AI.
          </p>
        </div>
        <button className="inline-flex items-center gap-2 px-5 py-3 bg-[var(--primary)] text-white rounded-xl font-bold text-sm hover:opacity-90 transition-opacity shadow-lg shadow-[var(--primary)]/15">
          <Plus size={16} />
          Tambah Soal
        </button>
      </div>

      {/* ── Filters ── */}
      <div
        className="bg-[var(--surface)] rounded-2xl p-5 border border-[var(--divider)] flex flex-col sm:flex-row gap-4"
        style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
      >
        <div className="relative flex-1">
          <Search
            size={16}
            className="absolute left-4 top-1/2 -translate-y-1/2 text-[var(--text-light)]"
          />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Cari soal atau topik..."
            className="w-full pl-11 pr-4 py-2.5 bg-[var(--background)] border border-[var(--divider)] rounded-xl text-sm font-medium text-[var(--foreground)] placeholder:text-[var(--text-light)] outline-none focus:border-[var(--primary)] transition-colors"
          />
        </div>
        <div className="flex gap-2 flex-wrap">
          {SUBJECTS.map((s) => (
            <button
              key={s}
              onClick={() => setActiveSubject(s)}
              className={`px-3.5 py-2 rounded-xl text-xs font-bold transition-all border ${
                activeSubject === s
                  ? "bg-[var(--primary)] text-white border-[var(--primary)]"
                  : "bg-[var(--background)] text-[var(--text-secondary)] border-[var(--divider)] hover:border-[var(--primary-light)]"
              }`}
            >
              {s}
            </button>
          ))}
        </div>
      </div>

      {/* ── Results count ── */}
      <p className="text-xs font-bold text-[var(--text-light)] uppercase tracking-wider">
        {filteredQuestions.length} soal ditemukan
      </p>

      {/* ── Questions List ── */}
      <div className="space-y-3">
        {filteredQuestions.map((q, i) => (
          <motion.div
            key={q.id}
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.03 }}
            className="bg-[var(--surface)] rounded-2xl p-5 border border-[var(--divider)] hover:border-[var(--primary-light)] transition-colors group"
            style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
          >
            <div className="flex items-start gap-4">
              {/* Number */}
              <span className="w-9 h-9 rounded-xl bg-[var(--primary-lighter)] flex items-center justify-center text-xs font-extrabold text-[var(--primary)] shrink-0">
                {q.id}
              </span>

              {/* Content */}
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-2">
                  <span className="text-xs font-bold text-[var(--primary)]">
                    {q.subject}
                  </span>
                  <span className="text-[var(--text-light)]">•</span>
                  <span className="text-xs font-medium text-[var(--text-light)]">
                    {q.topic}
                  </span>
                  <DifficultyBadge level={q.difficulty} />
                </div>
                <p className="text-sm font-bold text-[var(--foreground)] leading-relaxed">
                  {q.question}
                </p>
                <div className="flex items-center gap-4 mt-3">
                  <div className="flex items-center gap-1.5">
                    <CheckCircle2
                      size={12}
                      className={
                        q.accuracy >= 70
                          ? "text-green-500"
                          : q.accuracy >= 50
                            ? "text-yellow-500"
                            : "text-red-500"
                      }
                    />
                    <span className="text-xs font-bold text-[var(--text-secondary)]">
                      {q.accuracy}% akurasi
                    </span>
                  </div>
                  <span className="text-xs font-medium text-[var(--text-light)]">
                    {q.created}
                  </span>
                </div>
              </div>

              {/* Actions */}
              <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                <button className="p-2 rounded-lg text-[var(--text-light)] hover:text-[var(--primary)] hover:bg-[var(--primary-lighter)] transition-all">
                  <Edit3 size={14} />
                </button>
                <button className="p-2 rounded-lg text-[var(--text-light)] hover:text-red-500 hover:bg-red-50 transition-all">
                  <Trash2 size={14} />
                </button>
              </div>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
