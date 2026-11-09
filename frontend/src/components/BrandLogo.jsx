import React from 'react';

/**
 * Professional Brand Logo for BISINDO AI
 * 
 * Design Concept: "The Kinematic Gesture 'B'"
 * - Synthesis of:
 *   1. The letter 'B' (Brand anchor for BISINDO)
 *   2. Two dynamic curved loops symbolizing expressive signing hands & continuous communication
 *   3. Central kinematic landmark node representing real-time computer vision tracking
 * 
 * Props:
 * - variant: 'dark' (for white/light backgrounds, e.g. Navbar)
 *            'light' (for dark/wine backgrounds, e.g. Footer)
 *            'gradient' (radiant multi-color version)
 * - size: 'sm' (28px icon), 'md' (36px icon), 'lg' (48px icon), 'xl' (64px)
 * - showWordmark: boolean (whether to render text "BISINDO AI")
 * - withBadge: boolean (whether to render the "AI" as a sleek pill badge)
 */
export default function BrandLogo({
  variant = 'dark',
  size = 'md',
  showWordmark = true,
  withBadge = true,
  className = '',
}) {
  // Dimensions mapping
  const sizeMap = {
    xs: { box: 24, icon: 'w-6 h-6', text: 'text-sm', badge: 'text-[9px] px-1 py-0.2' },
    sm: { box: 28, icon: 'w-7 h-7', text: 'text-base', badge: 'text-[9px] px-1.5 py-0.5' },
    md: { box: 34, icon: 'w-[34px] h-[34px]', text: 'text-lg', badge: 'text-[10px] px-1.5 py-0.5' },
    lg: { box: 44, icon: 'w-11 h-11', text: 'text-xl', badge: 'text-xs px-2 py-0.5' },
    xl: { box: 56, icon: 'w-14 h-14', text: 'text-2xl', badge: 'text-xs px-2.5 py-1' },
  };

  const currentSize = sizeMap[size] || sizeMap.md;

  // Color theming
  const isLight = variant === 'light';
  const textColor = isLight ? 'text-white' : 'text-[#292827]';
  const subtextColor = isLight ? 'text-white/60' : 'text-[#292827]/60';

  return (
    <div className={`inline-flex items-center gap-2.5 select-none ${className}`}>
      {/* Standalone Bespoke Vector Glyph */}
      <div className={`relative ${currentSize.icon} shrink-0 flex items-center justify-center`}>
        <svg
          viewBox="0 0 40 40"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          className="w-full h-full drop-shadow-xs"
          aria-hidden="true"
        >
          <defs>
            {/* Primary kinetic gradient */}
            <linearGradient id={`bisindo-grad-primary-${variant}`} x1="4" y1="4" x2="36" y2="36" gradientUnits="userSpaceOnUse">
              <stop offset="0%" stopColor="#7C3AED" />
              <stop offset="50%" stopColor="#4F46E5" />
              <stop offset="100%" stopColor="#2563EB" />
            </linearGradient>

            {/* Radiant gesture loop gradient */}
            <linearGradient id={`bisindo-grad-accent-${variant}`} x1="36" y1="8" x2="12" y2="36" gradientUnits="userSpaceOnUse">
              <stop offset="0%" stopColor="#A855F7" />
              <stop offset="60%" stopColor="#6366F1" />
              <stop offset="100%" stopColor="#38BDF8" />
            </linearGradient>

            {/* Soft inner glow */}
            <filter id={`bisindo-glow-${variant}`} x="-20%" y="-20%" width="140%" height="140%">
              <feGaussianBlur stdDeviation="0.8" result="blur" />
              <feComposite in="SourceGraphic" in2="blur" operator="over" />
            </filter>
          </defs>

          {/* Squircle Housing with Subtle Border */}
          <rect
            x="2"
            y="2"
            width="36"
            height="36"
            rx="10"
            fill={isLight ? 'rgba(255, 255, 255, 0.12)' : '#18181B'}
            stroke={isLight ? 'rgba(255, 255, 255, 0.25)' : 'rgba(255, 255, 255, 0.12)'}
            strokeWidth="1"
          />

          {/* Vertical Kinematic Spine (The Precision Anchor) */}
          <rect
            x="11"
            y="9.5"
            width="4"
            height="21"
            rx="2"
            fill={`url(#bisindo-grad-primary-${variant})`}
          />

          {/* Upper Gesture Arc (Expressive Hand Motion 1) */}
          <path
            d="M13.5 11.5 H21 C25.5 11.5 28.5 14 28.5 17.5 C28.5 21 25.5 22.5 21 22.5 H13.5"
            stroke={`url(#bisindo-grad-accent-${variant})`}
            strokeWidth="3.2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />

          {/* Lower Gesture Arc (Expressive Hand Motion 2 - Slightly Wider Proportions) */}
          <path
            d="M13.5 22.5 H22 C27 22.5 30 25 30 28.5 C30 32 27 34 22 34 H13.5"
            stroke={`url(#bisindo-grad-accent-${variant})`}
            strokeWidth="3.2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />

          {/* Central Vision Landmark Node (Real-time Kinematics Fusion) */}
          <circle
            cx="21"
            cy="22.5"
            r="1.8"
            fill="#FFFFFF"
            filter={`url(#bisindo-glow-${variant})`}
          />

          {/* Top Tip Gesture Indicator Node */}
          <circle
            cx="21"
            cy="11.5"
            r="1.2"
            fill="#C4B5FD"
          />
        </svg>
      </div>

      {/* Wordmark Typography */}
      {showWordmark && (
        <div className="flex items-center gap-2">
          <span
            className={`font-w700 tracking-[-0.02em] uppercase ${currentSize.text} ${textColor} font-sans leading-none`}
          >
            BISINDO
          </span>

          {withBadge ? (
            <span
              className={`inline-flex items-center justify-center font-w700 tracking-wider text-white uppercase rounded-[5px] bg-gradient-to-r from-[#7C3AED] via-[#6366F1] to-[#3B82F6] shadow-xs leading-none ${currentSize.badge}`}
            >
              AI
            </span>
          ) : (
            <span
              className={`font-w700 tracking-wider text-[#7C3AED] uppercase leading-none ${currentSize.text}`}
            >
              AI
            </span>
          )}
        </div>
      )}
    </div>
  );
}

