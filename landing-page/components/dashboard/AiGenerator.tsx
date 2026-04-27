"use client";
import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Wand2, Check, Copy, Trash2, FileText, Sparkles } from "lucide-react";
import { supabase } from "@/lib/supabase";

export default function AiGenerator() {
  const [inputText, setInputText] = useState("");
  const [isGenerating, setIsGenerating] = useState(false);
  const [mode, setMode] = useState<"questions" | "material">("questions");
  const [questions, setQuestions] = useState<any[]>([]);
  const [material, setMaterial] = useState<string | null>(null);
  const [isSaving, setIsSaving] = useState(false);

  const handleGenerate = () => {
    setIsGenerating(true);
    // Simulate AI generation
    setTimeout(() => {
      if (mode === "questions") {
        setQuestions([
          {
            subject: "Biologi",
            topic: inputText.slice(0, 20) + "...",
            question_text: "Proses pembuatan makanan pada tumbuhan disebut?",
            options: { "A": "Respirasi", "B": "Fotosintesis", "C": "Oksidasi", "D": "Fermentasi" },
            correct_option: "B",
            difficulty: "Easy",
            explanation: "Fotosintesis menggunakan cahaya matahari untuk mengubah CO2 dan air menjadi glukosa."
          }
        ]);
        setMaterial(null);
      } else {
        setMaterial(`
# Memahami ${inputText}
          
Materi ini akan membahas poin-poin penting mengenai ${inputText} secara mendalam:
          
1. **Definisi Dasar**: Penjelasan fundamental mengenai konsep ini.
2. **Komponen Utama**: Apa saja yang terlibat dalam proses ini.
3. **Contoh Kasus**: Penerapan dalam kehidupan sehari-hari atau soal ujian.
          
---
*Materi ini di-generate otomatis oleh Study Buddy AI untuk membantu proses belajar mengajar.*
        `);
        setQuestions([]);
      }
      setIsGenerating(false);
    }, 2500);
  };

  const handlePublish = async () => {
    setIsSaving(true);
    try {
      const { data: userData } = await supabase.auth.getUser();
      if (!userData.user) throw new Error("Silakan login kembali");

      const questionsToSave = questions.map(q => ({
        ...q,
        teacher_id: userData.user.id
      }));

      const { error } = await supabase.from('questions').insert(questionsToSave);
      if (error) throw error;

      alert("Berhasil! Soal telah dipublikasikan ke Bank Soal Siswa.");
      setQuestions([]);
      setInputText("");
    } catch (err: any) {
      alert("Gagal menyimpan: " + err.message);
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="space-y-8">
      {/* ── Input Card ── */}
      <div className="bg-white p-8 rounded-3xl shadow-sm border border-slate-200">
        <div className="flex items-center justify-between mb-8">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-orange-100 flex items-center justify-center text-orange-600">
              <FileText size={20} />
            </div>
            <div>
              <h3 className="font-bold text-slate-900">AI Generator</h3>
              <p className="text-xs text-slate-500 font-medium">Buat konten edukasi instan dengan AI.</p>
            </div>
          </div>
          
          <div className="bg-slate-100 p-1 rounded-xl flex gap-1">
            <button 
              onClick={() => setMode("questions")}
              className={`px-4 py-2 rounded-lg text-xs font-bold transition-all ${mode === "questions" ? "bg-white text-orange-600 shadow-sm" : "text-slate-500 hover:text-slate-700"}`}
            >
              Generate Soal
            </button>
            <button 
              onClick={() => setMode("material")}
              className={`px-4 py-2 rounded-lg text-xs font-bold transition-all ${mode === "material" ? "bg-white text-orange-600 shadow-sm" : "text-slate-500 hover:text-slate-700"}`}
            >
              Generate Materi
            </button>
          </div>
        </div>
        
        <textarea
          value={inputText}
          onChange={(e) => setInputText(e.target.value)}
          placeholder={mode === "questions" ? "Contoh: Turunan adalah pengukuran bagaimana sebuah fungsi berubah..." : "Contoh: Berikan ringkasan materi tentang Perang Dunia II untuk kelas 10..."}
          className="w-full h-48 p-6 bg-slate-50 border-2 border-slate-100 rounded-2xl text-sm font-medium focus:outline-none focus:border-orange-500 transition-colors outline-none"
        />

        <div className="mt-6 flex justify-between items-center">
           <div className="text-xs text-slate-400 font-bold uppercase tracking-wider">
             AI will generate {mode === "questions" ? "Multiple Choice Questions" : "Educational Content"}
           </div>
           <button 
             onClick={handleGenerate}
             disabled={!inputText || isGenerating}
             className="bg-orange-500 hover:bg-orange-600 disabled:opacity-50 text-white px-8 py-3 rounded-full font-bold flex items-center gap-2 transition-all shadow-lg shadow-orange-500/20"
           >
             {isGenerating ? <motion.div animate={{ rotate: 360 }} transition={{ repeat: Infinity, ease: "linear" }}><Sparkles size={18} /></motion.div> : <Wand2 size={18} />}
             {isGenerating ? "Generating..." : `Generate ${mode === "questions" ? "Soal" : "Materi"} AI`}
           </button>
        </div>
      </div>

      {/* ── Generated Results ── */}
      <AnimatePresence>
        {material && (
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="bg-white p-8 rounded-3xl shadow-sm border border-slate-200"
          >
            <div className="flex justify-between items-center mb-8">
              <h4 className="text-sm font-bold text-slate-400 uppercase tracking-widest">Draft Materi AI</h4>
              <button 
                onClick={async () => {
                  setIsSaving(true);
                  try {
                    const { data: userData } = await supabase.auth.getUser();
                    const { error } = await supabase.from('study_materials').insert({
                      teacher_id: userData.user?.id,
                      subject: "Umum",
                      topic: inputText,
                      content: material
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
                className="bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-xl font-bold text-sm flex items-center gap-2 transition-all disabled:opacity-50"
              >
                {isSaving ? "Saving..." : <><Check size={16} /> Publish Materi</>}
              </button>
            </div>
            <div className="prose prose-slate max-w-none whitespace-pre-wrap font-medium text-slate-700">
              {material}
            </div>
          </motion.div>
        )}

        {questions.length > 0 && (
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="space-y-4"
          >
            <div className="flex justify-between items-center px-4">
              <h4 className="text-sm font-bold text-slate-400 uppercase tracking-widest">Hasil Draft AI</h4>
              <button 
                onClick={handlePublish}
                disabled={isSaving}
                className="bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-xl font-bold text-sm flex items-center gap-2 transition-all disabled:opacity-50"
              >
                {isSaving ? "Publishing..." : <><Check size={16} /> Publish ke Bank Soal</>}
              </button>
            </div>

            {questions.map((q, idx) => (
              <div key={idx} className="bg-white p-6 rounded-3xl shadow-sm border border-slate-200 group relative">
                <div className="flex justify-between items-start mb-4">
                  <span className="w-8 h-8 rounded-lg bg-slate-100 flex items-center justify-center text-xs font-bold text-slate-500">
                    {idx + 1}
                  </span>
                  <div className="flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button className="p-2 text-slate-400 hover:text-red-500 transition-colors"><Trash2 size={16}/></button>
                  </div>
                </div>
                <p className="font-bold text-slate-800 mb-6">{q.question_text}</p>
                <div className="grid grid-cols-2 gap-3">
                  {Object.entries(q.options).map(([key, value]: any) => (
                    <div key={key} className={`p-4 rounded-xl border-2 text-sm font-bold transition-colors ${
                      key === q.correct_option ? "bg-green-50 border-green-100 text-green-700" : "bg-slate-50 border-slate-50 text-slate-500"
                    }`}>
                      {key}. {value}
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </motion.div>
        )}
      </AnimatePresence>
    </div>

  );
}
