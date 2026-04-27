import AnalyticsHeatmap from "@/components/dashboard/AnalyticsHeatmap";
import AiGenerator from "@/components/dashboard/AiGenerator";

export default function DashboardPage() {
  return (
    <div className="grid lg:grid-cols-12 gap-8 items-start">
      {/* ── Left Column: Analytics ── */}
      <div className="lg:col-span-7 space-y-8">
        <AnalyticsHeatmap />
        
        <div className="bg-[#0F172A] p-8 rounded-3xl text-white relative overflow-hidden">
          <div className="relative z-10">
            <h3 className="text-2xl font-black mb-2">Teacher Tip of the Day</h3>
            <p className="text-white/60 text-sm font-medium leading-relaxed">
              Siswa Anda paling banyak membuat kesalahan pada soal nomor #4 dan #7. Cobalah untuk mereview materi "Turunan Berantai" di pertemuan berikutnya.
            </p>
          </div>
          <div className="absolute -right-10 -bottom-10 w-40 h-40 bg-orange-500/20 rounded-full blur-3xl" />
        </div>
      </div>

      {/* ── Right Column: AI Tools ── */}
      <div className="lg:col-span-5">
        <AiGenerator />
      </div>
    </div>
  );
}
