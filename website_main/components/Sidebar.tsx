"use client";

import Image from "next/image";
import Link from "next/link";
import { X } from "lucide-react";

export interface SidebarProps {
  activeItem:
    | "Dashboard"
    | "Sellers / EPC"
    | "Scrap Dealers"
    | "Seller Posts"
    | "Auctions"
    | "Facebook Leads"
    | "Quotation history"
    | "Quotation History"
    | "My Inventory"
    | "Notifications"
    | "Settings";
  mobileMenuOpen: boolean;
  setMobileMenuOpen: (open: boolean) => void;
}

export const navItems = [
  { name: "Dashboard", icon: "/icons/dashboard.svg", href: "/dashboard" },
  { name: "Sellers / EPC", icon: "/icons/seller.svg", href: "/sellers" },
  { name: "Scrap Dealers", icon: "/icons/scrap-dealer.svg", href: "/scrap-dealers" },
  { name: "Seller Posts", icon: "/icons/seller-post.svg", href: "/seller-posts" },
  { name: "Auctions", icon: "/icons/auction.svg", href: "/auctions" },
  { name: "Facebook Leads", icon: "/icons/facebook-leads.svg", href: "/facebook-leads" },
  { name: "Quotation history", icon: "/icons/quotation-history.svg", href: "/quotation-history" },
  { name: "My Inventory", icon: "/icons/inventory.svg", href: "/my-inventory" },
  { name: "Notifications", icon: "/icons/notifications.svg", href: "/notifications" },
  { name: "Settings", icon: "/icons/setting.svg", href: "/settings" },
];

export default function Sidebar({
  activeItem,
  mobileMenuOpen,
  setMobileMenuOpen,
}: SidebarProps) {
  // Normalize active match for "Quotation history" / "Quotation History"
  const isMatch = (name: string) => {
    if (activeItem.toLowerCase() === name.toLowerCase()) return true;
    return false;
  };

  return (
    <>
      {/* Mobile Drawer Overlay */}
      {mobileMenuOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={() => setMobileMenuOpen(false)}
        />
      )}

      {/* Sidebar Navigation */}
      <aside
        className={`fixed lg:static top-0 bottom-0 left-0 z-50 w-64 bg-[#0F172A] text-white flex flex-col shrink-0 h-screen sticky top-0 overflow-y-auto transition-transform duration-300 ease-in-out ${
          mobileMenuOpen ? "translate-x-0" : "-translate-x-full lg:translate-x-0"
        }`}
      >
        {/* Logo matching Figma design */}
        <div className="h-[76px] flex items-center justify-center relative px-6 border-b border-slate-800/80 shrink-0">
          <Link href="/dashboard" className="flex items-center justify-center">
            <Image
              src="/images/solar-scrap-sidebar-logo.png"
              alt="Solar Scrap Logo"
              width={130}
              height={52}
              className="w-[125px] sm:w-[130px] h-auto object-contain"
              priority
            />
          </Link>
          <button
            type="button"
            onClick={() => setMobileMenuOpen(false)}
            className="absolute right-4 text-slate-400 hover:text-white lg:hidden p-1 rounded-md"
            aria-label="Close Sidebar"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Navigation Items */}
        <nav className="flex-1 overflow-y-auto px-4 py-6 space-y-1">
          {navItems.map((item) => {
            const active = isMatch(item.name);
            return (
              <Link
                key={item.name}
                href={item.href}
                onClick={() => setMobileMenuOpen(false)}
                className={`flex items-center gap-3.5 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                  active
                    ? "bg-[#009845] text-white shadow-sm"
                    : "text-slate-400 hover:text-white hover:bg-slate-800/60"
                }`}
              >
                <div className="w-5 h-5 flex items-center justify-center shrink-0">
                  <Image
                    src={item.icon}
                    alt={item.name}
                    width={18}
                    height={18}
                    className={`object-contain ${
                      active ? "brightness-0 invert" : "opacity-70"
                    }`}
                  />
                </div>
                <span className="truncate">{item.name}</span>
              </Link>
            );
          })}
        </nav>

        {/* Logout Button */}
        <div className="p-4 border-t border-slate-800 shrink-0 mt-auto">
          <Link
            href="/"
            className="flex items-center gap-3.5 px-3 py-2.5 rounded-lg text-sm font-medium text-red-400 hover:text-red-300 hover:bg-red-500/10 transition-colors group"
          >
            <div className="w-5 h-5 flex items-center justify-center shrink-0">
              <Image
                src="/icons/logout-button.svg"
                alt="Logout"
                width={18}
                height={18}
                className="opacity-80 group-hover:opacity-100"
              />
            </div>
            <span>Logout</span>
          </Link>
        </div>
      </aside>
    </>
  );
}
