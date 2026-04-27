import Sidebar from "@/components/dashboard/Sidebar";
import { User } from "lucide-react";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen bg-slate-50">
      <Sidebar />
      <main className="flex-1 ml-64 p-10">
        {/* ── Dashboard Header ── */}
        <header className="flex justify-between items-center mb-10">
          <div>
            <nav className="flex gap-2 text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">
              <span>Home</span>
              <span>/</span>
              <span className="text-orange-500">Dashboard</span>
            </nav>
            <h1 className="text-3xl font-black text-slate-900">Welcome back, Professor!</h1>
          </div>

          <div className="flex items-center gap-4">
            <div className="text-right">
              <p className="text-sm font-bold text-slate-900">Dr. Benjamin Šeško</p>
              <p className="text-xs font-medium text-slate-400">Senior Mathematics Teacher</p>
            </div>
            <div className="w-12 h-12 rounded-2xl bg-[#0F172A] flex items-center justify-center text-white border-4 border-white shadow-lg">
              <User size={20} />
            </div>
          </div>
        </header>

        {children}
      </main>
    </div>
  );
}
