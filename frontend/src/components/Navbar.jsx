import React, { useState } from 'react';
import { Menu, X } from 'lucide-react';
import { GooglePlayIcon, AppleIcon } from './StoreIcons';
import BrandLogo from './BrandLogo';

/**
 * Navbar component
 * Clean, flat navigation bar with store download actions:
 * - Crisp white background with subtle border
 * - Brand logo at left
 * - Centered navigation items
 * - Right actions: Google Play & App Store download buttons
 */
export default function Navbar({ onOpenDemo }) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const navLinks = [
    { label: 'Produk', href: '#fitur' },
    { label: 'Kinematika AI', href: '#kinematika' },
    { label: 'Kamus 3D', href: '#fitur' },
    { label: 'Dokumentasi', href: '#dokumentasi' },
    { label: 'Tentang Kami', href: '#tentang' },
  ];

  return (
    <header className="sticky top-0 z-50 w-full bg-white/95 backdrop-blur-md border-b border-[#e3e3e2] text-[#292827]">
      <div className="max-w-[1340px] mx-auto h-16 px-4 md:px-8 flex items-center justify-between">
        {/* Brand Logo */}
        <a
          href="#beranda"
          className="flex items-center group select-none hover:opacity-95 transition-opacity"
        >
          <BrandLogo variant="dark" size="md" />
        </a>

        {/* Center Nav Links */}
        <nav className="hidden lg:flex items-center gap-8" aria-label="Navigasi Utama">
          {navLinks.map((link) => (
            <a
              key={link.label}
              href={link.href}
              className="text-[#292827] text-sm font-w500 hover:text-[#714cb6] transition-colors duration-150"
            >
              {link.label}
            </a>
          ))}
        </nav>

        {/* Right Actions - Google Play & App Store Downloads */}
        <div className="hidden md:flex items-center gap-2.5">
          <a
            href="https://play.google.com"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-3.5 py-2 rounded-lg border border-[#e3e3e2] hover:border-[#292827]/40 bg-white hover:bg-[#f6f5f4] text-[#292827] text-xs font-w540 transition-all shadow-xs cursor-pointer active:scale-[0.98]"
            title="Unduh di Google Play Store"
          >
            <GooglePlayIcon className="w-4 h-4 shrink-0" />
            <span>Google Play</span>
          </a>

          <a
            href="https://www.apple.com/app-store/"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-3.5 py-2 rounded-lg bg-[#292827] hover:bg-[#1a1918] text-white text-xs font-w540 transition-all shadow-xs cursor-pointer active:scale-[0.98]"
            title="Unduh di Apple App Store"
          >
            <AppleIcon className="w-4 h-4 shrink-0 fill-current" />
            <span>App Store</span>
          </a>
        </div>

        {/* Mobile Menu Toggle */}
        <div className="lg:hidden flex items-center">
          <button
            type="button"
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            className="p-2 text-[#292827] hover:bg-black/5 rounded-lg transition-colors cursor-pointer"
            aria-label="Menu"
          >
            {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
      </div>

      {/* Mobile Menu Dropdown */}
      {mobileMenuOpen && (
        <div className="lg:hidden bg-white border-b border-[#e3e3e2] px-6 py-6 flex flex-col gap-4 shadow-lg animate-in fade-in duration-200">
          <nav className="flex flex-col gap-3">
            {navLinks.map((link) => (
              <a
                key={link.label}
                href={link.href}
                onClick={() => setMobileMenuOpen(false)}
                className="text-[#292827] text-base font-w500 py-2 border-b border-[#e3e3e2]/60 hover:text-[#714cb6]"
              >
                {link.label}
              </a>
            ))}
          </nav>

          <div className="pt-2 flex flex-col gap-2.5">
            <a
              href="https://play.google.com"
              target="_blank"
              rel="noopener noreferrer"
              onClick={() => setMobileMenuOpen(false)}
              className="w-full flex items-center justify-center gap-2.5 py-2.5 px-4 rounded-lg border border-[#e3e3e2] bg-white text-[#292827] font-w500 text-sm shadow-xs hover:bg-[#f6f5f4]"
            >
              <GooglePlayIcon className="w-4 h-4 shrink-0" />
              <span>Unduh di Google Play</span>
            </a>
            <a
              href="https://www.apple.com/app-store/"
              target="_blank"
              rel="noopener noreferrer"
              onClick={() => setMobileMenuOpen(false)}
              className="w-full flex items-center justify-center gap-2.5 py-2.5 px-4 rounded-lg bg-[#292827] text-white font-w500 text-sm shadow-xs hover:bg-[#1a1918]"
            >
              <AppleIcon className="w-4 h-4 shrink-0 fill-current" />
              <span>Unduh di App Store</span>
            </a>
          </div>
        </div>
      )}
    </header>
  );
}
