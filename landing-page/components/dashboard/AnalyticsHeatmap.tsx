"use client";
import { TrendingUp, AlertTriangle, CheckCircle2 } from "lucide-react";

const PERFORMANCE_DATA = Array.from({ length: 20 }, (_, i) => ({
  id: i + 1,
  score: Math.floor(Math.random() * 100),
}));

export default function AnalyticsHeatmap() {
  return (
    <div className="bg-white p-8 rounded-3xl shadow-sm border border-slate-200">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h3 className="font-bold text-slate-900 text-xl">Student Performance Heatmap</h3>
          <p className="text-sm text-slate-500 font-medium">Visualisasi tingkat keberhasilan siswa per soal.</p>
        </div>
        <div className="flex items-center gap-2 px-4 py-2 bg-slate-50 rounded-xl border border-slate-100">
          <TrendingUp size={16} className="text-green-500" />
          <span className="text-sm font-bold text-slate-700">Overall Accuracy: 78%</span>
        </div>
      </div>

      <div className="grid grid-cols-5 md:grid-cols-10 gap-3">
        {PERFORMANCE_DATA.map((data) => {
          let bgColor = "bg-green-500";
          if (data.score < 40) bgColor = "bg-red-500";
          else if (data.score < 70) bgColor = "bg-yellow-500";

          return (
            <div 
              key={data.id}
              className="group relative flex flex-col items-center"
            >
              <div className={`w-full aspect-square rounded-xl ${bgColor} opacity-80 hover:opacity-100 transition-opacity cursor-pointer flex items-center justify-center text-white font-bold text-sm shadow-sm`}>
                {data.id}
              </div>
              
              {/* Tooltip */}
              <div className="absolute bottom-full mb-2 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none z-10 w-32">
                <div className="bg-slate-900 text-white text-[10px] p-2 rounded-lg shadow-xl text-center font-bold">
                  Question #{data.id}<br/>
                  Success: {data.score}%
                </div>
                <div className="w-2 h-2 bg-slate-900 rotate-45 mx-auto -mt-1" />
              </div>
            </div>
          );
        })}
      </div>

      <div className="mt-10 grid grid-cols-2 gap-4">
        <div className="p-6 bg-red-50 border border-red-100 rounded-2xl flex gap-4 items-center">
          <div className="w-12 h-12 rounded-xl bg-red-500 flex items-center justify-center text-white">
            <AlertTriangle size={24} />
          </div>
          <div>
            <p className="text-xs font-bold text-red-400 uppercase tracking-widest">Most Failed Topic</p>
            <h4 className="text-lg font-black text-red-900 leading-none">Turunan Trigonometri</h4>
          </div>
        </div>
        <div className="p-6 bg-green-50 border border-green-100 rounded-2xl flex gap-4 items-center">
          <div className="w-12 h-12 rounded-xl bg-green-500 flex items-center justify-center text-white">
            <CheckCircle2 size={24} />
          </div>
          <div>
            <p className="text-xs font-bold text-green-400 uppercase tracking-widest">Mastered Topic</p>
            <h4 className="text-lg font-black text-green-900 leading-none">Limit Fungsi Aljabar</h4>
          </div>
        </div>
      </div>
    </div>
  );
}
