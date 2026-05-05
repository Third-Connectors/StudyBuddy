"use client";
import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Send, Bot, User } from "lucide-react";

const DEMO_CHATS = [
  {
    role: "ai",
    text: "Halo! Aku Study Buddy. Materi apa yang ingin kamu pelajari hari ini?",
  },
  {
    role: "user",
    text: "Aku bingung soal konsep Turunan di Matematika...",
  },
  {
    role: "ai",
    text: "Oke, coba kita mulai dari hal sederhana. Menurutmu, apa yang terjadi pada kecepatan mobil saat tanjakan semakin curam?",
  },
  {
    role: "user",
    text: "Hmm, kecepatannya berubah tergantung kemiringannya?",
  },
  {
    role: "ai",
    text: "Tepat! Nah, turunan itu sebenarnya mengukur 'seberapa curam' perubahan itu. Bayangkan grafik — turunan adalah kemiringan garis di titik tertentu. Mau coba hitung satu contoh sederhana?",
  },
];

export default function AiPlayground() {
  const [messages, setMessages] = useState(DEMO_CHATS.slice(0, 1));
  const [isTyping, setIsTyping] = useState(false);
  const [currentIndex, setCurrentIndex] = useState(1);

  useEffect(() => {
    if (currentIndex >= DEMO_CHATS.length) return;

    const delay = DEMO_CHATS[currentIndex].role === "ai" ? 2500 : 1500;

    if (DEMO_CHATS[currentIndex].role === "ai") {
      setIsTyping(true);
      const timer = setTimeout(() => {
        setIsTyping(false);
        setMessages((prev) => [...prev, DEMO_CHATS[currentIndex]]);
        setCurrentIndex((prev) => prev + 1);
      }, delay);
      return () => clearTimeout(timer);
    } else {
      const timer = setTimeout(() => {
        setMessages((prev) => [...prev, DEMO_CHATS[currentIndex]]);
        setCurrentIndex((prev) => prev + 1);
      }, delay);
      return () => clearTimeout(timer);
    }
  }, [currentIndex, messages.length]);

  return (
    <section className="py-20 lg:py-28 bg-[var(--surface)]">
      <div className="container mx-auto max-w-6xl px-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-80px" }}
          transition={{ duration: 0.6 }}
          className="text-center mb-14"
        >
          <h2 className="text-3xl lg:text-4xl font-extrabold text-[var(--foreground)] mb-4">
            Lihat{" "}
            <span className="text-[var(--primary)]">Cara Kerjanya</span>
          </h2>
          <p className="text-[var(--text-secondary)] max-w-2xl mx-auto font-medium leading-relaxed">
            Study Buddy tidak langsung memberi jawaban. Ia bertanya balik untuk
            membantumu berpikir dan memahami konsep secara mendalam.
          </p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-60px" }}
          transition={{ duration: 0.6, delay: 0.1 }}
          className="max-w-2xl mx-auto rounded-2xl overflow-hidden border border-[var(--divider)]"
          style={{ boxShadow: "0 8px 40px rgba(0,0,0,0.06)" }}
        >
          {/* Chat header */}
          <div className="flex items-center gap-3 px-6 py-4 border-b border-[var(--divider)] bg-[var(--surface)]">
            <div className="w-9 h-9 rounded-full bg-[var(--primary)] flex items-center justify-center">
              <Bot size={18} className="text-white" />
            </div>
            <div>
              <p className="text-sm font-bold text-[var(--foreground)]">
                Study Buddy AI
              </p>
              <p className="text-xs text-[var(--text-light)]">
                Socratic Tutor • Selalu ada untukmu
              </p>
            </div>
          </div>

          {/* Chat body */}
          <div className="h-[380px] overflow-y-auto space-y-3 p-5 bg-[var(--background)]">
            <AnimatePresence>
              {messages.map((msg, i) => (
                <motion.div
                  key={i}
                  initial={{ opacity: 0, y: 14, scale: 0.97 }}
                  animate={{ opacity: 1, y: 0, scale: 1 }}
                  transition={{ duration: 0.35, ease: "easeOut" }}
                  className={`flex ${msg.role === "user" ? "justify-end" : "justify-start"}`}
                >
                  <div
                    className={`flex gap-2.5 max-w-[82%] ${msg.role === "user" ? "flex-row-reverse" : ""}`}
                  >
                    <div
                      className={`w-8 h-8 rounded-full flex items-center justify-center shrink-0 ${
                        msg.role === "ai"
                          ? "bg-[var(--primary)]"
                          : "bg-[var(--foreground)]"
                      }`}
                    >
                      {msg.role === "ai" ? (
                        <Bot size={16} className="text-white" />
                      ) : (
                        <User size={16} className="text-white" />
                      )}
                    </div>
                    <div
                      className={`px-4 py-3 rounded-2xl ${
                        msg.role === "ai"
                          ? "bg-[var(--surface)] text-[var(--foreground)] border border-[var(--divider)]"
                          : "bg-[var(--foreground)] text-white"
                      }`}
                    >
                      <p className="text-sm font-medium leading-relaxed">
                        {msg.text}
                      </p>
                    </div>
                  </div>
                </motion.div>
              ))}
              {isTyping && (
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  className="flex justify-start"
                >
                  <div className="flex gap-2.5">
                    <div className="w-8 h-8 rounded-full bg-[var(--primary)] flex items-center justify-center shrink-0">
                      <Bot size={16} className="text-white" />
                    </div>
                    <div className="bg-[var(--surface)] border border-[var(--divider)] px-4 py-3 rounded-2xl flex gap-1.5 items-center">
                      <span className="w-1.5 h-1.5 bg-[var(--primary)] rounded-full animate-bounce" />
                      <span className="w-1.5 h-1.5 bg-[var(--primary)] rounded-full animate-bounce [animation-delay:0.15s]" />
                      <span className="w-1.5 h-1.5 bg-[var(--primary)] rounded-full animate-bounce [animation-delay:0.3s]" />
                    </div>
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          {/* Chat input (disabled demo) */}
          <div className="px-5 py-4 bg-[var(--surface)] border-t border-[var(--divider)]">
            <div className="relative">
              <input
                disabled
                placeholder="Ketik pertanyaanmu di sini..."
                className="w-full bg-[var(--background)] border border-[var(--divider)] rounded-full py-3.5 px-5 pr-14 text-sm font-medium opacity-50 cursor-not-allowed placeholder:text-[var(--text-light)]"
              />
              <button
                disabled
                className="absolute right-2 top-1/2 -translate-y-1/2 w-9 h-9 bg-[var(--primary)] rounded-full flex items-center justify-center text-white opacity-50"
              >
                <Send size={16} />
              </button>
            </div>
            <p className="text-center text-xs text-[var(--text-light)] mt-2 font-medium">
              Demo interaktif — download app untuk pengalaman penuh
            </p>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
