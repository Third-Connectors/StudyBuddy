"use client";
import { motion, useScroll, useTransform } from "framer-motion";
import { useRef } from "react";
import Image from "next/image";
import Link from "next/link";

const FluidHero = () => {
  const containerRef = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ["start start", "end start"],
  });

  const y = useTransform(scrollYProgress, [0, 1], ["0%", "50%"]);
  const opacity = useTransform(scrollYProgress, [0, 0.5], [1, 0]);
  const scale = useTransform(scrollYProgress, [0, 0.5], [1, 0.8]);
  const textY = useTransform(scrollYProgress, [0, 0.5], [0, -20]);

  return (
    <section ref={containerRef} className="relative min-h-[90vh] flex items-center justify-center overflow-hidden px-6 pt-24 pb-12">
      {/* Dynamic Background Elements */}
      <div className="absolute inset-0 -z-10 overflow-hidden">
        <motion.div
          animate={{
            scale: [1, 1.2, 1],
            rotate: [0, 90, 0],
          }}
          transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
          className="absolute -top-[20%] -left-[10%] w-[60%] h-[60%] bg-[var(--primary)] opacity-10 blur-[120px] rounded-full"
        />
        <motion.div
          animate={{
            scale: [1, 1.3, 1],
            rotate: [0, -120, 0],
          }}
          transition={{ duration: 25, repeat: Infinity, ease: "linear" }}
          className="absolute -bottom-[20%] -right-[10%] w-[70%] h-[70%] bg-[var(--secondary)] opacity-10 blur-[120px] rounded-full"
        />
      </div>

      <div className="container mx-auto grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
        {/* Left Side: Content */}
        <motion.div
          initial={{ opacity: 0, x: -50 }}
          whileInView={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
          style={{ opacity, y: textY }}
        >
          <div className="inline-block px-4 py-1.5 mb-6 rounded-full bg-[var(--primary)]/10 border border-[var(--primary)]/20">
            <span className="text-[var(--primary)] text-sm font-bold tracking-wider uppercase">
              ✨ Best AI Tutor 2026
            </span>
          </div>

          <h1 className="text-6xl md:text-8xl font-black mb-8 leading-[0.9] tracking-tighter">
            UPGRADE <br />
            <span className="text-[var(--primary)]">SKILLS</span> <br />
            NOW.
          </h1>

          <p className="text-xl text-slate-600 mb-10 max-w-lg leading-relaxed font-medium">
            Personal AI tutor yang mengerti gaya belajarmu. Dapatkan bantuan 24/7 dengan pendekatan Socratic yang interaktif.
          </p>

          <div className="flex flex-wrap gap-4">
            <button className="px-8 py-4 bg-[var(--secondary)] text-white rounded-2xl font-bold text-lg hover:scale-105 transition-transform shadow-xl shadow-[var(--secondary)]/20">
              Download App
            </button>
            <button className="px-8 py-4 bg-white border-2 border-slate-200 text-slate-900 rounded-2xl font-bold text-lg hover:border-[var(--primary)] transition-colors">
              Join Waitlist
            </button>
          </div>

          <div className="mt-8 flex items-center gap-2">
            <span className="text-slate-500 text-sm font-medium">Apakah Anda seorang pendidik?</span>
            <Link href="/register-teacher" className="text-[var(--primary)] text-sm font-bold hover:underline">
              Daftar sebagai Guru & Buka Dashboard →
            </Link>
          </div>
        </motion.div>

        {/* Right Side: Visual Mockup */}
        <motion.div
          initial={{ opacity: 0, scale: 0.8, rotateZ: -10, x: 50 }}
          whileInView={{ opacity: 1, scale: 1, rotateZ: -5, x: 0 }}
          transition={{ duration: 1.2, ease: "easeOut" }}
          style={{ scale }}
          className="relative"
        >
          <div className="relative z-10 w-full max-w-[320px] mx-auto group">
            <div className="absolute -inset-10 bg-gradient-to-r from-[var(--primary)] to-[var(--secondary)] rounded-full blur-[100px] opacity-20 group-hover:opacity-40 transition-opacity" />
            <motion.div
              animate={{ y: [0, -15, 0] }}
              transition={{ duration: 6, repeat: Infinity, ease: "easeInOut" }}
              className="relative"
            >
              <Image
                src="/images/hero-v3.png"
                alt="Study Buddy App"
                width={450}
                height={900}
                className="w-full h-auto drop-shadow-[0_35px_35px_rgba(0,0,0,0.25)]"
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
