import React from 'react';
import { ArrowRight } from 'lucide-react';

/**
 * DarkFeatureBand component
 * Matches Superhuman's "Becoming Superhuman." manifesto section:
 * - Full-bleed #0c4243 (Deep Lagoon) background
 * - Left column: 48-56px weight 460 white headline, editorial copy, white outlined button
 * - Right column: Layered geometric art + portrait collage (/images/homepage-manifesto.webp)
 */
export default function DarkFeatureBand({ onOpenDocs }) {
  return (
    <section
      id="kinematika"
      className="w-full bg-[#0c4243] text-white py-20 md:py-28 overflow-hidden"
    >
      <div className="max-w-[1200px] mx-auto px-4 md:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16 items-center">
          {/* Left Column: Editorial Manifesto Copy (Matches Superhuman layout) */}
          <div className="lg:col-span-5 flex flex-col items-start">
            <h2 className="text-4xl sm:text-5xl md:text-[52px] leading-[1.04] font-w460 tracking-[-0.025em] text-white mb-6">
              Menembus Batas Komunikasi.
            </h2>

            <p className="text-base md:text-[18px] leading-[1.6] text-white/85 font-w460 mb-8">
              Ketika visi komputer bekerja langsung di perangkat Anda, cara kita berinteraksi berubah sepenuhnya. Deteksi 21 titik koordinat tangan berjalan dalam hitungan milidetik di RAM lokal tanpa pernah mengirim video keluar. Privasi terjaga mutlak, komunikasi mengalir tanpa jeda.
            </p>

            <button
              type="button"
              onClick={onOpenDocs}
              className="inline-flex items-center gap-2.5 px-5 py-3 rounded-[10px] border border-white/80 text-white text-sm font-w500 hover:bg-white hover:text-[#0c4243] transition-all duration-200 cursor-pointer"
            >
              <span>Baca Dokumentasi Arsitektur</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>

          {/* Right Column: Authentic Editorial Layered Art & Portrait Collage */}
          <div className="lg:col-span-7 flex justify-center lg:justify-end">
            <div className="relative w-full max-w-[640px] rounded-2xl overflow-hidden">
              <img
                src="/images/homepage-manifesto.webp"
                alt="Kolase Riset dan Kinematika BISINDO AI"
                loading="lazy"
                width="1280"
                height="1053"
                className="w-full h-auto object-cover"
              />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
