import React from 'react';
import { X, BookOpen, Layers, CheckCircle } from 'lucide-react';

/**
 * DocsModal component
 * Provides technical documentation and mathematical specifications:
 * - 21 Landmark Hand Topology
 * - Normalization & Euclidean Metric
 * - Hard-gate false-positive rejection filters
 */
export default function DocsModal({ isOpen, onClose }) {
  if (!isOpen) return null;

  return (
    <div
      role="dialog"
      aria-modal="true"
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200"
    >
      <div className="relative w-full max-w-2xl rounded-[20px] bg-[#ffffff] border border-[#e3e3e2] shadow-2xl overflow-hidden flex flex-col max-h-[85vh]">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-[#e3e3e2] bg-[#fbf9f5]">
          <div className="flex items-center gap-2.5">
            <BookOpen className="w-5 h-5 text-[#421d24]" />
            <h3 className="font-w540 text-base text-[#292827]">
              Dokumentasi Spesifikasi Teknis BISINDO AI
            </h3>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="p-1.5 rounded-lg text-[#666666] hover:text-[#292827] hover:bg-black/5 cursor-pointer"
            aria-label="Tutup Dokumentasi"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Content */}
        <div className="p-6 overflow-y-auto space-y-6 text-sm text-[#292827]">
          {/* Section 1: Topologi Landmark */}
          <div>
            <h4 className="font-w700 text-base text-[#421d24] mb-2 flex items-center gap-2">
              <Layers className="w-4 h-4 text-[#714cb6]" />
              Topologi 21 Titik Landmark Tangan (MediaPipe Hands)
            </h4>
            <p className="text-xs text-[#666666] leading-relaxed mb-3">
              Setiap frame video kamera diekstraksi menjadi 21 titik koordinat 3D ternormalisasi (x, y, z):
            </p>
            <div className="bg-[#f2f0eb] p-3 rounded-xl border border-[#e3e3e2] font-mono text-xs space-y-1 text-[#292827]">
              <div>• 0: Wrist (Pangkal Pergelangan Tangan)</div>
              <div>• 1 - 4: Thumb (CMC, MCP, IP, Tip)</div>
              <div>• 5 - 8: Index Finger (MCP, PIP, DIP, Tip)</div>
              <div>• 9 - 12: Middle Finger (MCP, PIP, DIP, Tip)</div>
              <div>• 13 - 16: Ring Finger (MCP, PIP, DIP, Tip)</div>
              <div>• 17 - 20: Pinky Finger (MCP, PIP, DIP, Tip)</div>
            </div>
          </div>

          {/* Section 2: Normalisasi Skala Invarian */}
          <div>
            <h4 className="font-w700 text-base text-[#421d24] mb-2">
              Normalisasi Jarak & Rasio Kurvatur
            </h4>
            <p className="text-xs text-[#666666] leading-relaxed mb-3">
              Untuk mengatasi perbedaan ukuran tangan pengguna dan jarak relatif terhadap lensa kamera, seluruh jarak euclidean dinormalisasi terhadap panjang telapak tangan:
            </p>
            <div className="p-3 bg-[#fbf9f5] rounded-lg border border-[#e3e3e2] font-mono text-xs text-[#0c4243]">
              PalmSize = ||Landmark[9] - Landmark[0]|| (Wrist ke Middle MCP)
              <br />
              NormalizedDist(A, B) = ||Landmark[A] - Landmark[B]|| / PalmSize
            </div>
          </div>

          {/* Section 3: Hard-gate False Positive Filters */}
          <div>
            <h4 className="font-w700 text-base text-[#421d24] mb-2">
              Filter Hard-Gate Pencegah False-Positive
            </h4>
            <p className="text-xs text-[#666666] leading-relaxed mb-3">
              Sistem menyertakan gerbang logika deterministik sebelum klasifikasi kurva:
            </p>
            <ul className="space-y-2 text-xs text-[#292827]">
              <li className="flex items-start gap-2">
                <CheckCircle className="w-4 h-4 text-[#0c4243] shrink-0 mt-0.5" />
                <span><strong>isThumbsUp:</strong> Menolak jempol acung agar tidak salah terbaca sebagai gestur huruf C atau L.</span>
              </li>
              <li className="flex items-start gap-2">
                <CheckCircle className="w-4 h-4 text-[#0c4243] shrink-0 mt-0.5" />
                <span><strong>isFist:</strong> Menolak kepalan tangan tertutup penuh saat transisi gerakan.</span>
              </li>
              <li className="flex items-start gap-2">
                <CheckCircle className="w-4 h-4 text-[#0c4243] shrink-0 mt-0.5" />
                <span><strong>Temporal Debounce:</strong> Buffer pembacaan stabil selama 300 milidetik sebelum karakter ditambahkan ke kalimat.</span>
              </li>
            </ul>
          </div>
        </div>

        {/* Footer */}
        <div className="px-6 py-3 border-t border-[#e3e3e2] bg-[#fbf9f5] flex justify-end">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 rounded-lg bg-[#421d24] text-white text-xs font-w540 hover:bg-[#34161c] cursor-pointer"
          >
            Selesai Membaca
          </button>
        </div>
      </div>
    </div>
  );
}

