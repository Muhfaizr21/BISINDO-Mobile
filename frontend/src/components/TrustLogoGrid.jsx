import React from 'react';

/**
 * TrustLogoGrid component
 * Follows DESIGN.md specifications:
 * - Background: #ffffff
 * - Border: 1px #e3e3e2
 * - Radius: 0 (square cell in grid row, no individual rounding)
 * - Padding: 24px vertical
 * - Logo centered, rendered in #292827 monochrome
 * - Single horizontal row of 6 cells (max-width contained: 1200px)
 */
export default function TrustLogoGrid() {
  const partners = [
    { name: 'PUSBISINDO', desc: 'Pusat Bahasa Isyarat' },
    { name: 'GERKATIN', desc: 'Komunitas Tunarungu RI' },
    { name: 'KEMENDIKBUD', desc: 'Inisiatif Pendidikan Inklusif' },
    { name: 'TELKOM UNIV', desc: 'Laboratorium Riset AI' },
    { name: 'INKLUSI DIGITAL', desc: 'Akselerator Aksesibilitas' },
    { name: 'SLB NEGERI', desc: 'Uji Klinis Edukasi' },
  ];

  return (
    <section className="w-full bg-[#f2f0eb] py-8 border-y border-[#e3e3e2]/60">
      <div className="max-w-[1200px] mx-auto px-4 md:px-6">
        <div className="text-center mb-6">
          <p className="text-xs uppercase tracking-widest text-[#666666] font-w540">
            Didukung Standar Riset & Komunitas Bahasa Isyarat Nasional
          </p>
        </div>

        {/* 6 Square Grid Cells in a single row on desktop, 3x2 on tablet, 2x3 on mobile */}
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 border-t border-l border-[#e3e3e2] bg-[#ffffff]">
          {partners.map((item, index) => (
            <div
              key={index}
              className="flex flex-col items-center justify-center py-6 px-4 border-r border-b border-[#e3e3e2] bg-[#ffffff] transition-colors duration-200 hover:bg-[#faf9f6]"
            >
              <span className="font-w700 text-sm md:text-base tracking-wider text-[#292827]">
                {item.name}
              </span>
              <span className="text-[10px] text-[#666666] font-w460 tracking-normal mt-0.5 text-center">
                {item.desc}
              </span>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

