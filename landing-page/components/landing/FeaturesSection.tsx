"use client";
import { motion } from "framer-motion";
import {
  MessageCircleQuestion,
  Brain,
  Target,
  Users,
} from "lucide-react";

const FEATURES = [
  {
    icon: <MessageCircleQuestion size={24} />,
    title: "Metode Socratic",
    desc: "Belajar melalui pertanyaan penuntun yang membantumu berpikir kritis — bukan jawaban instan yang mudah dilupakan.",
    color: "var(--primary)",
    bg: "var(--primary-lighter)",
  },
  {
    icon: <Brain size={24} />,
    title: "Sesuai Gaya Belajarmu",
    desc: "Deteksi gaya belajar (Visual, Auditori, Kinestetik) dan sesuaikan cara penyampaian materi secara otomatis.",
    color: "#8B5CF6",
    bg: "#F5F3FF",
  },
  {
    icon: <Target size={24} />,
    title: "Persiapan UTBK",
    desc: "Latihan soal dengan countdown UTBK, tracking progress, dan daily missions untuk menjaga konsistensi belajarmu.",
    color: "var(--secondary)",
    bg: "#D6F0DF",
  },
  {
    icon: <Users size={24} />,
    title: "Dashboard Guru",
    desc: "Pendidik dapat membuat soal, memantau perkembangan siswa, dan menggunakan AI untuk generate bank soal.",
    color: "#3B82F6",
    bg: "#EFF6FF",
  },
];

const containerVariants = {
  hidden: {},
  visible: {
    transition: { staggerChildren: 0.12 },
  },
};

const cardVariants = {
  hidden: { opacity: 0, y: 24 },
  visible: {
    opacity: 1,
    y: 0,
    transition: { duration: 0.5, ease: "easeOut" as const },
  },
};

export default function FeaturesSection() {
  return (
    <section className="py-20 lg:py-28">
      <div className="container mx-auto max-w-6xl px-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-80px" }}
          transition={{ duration: 0.6 }}
          className="text-center mb-14"
        >
          <h2 className="text-3xl lg:text-4xl font-extrabold text-[var(--foreground)] mb-4">
            Apa yang Bisa <span className="text-[var(--primary)]">Study Buddy</span> Lakukan?
          </h2>
          <p className="text-[var(--text-secondary)] max-w-2xl mx-auto font-medium leading-relaxed">
            Didesain untuk membantu siswa SMA belajar lebih efektif dengan pendekatan AI yang personal dan interaktif.
          </p>
        </motion.div>

        <motion.div
          variants={containerVariants}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true, margin: "-60px" }}
          className="grid sm:grid-cols-2 gap-5"
        >
          {FEATURES.map((feat, i) => (
            <motion.div
              key={i}
              variants={cardVariants}
              className="group p-7 rounded-2xl bg-[var(--surface)] border border-[var(--divider)] hover:border-[var(--primary-light)] transition-colors duration-300"
              style={{
                boxShadow: "0 2px 12px var(--card-shadow)",
              }}
            >
              <div
                className="w-12 h-12 rounded-xl flex items-center justify-center mb-5 transition-transform duration-300 group-hover:scale-105"
                style={{ background: feat.bg, color: feat.color }}
              >
                {feat.icon}
              </div>
              <h3 className="text-lg font-bold text-[var(--foreground)] mb-2">
                {feat.title}
              </h3>
              <p className="text-sm text-[var(--text-secondary)] leading-relaxed">
                {feat.desc}
              </p>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </section>
  );
}
