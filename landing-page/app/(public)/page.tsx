import FluidHero from "@/components/landing/FluidHero";
import AiPlayground from "@/components/landing/AiPlayground";
import SdgSection from "@/components/landing/SdgSection";

export default function LandingPage() {
  return (
    <main className="min-h-screen">
      {/* Navbar (Mini) */}
      <nav className="fixed top-0 left-0 w-full z-[100] px-6 py-8 flex justify-between items-center pointer-events-none">
        <div className="text-2xl font-black text-[var(--foreground)] pointer-events-auto">STUDY BUDDY.</div>
        <button className="bg-[var(--secondary)] text-white px-6 py-2 rounded-full font-bold text-sm pointer-events-auto hover:scale-105 transition-transform">
          Get Started
        </button>
      </nav>

      <FluidHero />
      <AiPlayground />
      <SdgSection />

      {/* Footer */}
      <footer className="py-12 bg-[var(--background)] border-t border-[var(--foreground)]/5 text-center">
        <p className="text-[var(--foreground)]/40 text-sm font-bold uppercase tracking-widest">
          © 2026 Study Buddy AI. Built for the future of education.
        </p>
      </footer>
    </main>
  );
}
