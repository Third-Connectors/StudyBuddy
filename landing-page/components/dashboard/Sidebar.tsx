"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { 
  LayoutDashboard, 
  BookOpen, 
  Users, 
  BarChart3, 
  Settings, 
  PlusCircle,
  LogOut
} from "lucide-react";
import { cn } from "@/lib/utils";

const NAV_ITEMS = [
  { icon: LayoutDashboard, label: "Overview", href: "/dashboard" },
  { icon: BookOpen, label: "Bank Soal", href: "/dashboard/bank-soal" },
  { icon: PlusCircle, label: "AI Generator", href: "/dashboard/generator" },
  { icon: BarChart3, label: "Analytics", href: "/dashboard/analytics" },
  { icon: Users, label: "Daftar Siswa", href: "/dashboard/students" },
];

export default function Sidebar() {
  const pathname = usePathname();

  return (
    <div className="w-64 h-screen bg-[#0F172A] text-white flex flex-col fixed left-0 top-0 z-50">
      <div className="p-8">
        <h2 className="text-xl font-black tracking-tighter">STUDY BUDDY<br/><span className="text-[#F97316]">TEACHER.</span></h2>
      </div>

      <nav className="flex-1 px-4 space-y-1">
        {NAV_ITEMS.map((item) => {
          const isActive = pathname === item.href;
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group",
                isActive 
                  ? "bg-[#F97316] text-white" 
                  : "text-white/60 hover:bg-white/5 hover:text-white"
              )}
            >
              <item.icon size={20} className={cn(isActive ? "text-white" : "text-white/40 group-hover:text-[#F97316]")} />
              <span className="font-bold text-sm">{item.label}</span>
            </Link>
          );
        })}
      </nav>

      <div className="p-6 border-t border-white/5">
        <button className="flex items-center gap-3 px-4 py-3 w-full text-white/40 hover:text-red-400 transition-colors">
          <LogOut size={20} />
          <span className="font-bold text-sm">Sign Out</span>
        </button>
      </div>
    </div>
  );
}
