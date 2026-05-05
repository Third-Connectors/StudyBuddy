"use client";
import { motion } from "framer-motion";
import { Heart, GraduationCap, Lightbulb } from "lucide-react";

const BELIEFS = [
  {
    icon: <GraduationCap size={28} />,
    title: "Pendidikan untuk Semua",
    desc: "Setiap siswa berhak mendapat bimbingan berkualitas, terlepas dari latar belakang atau lokasi mereka.",
    accent: "#3B82F6",
    bg: "#EFF6FF",
  },
  {
    icon: <Lightbulb size={28} />,
    title: "Memahami, Bukan Menghafal",
    desc: "Pendekatan Socratic mendorong pemahaman mendalam — kemampuan yang bertahan seumur hidup, bukan sekadar untuk ujian.",
    accent: "var(--primary)",
    bg: "var(--primary-lighter)",
  },
  {
    icon: <Heart size={28} />,
    title: "Belajar Tanpa Tekanan",
    desc: "AI yang sabar dan tidak menghakimi — membantu mengurangi kecemasan belajar dengan pendekatan yang empatik.",
    accent: "#EC4899",
    bg: "#FDF2F8",
  },
];

const cardVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: (i: number) => ({
    opacity: 1,
    y: 0,
    transition: { duration: 0.5, ease: "easeOut" as const, delay: i * 0.1 },
  }),
};

export default function MissionSection() {
  return (
    <section className="py-20 lg:py-28 bg-[var(--secondary)] text-white">
      <div className="container mx-auto max-w-6xl px-6">
        <div className="flex flex-col lg:flex-row gap-14 items-start">
          {/* Left — Mission statement */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-80px" }}
            transition={{ duration: 0.6 }}
            className="lg:w-5/12"
          >
            <h2 className="text-3xl lg:text-5xl font-extrabold mb-6 leading-tight">
              Lebih dari{" "}
              <span className="text-[var(--primary)]">Sekadar App.</span>
            </h2>
            <p className="text-white/60 text-base font-medium leading-relaxed mb-8">
              Study Buddy lahir dari keyakinan bahwa teknologi AI seharusnya
              membuat pendidikan lebih adil dan terjangkau — bukan lebih mahal
              dan eksklusif.
            </p>
            <p className="text-white/40 text-sm font-medium leading-relaxed">
              Kami membangun ini sejalan dengan tujuan SDG 4 (Quality Education)
              — agar setiap siswa di Indonesia punya akses ke bimbingan belajar
              yang personal dan berkualitas.
            </p>
          </motion.div>

          {/* Right — Belief cards */}
          <div className="lg:w-7/12 grid gap-4">
            {BELIEFS.map((item, i) => (
              <motion.div
                key={i}
                custom={i}
                variants={cardVariants}
                initial="hidden"
                whileInView="visible"
                viewport={{ once: true, margin: "-40px" }}
                className="flex gap-5 p-6 rounded-2xl bg-white/[0.06] border border-white/[0.08] hover:bg-white/[0.1] transition-colors duration-300"
              >
                <div
                  className="w-12 h-12 rounded-xl flex items-center justify-center shrink-0"
                  style={{ background: item.bg, color: item.accent }}
                >
                  {item.icon}
                </div>
                <div>
                  <h3 className="text-base font-bold mb-1">{item.title}</h3>
                  <p className="text-white/50 text-sm leading-relaxed">
                    {item.desc}
                  </p>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
