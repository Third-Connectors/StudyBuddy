import FluidHero from "@/components/landing/FluidHero";
import FeaturesSection from "@/components/landing/FeaturesSection";
import AiPlayground from "@/components/landing/AiPlayground";
import MissionSection from "@/components/landing/MissionSection";
import Link from "next/link";

export default function LandingPage() {
  return (
    <main className="min-h-screen">
      {/* ── Navbar ────────────────────────────────────────────────── */}
      <nav className="fixed top-0 left-0 w-full z-[100] px-6 py-5">
        <div className="max-w-6xl mx-auto flex justify-between items-center">
          <div className="text-xl font-extrabold text-[var(--foreground)] tracking-tight">
            Study Buddy<span className="text-[var(--primary)]">.</span>
          </div>
          <div className="flex items-center gap-3">
            <Link
              href="/login"
              className="text-sm font-bold text-[var(--text-secondary)] hover:text-[var(--foreground)] transition-colors px-4 py-2"
            >
              Login Guru
            </Link>
            <Link
              href="/register-teacher"
              className="bg-[var(--secondary)] text-white px-5 py-2.5 rounded-full font-bold text-sm hover:opacity-90 transition-opacity"
            >
              Daftar
            </Link>
          </div>
        </div>
      </nav>

      {/* ── Sections ──────────────────────────────────────────────── */}
      <FluidHero />
      <FeaturesSection />
      <AiPlayground />
      <MissionSection />

      {/* ── Footer ────────────────────────────────────────────────── */}
      <footer className="py-10 bg-[var(--background)] border-t border-[var(--divider)]">
        <div className="max-w-6xl mx-auto px-6 flex flex-col sm:flex-row justify-between items-center gap-4">
          <div className="text-sm font-bold text-[var(--foreground)]">
            Study Buddy<span className="text-[var(--primary)]">.</span>
          </div>
          <p className="text-[var(--text-light)] text-xs font-medium">
            © {new Date().getFullYear()} Study Buddy. Dibuat untuk masa depan
            pendidikan Indonesia.
          </p>
          <div className="flex gap-4">
            <Link
              href="/login"
              className="text-xs font-bold text-[var(--text-secondary)] hover:text-[var(--primary)] transition-colors"
            >
              Portal Guru
            </Link>
          </div>
        </div>
      </footer>
    </main>
  );
}
