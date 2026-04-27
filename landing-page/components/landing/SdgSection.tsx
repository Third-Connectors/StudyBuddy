import { motion } from "framer-motion";
import { Heart, GraduationCap, Globe, Zap } from "lucide-react";

const SDG_DATA = [
  {
    icon: <GraduationCap size={32} />,
    title: "SDG 4: Quality Education",
    desc: "Demokratisasi akses pendidikan berkualitas tinggi melalui tutor AI personal yang tersedia bagi siapa saja, di mana saja.",
    color: "bg-blue-50",
    iconColor: "text-blue-600",
  },
  {
    icon: <Heart size={32} />,
    title: "SDG 3: Well-being",
    desc: "Membantu mengurangi kecemasan belajar dengan pendekatan Socratic yang sabar, empati, dan tidak menghakimi.",
    color: "bg-rose-50",
    iconColor: "text-rose-600",
  },
];

export default function SdgSection() {
  return (
    <section className="py-24 bg-[var(--secondary)] text-white">
      <div className="container mx-auto px-6">
        <div className="flex flex-col lg:flex-row gap-16 items-center">
          <div className="lg:w-1/2">
            <h2 className="text-4xl lg:text-6xl font-black mb-8 leading-tight">
              Lebih Dari Sekadar<br />
              <span className="text-[var(--primary)]">Aplikasi Belajar.</span>
            </h2>
            <p className="text-white/70 text-lg font-medium max-w-xl leading-relaxed">
              Study Buddy didesain dengan misi global. Kami percaya bahwa teknologi tercanggih harus digunakan untuk menyelesaikan masalah fundamental manusia.
            </p>
            
            <div className="mt-12 flex gap-8">
               <div className="flex flex-col items-center">
                 <span className="text-4xl font-black text-[var(--primary)]">10K+</span>
                 <span className="text-sm text-white/50 uppercase font-bold tracking-widest">Siswa</span>
               </div>
               <div className="flex flex-col items-center">
                 <span className="text-4xl font-black text-[var(--primary)]">98%</span>
                 <span className="text-sm text-white/50 uppercase font-bold tracking-widest">Kepuasan</span>
               </div>
            </div>
          </div>

          <div className="lg:w-1/2 grid sm:grid-cols-2 gap-6">
            {SDG_DATA.map((item, i) => (
              <div 
                key={i}
                className="p-8 rounded-3xl bg-white/5 border border-white/10 hover:bg-white/10 transition-colors group"
              >
                <div className={`w-16 h-16 rounded-2xl flex items-center justify-center mb-6 transition-transform group-hover:scale-110 group-hover:rotate-6 ${item.iconColor} bg-white/10`}>
                  {item.icon}
                </div>
                <h3 className="text-xl font-bold mb-3">{item.title}</h3>
                <p className="text-white/50 text-sm leading-relaxed">{item.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
