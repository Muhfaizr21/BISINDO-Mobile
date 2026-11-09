import React, { useState } from 'react';
import { 
  Code2, 
  Terminal, 
  Layers, 
  Cpu, 
  Copy, 
  Check, 
  FileCode, 
  ExternalLink,
  ShieldCheck,
  Zap
} from 'lucide-react';

/**
 * DocumentationSection component
 * Dedicated on-page documentation target for #dokumentasi:
 * - Direct anchor target for Navbar link
 * - Architectural technical overview: 21 Landmarks, API Contracts, Logic Filters
 * - Follows DESIGN.md specifications & antislop guidelines
 */
export default function DocumentationSection({ onOpenDocs }) {
  const [activeTab, setActiveTab] = useState('landmarks');
  const [copied, setCopied] = useState(false);

  const apiSnippet = `// POST /api/v1/history/save
// Request Payload (JSON)
{
  "recognized_text": "SAYA BAIK",
  "confidence_score": 0.984,
  "landmark_count": 21,
  "inference_latency_ms": 14.2,
  "client_timestamp": "2026-11-09T23:00:00Z"
}

// Response 200 OK
{
  "status": "success",
  "data": {
    "session_id": "bisindo-sess-9210",
    "saved_at": "2026-11-09T23:00:01Z",
    "audio_synthesized": true
  }
}`;

  const handleCopyCode = () => {
    navigator.clipboard.writeText(apiSnippet);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <section id="dokumentasi" className="w-full py-20 md:py-28 bg-[#f2f0eb] border-t border-[#e3e3e2]">
      <div className="max-w-[1200px] mx-auto px-4 md:px-8">
        {/* Section Heading */}
        <div className="max-w-3xl mb-12">
          <div className="inline-flex items-center gap-2 text-xs font-w540 uppercase tracking-widest text-[#714cb6] mb-3">
            <FileCode className="w-3.5 h-3.5" />
            Dokumentasi &amp; Spesifikasi Teknis
          </div>
          <h2 className="text-3xl sm:text-4xl md:text-[48px] leading-[1.05] font-w460 tracking-tight text-[#292827] mb-4">
            Arsitektur Terbuka, Siap Diintegrasikan
          </h2>
          <p className="text-base md:text-lg text-[#666666] font-w460 leading-relaxed">
            Seluruh spesifikasi matematika ekstraksi landmark, filter hard-gate logika, hingga endpoint API backend Golang dirancang transparan untuk pengembangan inklusif.
          </p>
        </div>

        {/* Documentation Tab Nav */}
        <div className="flex border-b border-[#e3e3e2] mb-8 overflow-x-auto">
          <button
            type="button"
            onClick={() => setActiveTab('landmarks')}
            className={`pb-3 px-4 text-sm md:text-base font-w540 cursor-pointer border-b-2 transition-all whitespace-nowrap ${
              activeTab === 'landmarks'
                ? 'border-[#292827] text-[#292827]'
                : 'border-transparent text-[#666666] hover:text-[#292827]'
            }`}
          >
            Topologi 21 Landmark Tangan
          </button>
          <button
            type="button"
            onClick={() => setActiveTab('api')}
            className={`pb-3 px-4 text-sm md:text-base font-w540 cursor-pointer border-b-2 transition-all whitespace-nowrap ${
              activeTab === 'api'
                ? 'border-[#292827] text-[#292827]'
                : 'border-transparent text-[#666666] hover:text-[#292827]'
            }`}
          >
            Kontrak REST API &amp; SDK
          </button>
          <button
            type="button"
            onClick={() => setActiveTab('filters')}
            className={`pb-3 px-4 text-sm md:text-base font-w540 cursor-pointer border-b-2 transition-all whitespace-nowrap ${
              activeTab === 'filters'
                ? 'border-[#292827] text-[#292827]'
                : 'border-transparent text-[#666666] hover:text-[#292827]'
            }`}
          >
            Hard-Gate Anti False-Positive
          </button>
        </div>

        {/* Tab 1: Topologi Landmark */}
        {activeTab === 'landmarks' && (
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            <div className="lg:col-span-7 bg-white rounded-[16px] border border-[#e3e3e2] p-6 md:p-8">
              <h3 className="text-xl font-w700 text-[#292827] mb-3 flex items-center gap-2">
                <Layers className="w-5 h-5 text-[#714cb6]" />
                Pemetaan 21 Titik Spasial 3D
              </h3>
              <p className="text-sm text-[#666666] leading-relaxed mb-6 font-w460">
                Model mengekstraksi koordinat X, Y, dan Z pada setiap sendi jari tangan manusia secara kontinu pada 60 frame per detik:
              </p>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                <div className="p-3.5 rounded-xl bg-[#f2f0eb] border border-[#e3e3e2]">
                  <span className="font-w700 text-[#292827] block mb-1">0 : Pergelangan (Wrist)</span>
                  <span className="text-[#666666]">Titik pangkal referensi orientasi telapak tangan.</span>
                </div>
                <div className="p-3.5 rounded-xl bg-[#f2f0eb] border border-[#e3e3e2]">
                  <span className="font-w700 text-[#292827] block mb-1">1 - 4 : Ibu Jari (Thumb)</span>
                  <span className="text-[#666666]">CMC, MCP, IP, dan Ujung Jempol (Tip).</span>
                </div>
                <div className="p-3.5 rounded-xl bg-[#f2f0eb] border border-[#e3e3e2]">
                  <span className="font-w700 text-[#292827] block mb-1">5 - 8 : Telunjuk (Index)</span>
                  <span className="text-[#666666]">MCP, PIP, DIP, dan Ujung Telunjuk.</span>
                </div>
                <div className="p-3.5 rounded-xl bg-[#f2f0eb] border border-[#e3e3e2]">
                  <span className="font-w700 text-[#292827] block mb-1">9 - 12 : Jari Tengah</span>
                  <span className="text-[#666666]">MCP referensi normalisasi ukuran telapak tangan.</span>
                </div>
                <div className="p-3.5 rounded-xl bg-[#f2f0eb] border border-[#e3e3e2]">
                  <span className="font-w700 text-[#292827] block mb-1">13 - 16 : Jari Manis</span>
                  <span className="text-[#666666]">Pendeteksi lekukan gestur kurva dan kepalan.</span>
                </div>
                <div className="p-3.5 rounded-xl bg-[#f2f0eb] border border-[#e3e3e2]">
                  <span className="font-w700 text-[#292827] block mb-1">17 - 20 : Kelingking</span>
                  <span className="text-[#666666]">Penjaga kestabilan gestur huruf Y dan I.</span>
                </div>
              </div>
            </div>

            <div className="lg:col-span-5 bg-white rounded-[16px] border border-[#e3e3e2] p-6 md:p-8 flex flex-col justify-between">
              <div>
                <h4 className="text-base font-w700 text-[#292827] mb-2 flex items-center gap-2">
                  <Zap className="w-4 h-4 text-[#0c4243]" />
                  Metrik Invarian Skala
                </h4>
                <p className="text-xs text-[#666666] leading-relaxed mb-4">
                  Setiap jarak Euclidean dibagi dengan panjang dasar telapak tangan (PalmSize), sehingga akurasi tetap stabil saat pengguna mendekat atau menjauh dari lensa kamera:
                </p>

                <div className="p-4 rounded-xl bg-[#1b1938] text-white font-mono text-xs mb-4">
                  <div className="text-white/50 mb-1">// Rumus Normalisasi</div>
                  <div className="text-[#d4c7ff]">
                    PalmSize = ||P[9] - P[0]||
                  </div>
                  <div className="text-white mt-1">
                    NormalizedDist(A, B) = ||P[A] - P[B]|| / PalmSize
                  </div>
                </div>
              </div>

              <button
                type="button"
                onClick={onOpenDocs}
                className="w-full text-center py-2.5 rounded-lg border border-[#292827] text-sm font-w540 text-[#292827] hover:bg-[#f2f0eb] transition-colors cursor-pointer"
              >
                Lihat Spesifikasi Matematika Lengkap
              </button>
            </div>
          </div>
        )}

        {/* Tab 2: API Contract */}
        {activeTab === 'api' && (
          <div className="bg-white rounded-[16px] border border-[#e3e3e2] p-6 md:p-8">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-4 pb-4 border-b border-[#e3e3e2]">
              <div>
                <h3 className="text-lg font-w700 text-[#292827] flex items-center gap-2">
                  <Terminal className="w-4 h-4 text-[#714cb6]" />
                  Sinkronisasi Riwayat dan Pembelajaran
                </h3>
                <p className="text-xs text-[#666666] mt-0.5">
                  Backend Golang REST API melayani sinkronisasi data riwayat dan materi belajar secara asinkron.
                </p>
              </div>

              <button
                type="button"
                onClick={handleCopyCode}
                className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-[#e3e3e2] text-xs font-w500 text-[#292827] hover:bg-black/5 cursor-pointer self-start"
              >
                {copied ? <Check className="w-3.5 h-3.5 text-[#0c4243]" /> : <Copy className="w-3.5 h-3.5" />}
                <span>{copied ? 'Tersalin' : 'Salin JSON'}</span>
              </button>
            </div>

            <pre className="p-4 md:p-6 rounded-xl bg-[#1b1938] text-white font-mono text-xs md:text-sm overflow-x-auto leading-relaxed">
              <code>{apiSnippet}</code>
            </pre>
          </div>
        )}

        {/* Tab 3: Hard-gate Filters */}
        {activeTab === 'filters' && (
          <div className="bg-white rounded-[16px] border border-[#e3e3e2] p-6 md:p-8 space-y-6">
            <div>
              <h3 className="text-lg font-w700 text-[#292827] mb-2 flex items-center gap-2">
                <ShieldCheck className="w-5 h-5 text-[#0c4243]" />
                Filter Hard-Gate Pencegah Kesalahan Klasifikasi
              </h3>
              <p className="text-sm text-[#666666] leading-relaxed">
                Untuk mengatasi kelemahan model visi di mana pose jempol acung (👍) atau tinju tertutup (✊) sering salah dideteksi sebagai huruf kurva seperti C atau L, sistem menyertakan gerbang deterministik di tingkat klien:
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="p-4 rounded-xl bg-[#f2f0eb] border border-[#e3e3e2]">
                <div className="text-sm font-w700 text-[#292827] mb-1">1. isThumbsUp Gate</div>
                <p className="text-xs text-[#666666] leading-relaxed">
                  Jika keempat jari lainnya tertekuk rapat ke telapak dan hanya jempol yang tegak ke atas, sistem langsung menolak klasifikasi abjad huruf kurva.
                </p>
              </div>

              <div className="p-4 rounded-xl bg-[#f2f0eb] border border-[#e3e3e2]">
                <div className="text-sm font-w700 text-[#292827] mb-1">2. isFist Gate</div>
                <p className="text-xs text-[#666666] leading-relaxed">
                  Ketika kelima ujung jari berada di dalam radius telapak tangan, frame ditandai sebagai kepalan netral dan tidak memicu ketikan huruf palsu.
                </p>
              </div>

              <div className="p-4 rounded-xl bg-[#f2f0eb] border border-[#e3e3e2]">
                <div className="text-sm font-w700 text-[#292827] mb-1">3. Debounce Temporal 300ms</div>
                <p className="text-xs text-[#666666] leading-relaxed">
                  Sebuah gestur harus dipertahankan stabil selama minimal 0.3 detik sebelum dimasukkan ke dalam buffer kalimat terjemahan.
                </p>
              </div>
            </div>
          </div>
        )}
      </div>
    </section>
  );
}

