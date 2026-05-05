"use client";
import { motion, useScroll, useTransform } from "framer-motion";
import { useRef } from "react";
import Image from "next/image";
import Link from "next/link";
import { ArrowRight, Sparkles } from "lucide-react";

const FluidHero = () => {
  const containerRef = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ["start start", "end start"],
  });

  const opacity = useTransform(scrollYProgress, [0, 0.5], [1, 0]);
  const scale = useTransform(scrollYProgress, [0, 0.5], [1, 0.92]);
  const textY = useTransform(scrollYProgress, [0, 0.5], [0, -30]);

  return (
    <section
      ref={containerRef}
      className="relative min-h-[92vh] flex items-center justify-center overflow-hidden px-6 pt-28 pb-16"
    >
      {/* Soft organic background blobs — warm, not aggressive */}
      <div className="absolute inset-0 -z-10 overflow-hidden">
        <motion.div
          animate={{
            scale: [1, 1.15, 1],
            rotate: [0, 60, 0],
          }}
          transition={{ duration: 25, repeat: Infinity, ease: "linear" }}
          className="absolute -top-[25%] -left-[15%] w-[55%] h-[55%] rounded-full blur-[140px]"
          style={{ background: "var(--primary)", opacity: 0.08 }}
        />
        <motion.div
          animate={{
            scale: [1, 1.2, 1],
            rotate: [0, -90, 0],
          }}
          transition={{ duration: 30, repeat: Infinity, ease: "linear" }}
          className="absolute -bottom-[25%] -right-[15%] w-[60%] h-[60%] rounded-full blur-[140px]"
          style={{ background: "var(--accent-blue)", opacity: 0.1 }}
        />
        <motion.div
          animate={{
            scale: [1, 1.1, 1],
          }}
          transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
          className="absolute top-[20%] right-[10%] w-[30%] h-[30%] rounded-full blur-[120px]"
          style={{ background: "var(--secondary)", opacity: 0.05 }}
        />
      </div>

      <div className="container mx-auto max-w-6xl grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-16 items-center">
        {/* Left Side: Content */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, ease: "easeOut" }}
          style={{ opacity, y: textY }}
        >
          {/* Honest badge — describes what it is, no superlatives */}
          <div className="inline-flex items-center gap-2 px-4 py-2 mb-8 rounded-full bg-[var(--primary-lighter)] border border-[var(--primary-light)]">
            <Sparkles size={14} className="text-[var(--primary)]" />
            <span className="text-[var(--primary)] text-sm font-bold">
              Powered by AI Socratic Method
            </span>
          </div>

          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold mb-6 leading-[1.1] tracking-tight text-[var(--foreground)]">
            Teman Belajar{" "}
            <br className="hidden sm:block" />
            yang{" "}
            <span className="text-[var(--primary)]">Mengerti</span>{" "}
            <br className="hidden sm:block" />
            Caramu.
          </h1>

          <p className="text-lg text-[var(--text-secondary)] mb-10 max-w-lg leading-relaxed font-medium">
            Asisten AI dengan pendekatan Socratic — membimbingmu memahami materi
            melalui pertanyaan penuntun, bukan sekadar memberikan jawaban instan.
          </p>

          <div className="flex flex-wrap gap-4">
            <button className="inline-flex items-center gap-2 px-7 py-4 bg-[var(--secondary)] text-white rounded-full font-bold text-base hover:opacity-90 transition-opacity shadow-lg">
              Download App
              <ArrowRight size={18} />
            </button>
            <button className="px-7 py-4 bg-[var(--surface)] border border-[var(--divider)] text-[var(--foreground)] rounded-full font-bold text-base hover:border-[var(--primary)] transition-colors">
              Pelajari Lebih Lanjut
            </button>
          </div>

          <div className="mt-8 flex items-center gap-2">
            <span className="text-[var(--text-secondary)] text-sm font-medium">
              Seorang pendidik?
            </span>
            <Link
              href="/register-teacher"
              className="text-[var(--primary)] text-sm font-bold hover:underline"
            >
              Buka Dashboard Guru →
            </Link>
          </div>
        </motion.div>

        {/* Right Side: Phone Mockup */}
        <motion.div
          initial={{ opacity: 0, scale: 0.9, y: 30 }}
          whileInView={{ opacity: 1, scale: 1, y: 0 }}
          transition={{ duration: 0.9, ease: "easeOut", delay: 0.15 }}
          style={{ scale }}
          className="relative flex justify-center"
        >
          <div className="relative z-10 w-full max-w-[300px] group">
            {/* Soft glow behind phone */}
            <div
              className="absolute -inset-12 rounded-full blur-[100px] opacity-15 group-hover:opacity-25 transition-opacity duration-700"
              style={{
                background:
                  "linear-gradient(135deg, var(--primary), var(--accent-blue))",
              }}
            />
            <motion.div
              animate={{ y: [0, -12, 0] }}
              transition={{
                duration: 5,
                repeat: Infinity,
                ease: "easeInOut",
              }}
              className="relative"
            >
              <Image
                src="/images/hero-v3.png"
                alt="Study Buddy — tampilan aplikasi mobile"
                width={450}
                height={900}
                className="w-full h-auto drop-shadow-2xl"
                priority
              />
            </motion.div>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default FluidHero;
