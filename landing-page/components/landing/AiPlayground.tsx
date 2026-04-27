"use client";
import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Send, Bot, User } from "lucide-react";

const DEMO_CHATS = [
  { role: "ai", text: "Halo Benjamin! Sudah siap belajar hari ini? Materi apa yang ingin kamu kuasai?" },
  { role: "user", text: "Aku bingung soal konsep Turunan di Matematika..." },
  { role: "ai", text: "Tenang, buddy! Turunan itu seperti mengukur 'kecepatan perubahan'. Bayangkan kamu sedang naik sepeda..." },
];

export default function AiPlayground() {
  const [messages, setMessages] = useState(DEMO_CHATS.slice(0, 1));
  const [isTyping, setIsTyping] = useState(false);

  useEffect(() => {
    if (messages.length === 1) {
      const timer = setTimeout(() => {
        setMessages(prev => [...prev, DEMO_CHATS[1]]);
      }, 2000);
      return () => clearTimeout(timer);
    }
    if (messages.length === 2) {
      setIsTyping(true);
      const timer = setTimeout(() => {
        setIsTyping(false);
        setMessages(prev => [...prev, DEMO_CHATS[2]]);
      }, 3000);
      return () => clearTimeout(timer);
    }
  }, [messages]);

  return (
    <section className="py-24 bg-white overflow-hidden">
      <div className="container mx-auto px-6">
        <div className="text-center mb-16">
          <h2 className="text-4xl lg:text-5xl font-black text-[var(--foreground)] mb-4">
            Test our <span className="text-[var(--primary)]">Socratic Tutor</span>
          </h2>
          <p className="text-[var(--foreground)]/60 max-w-2xl mx-auto font-medium">
            Jangan hanya percaya kata-kata kami. Rasakan sendiri bagaimana asisten belajar terpintar kami membantumu memahami materi sesulit apapun.
          </p>
        </div>

        <div className="max-w-3xl mx-auto bg-[var(--accent)]/10 rounded-3xl p-6 shadow-2xl border-4 border-[var(--foreground)]">
          <div className="h-[400px] overflow-y-auto space-y-4 mb-6 p-4">
            <AnimatePresence>
              {messages.map((msg, i) => (
                <motion.div
                  key={i}
                  initial={{ opacity: 0, y: 20, scale: 0.95 }}
                  animate={{ opacity: 1, y: 0, scale: 1 }}
                  className={`flex ${msg.role === "user" ? "justify-end" : "justify-start"}`}
                >
                  <div className={`flex gap-3 max-w-[80%] ${msg.role === "user" ? "flex-row-reverse" : ""}`}>
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center shrink-0 ${
                      msg.role === "ai" ? "bg-[var(--primary)]" : "bg-[var(--foreground)]"
                    }`}>
                      {msg.role === "ai" ? <Bot size={20} className="text-white" /> : <User size={20} className="text-white" />}
                    </div>
                    <div className={`p-4 rounded-2xl ${
                      msg.role === "ai" ? "bg-white text-[var(--foreground)]" : "bg-[var(--foreground)] text-white"
                    } shadow-md`}>
                      <p className="text-sm font-semibold">{msg.text}</p>
                    </div>
                  </div>
                </motion.div>
              ))}
              {isTyping && (
                <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="flex justify-start">
                  <div className="bg-white p-4 rounded-2xl shadow-md flex gap-1">
                    <span className="w-1.5 h-1.5 bg-[var(--primary)] rounded-full animate-bounce" />
                    <span className="w-1.5 h-1.5 bg-[var(--primary)] rounded-full animate-bounce [animation-delay:0.2s]" />
                    <span className="w-1.5 h-1.5 bg-[var(--primary)] rounded-full animate-bounce [animation-delay:0.4s]" />
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          <div className="relative">
            <input 
              disabled 
              placeholder="Type your question..." 
              className="w-full bg-white border-2 border-[var(--foreground)] rounded-full py-4 px-6 pr-14 text-sm font-bold opacity-50 cursor-not-allowed"
            />
            <button className="absolute right-2 top-2 w-10 h-10 bg-[var(--primary)] rounded-full flex items-center justify-center text-white">
              <Send size={18} />
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
