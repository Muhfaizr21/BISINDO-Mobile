import React from 'react';
import { ArrowRight } from 'lucide-react';
import { GooglePlayIcon, AppleIcon } from './StoreIcons';

/**
 * AtmosphericBanner component
 * Reconstructs Superhuman's atmospheric banner ("AI that works everywhere you work"):
 * - Full-bleed atmospheric gradient
 * - Overlaid with /images/homepage-tonal-flower.webp
 * - Left-aligned 48px headline
 * - Right-aligned primary CTA button with Google Play & App Store badges underneath
 */
export default function AtmosphericBanner({ onOpenDemo }) {
  return (
    <section
      id="tentang"
      className="relative w-full py-20 md:py-28 overflow-hidden"
      style={{
        background: 'linear-gradient(270deg, #554DCB 9.04%, #86CBF9 84.36%, #F7DBFF 100%)',
      }}
    >
      {/* Tonal Flower Overlay Asset from Superhuman */}
      <div className="absolute inset-0 pointer-events-none overflow-hidden">
        <img
          src="/images/homepage-tonal-flower.webp"
          alt=""
          aria-hidden="true"
          loading="lazy"
          className="w-full h-full object-cover object-center opacity-75 mix-blend-overlay"
        />
      </div>

      <div className="relative z-10 max-w-[1200px] mx-auto px-4 md:px-8 flex flex-col md:flex-row items-start md:items-center justify-between gap-8">
        <h2 className="text-3xl sm:text-4xl md:text-[48px] leading-[1.06] font-w460 tracking-[-0.025em] text-[#292827] max-w-2xl">
          AI Bahasa Isyarat yang Bekerja di Mana Saja Anda Berkomunikasi
        </h2>

        {/* Right CTA Area: Primary Button + Store Badges underneath */}
        <div className="shrink-0 flex flex-col items-start md:items-end gap-3.5">
          <button
            type="button"
            onClick={onOpenDemo}
            className="inline-flex items-center gap-2.5 px-6 py-3.5 rounded-xl bg-white text-[#292827] text-base font-w540 hover:bg-[#f2f0eb] shadow-md transition-all duration-200 cursor-pointer active:scale-[0.98]"
          >
            <span>Coba BISINDO AI Sekarang</span>
            <ArrowRight className="w-4 h-4 text-[#292827]" />
          </button>

          {/* Store Download Badges directly underneath the button */}
          <div className="flex flex-wrap items-center gap-2.5">
            {/* Google Play Store Badge */}
            <a
              href="https://play.google.com"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2.5 px-3.5 py-2 rounded-xl bg-[#111013]/90 hover:bg-[#111013] text-white border border-white/20 hover:border-white/40 shadow-sm transition-all duration-150 backdrop-blur-sm cursor-pointer active:scale-[0.98]"
              title="Temukan di Google Play"
            >
              <GooglePlayIcon className="w-5 h-5 shrink-0" />
              <div className="flex flex-col text-left leading-none">
                <span className="text-[9px] uppercase tracking-wider text-white/70 font-w500">
                  Temukan di
                </span>
                <span className="text-[13px] font-w600 text-white tracking-tight mt-0.5">
                  Google Play
                </span>
              </div>
            </a>

            {/* Apple App Store Badge */}
            <a
              href="https://www.apple.com/app-store/"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2.5 px-3.5 py-2 rounded-xl bg-[#111013]/90 hover:bg-[#111013] text-white border border-white/20 hover:border-white/40 shadow-sm transition-all duration-150 backdrop-blur-sm cursor-pointer active:scale-[0.98]"
              title="Unduh di App Store"
            >
              <AppleIcon className="w-5 h-5 shrink-0 fill-white" />
              <div className="flex flex-col text-left leading-none">
                <span className="text-[9px] uppercase tracking-wider text-white/70 font-w500">
                  Unduh di
                </span>
                <span className="text-[13px] font-w600 text-white tracking-tight mt-0.5">
                  App Store
                </span>
              </div>
            </a>
          </div>
        </div>
      </div>
    </section>
  );
}
