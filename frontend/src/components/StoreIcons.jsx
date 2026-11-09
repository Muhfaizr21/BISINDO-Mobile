import React from 'react';

/**
 * Official Apple Vector Icon
 */
export function AppleIcon({ className = 'w-5 h-5', ...props }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="currentColor"
      aria-hidden="true"
      className={className}
      {...props}
    >
      <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M15.97 6.37c.61-.75 1.04-1.8 1.01-2.87-.9.04-2.02.6-2.67 1.34-.58.65-1.09 1.71-1.04 2.76 1.01.08 2.06-.51 2.7-1.23z" />
    </svg>
  );
}

/**
 * Official Google Play Store Vector Icon
 */
export function GooglePlayIcon({ className = 'w-5 h-5', ...props }) {
  return (
    <svg
      viewBox="0 0 512 512"
      aria-hidden="true"
      className={className}
      {...props}
    >
      <path
        fill="#4285F4"
        d="M47.7 20.3C40 28.5 35.6 40.5 35.6 55.4v401.2c0 14.9 4.4 26.9 12.1 35.1l1.8 1.8 226.7-226.7v-5.4L49.5 18.5l-1.8 1.8z"
      />
      <path
        fill="#FBBC04"
        d="M351.4 329.8l-75.2-75.2v-5.4l75.2-75.2 1.7 1 89.2 50.7c25.5 14.5 25.5 38.1 0 52.6l-89.2 50.7-1.7.8z"
      />
      <path
        fill="#EA4335"
        d="M353.1 328.8L276.2 252 47.7 480.5c8.4 8.9 22.2 9.9 37.9 1l267.5-152.7z"
      />
      <path
        fill="#34A853"
        d="M353.1 183.2L85.6 30.5C69.9 21.6 56.1 22.6 47.7 31.5L276.2 260l76.9-76.8z"
      />
    </svg>
  );
}

