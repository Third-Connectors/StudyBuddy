"use client";
import React, { useEffect, useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X, Smartphone, Download, AlertCircle, Apple, QrCode } from "lucide-react";

interface DownloadModalProps {
  isOpen: boolean;
  onClose: () => void;
}

type DeviceType = "android" | "ios" | "desktop";

export default function DownloadModal({ isOpen, onClose }: DownloadModalProps) {
  const [device, setDevice] = useState<DeviceType>("desktop");
  const [downloading, setDownloading] = useState(false);

  useEffect(() => {
    if (typeof window !== "undefined") {
      const ua = navigator.userAgent.toLowerCase();
      if (ua.includes("android")) {
        setDevice("android");
      } else if (ua.includes("iphone") || ua.includes("ipad") || ua.includes("ipod")) {
        setDevice("ios");
      } else {
        setDevice("desktop");
      }
    }
  }, []);

  const handleAndroidDownload = () => {
    setDownloading(true);
    // Create a temporary link to download the APK
    const link = document.createElement("a");
    link.href = "/downloads/study-buddy.apk";
    link.download = "study-buddy.apk";
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    setTimeout(() => {
      setDownloading(false);
    }, 3000);
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-[200] flex items-center justify-center p-4">
          {/* Backdrop */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="absolute inset-0 bg-black/60 backdrop-blur-md"
          />

          {/* Modal Card */}
          <motion.div
            initial={{ opacity: 0, scale: 0.95, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: 20 }}
            transition={{ type: "spring", duration: 0.5 }}
            className="relative w-full max-w-2xl bg-[var(--surface)] rounded-3xl overflow-hidden border border-[var(--divider)] shadow-2xl z-10"
          >
            {/* Soft decorative background inside modal */}
            <div className="absolute top-0 right-0 -z-10 w-[200px] h-[200px] rounded-full blur-[80px]" style={{ background: "var(--primary)", opacity: 0.08 }} />
            <div className="absolute bottom-0 left-0 -z-10 w-[200px] h-[200px] rounded-full blur-[80px]" style={{ background: "var(--accent-blue)", opacity: 0.08 }} />

            {/* Header */}
            <div className="flex justify-between items-center px-8 py-6 border-b border-[var(--divider)]">
              <div>
                <h3 className="text-xl font-extrabold text-[var(--foreground)] tracking-tight">
                  Download Study Buddy
                </h3>
                <p className="text-xs text-[var(--text-secondary)] font-medium mt-1">
                  Mulai petualangan belajarmu sekarang juga
                </p>
              </div>
              <button
                onClick={onClose}
                className="p-2 rounded-full hover:bg-[var(--background)] transition-colors text-[var(--foreground)]"
              >
                <X size={20} />
              </button>
            </div>

            {/* Content */}
            <div className="p-8 max-h-[75vh] overflow-y-auto">
              {/* Device Detected Banner */}
              <div className="flex items-center gap-3 p-4 mb-6 rounded-2xl bg-[var(--primary-lighter)] border border-[var(--primary-light)]">
                <Smartphone size={20} className="text-[var(--primary)] shrink-0" />
                <p className="text-sm font-semibold text-[var(--foreground)]">
                  Perangkat terdeteksi:{" "}
                  <span className="text-[var(--primary)] font-extrabold capitalize">
                    {device === "ios" ? "Apple iOS (iPhone/iPad)" : device === "android" ? "Android" : "Desktop / Laptop"}
                  </span>
                </p>
              </div>

              {/* Layout depending on device */}
              {device === "android" && (
                <div className="space-y-6">
                  <div className="p-6 rounded-2xl border border-[var(--divider)] bg-[var(--surface)] hover:border-[var(--primary)] transition-all">
                    <div className="flex gap-4 items-start">
                      <div className="p-4 rounded-xl bg-orange-100 text-[var(--primary)]">
                        <Download size={28} />
                      </div>
                      <div className="flex-1">
                        <h4 className="font-extrabold text-lg text-[var(--foreground)]">
                          Android APK (Direct Download)
                        </h4>
                        <p className="text-sm text-[var(--text-secondary)] font-medium mt-1">
                          Unduh dan instal langsung file APK versi terbaru di smartphone Android Anda.
                        </p>
                        <div className="flex flex-wrap gap-4 mt-3 text-xs font-semibold text-[var(--text-light)]">
                          <span>Versi: 1.0.0</span>
                          <span>•</span>
                          <span>Ukuran: ~24 MB</span>
                          <span>•</span>
                          <span>Format: .APK</span>
                        </div>
                      </div>
                    </div>

                    <button
                      onClick={handleAndroidDownload}
                      disabled={downloading}
                      className="w-full mt-6 py-4 bg-[var(--primary)] hover:opacity-90 text-white font-bold rounded-2xl transition-all shadow-md flex items-center justify-center gap-2"
                    >
                      <Download size={18} />
                      {downloading ? "Mengunduh file..." : "Unduh APK Sekarang"}
                    </button>
                  </div>

                  <div className="flex gap-2.5 p-4 rounded-xl bg-[var(--background)] border border-[var(--primary-light)] text-amber-900">
                    <AlertCircle size={18} className="shrink-0 text-[var(--primary)] mt-0.5" />
                    <p className="text-xs font-semibold leading-relaxed">
                      Jika muncul peringatan keamanan saat instalasi APK, silakan aktifkan izin <strong>&quot;Izinkan Instalasi dari Sumber Tidak Dikenal&quot;</strong> di pengaturan perangkat Anda.
                    </p>
                  </div>
                </div>
              )}

              {device === "ios" && (
                <div className="space-y-6">
                  <div className="p-6 rounded-2xl border border-[var(--divider)] bg-[var(--surface)] hover:border-amber-500 transition-all">
                    <div className="flex gap-4 items-start">
                      <div className="p-4 rounded-xl bg-amber-50 text-amber-600">
                        <Apple size={28} />
                      </div>
                      <div className="flex-1">
                        <div className="flex items-center gap-2">
                          <h4 className="font-extrabold text-lg text-[var(--foreground)]">
                            Apple iOS
                          </h4>
                          <span className="px-2 py-0.5 rounded-full bg-amber-100 text-amber-800 text-[10px] font-extrabold uppercase">
                            Dalam Pengembangan
                          </span>
                        </div>
                        <p className="text-sm text-[var(--text-secondary)] font-medium mt-1">
                          Aplikasi Study Buddy untuk versi iOS (iPhone & iPad) saat ini sedang dalam proses pengembangan intensif agar siap diluncurkan di App Store.
                        </p>
                      </div>
                    </div>

                    <div className="mt-6 p-5 rounded-xl bg-[var(--background)] border border-dashed border-[var(--divider)]">
                      <p className="text-xs text-[var(--text-secondary)] font-medium leading-relaxed">
                        Kami sedang menyempurnakan performa, animasi, dan kecerdasan asisten Socratic AI di ekosistem iOS untuk memberikan pengalaman belajar terbaik.
                      </p>
                    </div>

                    <button
                      disabled
                      className="w-full mt-6 py-4 bg-slate-100 text-slate-400 font-bold rounded-2xl transition-all flex items-center justify-center gap-2 cursor-not-allowed"
                    >
                      <Apple size={18} />
                      Segera Hadir di App Store
                    </button>
                  </div>
                </div>
              )}

              {device === "desktop" && (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {/* Android Side */}
                  <div className="p-6 rounded-2xl border border-[var(--divider)] bg-[var(--surface)] flex flex-col justify-between hover:border-[var(--primary)] transition-all">
                    <div>
                      <div className="flex items-center gap-2 mb-3">
                        <div className="p-2 rounded-lg bg-orange-100 text-[var(--primary)]">
                          <Download size={20} />
                        </div>
                        <h4 className="font-extrabold text-base text-[var(--foreground)]">
                          Android Versi
                        </h4>
                      </div>
                      <p className="text-xs text-[var(--text-secondary)] font-semibold leading-relaxed">
                        Unduh file APK langsung ke komputer Anda dan transfer ke HP, atau scan QR Code di bawah ini langsung dari HP Anda.
                      </p>
                    </div>

                    <div className="my-5 flex flex-col items-center gap-3">
                      <div className="w-32 h-32 bg-slate-100 rounded-xl flex items-center justify-center border border-[var(--divider)] relative overflow-hidden group">
                        <QrCode size={90} className="text-slate-700 group-hover:scale-105 transition-transform" />
                        <div className="absolute inset-0 bg-white/90 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                          <span className="text-[10px] font-bold text-[var(--primary)] text-center px-2">Scan untuk Download APK</span>
                        </div>
                      </div>
                      <span className="text-[10px] text-[var(--text-light)] font-bold">Android APK (v1.0.0)</span>
                    </div>

                    <button
                      onClick={handleAndroidDownload}
                      disabled={downloading}
                      className="w-full py-3 bg-[var(--primary)] hover:opacity-90 text-white font-bold rounded-xl text-sm transition-all shadow-sm flex items-center justify-center gap-2"
                    >
                      <Download size={15} />
                      {downloading ? "Mengunduh..." : "Download APK"}
                    </button>
                  </div>

                  {/* iOS Side */}
                  <div className="p-6 rounded-2xl border border-[var(--divider)] bg-[var(--surface)] flex flex-col justify-between hover:border-amber-500 transition-all">
                    <div>
                      <div className="flex items-center justify-between mb-3">
                        <div className="flex items-center gap-2">
                          <div className="p-2 rounded-lg bg-amber-50 text-amber-600">
                            <Apple size={20} />
                          </div>
                          <h4 className="font-extrabold text-base text-[var(--foreground)]">
                            iOS Versi
                          </h4>
                        </div>
                        <span className="px-2 py-0.5 rounded-full bg-amber-100 text-amber-800 text-[9px] font-extrabold uppercase">
                          Under Dev
                        </span>
                      </div>
                      <p className="text-xs text-[var(--text-secondary)] font-semibold leading-relaxed">
                        Pengembangan intensif sedang berjalan untuk menghadirkan Study Buddy secara penuh ke pengguna iPhone dan iPad dalam waktu dekat.
                      </p>
                    </div>

                    <div className="my-5 flex flex-col items-center gap-3">
                      <div className="w-32 h-32 bg-slate-50 rounded-xl flex items-center justify-center border border-[var(--divider)] relative overflow-hidden group">
                        <div className="absolute inset-0 bg-white/95 flex flex-col items-center justify-center p-3">
                          <span className="text-[20px] mb-1">⏳</span>
                          <span className="text-[10px] font-extrabold text-amber-600 text-center">Dalam Pengembangan</span>
                        </div>
                      </div>
                      <span className="text-[10px] text-[var(--text-light)] font-bold">iOS Coming Soon</span>
                    </div>

                    <button
                      disabled
                      className="w-full py-3 bg-slate-100 text-slate-400 font-bold rounded-xl text-sm transition-all flex items-center justify-center gap-2 cursor-not-allowed"
                    >
                      <Apple size={15} />
                      Segera Hadir
                    </button>
                  </div>
                </div>
              )}
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
