import React from 'react';
import { Sparkles, ArrowRight } from 'lucide-react';

/**
 * AnnouncementBanner component
 * Implements the flush top-of-page promotional strip from DESIGN.md:
 * - Background: #421d24 (Midnight Wine)
 * - Text: #ffffff, 14px
 * - Bordered learn-more link
 */
export default function AnnouncementBanner({ onOpenDemo }) {
  return (
    <aside 
      aria-label="Pengumuman Rilis Teknologi"
      className="w-full bg-[#421d24] text-white text-xs md:text-sm py-2.5 px-4"
    >
      <div className="max-w-[1200px] mx-auto flex items-center justify-between gap-3">
        <div className="flex items-center gap-2 overflow-hidden text-ellipsis whitespace-nowrap">
          <span className="inline-flex items-center justify-center w-5 h-5 rounded-full bg-white/10 shrink-0">
            <Sparkles className="w-3 h-3 text-[#d4c7ff]" />
          </span>
          <span className="font-w460 text-white/90">
            Pembaruan v2.4: Model Kinematika 21 Titik Tangan kini aktif langsung di peramban web.
          </span>
        </div>

        <button
          type="button"
          onClick={onOpenDemo}
          className="shrink-0 inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full border border-white/30 text-white/95 hover:bg-white/10 hover:border-white/50 text-xs font-w500 transition-all duration-150 cursor-pointer"
        >
          <span>Uji Coba Live</span>
          <ArrowRight className="w-3 h-3" />
        </button>
      </div>
    </aside>
  );
}

