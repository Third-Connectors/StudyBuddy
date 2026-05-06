"use client";
import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import {
  Wand2,
  Check,
  Trash2,
  FileText,
  Sparkles,
  BookOpen,
  GraduationCap,
} from "lucide-react";
import { supabase } from "@/lib/supabase";

export default function AiGenerator() {
  const [inputText, setInputText] = useState("");
  const [contextText, setContextText] = useState("");
  const [subject, setSubject] = useState("Matematika");
  const [difficulty, setDifficulty] = useState<"Easy" | "Medium" | "Hard">(
    "Medium"
  );
  const [questionCount, setQuestionCount] = useState(5);
  const [isGenerating, setIsGenerating] = useState(false);
  const [mode, setMode] = useState<"questions" | "material">("questions");
  const [questions, setQuestions] = useState<any[]>([]);
  const [material, setMaterial] = useState<string | null>(null);
  const [isSaving, setIsSaving] = useState(false);

  const SUBJECTS = [
    "Matematika",
    "Fisika",
    "Biologi",
    "Kimia",
    "B. Indonesia",
    "B. Inggris",
    "Ekonomi",
    "Sejarah",
  ];

  const handleGenerate = async () => {
    if (!inputText) return;
    setIsGenerating(true);
    try {
      const response = await fetch("/api/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          topic: inputText,
          context: contextText, // Send additional context
          subject,
          difficulty,
          count: questionCount,
          mode,
        }),
      });

      const { data, error } = await response.json();
      if (error) throw new Error(error);

      if (mode === "questions") {
        setQuestions(data);
        setMaterial(null);
      } else {
        setMaterial(data);
        setQuestions([]);
      }
    } catch (err: any) {
      alert("Gagal generate: " + err.message);
    } finally {
      setIsGenerating(false);
    }
  };

  const handlePublish = async () => {
    setIsSaving(true);
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error("Silakan login kembali");

      // We save questions into 'quizzes' table (one quiz per topic or multiple questions)
      // For now, let's group them as one quiz entry in Supabase if preferred,
      // or individual questions. The Flutter app expects 'quizzes' table entries.
      
      const { error } = await supabase.from("quizzes").insert(
        questions.map((q) => ({
          subject: q.subject,
          topic: q.topic,
          question_text: q.question_text,
          options: q.options,
          correct_option: q.correct_option,
          difficulty: q.difficulty,
          explanation: q.explanation,
          teacher_id: user.id,
        }))
      );

      if (error) throw error;

      alert("Berhasil! Soal telah dipublikasikan ke Bank Soal.");
      setQuestions([]);
      setInputText("");
      setContextText("");
    } catch (err: any) {
      alert("Gagal menyimpan: " + err.message);
    } finally {
      setIsSaving(false);
    }
  };

  const removeQuestion = (idx: number) => {
    setQuestions((prev) => prev.filter((_, i) => i !== idx));
  };

  return (
    <div className="grid grid-cols-1 xl:grid-cols-12 gap-6">
      {/* ── Left: Input Panel ── */}
      <div className="xl:col-span-5 space-y-5">
        <div
          className="bg-[var(--surface)] rounded-2xl p-6 border border-[var(--divider)]"
          style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
        >
          {/* Mode Toggle */}
          <div className="flex gap-1 p-1 bg-[var(--background)] rounded-xl mb-6">
            <button
              onClick={() => setMode("questions")}
              className={`flex-1 flex items-center justify-center gap-2 px-4 py-2.5 rounded-lg text-[13px] font-bold transition-all ${
                mode === "questions"
                  ? "bg-[var(--surface)] text-[var(--primary)] shadow-sm"
                  : "text-[var(--text-secondary)] hover:text-[var(--foreground)]"
              }`}
            >
              <GraduationCap size={14} />
              Generate Soal
            </button>
            <button
              onClick={() => setMode("material")}
              className={`flex-1 flex items-center justify-center gap-2 px-4 py-2.5 rounded-lg text-[13px] font-bold transition-all ${
                mode === "material"
                  ? "bg-[var(--surface)] text-[var(--primary)] shadow-sm"
                  : "text-[var(--text-secondary)] hover:text-[var(--foreground)]"
              }`}
            >
              <BookOpen size={14} />
              VAK Material
            </button>
          </div>

          {/* Subject Selector */}
          {mode === "questions" && (
            <div className="mb-5">
              <label className="block text-xs font-bold text-[var(--text-secondary)] uppercase tracking-wider mb-2">
                Mata Pelajaran
              </label>
              <div className="flex flex-wrap gap-2">
                {SUBJECTS.map((s) => (
                  <button
                    key={s}
                    onClick={() => setSubject(s)}
                    className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-all border ${
                      subject === s
                        ? "bg-[var(--primary)] text-white border-[var(--primary)]"
                        : "bg-[var(--background)] text-[var(--text-secondary)] border-[var(--divider)] hover:border-[var(--primary-light)]"
                    }`}
                  >
                    {s}
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Difficulty & Count */}
          {mode === "questions" && (
            <div className="grid grid-cols-2 gap-4 mb-5">
              <div>
                <label className="block text-xs font-bold text-[var(--text-secondary)] uppercase tracking-wider mb-2">
                  Tingkat Kesulitan
                </label>
                <select
                  value={difficulty}
                  onChange={(e) =>
                    setDifficulty(e.target.value as "Easy" | "Medium" | "Hard")
                  }
                  className="w-full px-3 py-2.5 bg-[var(--background)] border border-[var(--divider)] rounded-xl text-sm font-bold text-[var(--foreground)] outline-none focus:border-[var(--primary)] transition-colors"
                >
                  <option value="Easy">Mudah</option>
                  <option value="Medium">Sedang</option>
                  <option value="Hard">Sulit</option>
                </select>
              </div>
              <div>
                <label className="block text-xs font-bold text-[var(--text-secondary)] uppercase tracking-wider mb-2">
                  Jumlah Soal
                </label>
                <select
                  value={questionCount}
                  onChange={(e) => setQuestionCount(Number(e.target.value))}
                  className="w-full px-3 py-2.5 bg-[var(--background)] border border-[var(--divider)] rounded-xl text-sm font-bold text-[var(--foreground)] outline-none focus:border-[var(--primary)] transition-colors"
                >
                  {[3, 5, 10, 15, 20].map((n) => (
                    <option key={n} value={n}>
                      {n} soal
                    </option>
                  ))}
                </select>
              </div>
            </div>
          )}

          {/* Topic Input */}
          <div className="mb-5">
            <label className="block text-xs font-bold text-[var(--text-secondary)] uppercase tracking-wider mb-2">
              {mode === "questions"
                ? "Topik / Judul Kuis"
                : "Topik Materi VAK"}
            </label>
            <input
              type="text"
              value={inputText}
              onChange={(e) => setInputText(e.target.value)}
              placeholder="Contoh: Turunan Fungsi Aljabar"
              className="w-full p-3.5 bg-[var(--background)] border border-[var(--divider)] rounded-xl text-sm font-bold text-[var(--foreground)] outline-none focus:border-[var(--primary)] transition-colors"
            />
          </div>

          {/* Context Input (New) */}
          <div className="mb-5">
            <div className="flex items-center justify-between mb-2">
              <label className="text-xs font-bold text-[var(--text-secondary)] uppercase tracking-wider">
                Konteks Tambahan (PDF/Teks)
              </label>
              <span className="text-[10px] font-bold text-[var(--primary)] bg-[var(--primary-lighter)] px-2 py-0.5 rounded">Opsional</span>
            </div>
            <textarea
              value={contextText}
              onChange={(e) => setContextText(e.target.value)}
              placeholder="Tempel teks materi dari PDF atau catatan Anda di sini agar AI membuat soal yang relevan..."
              className="w-full h-32 p-4 bg-[var(--background)] border border-[var(--divider)] rounded-xl text-sm font-medium text-[var(--foreground)] placeholder:text-[var(--text-light)] focus:outline-none focus:border-[var(--primary)] transition-colors resize-none"
            />
          </div>

          {/* Generate Button */}
          <button
            onClick={handleGenerate}
            disabled={!inputText || isGenerating}
            className="w-full bg-[var(--primary)] hover:opacity-90 disabled:opacity-40 text-white py-3.5 rounded-xl font-bold text-sm flex items-center justify-center gap-2 transition-all shadow-lg shadow-[var(--primary)]/15"
          >
            {isGenerating ? (
              <motion.div
                animate={{ rotate: 360 }}
                transition={{
                  repeat: Infinity,
                  ease: "linear" as const,
                  duration: 1,
                }}
              >
                <Sparkles size={16} />
              </motion.div>
            ) : (
              <Wand2 size={16} />
            )}
            {isGenerating
              ? "Generating..."
              : `Generate ${mode === "questions" ? "Soal" : "Materi"}`}
          </button>
        </div>
      </div>

      {/* ── Right: Results Panel ── */}
      <div className="xl:col-span-7 space-y-4">
        <AnimatePresence mode="wait">
          {/* Empty state */}
          {questions.length === 0 && !material && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="bg-[var(--surface)] rounded-2xl border border-[var(--divider)] p-16 flex flex-col items-center justify-center text-center"
              style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
            >
              <div className="w-16 h-16 rounded-2xl bg-[var(--primary-lighter)] flex items-center justify-center mb-5">
                <FileText size={24} className="text-[var(--primary)]" />
              </div>
              <h3 className="font-bold text-[var(--foreground)] mb-2">
                Belum Ada Hasil
              </h3>
              <p className="text-sm text-[var(--text-light)] font-medium max-w-sm">
                Isi topik di panel kiri, lalu klik Generate untuk membuat soal
                atau materi secara otomatis dengan AI.
              </p>
            </motion.div>
          )}

          {/* Material result */}
          {material && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="bg-[var(--surface)] rounded-2xl p-6 border border-[var(--divider)]"
              style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
            >
              <div className="flex justify-between items-center mb-5">
                <h4 className="text-xs font-bold text-[var(--text-light)] uppercase tracking-widest">
                  Draft Materi
                </h4>
                <button
                  onClick={async () => {
                    setIsSaving(true);
                    try {
                      const { data: userData } =
                        await supabase.auth.getUser();
                      const { error } = await supabase
                        .from("study_materials")
                        .insert({
                          teacher_id: userData.user?.id,
                          subject: "Umum",
                          topic: inputText,
                          content: material,
                        });
                      if (error) throw error;
                      alert("Materi berhasil disimpan!");
                      setMaterial(null);
                      setInputText("");
                    } catch (err: any) {
                      alert(err.message);
                    } finally {
                      setIsSaving(false);
                    }
                  }}
                  disabled={isSaving}
                  className="bg-[var(--secondary)] hover:opacity-90 text-white px-5 py-2 rounded-xl font-bold text-xs flex items-center gap-2 transition-all disabled:opacity-50"
                >
                  {isSaving ? (
                    "Menyimpan..."
                  ) : (
                    <>
                      <Check size={14} /> Publish Materi
                    </>
                  )}
                </button>
              </div>
              <div className="prose prose-sm max-w-none whitespace-pre-wrap font-medium text-[var(--foreground)] bg-[var(--background)] p-5 rounded-xl border border-[var(--divider)]/50">
                {material}
              </div>
            </motion.div>
          )}

          {/* Questions result */}
          {questions.length > 0 && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="space-y-4"
            >
              <div className="flex justify-between items-center">
                <h4 className="text-xs font-bold text-[var(--text-light)] uppercase tracking-widest">
                  {questions.length} Soal Di-generate
                </h4>
                <button
                  onClick={handlePublish}
                  disabled={isSaving}
                  className="bg-[var(--secondary)] hover:opacity-90 text-white px-5 py-2.5 rounded-xl font-bold text-xs flex items-center gap-2 transition-all disabled:opacity-50 shadow-lg shadow-[var(--secondary)]/15"
                >
                  {isSaving ? (
                    "Publishing..."
                  ) : (
                    <>
                      <Check size={14} /> Publish ke Bank Soal
                    </>
                  )}
                </button>
              </div>

              {questions.map((q, idx) => (
                <motion.div
                  key={idx}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: idx * 0.05 }}
                  className="bg-[var(--surface)] p-5 rounded-2xl border border-[var(--divider)] group"
                  style={{ boxShadow: "0 1px 8px var(--card-shadow)" }}
                >
                  <div className="flex justify-between items-start mb-4">
                    <div className="flex items-center gap-3">
                      <span className="w-8 h-8 rounded-lg bg-[var(--primary-lighter)] flex items-center justify-center text-xs font-extrabold text-[var(--primary)]">
                        {idx + 1}
                      </span>
                      <span
                        className={`px-2 py-0.5 rounded-md text-[10px] font-bold uppercase ${
                          q.difficulty === "Easy"
                            ? "bg-green-50 text-green-600"
                            : q.difficulty === "Medium"
                              ? "bg-yellow-50 text-yellow-600"
                              : "bg-red-50 text-red-600"
                        }`}
                      >
                        {q.difficulty}
                      </span>
                    </div>
                    <button
                      onClick={() => removeQuestion(idx)}
                      className="p-2 text-[var(--text-light)] hover:text-red-500 opacity-0 group-hover:opacity-100 transition-all rounded-lg hover:bg-red-50"
                    >
                      <Trash2 size={14} />
                    </button>
                  </div>
                  <p className="font-bold text-sm text-[var(--foreground)] mb-4 leading-relaxed">
                    {q.question_text}
                  </p>
                  <div className="grid grid-cols-2 gap-2">
                    {Object.entries(q.options).map(([key, value]: any) => (
                      <div
                        key={key}
                        className={`p-3 rounded-xl text-[13px] font-bold transition-colors border ${
                          key === q.correct_option
                            ? "bg-green-50 border-green-200 text-green-700"
                            : "bg-[var(--background)] border-[var(--divider)]/50 text-[var(--text-secondary)]"
                        }`}
                      >
                        <span className="font-extrabold mr-1.5">{key}.</span>
                        {value}
                      </div>
                    ))}
                  </div>
                </motion.div>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}
