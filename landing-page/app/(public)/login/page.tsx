"use client";
import { useState } from "react";
import { motion } from "framer-motion";
import { supabase } from "@/lib/supabase";
import { useRouter } from "next/navigation";
import { Mail, Lock, ArrowRight, LogIn } from "lucide-react";
import Link from "next/link";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      const { data, error: authError } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (authError) throw authError;

      if (data.user) {
        // Cek profile untuk status approval
        const { data: profile, error: profileError } = await supabase
          .from('profiles')
          .select('role, status')
          .eq('id', data.user.id)
          .single();

        if (profileError) throw profileError;

        if (profile.role === 'teacher') {
          if (profile.status !== 'approved') {
            await supabase.auth.signOut();
            setError("Akun Anda sedang dalam peninjauan. Mohon tunggu persetujuan admin (Enterprise Approval).");
            return;
          }
          router.push("/dashboard");
        } else {
          // Jika siswa mencoba login di web, arahkan ke aplikasi (atau biarkan masuk profil)
          router.push("/");
        }
      }
    } catch (err: any) {
      setError(err.message || "Gagal masuk. Cek email dan password Anda.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[var(--background)] flex items-center justify-center px-6">
      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md bg-white p-10 rounded-[2.5rem] shadow-2xl border-4 border-[var(--foreground)]"
      >
        <div className="text-center mb-10">
          <Link href="/" className="text-2xl font-black tracking-tighter text-[var(--foreground)]">STUDY BUDDY.</Link>
          <h2 className="text-3xl font-black mt-8 text-[var(--foreground)]">Selamat Datang</h2>
          <p className="text-slate-500 font-medium mt-2 text-sm uppercase tracking-widest">Portal Pendidik</p>
        </div>

        <form onSubmit={handleLogin} className="space-y-6">
          <div>
            <label className="block text-sm font-bold text-[var(--foreground)] mb-2 uppercase tracking-wide">Email</label>
            <div className="relative">
              <Mail className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
              <input 
                required
                type="email" 
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="nama@institusi.id"
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
                placeholder="Masukkan password Anda"
                className="w-full bg-slate-50 border-2 border-slate-100 rounded-2xl py-4 px-12 text-sm font-bold focus:border-[var(--primary)] focus:bg-white transition-all outline-none"
              />
            </div>
          </div>

          {error && (
            <div className="bg-orange-50 text-orange-700 p-4 rounded-2xl text-xs font-bold border border-orange-100 leading-relaxed">
              ⚠️ {error}
            </div>
          )}

          <button 
            type="submit"
            disabled={loading}
            className="w-full bg-[var(--foreground)] text-white rounded-2xl py-5 font-bold text-lg hover:bg-[var(--secondary)] transition-all shadow-xl shadow-slate-200 flex items-center justify-center gap-3 disabled:opacity-50"
          >
            {loading ? "Menghubungkan..." : (
              <>
                Masuk ke Dashboard <LogIn size={20} />
              </>
            )}
          </button>
        </form>

        <div className="mt-10 text-center">
          <p className="text-slate-500 font-medium text-sm">
            Belum punya akun Enterprise? <Link href="/register-teacher" className="text-[var(--primary)] font-bold hover:underline">Daftar di sini</Link>
          </p>
        </div>
      </motion.div>
    </div>
  );
}
