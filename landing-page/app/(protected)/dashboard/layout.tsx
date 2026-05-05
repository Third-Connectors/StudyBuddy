import Sidebar from "@/components/dashboard/Sidebar";
import { User, Bell } from "lucide-react";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen bg-[var(--background)]">
      <Sidebar />
      <main className="flex-1 ml-[260px]">
        {/* ── Top Header Bar ── */}
        <header className="sticky top-0 z-40 bg-[var(--background)]/80 backdrop-blur-xl border-b border-[var(--divider)]/50">
          <div className="flex justify-between items-center px-8 py-4">
            <div>
              <p className="text-xs font-bold text-[var(--text-light)] uppercase tracking-[0.15em]">
                Teacher Portal
              </p>
            </div>

            <div className="flex items-center gap-3">
              {/* Notification bell */}
              <button className="relative w-10 h-10 rounded-xl bg-[var(--surface)] border border-[var(--divider)] flex items-center justify-center text-[var(--text-secondary)] hover:text-[var(--primary)] transition-colors">
                <Bell size={18} />
                <span className="absolute -top-0.5 -right-0.5 w-2.5 h-2.5 bg-[var(--primary)] rounded-full border-2 border-[var(--background)]" />
              </button>

              {/* Avatar */}
              <div className="flex items-center gap-3 pl-3 border-l border-[var(--divider)]">
                <div className="text-right">
                  <p className="text-sm font-bold text-[var(--foreground)]">
                    Guru Study Buddy
                  </p>
                  <p className="text-[11px] font-medium text-[var(--text-light)]">
                    Matematika
                  </p>
                </div>
                <div className="w-10 h-10 rounded-xl bg-[var(--secondary)] flex items-center justify-center text-white">
                  <User size={18} />
                </div>
              </div>
            </div>
          </div>
        </header>

        {/* ── Content ── */}
        <div className="p-8">{children}</div>
      </main>
    </div>
  );
}
