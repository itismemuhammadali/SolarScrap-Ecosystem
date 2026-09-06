"use client";

import { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import {
  Search,
  Bell,
  User,
  Users,
  Clock,
  FileText,
  Gavel,
  TrendingUp,
  Share2,
  Trophy,
  Menu,
  X,
  Sun,
  LayoutDashboard,
  LogOut,
  Settings as SettingsIcon,
  ShieldCheck,
  Building2,
  FileSpreadsheet,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";

export default function DashboardPage() {
  const [activeNav, setActiveNav] = useState("Dashboard");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");

  const navItems = [
    { name: "Dashboard", icon: "/icons/dashboard.svg", href: "/dashboard" },
    { name: "Sellers / EPC", icon: "/icons/seller.svg", href: "/sellers" },
    { name: "Scrap Dealers", icon: "/icons/scrap-dealer.svg", href: "/scrap-dealers" },
    { name: "Seller Posts", icon: "/icons/seller-post.svg", href: "/seller-posts" },
    { name: "Auctions", icon: "/icons/auction.svg", href: "/auctions" },
    { name: "Bids", icon: "/icons/bids.svg", href: "/bids" },
    { name: "Facebook Leads", icon: "/icons/facebook-leads.svg", href: "/facebook-leads" },
    { name: "Quotation history", icon: "/icons/quotation-history.svg", href: "/quotation-history" },
    { name: "My Inventory", icon: "/icons/inventory.svg", href: "/my-inventory" },
    { name: "Notifications", icon: "/icons/notifications.svg", href: "/notifications" },
    { name: "Settings", icon: "/icons/setting.svg", href: "/settings" },
  ];

  const statCards = [
    {
      title: "Total Sellers",
      value: "4",
      iconBg: "bg-emerald-100/80 text-emerald-600",
      pillBg: "text-emerald-700 bg-emerald-50 border border-emerald-100",
      IconComponent: User,
      href: "/sellers",
    },
    {
      title: "Total Dealers",
      value: "4",
      iconBg: "bg-indigo-100/80 text-indigo-600",
      pillBg: "text-indigo-700 bg-indigo-50 border border-indigo-100",
      IconComponent: Users,
      href: "/scrap-dealers",
    },
    {
      title: "Pending Approvals",
      value: "4",
      iconBg: "bg-amber-100/80 text-amber-600",
      pillBg: "text-amber-700 bg-amber-50 border border-amber-100",
      IconComponent: Clock,
      href: "/sellers",
    },
    {
      title: "Pending Posts",
      value: "2",
      iconBg: "bg-purple-100/80 text-purple-600",
      pillBg: "text-purple-700 bg-purple-50 border border-purple-100",
      IconComponent: FileText,
      href: "/seller-posts",
    },
    {
      title: "Active Auctions",
      value: "2",
      iconBg: "bg-sky-100/80 text-sky-600",
      pillBg: "text-sky-700 bg-sky-50 border border-sky-100",
      IconComponent: Gavel,
      href: "/auctions",
    },
    {
      title: "Total Bids",
      value: "6",
      iconBg: "bg-rose-100/80 text-rose-600",
      pillBg: "text-rose-700 bg-rose-50 border border-rose-100",
      IconComponent: TrendingUp,
      href: "/bids",
    },
    {
      title: "Facebook Leads",
      value: "5",
      iconBg: "bg-blue-100/80 text-blue-600",
      pillBg: "text-blue-700 bg-blue-50 border border-blue-100",
      IconComponent: Share2,
      href: "/facebook-leads",
    },
  ];

  const cityLeads = [
    { city: "Karachi", count: 18, percentage: 90 },
    { city: "Lahore", count: 12, percentage: 60 },
    { city: "Islamabad", count: 8, percentage: 40 },
    { city: "Rawalpindi", count: 5, percentage: 25 },
    { city: "Faisalabad", count: 4, percentage: 20 },
  ];

  const recentActivities = [
    {
      id: 1,
      title: "Raza Ahmed registered as a new Seller",
      time: "5m ago",
      icon: User,
      iconBg: "bg-sky-50 text-sky-600 border border-sky-100",
    },
    {
      id: 2,
      title: "Bilal Hussain placed a bid of PKR 210,000 on AUC001",
      time: "18m ago",
      icon: Gavel,
      iconBg: "bg-amber-50 text-amber-600 border border-amber-100",
    },
    {
      id: 3,
      title: "Sana Malik submitted a new scrap post — Solar Panels",
      time: "2h ago",
      icon: FileSpreadsheet,
      iconBg: "bg-orange-50 text-orange-600 border border-orange-100",
    },
    {
      id: 4,
      title: "Auction AUC002 published — Transformer (2 units)",
      time: "3h ago",
      icon: Gavel,
      iconBg: "bg-cyan-50 text-cyan-600 border border-cyan-100",
    },
    {
      id: 5,
      title: "Winner selected for AUC004 — Bilal Hussain",
      time: "5h ago",
      icon: Trophy,
      iconBg: "bg-yellow-50 text-yellow-600 border border-yellow-100",
    },
    {
      id: 6,
      title: "New Facebook lead — Kamran Sheikh, Karachi",
      time: "6h ago",
      icon: Share2,
      iconBg: "bg-blue-50 text-blue-600 border border-blue-100",
    },
  ];

  return (
    <div className="min-h-screen w-full bg-[#f8fafc] flex flex-col lg:flex-row">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Dashboard"
        mobileMenuOpen={mobileMenuOpen}
        setMobileMenuOpen={setMobileMenuOpen}
      />

      {/* ===================== MAIN CONTENT AREA ===================== */}
      <div className="flex-1 bg-[#f8fafc] flex flex-col min-w-0 min-h-screen">
        
        {/* Top Navbar */}
        <header className="sticky top-0 z-20 bg-white border-b border-gray-200/80 px-5 sm:px-8 py-3.5 flex items-center justify-between gap-4">
            {/* Search Input */}
            <div className="relative flex-1 max-w-[420px]">
              <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search users, posts, auctions, bids..."
                className="w-full pl-10 pr-4 py-2 text-xs sm:text-sm bg-gray-50/70 border border-gray-200/80 rounded-xl outline-none focus:bg-white focus:border-[#009639] focus:ring-2 focus:ring-[#009639]/15 transition-all text-gray-800 placeholder:text-gray-400"
              />
            </div>

            {/* Right Admin Profile */}
            <div className="flex items-center gap-4 sm:gap-6">
              {/* Notification Bell */}
              <Link
                href="/notifications"
                className="relative p-2 text-gray-500 hover:text-gray-800 hover:bg-gray-100 rounded-full transition-colors"
                aria-label="Notifications"
              >
                <Bell className="w-4.5 h-4.5" />
                <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white" />
              </Link>

              {/* Admin Platform & Avatar */}
              <div className="flex items-center gap-3 pl-2 sm:border-l border-gray-200">
                <span className="hidden sm:inline-block text-xs font-semibold text-gray-800">
                  Admin Platform
                </span>
                <div className="relative w-8.5 h-8.5 sm:w-9 sm:h-9 rounded-full overflow-hidden ring-2 ring-gray-100 shadow-sm">
                  <Image
                    src="/images/admin.png"
                    alt="Admin Avatar"
                    fill
                    className="object-cover"
                  />
                </div>
              </div>
            </div>
          </header>

          {/* Dashboard Body */}
          <main className="flex-1 p-5 sm:p-7 md:p-8 space-y-6 overflow-y-auto">
            
            {/* Greeting Header */}
            <div>
              <h1 className="text-xl sm:text-2xl font-bold text-gray-900 tracking-tight flex items-center gap-2">
                Good morning, Admin <span className="text-xl">👋</span>
              </h1>
              <p className="text-xs text-gray-500 mt-0.5">
                Here&apos;s what&apos;s happening on Solar Scrap today.
              </p>
            </div>

            {/* Stat Cards - Top Grid */}
            <div className="grid grid-cols-2 sm:grid-cols-2 md:grid-cols-4 gap-3 sm:gap-4">
              {statCards.slice(0, 4).map((stat) => {
                const Icon = stat.IconComponent;
                return (
                  <div
                    key={stat.title}
                    className="bg-white rounded-2xl p-4 sm:p-5 border border-gray-200/70 shadow-sm hover:shadow-md transition-shadow duration-200 flex flex-col justify-between"
                  >
                    <div className="flex items-center justify-between">
                      <div className={`w-8 h-8 rounded-xl ${stat.iconBg} flex items-center justify-center shadow-xs`}>
                        <Icon className="w-4 h-4" />
                      </div>
                      <Link
                        href={stat.href || "#"}
                        className={`text-[10px] font-medium px-2 py-0.5 rounded-full hover:opacity-80 transition-opacity ${stat.pillBg}`}
                      >
                        View →
                      </Link>
                    </div>
                    <div className="mt-3">
                      <p className="text-2xl font-bold text-gray-900 tracking-tight leading-none">
                        {stat.value}
                      </p>
                      <p className="text-[11px] font-medium text-gray-500 mt-1.5 truncate">
                        {stat.title}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>

            {/* Stat Cards - Second Row (3 items) */}
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 sm:gap-4">
              {statCards.slice(4, 7).map((stat) => {
                const Icon = stat.IconComponent;
                return (
                  <div
                    key={stat.title}
                    className="bg-white rounded-2xl p-4 sm:p-5 border border-gray-200/70 shadow-sm hover:shadow-md transition-shadow duration-200 flex flex-col justify-between"
                  >
                    <div className="flex items-center justify-between">
                      <div className={`w-8 h-8 rounded-xl ${stat.iconBg} flex items-center justify-center shadow-xs`}>
                        <Icon className="w-4 h-4" />
                      </div>
                      <span className={`text-[10px] font-medium px-2 py-0.5 rounded-full ${stat.pillBg}`}>
                        View →
                      </span>
                    </div>
                    <div className="mt-3">
                      <p className="text-2xl font-bold text-gray-900 tracking-tight leading-none">
                        {stat.value}
                      </p>
                      <p className="text-[11px] font-medium text-gray-500 mt-1.5 truncate">
                        {stat.title}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>

            {/* ===================== MIDDLE CHARTS SECTION ===================== */}
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-5">
              
              {/* User Growth Line Chart (8 cols) */}
              <div className="lg:col-span-8 bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/70 shadow-sm flex flex-col justify-between">
                <div>
                  <h3 className="text-sm font-bold text-gray-900">User Growth</h3>
                  <p className="text-xs text-gray-500 mt-0.5">Sellers &amp; dealers over 6 months</p>
                </div>

                {/* SVG Line Chart */}
                <div className="mt-4 w-full h-[210px] relative flex flex-col justify-end">
                  {/* Grid Lines & Labels */}
                  <div className="absolute inset-0 flex flex-col justify-between text-[10px] text-gray-400 pointer-events-none pb-6">
                    <div className="flex items-center gap-2">
                      <span className="w-5 text-right">60</span>
                      <div className="flex-1 border-b border-gray-100 border-dashed" />
                    </div>
                    <div className="flex items-center gap-2">
                      <span className="w-5 text-right">45</span>
                      <div className="flex-1 border-b border-gray-100 border-dashed" />
                    </div>
                    <div className="flex items-center gap-2">
                      <span className="w-5 text-right">30</span>
                      <div className="flex-1 border-b border-gray-100 border-dashed" />
                    </div>
                    <div className="flex items-center gap-2">
                      <span className="w-5 text-right">15</span>
                      <div className="flex-1 border-b border-gray-100 border-dashed" />
                    </div>
                    <div className="flex items-center gap-2">
                      <span className="w-5 text-right">0</span>
                      <div className="flex-1 border-b border-gray-100" />
                    </div>
                  </div>

                  {/* SVG Curves */}
                  <svg
                    viewBox="0 0 500 160"
                    className="w-full h-[150px] overflow-visible pl-7 pr-2"
                    preserveAspectRatio="none"
                  >
                    <defs>
                      <linearGradient id="sellersGrad" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stopColor="#009639" stopOpacity="0.25" />
                        <stop offset="100%" stopColor="#009639" stopOpacity="0.0" />
                      </linearGradient>
                      <linearGradient id="dealersGrad" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stopColor="#4f46e5" stopOpacity="0.2" />
                        <stop offset="100%" stopColor="#4f46e5" stopOpacity="0.0" />
                      </linearGradient>
                    </defs>

                    {/* Area fills */}
                    <path
                      d="M 0 130 C 100 120, 200 95, 300 75 C 400 55, 450 40, 500 30 L 500 160 L 0 160 Z"
                      fill="url(#sellersGrad)"
                    />
                    <path
                      d="M 0 145 C 100 140, 200 120, 300 105 C 400 90, 450 78, 500 68 L 500 160 L 0 160 Z"
                      fill="url(#dealersGrad)"
                    />

                    {/* Blue Line - Dealers */}
                    <path
                      d="M 0 145 C 100 140, 200 120, 300 105 C 400 90, 450 78, 500 68"
                      fill="none"
                      stroke="#4f46e5"
                      strokeWidth="2.5"
                      strokeLinecap="round"
                    />

                    {/* Green Line - Sellers */}
                    <path
                      d="M 0 130 C 100 120, 200 95, 300 75 C 400 55, 450 40, 500 30"
                      fill="none"
                      stroke="#009639"
                      strokeWidth="2.5"
                      strokeLinecap="round"
                    />
                  </svg>

                  {/* X Axis Month Labels */}
                  <div className="flex justify-between text-[11px] font-medium text-gray-400 pl-7 pr-2 pt-2">
                    <span>Jul</span>
                    <span>Aug</span>
                    <span>Sep</span>
                    <span>Oct</span>
                    <span>Nov</span>
                    <span>Dec</span>
                  </div>
                </div>

                {/* Legend */}
                <div className="flex items-center justify-center gap-6 mt-4 pt-3 border-t border-gray-100 text-xs font-semibold">
                  <div className="flex items-center gap-2 text-emerald-700">
                    <span className="w-2.5 h-2.5 rounded-full bg-[#009639]" />
                    <span>Sellers</span>
                  </div>
                  <div className="flex items-center gap-2 text-indigo-700">
                    <span className="w-2.5 h-2.5 rounded-full bg-[#4f46e5]" />
                    <span>Dealers</span>
                  </div>
                </div>
              </div>

              {/* User Status Donut Chart (4 cols) */}
              <div className="lg:col-span-4 bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/70 shadow-sm flex flex-col justify-between">
                <div>
                  <h3 className="text-sm font-bold text-gray-900">User Status</h3>
                  <p className="text-xs text-gray-500 mt-0.5">Account approval breakdown</p>
                </div>

                {/* Donut Chart Display */}
                <div className="flex flex-col items-center justify-center my-3">
                  <div className="relative w-36 h-36">
                    <svg viewBox="0 0 100 100" className="w-full h-full -rotate-90">
                      {/* Orange - Pending 4 (50%) */}
                      <circle
                        cx="50"
                        cy="50"
                        r="38"
                        fill="transparent"
                        stroke="#f59e0b"
                        strokeWidth="14"
                        strokeDasharray="120 120"
                        strokeDashoffset="0"
                      />
                      {/* Green - Approved 3 (37.5%) */}
                      <circle
                        cx="50"
                        cy="50"
                        r="38"
                        fill="transparent"
                        stroke="#009639"
                        strokeWidth="14"
                        strokeDasharray="90 150"
                        strokeDashoffset="-120"
                      />
                      {/* Red - Rejected 1 (12.5%) */}
                      <circle
                        cx="50"
                        cy="50"
                        r="38"
                        fill="transparent"
                        stroke="#ef4444"
                        strokeWidth="14"
                        strokeDasharray="30 210"
                        strokeDashoffset="-210"
                      />
                    </svg>
                  </div>
                </div>

                {/* Status Breakdown Legend */}
                <div className="space-y-2 pt-2 border-t border-gray-100 text-xs">
                  <div className="flex items-center justify-between text-gray-600">
                    <div className="flex items-center gap-2">
                      <span className="w-2.5 h-2.5 rounded-full bg-[#009639]" />
                      <span>Approved</span>
                    </div>
                    <span className="font-bold text-gray-900">3</span>
                  </div>
                  <div className="flex items-center justify-between text-gray-600">
                    <div className="flex items-center gap-2">
                      <span className="w-2.5 h-2.5 rounded-full bg-[#f59e0b]" />
                      <span>Pending</span>
                    </div>
                    <span className="font-bold text-gray-900">4</span>
                  </div>
                  <div className="flex items-center justify-between text-gray-600">
                    <div className="flex items-center gap-2">
                      <span className="w-2.5 h-2.5 rounded-full bg-[#ef4444]" />
                      <span>Rejected</span>
                    </div>
                    <span className="font-bold text-gray-900">1</span>
                  </div>
                </div>
              </div>

            </div>

            {/* ===================== BOTTOM SECTION (3 COLUMNS) ===================== */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
              
              {/* Column 1: Bid Activity Bar Chart */}
              <div className="bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/70 shadow-sm flex flex-col justify-between">
                <div>
                  <h3 className="text-sm font-bold text-gray-900">Bid Activity</h3>
                  <p className="text-xs text-gray-500 mt-0.5">Weekly bids placed</p>
                </div>

                {/* Bar Chart */}
                <div className="mt-5 h-[170px] flex items-end justify-between gap-2.5 px-1 relative">
                  {/* Y Axis Guide */}
                  <div className="absolute inset-0 flex flex-col justify-between text-[9px] text-gray-300 pointer-events-none -left-1">
                    <span>20</span>
                    <span>15</span>
                    <span>10</span>
                    <span>5</span>
                    <span>0</span>
                  </div>

                  {/* Bars */}
                  {[
                    { week: "W1", height: "20%" },
                    { week: "W2", height: "45%" },
                    { week: "W3", height: "30%" },
                    { week: "W4", height: "75%" },
                    { week: "W5", height: "55%" },
                    { week: "W6", height: "95%" },
                  ].map((bar) => (
                    <div key={bar.week} className="flex-1 flex flex-col items-center gap-1.5 z-10">
                      <div className="w-full bg-gray-50 rounded-md h-[120px] flex items-end">
                        <div
                          style={{ height: bar.height }}
                          className="w-full bg-[#009639] rounded-md transition-all duration-500 hover:bg-[#008230]"
                        />
                      </div>
                      <span className="text-[10px] font-semibold text-gray-400">{bar.week}</span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Column 2: Leads by City */}
              <div className="bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/70 shadow-sm flex flex-col justify-between">
                <div>
                  <h3 className="text-sm font-bold text-gray-900">Leads by City</h3>
                  <p className="text-xs text-gray-500 mt-0.5">Share2 leads distribution</p>
                </div>

                <div className="space-y-3.5 mt-4">
                  {cityLeads.map((item) => (
                    <div key={item.city} className="space-y-1">
                      <div className="flex items-center justify-between text-xs font-semibold text-gray-700">
                        <span>{item.city}</span>
                        <span className="text-gray-900 font-bold">{item.count}</span>
                      </div>
                      <div className="w-full bg-gray-100 rounded-full h-2 overflow-hidden">
                        <div
                          style={{ width: `${item.percentage}%` }}
                          className="bg-[#009639] h-full rounded-full transition-all duration-500"
                        />
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Column 3: Recent Activity Feed */}
              <div className="bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/70 shadow-sm flex flex-col justify-between">
                <div>
                  <h3 className="text-sm font-bold text-gray-900">Recent Activity</h3>
                </div>

                <div className="space-y-3 mt-3 overflow-y-auto max-h-[220px] pr-1">
                  {recentActivities.map((act) => {
                    const ActIcon = act.icon;
                    return (
                      <div key={act.id} className="flex items-start gap-2.5 text-xs">
                        <div className={`w-6 h-6 rounded-lg ${act.iconBg} flex items-center justify-center shrink-0 mt-0.5`}>
                          <ActIcon className="w-3.5 h-3.5" />
                        </div>
                        <div className="flex-1 min-w-0">
                          <p className="text-[11px] font-medium text-gray-800 leading-tight">
                            {act.title}
                          </p>
                          <span className="text-[10px] text-gray-400">{act.time}</span>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

            </div>

          </main>

        </div>

    </div>
  );
}
