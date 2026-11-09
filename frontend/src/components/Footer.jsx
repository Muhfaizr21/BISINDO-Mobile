import React from 'react';
import { Heart, Globe2 } from 'lucide-react';
import BrandLogo from './BrandLogo';

/**
 * Footer component
 * Follows DESIGN.md specifications:
 * - Background: #421d24 (Midnight Wine) full-bleed
 * - Padding: 64px top and bottom
 * - Text: #ffffff for headings (14px weight 700), #ffffff at 70% opacity for links (14px weight 460)
 * - Multi-column layout: Produk, Sumber Daya, Inisiatif Inklusif, Legalitas
 * - Zero em-dashes in copy
 */
export default function Footer({ onOpenDemo, onOpenDocs }) {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="w-full bg-[#421d24] text-white py-16 px-4 md:px-6">
      <div className="max-w-[1200px] mx-auto">
        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-10 pb-16 border-b border-white/10">
          {/* Brand Col */}
          <div className="col-span-2">
            <BrandLogo variant="light" size="md" className="mb-4" />
            <p className="text-sm font-w460 text-white/70 max-w-sm leading-relaxed mb-6">
              Penerjemah Bahasa Isyarat Indonesia real-time berbasis visi komputer lokal, mengutamakan privasi pengguna dan kesetaraan akses komunikasi digital.
            </p>
            <div className="flex items-center gap-2 text-xs text-white/60 font-mono">
              <Globe2 className="w-3.5 h-3.5 text-[#d4c7ff]" />
              <span>Standar Terbuka & Kompatibel Nasional</span>
            </div>
          </div>

          {/* Col 1: Produk */}
          <div className="flex flex-col gap-3">
            <h4 className="text-sm font-w700 text-white tracking-wider uppercase mb-1">
              Produk
            </h4>
            <button
              type="button"
              onClick={onOpenDemo}
              className="text-left text-sm font-w460 text-white/70 hover:text-white transition-colors cursor-pointer"
            >
              Simulator Kamera Web
            </button>
            <a
              href="#fitur"
              className="text-sm font-w460 text-white/70 hover:text-white transition-colors"
            >
              Kamus Gestur 3D
            </a>
            <a
              href="#kinematika"
              className="text-sm font-w460 text-white/70 hover:text-white transition-colors"
            >
              Mesin Kinematik Tangan
            </a>
            <a
              href="#fitur"
              className="text-sm font-w460 text-white/70 hover:text-white transition-colors"
            >
              Modul Evaluasi Latihan
            </a>
          </div>

          {/* Col 2: Sumber Daya */}
          <div className="flex flex-col gap-3">
            <h4 className="text-sm font-w700 text-white tracking-wider uppercase mb-1">
              Dokumentasi
            </h4>
            <button
              type="button"
              onClick={onOpenDocs}
              className="text-left text-sm font-w460 text-white/70 hover:text-white transition-colors cursor-pointer"
            >
              Spesifikasi Landmark 21 Titik
            </button>
            <button
              type="button"
              onClick={onOpenDocs}
              className="text-left text-sm font-w460 text-white/70 hover:text-white transition-colors cursor-pointer"
            >
              Metrik Kalibrasi Tangan
            </button>
            <a
              href="#kinematika"
              className="text-sm font-w460 text-white/70 hover:text-white transition-colors"
            >
              Normalisasi Jarak Euclidean
            </a>
            <a
              href="#beranda"
              className="text-sm font-w460 text-white/70 hover:text-white transition-colors"
            >
              Arsitektur WebAssembly
            </a>
          </div>

          {/* Col 3: Komunitas & Legalitas */}
          <div className="flex flex-col gap-3">
            <h4 className="text-sm font-w700 text-white tracking-wider uppercase mb-1">
              Etika & Privasi
            </h4>
            <span className="text-sm font-w460 text-white/70">
              Zero Cloud Video Storage
            </span>
            <span className="text-sm font-w460 text-white/70">
              Kamus Berbasis PUSBISINDO
            </span>
            <span className="text-sm font-w460 text-white/70">
              Pedoman Aksesibilitas WCAG 2.2
            </span>
            <span className="text-sm font-w460 text-white/70">
              Lisensi Riset Terbuka
            </span>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="pt-8 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-white/60 font-w460">
          <div>
            &copy; {currentYear} BISINDO AI. Seluruh hak cipta dilindungi. Dikembangkan untuk kemajuan inklusi Indonesia.
          </div>
          <div className="flex items-center gap-1">
            <span>Dibuat dengan dedikasi untuk kesetaraan aksesibilitas</span>
            <Heart className="w-3.5 h-3.5 text-[#d4c7ff] fill-current" />
          </div>
        </div>
      </div>
    </footer>
  );
}

