"use client";
import AiGenerator from "@/components/dashboard/AiGenerator";

export default function GeneratorPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-extrabold text-[var(--foreground)]">
          AI Generator
        </h1>
        <p className="text-sm text-[var(--text-secondary)] font-medium mt-1">
          Buat soal dan materi pembelajaran secara instan menggunakan AI.
        </p>
      </div>
      <AiGenerator />
    </div>
  );
}
