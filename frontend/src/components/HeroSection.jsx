import React from 'react';
import {
  ArrowRight,
  Sparkles,
  Send,
  Camera,
  BookOpen,
  Volume2,
  History,
  Share2,
  ShieldCheck,
  Clock,
  Users,
  FileText,
  Sliders
} from 'lucide-react';

/**
 * HeroSection component
 * Exact 1:1 architectural and visual reconstruction of Superhuman's Hero:
 * - Twilight sky backdrop with subtle cloud texture & golden-hour radial light
 * - Natural-aspect-ratio portrait centered at bottom (822x660, never stretched)
 * - Weight 460 display title + subtitle + signature Superhuman CTA button
 * - Authentic .sh-glass-card floating panels with proper Tailwind v4 spacing
 */
export default function HeroSection({ onOpenDemo }) {
  return (
    <section
      id="beranda"
      className="relative w-full min-h-[880px] lg:min-h-[940px] flex flex-col justify-between overflow-hidden select-none"
      style={{
        background: `
          linear-gradient(to bottom left, rgba(168, 164, 216, 0.52), rgba(107, 165, 232, 0.52), rgba(176, 112, 192, 0.62), rgba(144, 136, 208, 0.52)),
          linear-gradient(180deg, #7c9ad3 0%, #526aa8 52%, #314682 100%)
        `,
      }}
    >
      {/* Subtle Photographic Cloud Texture Layer */}
      <div className="absolute inset-0 pointer-events-none overflow-hidden">
        <img
          src="/images/hero-sky-bg.jpg"
          alt=""
          aria-hidden="true"
          className="w-full h-full object-cover object-center opacity-35 mix-blend-soft-light scale-105"
        />
        {/* Golden hour warm horizon glow behind the subject */}
        <div
          className="absolute inset-0"
          style={{
            background: `
              radial-gradient(circle at 54% 68%, rgba(236, 159, 176, 0.42) 0%, transparent 48%),
              radial-gradient(circle at 50% 100%, rgba(28, 20, 48, 0.65) 0%, transparent 55%)
            `,
          }}
        />
      </div>

      {/* Top Centered Title, Subtitle & Signature Hero Button */}
      <div className="relative z-20 pt-12 md:pt-16 pb-6 px-4 max-w-4xl mx-auto flex flex-col items-center text-center">
        <h1 className="text-4xl sm:text-5xl md:text-[64px] font-w460 tracking-[-0.028em] leading-[0.98] text-white drop-shadow-xs">
          Komunikasi Tanpa Sekat,
          <br className="hidden sm:inline" /> di Mana Saja Anda Berkarya
        </h1>

        <p className="mt-4 text-base sm:text-lg md:text-[21px] leading-[1.35] text-white/90 font-w460 max-w-2xl">
          Kamera, Kamus 3D, dan AI Bahasa Isyarat yang bekerja di setiap aplikasi dan tab
        </p>

        <div className="mt-7">
          <button
            type="button"
            onClick={onOpenDemo}
            className="sh-hero-btn cursor-pointer group"
          >
            <span className="text-base font-w700 tracking-tight text-white">
              Mulai BISINDO AI
            </span>
            <span className="sh-hero-btn-icon">
              <ArrowRight className="w-4 h-4 text-white transition-transform duration-300 group-hover:translate-x-1" />
            </span>
          </button>
        </div>
      </div>

      {/* Center-Bottom Portrait + Overlaid Floating Glass Cards */}
      <div className="relative z-10 w-full max-w-[1360px] mx-auto flex-1 flex items-end justify-center px-4 md:px-8 pt-4">
        {/* Centered Subject Portrait at True Aspect Ratio (Not stretched) */}
        <figure className="relative z-10 flex justify-center items-end w-full pointer-events-none">
          <img
            src="/images/hero-person-4.webp"
            alt="Pengguna BISINDO AI"
            width="822"
            height="660"
            fetchPriority="high"
            className="w-[460px] sm:w-[580px] md:w-[680px] lg:w-[752px] max-w-full h-auto object-contain object-bottom drop-shadow-2xl"
          />
        </figure>

        {/* LEFT COLUMN FLOATING CARDS */}
        <div className="hidden md:flex flex-col gap-5 absolute left-4 lg:left-8 top-2 bottom-6 z-20 pointer-events-auto">
          {/* Top Row: Chat Card + Vertical Agent Dock */}
          <div className="flex items-center gap-4">
            {/* 1. Chat Assistant Card */}
            <div className="sh-glass-card w-[320px] lg:w-[350px] p-5 text-white flex flex-col gap-3.5">
              <div className="w-6 h-6 rounded-full bg-white/20 flex items-center justify-center">
                <Sparkles className="w-3.5 h-3.5 text-white" />
              </div>

              <p className="text-[13px] leading-[1.45] text-white/95 font-w460">
                Terdeteksi diskusi dengan Raka dan Dinda di{' '}
                <span className="px-1.5 py-0.5 rounded bg-white/15 border border-white/20 text-xs">
                  #inklusi-proyek
                </span>{' '}
                dan perlu memulai terjemahan isyarat. Aktifkan kamera dan suara sekarang?
              </p>

              <div className="self-end px-4 py-2 rounded-full rounded-br-none bg-white/20 border border-white/20 text-xs font-w500 text-white">
                ya, aktifkan!
              </div>

              <div className="space-y-1.5">
                <span className="text-xs text-white/85 block">
                  Mode kalibrasi yang siap digunakan:
                </span>
                <div className="flex flex-wrap items-center gap-1.5 text-[11px]">
                  <span className="inline-flex items-center gap-1 px-2 py-1 rounded-md bg-white/15 border border-white/20 text-white">
                    <Clock className="w-3 h-3" />
                    WebGL 60 FPS
                  </span>
                  <span className="inline-flex items-center gap-1 px-2 py-1 rounded-md bg-white/15 border border-white/20 text-white">
                    <Volume2 className="w-3 h-3" />
                    Suara Bahasa ID
                  </span>
                </div>
              </div>

              <div
                onClick={onOpenDemo}
                className="mt-1 px-3.5 py-2.5 rounded-xl bg-white/10 border border-white/25 flex items-center justify-between text-xs text-white/90 cursor-pointer hover:bg-white/15 transition-colors"
              >
                <span>aktifkan mode kamera langsung</span>
                <Send className="w-3.5 h-3.5 text-white/90" />
              </div>
            </div>

            {/* 2. Vertical Agent Dock */}
            <div className="sh-glass-card rounded-full p-1.5 flex flex-col items-center gap-2">
              <button
                type="button"
                onClick={onOpenDemo}
                className="w-10 h-10 rounded-full bg-white/25 flex items-center justify-center text-white hover:bg-white/35 transition-colors cursor-pointer"
                title="Asisten AI"
              >
                <Sparkles className="w-4 h-4" />
              </button>
              <button
                type="button"
                onClick={onOpenDemo}
                className="w-10 h-10 rounded-full flex items-center justify-center text-white/80 hover:text-white hover:bg-white/15 transition-colors cursor-pointer"
                title="Kamera Real-time"
              >
                <Camera className="w-4 h-4" />
              </button>
              <button
                type="button"
                onClick={onOpenDemo}
                className="w-10 h-10 rounded-full flex items-center justify-center text-white/80 hover:text-white hover:bg-white/15 transition-colors cursor-pointer"
                title="Kamus 3D"
              >
                <BookOpen className="w-4 h-4" />
              </button>
              <button
                type="button"
                onClick={onOpenDemo}
                className="w-10 h-10 rounded-full flex items-center justify-center text-white/80 hover:text-white hover:bg-white/15 transition-colors cursor-pointer"
                title="Sintesis Suara"
              >
                <Volume2 className="w-4 h-4" />
              </button>
              <button
                type="button"
                onClick={onOpenDemo}
                className="w-10 h-10 rounded-full flex items-center justify-center text-white/80 hover:text-white hover:bg-white/15 transition-colors cursor-pointer"
                title="Riwayat Sesi"
              >
                <History className="w-4 h-4" />
              </button>
            </div>
          </div>

          {/* 3. Bottom Left Telemetry / Inbox Style List Card */}
          <div className="relative sh-glass-card w-[390px] lg:w-[440px] p-5 text-white mt-auto">
            {/* Header Tabs */}
            <div className="flex items-center gap-4 text-xs pb-3 mb-3 border-b border-white/15">
              <span className="font-w700 text-white">Abjad <span className="text-white/60 font-w460">26</span></span>
              <span className="text-white/75">Angka <span className="text-white/50">10</span></span>
              <span className="text-white/75">Frasa <span className="text-white/50">48</span></span>
              <span className="text-white/75">Akurasi <span className="text-white/50">98%</span></span>
            </div>

            {/* Rows */}
            <div className="space-y-2.5 text-xs">
              {[
                { name: 'Huruf C', title: 'Kurva Setengah Lingkaran', note: 'Akurasi 98.4% stabil' },
                { name: 'Huruf L', title: 'Sudut Siku 90 Derajat', note: 'Ekstensi telunjuk & jempol' },
                { name: 'Kata SAYA', title: 'Isyarat Tunjuk Dada', note: 'Sintesis suara aktif' },
                { name: 'Kata BAIK', title: 'Filter Hard-Gate Jempol', note: 'Bebas salah deteksi' },
                { name: 'Angka 1-9', title: 'Deteksi Numerik Cepat', note: 'Latensi frame 14.2 ms' },
              ].map((row, idx) => (
                <div key={idx} className="grid grid-cols-12 items-center gap-2 py-0.5">
                  <span className="col-span-3 font-w540 text-white truncate">{row.name}</span>
                  <span className="col-span-5 font-w500 text-white/95 truncate">{row.title}</span>
                  <span className="col-span-4 text-white/60 truncate">{row.note}</span>
                </div>
              ))}
            </div>

            {/* Overlapping Verification Popover */}
            <div className="hidden lg:flex sh-glass-card absolute -right-10 -bottom-4 w-[240px] p-3.5 items-start gap-2.5 text-xs">
              <Sparkles className="w-4 h-4 text-[#d4c7ff] shrink-0 mt-0.5" />
              <span className="text-white/95 leading-snug">
                Kalibrasi 21 titik tangan selesai dalam 14 milidetik
              </span>
            </div>
          </div>
        </div>

        {/* RIGHT COLUMN FLOATING CARDS */}
        <div className="hidden lg:flex flex-col items-end gap-4 absolute right-8 top-14 bottom-12 z-20 pointer-events-auto">
          {/* Top Pill Badge */}
          <div
            onClick={onOpenDemo}
            className="sh-glass-card rounded-full px-4 py-2.5 flex items-center gap-2 text-xs text-white cursor-pointer hover:bg-white/20 transition-colors mr-6"
          >
            <Users className="w-4 h-4 text-[#d4c7ff]" />
            <span>Terjemahkan bahasa isyarat untuk rapat tim</span>
          </div>

          {/* 4. Right Workspace Document Editor Card */}
          <div className="sh-glass-card w-[390px] p-6 text-white flex flex-col gap-3.5 my-auto">
            <div className="flex items-center justify-between text-xs text-white/80 pb-2 border-b border-white/15">
              <span className="inline-flex items-center gap-1.5 font-w700 text-white">
                <FileText className="w-3.5 h-3.5 text-[#d4c7ff]" />
                Ruang Kerja Tim
              </span>
              <span className="inline-flex items-center gap-2 text-white/75">
                Bagikan <Share2 className="w-3.5 h-3.5" />
              </span>
            </div>

            <h3 className="text-sm font-w700 text-white">
              Standarisasi Komunikasi Inklusif
            </h3>

            <p className="text-xs leading-[1.6] text-white/90 font-w460">
              Kami menyederhanakan alur komunikasi bagi{' '}
              <span className="bg-white/20 px-1 py-0.5 rounded underline decoration-white/60">
                rekan kerja Tuli dan Dengar.
              </span>{' '}
              Saat ini seluruh deteksi 21 titik persendian tangan diproses langsung di browser tanpa kirim video ke server, sehingga percakapan berlangsung instan dan terjaga privasinya.
            </p>

            {/* Editor Formatting Pill Bar */}
            <div className="mt-2 self-center px-3 py-1.5 rounded-full bg-white/12 border border-white/20 flex items-center gap-3.5 text-xs font-mono text-white/90">
              <span>T</span>
              <span className="font-bold">B</span>
              <span className="italic">I</span>
              <span className="underline">U</span>
              <span className="line-through">S</span>
              <Sliders className="w-3.5 h-3.5 text-white/80" />
            </div>
          </div>

          {/* Bottom Pill Badge */}
          <div
            onClick={onOpenDemo}
            className="sh-glass-card rounded-full px-4 py-2.5 flex items-center gap-2 text-xs text-white cursor-pointer hover:bg-white/20 transition-colors mr-24"
          >
            <ShieldCheck className="w-4 h-4 text-[#d4c7ff]" />
            <span>Terverifikasi Kamus PUSBISINDO</span>
          </div>
        </div>
      </div>
    </section>
  );
}
