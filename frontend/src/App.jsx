import React, { useState } from 'react';
import Navbar from './components/Navbar';
import HeroSection from './components/HeroSection';
import TrustLogoGrid from './components/TrustLogoGrid';
import SuiteSection from './components/SuiteSection';
import DarkFeatureBand from './components/DarkFeatureBand';
import DocumentationSection from './components/DocumentationSection';
import AtmosphericBanner from './components/AtmosphericBanner';
import Footer from './components/Footer';
import InteractiveDemoModal from './components/InteractiveDemoModal';
import DocsModal from './components/DocsModal';

/**
 * App component
 * Golden Hour Editorial Dashboard Landing Page for BISINDO AI
 * Follows DESIGN.md specifications & antislop-ui guidelines:
 * - Theme: Light (Warm Parchment #f2f0eb canvas)
 * - Signature headline font weight 460 at 28px+
 * - Midnight Wine #421d24 primary action fill
 * - Deep Lagoon #0c4243 dark feature band
 * - Zero em-dashes in copy
 * - Zero dead controls
 */
export default function App() {
  const [isDemoOpen, setIsDemoOpen] = useState(false);
  const [isDocsOpen, setIsDocsOpen] = useState(false);

  return (
    <div className="min-h-screen bg-[#f2f0eb] text-[#292827] flex flex-col font-sans selection:bg-[#d4c7ff] selection:text-[#292827]">
      {/* 1. Sticky Navigation Header */}
      <Navbar onOpenDemo={() => setIsDemoOpen(true)} />

      {/* Main Content Area */}
      <main className="flex-1">
        {/* 3. Hero Section with 64px/weight 460 Headline & Floating UI Cards */}
        <HeroSection onOpenDemo={() => setIsDemoOpen(true)} />

        {/* 4. Social Proof Logo Grid (6 cells, Paper White #ffffff) */}
        <TrustLogoGrid />

        {/* 5. Suite Section with Interactive Tab Strip & Product Cards */}
        <SuiteSection onOpenDemo={() => setIsDemoOpen(true)} />

        {/* 6. Dark Feature Band (Deep Lagoon #0c4243 full-bleed) */}
        <DarkFeatureBand onOpenDocs={() => setIsDocsOpen(true)} />

        {/* 7. Dedicated On-Page Documentation Section (#dokumentasi) */}
        <DocumentationSection onOpenDocs={() => setIsDocsOpen(true)} />

        {/* 8. Atmospheric Gradient Banner */}
        <AtmosphericBanner onOpenDemo={() => setIsDemoOpen(true)} />
      </main>

      {/* 8. Site-wide Footer (Midnight Wine #421d24 full-bleed) */}
      <Footer 
        onOpenDemo={() => setIsDemoOpen(true)} 
        onOpenDocs={() => setIsDocsOpen(true)} 
      />

      {/* Interactive Modals ensuring zero dead controls */}
      <InteractiveDemoModal 
        isOpen={isDemoOpen} 
        onClose={() => setIsDemoOpen(false)} 
      />

      <DocsModal 
        isOpen={isDocsOpen} 
        onClose={() => setIsDocsOpen(false)} 
      />
    </div>
  );
}
