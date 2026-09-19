"use client";

import React, { useRef, useEffect, useState, useCallback } from "react";

interface DoubleScrollContainerProps {
  children: React.ReactNode;
  className?: string;
  topScrollClassName?: string;
}

export default function DoubleScrollContainer({
  children,
  className = "",
  topScrollClassName = "",
}: DoubleScrollContainerProps) {
  const topScrollRef = useRef<HTMLDivElement>(null);
  const bottomScrollRef = useRef<HTMLDivElement>(null);
  const contentRef = useRef<HTMLDivElement>(null);

  const [scrollWidth, setScrollWidth] = useState(0);
  const [hasOverflow, setHasOverflow] = useState(false);

  const isSyncingTop = useRef(false);
  const isSyncingBottom = useRef(false);

  // Measure content scroll width dynamically
  const updateDimensions = useCallback(() => {
    const bottomEl = bottomScrollRef.current;
    if (!bottomEl) return;

    // Use bottomEl.scrollWidth or contentRef.scrollWidth
    const sw = bottomEl.scrollWidth;
    const cw = bottomEl.clientWidth;

    setScrollWidth(sw);
    setHasOverflow(sw > cw + 2); // +2 for minor pixel rounding differences

    // Keep scroll position in sync when dimensions update
    if (topScrollRef.current) {
      topScrollRef.current.scrollLeft = bottomEl.scrollLeft;
    }
  }, []);

  useEffect(() => {
    updateDimensions();

    const bottomEl = bottomScrollRef.current;
    const contentEl = contentRef.current;

    let resizeObserver: ResizeObserver | null = null;
    if (typeof ResizeObserver !== "undefined") {
      resizeObserver = new ResizeObserver(() => {
        updateDimensions();
      });

      if (bottomEl) resizeObserver.observe(bottomEl);
      if (contentEl) resizeObserver.observe(contentEl);
    }

    window.addEventListener("resize", updateDimensions);

    // Also run a small requestAnimationFrame/timeout to catch post-render reflows
    const timer = setTimeout(updateDimensions, 150);

    return () => {
      if (resizeObserver) resizeObserver.disconnect();
      window.removeEventListener("resize", updateDimensions);
      clearTimeout(timer);
    };
  }, [updateDimensions, children]);

  // Handle synchronized scrolling
  useEffect(() => {
    const topEl = topScrollRef.current;
    const bottomEl = bottomScrollRef.current;
    if (!topEl || !bottomEl) return;

    const handleTopScroll = () => {
      if (isSyncingTop.current) {
        isSyncingTop.current = false;
        return;
      }
      isSyncingBottom.current = true;
      bottomEl.scrollLeft = topEl.scrollLeft;
    };

    const handleBottomScroll = () => {
      if (isSyncingBottom.current) {
        isSyncingBottom.current = false;
        return;
      }
      isSyncingTop.current = true;
      topEl.scrollLeft = bottomEl.scrollLeft;
    };

    topEl.addEventListener("scroll", handleTopScroll, { passive: true });
    bottomEl.addEventListener("scroll", handleBottomScroll, { passive: true });

    return () => {
      topEl.removeEventListener("scroll", handleTopScroll);
      bottomEl.removeEventListener("scroll", handleBottomScroll);
    };
  }, [hasOverflow]);

  return (
    <div className={`w-full flex flex-col ${className}`}>
      {/* Top Synchronized Scrollbar (Visible only when table overflows horizontally) */}
      {hasOverflow && (
        <div
          ref={topScrollRef}
          className={`overflow-x-auto overflow-y-hidden mb-1.5 scrollbar-thin ${topScrollClassName}`}
          style={{ height: "14px", minHeight: "14px" }}
          aria-hidden="true"
        >
          <div style={{ width: `${scrollWidth}px`, height: "1px" }} />
        </div>
      )}

      {/* Main Table / Content with Bottom Scrollbar */}
      <div
        ref={bottomScrollRef}
        className="overflow-x-auto w-full"
      >
        <div ref={contentRef} className="w-fit min-w-full">
          {children}
        </div>
      </div>
    </div>
  );
}
