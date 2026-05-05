"use client";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import {
  LayoutDashboard,
  BookOpen,
  Users,
  BarChart3,
  Sparkles,
  LogOut,
  ChevronRight,
} from "lucide-react";
import { cn } from "@/lib/utils";
import { supabase } from "@/lib/supabase";

const NAV_ITEMS = [
  { icon: LayoutDashboard, label: "Overview", href: "/dashboard" },
  { icon: BookOpen, label: "Bank Soal", href: "/dashboard/bank-soal" },
  { icon: Sparkles, label: "AI Generator", href: "/dashboard/generator" },
  { icon: BarChart3, label: "Analytics", href: "/dashboard/analytics" },
  { icon: Users, label: "Daftar Siswa", href: "/dashboard/students" },
];

export default function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();

  const handleSignOut = async () => {
    await supabase.auth.signOut();
    router.push("/login");
  };

  return (
    <div className="w-[260px] h-screen bg-[var(--foreground)] text-white flex flex-col fixed left-0 top-0 z-50">
      {/* Logo */}
      <div className="px-7 pt-8 pb-6">
        <Link href="/dashboard" className="block">
          <h2 className="text-lg font-extrabold tracking-tight">
            Study Buddy
            <span className="text-[var(--primary)]">.</span>
          </h2>
          <p className="text-[10px] font-bold text-white/30 uppercase tracking-[0.2em] mt-0.5">
            Teacher Portal
          </p>
        </Link>
      </div>

      {/* Navigation */}
      <nav className="flex-1 px-4 space-y-1">
        <p className="text-[10px] font-bold text-white/20 uppercase tracking-[0.2em] px-3 mb-3">
          Menu
        </p>
        {NAV_ITEMS.map((item) => {
          const isActive =
            pathname === item.href ||
            (item.href !== "/dashboard" && pathname?.startsWith(item.href));
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group relative",
                isActive
                  ? "bg-[var(--primary)] text-white shadow-lg shadow-[var(--primary)]/20"
                  : "text-white/50 hover:bg-white/[0.06] hover:text-white/80"
              )}
            >
              <item.icon
                size={18}
                className={cn(
                  "shrink-0 transition-colors",
                  isActive
                    ? "text-white"
                    : "text-white/30 group-hover:text-[var(--primary)]"
                )}
              />
              <span className="font-bold text-[13px]">{item.label}</span>
              {isActive && (
                <ChevronRight size={14} className="ml-auto text-white/60" />
              )}
            </Link>
          );
        })}
      </nav>

      {/* Bottom */}
      <div className="p-4 border-t border-white/[0.06]">
        <button
          onClick={handleSignOut}
          className="flex items-center gap-3 px-4 py-3 w-full text-white/30 hover:text-red-400 transition-colors rounded-xl hover:bg-white/[0.04]"
        >
          <LogOut size={18} />
          <span className="font-bold text-[13px]">Keluar</span>
        </button>
      </div>
    </div>
  );
}
