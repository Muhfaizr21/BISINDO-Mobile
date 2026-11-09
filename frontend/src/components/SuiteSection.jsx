import React, { useState } from 'react';
import { Camera, BookOpen, Layers, Award, ArrowRight, Activity, Volume2, CheckCircle2 } from 'lucide-react';

/**
 * SuiteSection component
 * Exact reconstruction of Superhuman's "Your Superhuman suite" section:
 * 1. Header with 48px weight 460 title ("Suite BISINDO AI Anda") + Outlined Lilac Mist button ("Buka Seluruh Suite")
 * 2. 4 Suite Product Cards in a 4-column row (#ffffff on #f2f0eb canvas, colored icon, 19px bold title, violet link)
 * 3. 4-tab Suite Tab Strip (#ffffff container, active tab #d4c7ff fill)
 * 4. Two-column Suite Detail Showcase with hollow-circle list items and rich interactive visual mockup
 */
export default function SuiteSection({ onOpenDemo }) {
  const [activeTab, setActiveTab] = useState(0);

  const suiteItems = [
    {
      id: 'kamera',
      name: 'Kamera Live',
      shortDesc: 'Deteksi 21 titik persendian tangan secara real-time di peramban.',
      icon: Camera,
      iconBg: 'bg-[#421d24] text-white',
      headline: 'Penerjemah kamera tercepat tanpa latensi server',
      copy: 'Arahkan tangan ke kamera perangkat Anda, dapatkan hasil terjemahan abjad, angka, dan kata secara instan pada 60 frame per detik.',
      linkText: 'Uji modul Kamera Live',
      bullets: [
        'Ekstraksi 21 koordinat 3D tangan dengan MediaPipe WebGL',
        'Stabilisasi temporal 300ms untuk mencegah salah ketik gestur',
        'Sintesis suara Bahasa Indonesia otomatis (Text-to-Speech)',
        '100% pemrosesan di perangkat lokal tanpa unggah video ke awan',
      ],
      previewType: 'camera',
    },
    {
      id: 'kamus',
      name: 'Kamus 3D',
      shortDesc: 'Katalog standar abjad A-Z dan angka 0-9 terverifikasi PUSBISINDO.',
      icon: BookOpen,
      iconBg: 'bg-[#0c4243] text-white',
      headline: 'Panduan visual bahasa isyarat yang presisi dan mudah dipahami',
      copy: 'Pelajari setiap lekukan jari, sudut persendian, dan orientasi telapak tangan melalui visualisasi rangka kinematik yang jernih.',
      linkText: 'Jelajahi Kamus 3D',
      bullets: [
        'Mencakup seluruh abjad BISINDO A-Z dan angka 0-9',
        'Dilengkapi indikator sudut fleksi sendi MCP, PIP, dan DIP',
        'Pencarian cepat berdasarkan kategori huruf, angka, dan kata dasar',
        'Disusun selaras dengan pedoman kurikulum inklusif nasional',
      ],
      previewType: 'lexicon',
    },
    {
      id: 'kinematika',
      name: 'Kinematika',
      shortDesc: 'Mesin klasifikasi geometri vektor yang tahan variasi ukuran tangan.',
      icon: Layers,
      iconBg: 'bg-[#714cb6] text-white',
      headline: 'Akurasi matematis di balik setiap gerakan jari Anda',
      copy: 'Menggunakan normalisasi ukuran telapak tangan dan gerbang logika deterministik untuk membedakan gestur serupa secara akurat.',
      linkText: 'Pelajari mesin Kinematika',
      bullets: [
        'Normalisasi jarak Euclidean berbasis panjang telapak tangan',
        'Hard-gate filter pencegah salah deteksi jempol acung dan kepalan',
        'Invarian terhadap jarak tangan dari lensa kamera maupun rotasi',
        'Waktu komputasi rata-rata di bawah 14.2 milidetik per frame',
      ],
      previewType: 'kinematics',
    },
    {
      id: 'evaluasi',
      name: 'Evaluasi AI',
      shortDesc: 'Latihan mandiri interaktif dengan penilaian kecocokan langsung.',
      icon: Award,
      iconBg: 'bg-[#292827] text-white',
      headline: 'Uji dan tingkatkan kemahiran bahasa isyarat setiap hari',
      copy: 'Praktikkan gestur langsung di depan kamera dan terima umpan balik akurasi secara real-time untuk mempercepat proses belajar.',
      linkText: 'Mulai sesi Evaluasi AI',
      bullets: [
        'Skor kemiripan gestur real-time dalam satuan persentase',
        'Tantangan ejaan kata bertahap dari tingkat dasar hingga mahir',
        'koreksi langsung pada posisi jari yang kurang tepat',
        'Penyimpanan riwayat belajar lokal yang aman di peramban',
      ],
      previewType: 'eval',
    },
  ];

  const current = suiteItems[activeTab];
  const CurrentIcon = current.icon;

  return (
    <section id="fitur" className="w-full py-20 md:py-28 bg-[#f2f0eb]">
      <div className="max-w-[1200px] mx-auto px-4 md:px-8">
        {/* 1. Section Header Row matching Superhuman */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-6 mb-12">
          <h2 className="text-4xl sm:text-5xl md:text-[49px] leading-[1.08] font-w460 tracking-[-0.027em] text-[#292827]">
            Suite BISINDO AI Anda
          </h2>

          <button
            type="button"
            onClick={onOpenDemo}
            className="w-fit inline-flex items-center justify-center px-5 py-2.5 rounded-[8px] bg-[#d4c7ff] text-[#292827] border border-[#292827] text-sm font-w540 hover:bg-[#c4b4ff] transition-all cursor-pointer"
          >
            Buka Seluruh Suite
          </button>
        </div>

        {/* 2. Four Suite Product Cards Row (DESIGN.md specification) */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-12">
          {suiteItems.map((item, idx) => {
            const Icon = item.icon;
            return (
              <div
                key={item.id}
                onClick={() => setActiveTab(idx)}
                className={`bg-[#ffffff] rounded-[16px] p-5 border transition-all cursor-pointer flex flex-col justify-between ${
                  activeTab === idx
                    ? 'border-[#714cb6] ring-1 ring-[#714cb6]'
                    : 'border-[#e3e3e2] hover:border-[#292827]/40'
                }`}
              >
                <div>
                  <div className={`w-9 h-9 rounded-lg ${item.iconBg} flex items-center justify-center mb-4`}>
                    <Icon className="w-4 h-4" />
                  </div>
                  <h3 className="text-[19px] leading-[1.4] font-w700 text-[#292827] mb-1.5">
                    {item.name}
                  </h3>
                  <p className="text-sm leading-[1.5] font-w460 text-[#666666] mb-4">
                    {item.shortDesc}
                  </p>
                </div>

                <span className="violet-link text-sm font-w500 inline-flex items-center gap-1.5">
                  <span>Pelajari lebih lanjut</span>
                  <ArrowRight className="w-3.5 h-3.5" />
                </span>
              </div>
            );
          })}
        </div>

        {/* 3. Suite Tab Strip (4 equal-width tabs, #ffffff outer, #d4c7ff active) */}
        <div className="w-full bg-[#ffffff] rounded-[8px] border border-[#e3e3e2] overflow-hidden mb-8">
          <div className="grid grid-cols-2 md:grid-cols-4 divide-x divide-[#e3e3e2]">
            {suiteItems.map((tab, idx) => {
              const TabIcon = tab.icon;
              const isActive = activeTab === idx;
              return (
                <button
                  key={tab.id}
                  type="button"
                  onClick={() => setActiveTab(idx)}
                  className={`flex items-center justify-center gap-2.5 py-4 px-4 transition-colors duration-150 cursor-pointer ${
                    isActive
                      ? 'bg-[#d4c7ff] text-[#292827] font-w540'
                      : 'bg-[#ffffff] text-[#292827] hover:bg-[#f2f0eb]/60 font-w460'
                  }`}
                >
                  <TabIcon className="w-4 h-4 shrink-0 text-[#292827]" />
                  <span className="text-base leading-none">{tab.name}</span>
                </button>
              );
            })}
          </div>
        </div>

        {/* 4. Two-Column Suite Detail Showcase Card */}
        <div className="w-full bg-[#ffffff] rounded-[16px] border border-[#e3e3e2] p-6 sm:p-8 md:p-12">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-12 items-center">
            {/* Left Column: Narrative + Hollow Circle Bullets */}
            <div className="lg:col-span-6 flex flex-col items-start">
              <div className="inline-flex items-center gap-2 mb-4">
                <div className={`w-6 h-6 rounded-md ${current.iconBg} flex items-center justify-center`}>
                  <CurrentIcon className="w-3.5 h-3.5" />
                </div>
                <span className="text-lg font-w500 text-[#292827]">{current.name}</span>
              </div>

              <h3 className="text-3xl sm:text-4xl md:text-[42px] leading-[1.1] font-w460 tracking-[-0.024em] text-[#292827] mb-4">
                {current.headline}
              </h3>

              <p className="text-base md:text-[17px] leading-[1.55] text-[#666666] font-w460 mb-6">
                {current.copy}
              </p>

              <button
                type="button"
                onClick={onOpenDemo}
                className="violet-link text-base font-w500 inline-flex items-center gap-2 mb-8 cursor-pointer"
              >
                <span>{current.linkText}</span>
                <ArrowRight className="w-4 h-4" />
              </button>

              {/* Superhuman Signature Hollow Circle List */}
              <ul className="space-y-3.5 w-full pt-6 border-t border-[#e3e3e2]">
                {current.bullets.map((bullet, idx) => (
                  <li key={idx} className="flex items-center gap-3.5 text-base font-w460 text-[#292827]">
                    <span className="w-3 h-3 rounded-full border-[1.5px] border-[#292827] shrink-0" />
                    <span>{bullet}</span>
                  </li>
                ))}
              </ul>
            </div>

            {/* Right Column: Interactive Visual Preview Canvas */}
            <div className="lg:col-span-6">
              <div
                className="relative w-full rounded-[16px] overflow-hidden p-6 sm:p-8 min-h-[420px] flex flex-col justify-between border border-[#e3e3e2]"
                style={{
                  background:
                    'linear-gradient(145deg, #2d3864 0%, #4b3d77 52%, #7c6295 100%)',
                }}
              >
                {/* Top Status Bar inside Visual */}
                <div className="sh-glass-card px-4 py-3 flex items-center justify-between text-white text-xs">
                  <span className="inline-flex items-center gap-2 font-w540">
                    <Activity className="w-4 h-4 text-[#d4c7ff]" />
                    {current.name} &bull; Engine v2.4 Aktif
                  </span>
                  <span className="px-2.5 py-0.5 rounded-full bg-white/20 font-mono text-[11px]">
                    60 FPS
                  </span>
                </div>

                {/* Center Hand Landmark Visualization */}
                <div className="my-6 sh-glass-card p-6 text-white flex flex-col items-center">
                  <svg
                    viewBox="0 0 220 170"
                    className="w-48 h-40 stroke-white/90 fill-none mb-4"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  >
                    <line x1="110" y1="155" x2="110" y2="120" />
                    <line x1="110" y1="120" x2="75" y2="95" />
                    <line x1="110" y1="120" x2="95" y2="85" />
                    <line x1="110" y1="120" x2="115" y2="82" />
                    <line x1="110" y1="120" x2="138" y2="95" />
                    <polyline points="75,95 55,82 42,68 32,55" />
                    <polyline points="95,85 92,55 90,35 88,18" />
                    <polyline points="115,82 116,50 117,30 118,14" />
                    <polyline points="126,88 130,58 132,38 134,22" />
                    <polyline points="138,95 148,70 154,52 158,38" />
                    {[
                      [110, 155], [110, 120], [75, 95], [55, 82], [42, 68], [32, 55],
                      [95, 85], [92, 55], [90, 35], [88, 18],
                      [115, 82], [116, 50], [117, 30], [118, 14],
                      [126, 88], [130, 58], [132, 38], [134, 22],
                      [138, 95], [148, 70], [154, 52], [158, 38],
                    ].map(([cx, cy], i) => (
                      <circle
                        key={i}
                        cx={cx}
                        cy={cy}
                        r="3.5"
                        className="fill-[#d4c7ff] stroke-[#1b1938]"
                        strokeWidth="1.5"
                      />
                    ))}
                  </svg>

                  <div className="w-full flex items-center justify-between text-xs pt-3 border-t border-white/15">
                    <span className="text-white/80">Klasifikasi Spasial:</span>
                    <span className="font-w700 text-[#d4c7ff]">Akurasi 98.8% (14.2 ms)</span>
                  </div>
                </div>

                {/* Bottom Action Strip inside Visual */}
                <div className="sh-glass-card px-4 py-3 flex items-center justify-between text-white text-xs">
                  <span className="inline-flex items-center gap-2">
                    <Volume2 className="w-4 h-4 text-[#d4c7ff]" />
                    Output: &ldquo;HALO TEMAN INKLUSI&rdquo;
                  </span>
                  <button
                    type="button"
                    onClick={onOpenDemo}
                    className="px-3 py-1 rounded-md bg-white text-[#1b1938] font-w700 hover:bg-[#d4c7ff] transition-colors cursor-pointer"
                  >
                    Coba Live
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
