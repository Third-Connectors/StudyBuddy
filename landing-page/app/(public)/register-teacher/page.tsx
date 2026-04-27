"use client";
import { useState } from "react";
import { motion } from "framer-motion";
import { supabase } from "@/lib/supabase";
import { useRouter } from "next/navigation";
import { GraduationCap, Mail, Lock, User, ArrowRight, CheckCircle2 } from "lucide-react";
import Link from "next/link";

export default function RegisterTeacherPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [fullName, setFullName] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);
  const router = useRouter();

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      // 1. Sign up user
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            full_name: fullName,
          }
        }
      });

      if (authError) throw authError;

      if (authData.user) {
        // 2. Update profile with role 'teacher'
        // We use an update because the trigger might have already created the profile
        const { error: profileError } = await supabase
          .from('profiles')
          .update({ 
            name: fullName,
            role: 'teacher' 
          })
          .eq('id', authData.user.id);

        if (profileError) throw profileError;

        setSuccess(true);
        setTimeout(() => {
          router.push("/dashboard");
        }, 2000);
      }
    } catch (err: any) {
      setError(err.message || "Terjadi kesalahan saat mendaftar");
    } finally {
      setLoading(false);
    }
  };

  if (success) {
    return (
      <div className="min-h-screen bg-[var(--background)] flex items-center justify-center px-6">
        <motion.div 
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          className="text-center max-w-md"
        >
          <div className="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-6">
            <CheckCircle2 size={40} className="text-orange-600" />
          </div>
          <h2 className="text-3xl font-black text-[var(--foreground)] mb-4">Pendaftaran Terkirim!</h2>
          <p className="text-slate-600 mb-8 font-medium leading-relaxed">
            Terima kasih telah mendaftar sebagai Enterprise Partner. Akun Anda saat ini dalam status <strong>Pending</strong>. 
            Mohon tunggu email konfirmasi setelah Admin menyetujui akses Anda.
          </p>
          <Link href="/" className="inline-block bg-[var(--foreground)] text-white px-8 py-4 rounded-2xl font-bold">
            Kembali ke Beranda
          </Link>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[var(--background)] grid lg:grid-cols-2">
      {/* Left: Branding/Info */}
      <div className="hidden lg:flex bg-[var(--secondary)] p-12 flex-col justify-between text-white relative overflow-hidden">
        <div className="relative z-10">
          <Link href="/" className="text-2xl font-black tracking-tighter">STUDY BUDDY.</Link>
          <div className="mt-24">
            <div className="w-16 h-16 bg-[var(--primary)] rounded-2xl flex items-center justify-center mb-8 rotate-3">
              <GraduationCap size={32} className="text-white" />
            </div>
            <h1 className="text-5xl font-black leading-tight mb-6">
              Bantu Siswa <br />
              Dunia dengan <br />
              <span className="text-[var(--primary)]">Keahlian Anda.</span>
            </h1>
            <p className="text-white/70 text-lg max-w-md font-medium leading-relaxed">
              Bergabunglah dengan ribuan pendidik lainnya untuk membangun bank soal AI dan memantau perkembangan siswa secara realtime.
            </p>
          </div>
        </div>

        <div className="relative z-10">
          <p className="text-sm font-bold uppercase tracking-widest text-white/40">© 2026 Study Buddy For Educators</p>
        </div>

        {/* Abstract shapes */}
        <div className="absolute -bottom-20 -left-20 w-80 h-80 bg-[var(--primary)] opacity-10 blur-[100px] rounded-full" />
        <div className="absolute top-40 -right-20 w-60 h-60 bg-blue-400 opacity-10 blur-[80px] rounded-full" />
      </div>

      {/* Right: Form */}
      <div className="flex items-center justify-center p-8 lg:p-12">
        <div className="w-full max-w-md">
          <div className="mb-10">
            <h2 className="text-3xl font-black text-[var(--foreground)] mb-2">Daftar Akun Guru</h2>
            <p className="text-slate-500 font-medium">Lengkapi data di bawah untuk mulai mengajar.</p>
          </div>

          <form onSubmit={handleRegister} className="space-y-6">
            <div>
              <label className="block text-sm font-bold text-[var(--foreground)] mb-2 uppercase tracking-wide">Nama Lengkap</label>
              <div className="relative">
                <User className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
                <input 
                  required
                  type="text" 
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  placeholder="Contoh: Dr. Benjamin S."
                  className="w-full bg-slate-50 border-2 border-slate-100 rounded-2xl py-4 px-12 text-sm font-bold focus:border-[var(--primary)] focus:bg-white transition-all outline-none"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-bold text-[var(--foreground)] mb-2 uppercase tracking-wide">Email Institusi</label>
              <div className="relative">
                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
                <input 
                  required
                  type="email" 
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="nama@sekolah.sch.id"
                  className="w-full bg-slate-50 border-2 border-slate-100 rounded-2xl py-4 px-12 text-sm font-bold focus:border-[var(--primary)] focus:bg-white transition-all outline-none"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-bold text-[var(--foreground)] mb-2 uppercase tracking-wide">Password</label>
              <div className="relative">
                <Lock className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
                <input 
                  required
                  type="password" 
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Min. 8 karakter"
                  className="w-full bg-slate-50 border-2 border-slate-100 rounded-2xl py-4 px-12 text-sm font-bold focus:border-[var(--primary)] focus:bg-white transition-all outline-none"
                />
              </div>
            </div>

            {error && (
              <div className="bg-red-50 text-red-600 p-4 rounded-2xl text-sm font-bold border border-red-100">
                ⚠️ {error}
              </div>
            )}

            <button 
              type="submit"
              disabled={loading}
              className="w-full bg-[var(--foreground)] text-white rounded-2xl py-5 font-bold text-lg hover:bg-[var(--secondary)] transition-all shadow-xl shadow-slate-200 flex items-center justify-center gap-3 disabled:opacity-50"
            >
              {loading ? "Memproses..." : (
                <>
                  Daftar Sekarang <ArrowRight size={20} />
                </>
              )}
            </button>
          </form>

          <div className="mt-12 text-center">
            <p className="text-slate-500 font-medium text-sm">
              Sudah punya akun guru? <Link href="/login" className="text-[var(--primary)] font-bold hover:underline">Masuk di sini</Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
