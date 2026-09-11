"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
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
  FileSpreadsheet,
  RefreshCw,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";
import { getSession, getAvatarUrl, clearSession } from "@/lib/auth";
import { getDashboardStats, seedDemoData } from "@/lib/admin-api";
import { DashboardStatsResponse } from "@/lib/types";

export default function DashboardPage() {
  const router = useRouter();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [adminName, setAdminName] = useState("Admin");
  const [adminPhotoUrl, setAdminPhotoUrl] = useState<string | null>(null);
  const [unreadCount, setUnreadCount] = useState(0);
  const [isLoading, setIsLoading] = useState(true);
  const [isSeeding, setIsSeeding] = useState(false);
  const [dashboardData, setDashboardData] = useState<DashboardStatsResponse | null>(null);

  // Fetch admin session and dashboard metrics
  const loadStats = async () => {
    try {
      setIsLoading(true);
      const session = getSession();
      if (!session?.token) {
        clearSession();
        router.replace("/");
        return;
      }
      if (session.user) {
        if (session.user.display_name) {
          setAdminName(session.user.display_name);
        } else if (session.user.email) {
          const username = session.user.email.split("@")[0];
          setAdminName(username.charAt(0).toUpperCase() + username.slice(1));
        }
        if (session.user.profile_photo_url) {
          setAdminPhotoUrl(session.user.profile_photo_url);
        }
      }

      if (typeof window !== "undefined") {
        const storedCount = localStorage.getItem("admin_unread_count");
        if (storedCount) {
          setUnreadCount(parseInt(storedCount, 10) || 0);
        }
      }

      const stats = await getDashboardStats();
      setDashboardData(stats);
    } catch (err) {
      console.error("Failed to load dashboard metrics:", err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    const session = getSession();
    if (!session?.token) {
      clearSession();
      router.replace("/");
      return;
    }
    loadStats();
  }, [router]);

  const handleSeedData = async () => {
    try {
      setIsSeeding(true);
      await seedDemoData();
      await loadStats();
    } catch (err) {
      console.error("Failed to seed demo data:", err);
    } finally {
      setIsSeeding(false);
    }
  };

  // Dynamic stat cards
  const stats = dashboardData?.stats;
  const statCards = [
    {
      title: "Total Sellers",
      value: isLoading ? "-" : (stats?.total_sellers ?? 0).toString(),
      iconBg: "bg-emerald-50 text-[#009845]",
      pillBg: "text-emerald-700 bg-emerald-50 border border-emerald-100/60",
      IconComponent: User,
      href: "/sellers",
    },
    {
      title: "Total Dealers",
      value: isLoading ? "-" : (stats?.total_dealers ?? 0).toString(),
      iconBg: "bg-indigo-50 text-indigo-600",
      pillBg: "text-indigo-700 bg-indigo-50 border border-indigo-100/60",
      IconComponent: Users,
      href: "/scrap-dealers",
    },
    {
      title: "Pending Approvals",
      value: isLoading ? "-" : (stats?.pending_approvals ?? 0).toString(),
      iconBg: "bg-amber-50 text-amber-600",
      pillBg: "text-amber-700 bg-amber-50 border border-amber-100/60",
      IconComponent: Clock,
      href: "/sellers?status=Pending",
    },
    {
      title: "Pending Posts",
      value: isLoading ? "-" : (stats?.pending_posts ?? 0).toString(),
      iconBg: "bg-purple-50 text-purple-600",
      pillBg: "text-purple-700 bg-purple-50 border border-purple-100/60",
      IconComponent: FileText,
      href: "/seller-posts",
    },
    {
      title: "Active Auctions",
      value: isLoading ? "-" : (stats?.active_auctions ?? 0).toString(),
      iconBg: "bg-sky-50 text-sky-600",
      pillBg: "text-sky-700 bg-sky-50 border border-sky-100/60",
      IconComponent: Gavel,
      href: "/auctions",
    },
    {
      title: "Total Bids",
      value: isLoading ? "-" : (stats?.total_bids ?? 0).toString(),
      iconBg: "bg-rose-50 text-rose-600",
      pillBg: "text-rose-700 bg-rose-50 border border-rose-100/60",
      IconComponent: TrendingUp,
      href: "/bids",
    },
    {
      title: "Facebook Leads",
      value: isLoading ? "-" : (stats?.facebook_leads ?? 0).toString(),
      iconBg: "bg-blue-50 text-blue-600",
      pillBg: "text-blue-700 bg-blue-50 border border-blue-100/60",
      IconComponent: Share2,
      href: "/facebook-leads",
    },
  ];

  // User status breakdown
  const statusData = dashboardData?.user_status || { approved: 0, pending: 0, rejected: 0 };
  const totalStatusUsers = statusData.approved + statusData.pending + statusData.rejected;
  const pendingDash = totalStatusUsers > 0 ? Math.round((statusData.pending / totalStatusUsers) * 240) : 0;
  const approvedDash = totalStatusUsers > 0 ? Math.round((statusData.approved / totalStatusUsers) * 240) : 0;
  const rejectedDash = totalStatusUsers > 0 ? Math.round((statusData.rejected / totalStatusUsers) * 240) : 0;

  // Leads by city (real dynamic data)
  const cityLeads = dashboardData?.city_leads || [];

  // Bid activity (real dynamic data)
  const bidActivity = dashboardData?.bid_activity || [];
  const maxBidCount = Math.max(...bidActivity.map((b) => b.count), 5);

  // Dynamic User Growth Line Chart calculations
  const userGrowth = dashboardData?.user_growth || [
    { month: "Jul", sellers: 0, dealers: 0 },
    { month: "Aug", sellers: 0, dealers: 0 },
    { month: "Sep", sellers: 0, dealers: 0 },
    { month: "Oct", sellers: 0, dealers: 0 },
    { month: "Nov", sellers: 0, dealers: 0 },
    { month: "Dec", sellers: 0, dealers: 0 },
  ];

  const maxGrowthVal = Math.max(
    ...userGrowth.map((g) => Math.max(g.sellers, g.dealers)),
    10
  );

  const buildSvgPath = (dataKey: "sellers" | "dealers") => {
    if (userGrowth.length === 0) return "M 0 145 L 500 145";
    const n = userGrowth.length;
    const points = userGrowth.map((item, idx) => {
      const x = n > 1 ? (idx / (n - 1)) * 500 : 250;
      const val = item[dataKey];
      const y = 145 - (val / maxGrowthVal) * 120;
      return { x, y };
    });

    return points.reduce((acc, pt, idx, arr) => {
      if (idx === 0) return `M ${pt.x} ${pt.y}`;
      const prev = arr[idx - 1];
      const cpX1 = prev.x + (pt.x - prev.x) * 0.4;
      const cpY1 = prev.y;
      const cpX2 = prev.x + (pt.x - prev.x) * 0.6;
      const cpY2 = pt.y;
      return `${acc} C ${cpX1} ${cpY1}, ${cpX2} ${cpY2}, ${pt.x} ${pt.y}`;
    }, "");
  };

  const sellersPath = buildSvgPath("sellers");
  const dealersPath = buildSvgPath("dealers");
  const sellersArea = `${sellersPath} L 500 160 L 0 160 Z`;
  const dealersArea = `${dealersPath} L 500 160 L 0 160 Z`;

  // Recent activities mapping (real dynamic feed)
  const getActivityIcon = (type: string) => {
    switch (type) {
      case "user":
        return { icon: User, bg: "bg-sky-50 text-sky-600 border border-sky-100" };
      case "bid":
        return { icon: Gavel, bg: "bg-amber-50 text-amber-600 border border-amber-100" };
      case "post":
        return { icon: FileSpreadsheet, bg: "bg-orange-50 text-orange-600 border border-orange-100" };
      case "auction":
        return { icon: Trophy, bg: "bg-yellow-50 text-yellow-600 border border-yellow-100" };
      case "lead":
      default:
        return { icon: Share2, bg: "bg-blue-50 text-blue-600 border border-blue-100" };
    }
  };

  const recentActivities = dashboardData?.recent_activities || [];

  return (
    <div className="flex h-screen w-full bg-[#F5F6FA] overflow-hidden">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Dashboard"
        mobileMenuOpen={mobileMenuOpen}
        setMobileMenuOpen={setMobileMenuOpen}
      />

      {/* ===================== MAIN CONTENT AREA ===================== */}
      <div className="flex-1 bg-[#F5F6FA] flex flex-col min-w-0 h-screen overflow-hidden">
        
        {/* Top Navbar */}
        <header className="sticky top-0 z-20 bg-white border-b border-gray-200/80 px-5 sm:px-8 py-3.5 flex items-center justify-between gap-4">
          {/* Mobile menu trigger */}
          <button
            type="button"
            onClick={() => setMobileMenuOpen(true)}
            className="p-2 -ml-2 text-gray-600 hover:text-gray-900 lg:hidden rounded-lg focus:outline-none"
            aria-label="Open Sidebar"
          >
            <Menu className="w-5 h-5" />
          </button>

          {/* Search Input */}
          <div className="relative flex-1 max-w-[420px]">
            <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search users, posts, auctions, bids..."
              className="w-full pl-10 pr-4 py-2 text-xs sm:text-sm bg-gray-50/70 border border-gray-200/80 rounded-xl outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all text-gray-800 placeholder:text-gray-400"
            />
          </div>

          {/* Right Controls */}
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
              <div className="relative w-8.5 h-8.5 sm:w-9 sm:h-9 rounded-full overflow-hidden ring-2 ring-gray-100 shadow-sm bg-emerald-700 flex items-center justify-center text-white font-bold text-sm select-none">
                {adminPhotoUrl ? (
                  /* eslint-disable-next-line @next/next/no-img-element */
                  <img
                    src={getAvatarUrl(adminPhotoUrl)!}
                    alt={adminName}
                    className="w-full h-full object-cover"
                  />
                ) : (
                  <span>{adminName ? adminName.charAt(0).toUpperCase() : "A"}</span>
                )}
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

          {/* Stat Cards - Single 4-column Grid (1:1 with Figma) */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4">
            {statCards.map((stat) => {
              const Icon = stat.IconComponent;
              return (
                <div
                  key={stat.title}
                  className="bg-white rounded-2xl p-4 sm:p-5 border border-gray-100 shadow-2xs hover:shadow-xs transition-shadow duration-200 flex flex-col justify-between"
                >
                  <div className="flex items-center justify-between">
                    <div className={`w-9 h-9 rounded-full ${stat.iconBg} flex items-center justify-center`}>
                      <Icon className="w-4.5 h-4.5" />
                    </div>
                    <Link
                      href={stat.href || "#"}
                      className={`text-[10px] font-semibold px-2.5 py-0.5 rounded-full hover:opacity-80 transition-opacity ${stat.pillBg}`}
                    >
                      View →
                    </Link>
                  </div>
                  <div className="mt-4">
                    <p className="text-3xl font-bold text-gray-900 tracking-tight leading-none">
                      {stat.value}
                    </p>
                    <p className="text-xs font-medium text-gray-400 mt-2 truncate">
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
            <div className="lg:col-span-8 bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/70 shadow-xs flex flex-col justify-between">
              <div>
                <h3 className="text-sm font-bold text-gray-900">User Growth</h3>
                <p className="text-xs text-gray-500 mt-0.5">Sellers &amp; dealers over 6 months</p>
              </div>

              {/* SVG Line Chart */}
              <div className="mt-4 w-full h-[210px] relative flex flex-col justify-end">
                {/* Grid Lines & Labels */}
                <div className="absolute inset-0 flex flex-col justify-between text-[10px] text-gray-400 pointer-events-none pb-6">
                  <div className="flex items-center gap-2">
                    <span className="w-5 text-right">{maxGrowthVal}</span>
                    <div className="flex-1 border-b border-gray-100 border-dashed" />
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="w-5 text-right">{Math.round(maxGrowthVal * 0.75)}</span>
                    <div className="flex-1 border-b border-gray-100 border-dashed" />
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="w-5 text-right">{Math.round(maxGrowthVal * 0.5)}</span>
                    <div className="flex-1 border-b border-gray-100 border-dashed" />
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="w-5 text-right">{Math.round(maxGrowthVal * 0.25)}</span>
                    <div className="flex-1 border-b border-gray-100 border-dashed" />
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="w-5 text-right">0</span>
                    <div className="flex-1 border-b border-gray-100" />
                  </div>
                </div>

                {/* Dynamic SVG Curves */}
                <svg
                  viewBox="0 0 500 160"
                  className="w-full h-[150px] overflow-visible pl-7 pr-2"
                  preserveAspectRatio="none"
                >
                  <defs>
                    <linearGradient id="sellersGrad" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="0%" stopColor="#009845" stopOpacity="0.25" />
                      <stop offset="100%" stopColor="#009845" stopOpacity="0.0" />
                    </linearGradient>
                    <linearGradient id="dealersGrad" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="0%" stopColor="#4f46e5" stopOpacity="0.2" />
                      <stop offset="100%" stopColor="#4f46e5" stopOpacity="0.0" />
                    </linearGradient>
                  </defs>

                  {/* Dynamic Area fills */}
                  <path d={sellersArea} fill="url(#sellersGrad)" />
                  <path d={dealersArea} fill="url(#dealersGrad)" />

                  {/* Blue Line - Dealers */}
                  <path
                    d={dealersPath}
                    fill="none"
                    stroke="#4f46e5"
                    strokeWidth="2.5"
                    strokeLinecap="round"
                  />

                  {/* Green Line - Sellers */}
                  <path
                    d={sellersPath}
                    fill="none"
                    stroke="#009845"
                    strokeWidth="2.5"
                    strokeLinecap="round"
                  />
                </svg>

                {/* X Axis Dynamic Month Labels */}
                <div className="flex justify-between text-[11px] font-medium text-gray-400 pl-7 pr-2 pt-2">
                  {userGrowth.map((g) => (
                    <span key={g.month}>{g.month}</span>
                  ))}
                </div>
              </div>

              {/* Legend */}
              <div className="flex items-center justify-center gap-6 mt-4 pt-3 border-t border-gray-100 text-xs font-semibold">
                <div className="flex items-center gap-1.5 text-[#009845]">
                  <span className="inline-block w-2.5 h-0.5 bg-[#009845]" />
                  <span className="inline-block w-2 h-2 rounded-full bg-[#009845] -ml-1.5" />
                  <span className="inline-block w-2.5 h-0.5 bg-[#009845] -ml-1" />
                  <span className="ml-1 text-gray-600 font-medium">Sellers</span>
                </div>
                <div className="flex items-center gap-1.5 text-[#4f46e5]">
                  <span className="inline-block w-2.5 h-0.5 bg-[#4f46e5]" />
                  <span className="inline-block w-2 h-2 rounded-full bg-[#4f46e5] -ml-1.5" />
                  <span className="inline-block w-2.5 h-0.5 bg-[#4f46e5] -ml-1" />
                  <span className="ml-1 text-gray-600 font-medium">Dealers</span>
                </div>
              </div>
            </div>

            {/* User Status Donut Chart (4 cols) */}
            <div className="lg:col-span-4 bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/70 shadow-xs flex flex-col justify-between">
              <div>
                <h3 className="text-sm font-bold text-gray-900">User Status</h3>
                <p className="text-xs text-gray-500 mt-0.5">Account approval breakdown</p>
              </div>

              {/* Donut Chart Display */}
              <div className="flex flex-col items-center justify-center my-3">
                <div className="relative w-36 h-36">
                  <svg viewBox="0 0 100 100" className="w-full h-full -rotate-90">
                    {totalStatusUsers === 0 ? (
                      <circle
                        cx="50"
                        cy="50"
                        r="38"
                        fill="transparent"
                        stroke="#E5E7EB"
                        strokeWidth="14"
                      />
                    ) : (
                      <>
                        {/* Orange - Pending */}
                        <circle
                          cx="50"
                          cy="50"
                          r="38"
                          fill="transparent"
                          stroke="#f59e0b"
                          strokeWidth="14"
                          strokeDasharray={`${pendingDash} 240`}
                          strokeDashoffset="0"
                        />
                        {/* Green - Approved */}
                        <circle
                          cx="50"
                          cy="50"
                          r="38"
                          fill="transparent"
                          stroke="#009845"
                          strokeWidth="14"
                          strokeDasharray={`${approvedDash} 240`}
                          strokeDashoffset={`-${pendingDash}`}
                        />
                        {/* Red - Rejected */}
                        <circle
                          cx="50"
                          cy="50"
                          r="38"
                          fill="transparent"
                          stroke="#ef4444"
                          strokeWidth="14"
                          strokeDasharray={`${rejectedDash} 240`}
                          strokeDashoffset={`-${pendingDash + approvedDash}`}
                        />
                      </>
                    )}
                  </svg>
                </div>
              </div>

              {/* Status Breakdown Legend */}
              <div className="space-y-2 pt-2 border-t border-gray-100 text-xs">
                <div className="flex items-center justify-between text-gray-600">
                  <div className="flex items-center gap-2">
                    <span className="w-2.5 h-2.5 rounded-full bg-[#009845]" />
                    <span>Approved</span>
                  </div>
                  <span className="font-bold text-gray-900">{statusData.approved}</span>
                </div>
                <div className="flex items-center justify-between text-gray-600">
                  <div className="flex items-center gap-2">
                    <span className="w-2.5 h-2.5 rounded-full bg-[#f59e0b]" />
                    <span>Pending</span>
                  </div>
                  <span className="font-bold text-gray-900">{statusData.pending}</span>
                </div>
                <div className="flex items-center justify-between text-gray-600">
                  <div className="flex items-center gap-2">
                    <span className="w-2.5 h-2.5 rounded-full bg-[#ef4444]" />
                    <span>Rejected</span>
                  </div>
                  <span className="font-bold text-gray-900">{statusData.rejected}</span>
                </div>
              </div>
            </div>

          </div>

          {/* ===================== BOTTOM SECTION (3 COLUMNS) ===================== */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
            
            {/* Column 1: Bid Activity Bar Chart */}
            <div className="bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/70 shadow-xs flex flex-col justify-between">
              <div>
                <h3 className="text-sm font-bold text-gray-900">Bid Activity</h3>
                <p className="text-xs text-gray-500 mt-0.5">Weekly bids placed</p>
              </div>

              {/* Bar Chart */}
              {bidActivity.length === 0 ? (
                <div className="py-12 text-center text-xs text-gray-400 font-medium">
                  No bid activity recorded yet.
                </div>
              ) : (
                <div className="mt-5 h-[170px] flex items-end justify-between gap-2.5 px-1 relative">
                  {/* Y Axis Guide */}
                  <div className="absolute inset-0 flex flex-col justify-between text-[9px] text-gray-300 pointer-events-none -left-1">
                    <span>{maxBidCount}</span>
                    <span>{Math.round(maxBidCount * 0.75)}</span>
                    <span>{Math.round(maxBidCount * 0.5)}</span>
                    <span>{Math.round(maxBidCount * 0.25)}</span>
                    <span>0</span>
                  </div>

                  {/* Bars */}
                  {bidActivity.map((bar) => {
                    const heightPct = maxBidCount > 0 ? Math.round((bar.count / maxBidCount) * 100) : 0;
                    return (
                      <div key={bar.week} className="flex-1 flex flex-col items-center gap-1.5 z-10">
                        <div className="w-full bg-gray-50 rounded-md h-[120px] flex items-end">
                          <div
                            style={{ height: `${heightPct}%` }}
                            className="w-full bg-[#009845] rounded-md transition-all duration-500 hover:bg-[#008230]"
                            title={`${bar.week}: ${bar.count} bids`}
                          />
                        </div>
                        <span className="text-[10px] font-semibold text-gray-400">{bar.week}</span>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>

            {/* Column 2: Leads by City */}
            <div className="bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/70 shadow-xs flex flex-col justify-between">
              <div>
                <h3 className="text-sm font-bold text-gray-900">Leads by City</h3>
                <p className="text-xs text-gray-500 mt-0.5">Distribution across major hubs</p>
              </div>

              {cityLeads.length === 0 ? (
                <div className="py-12 text-center text-xs text-gray-400 font-medium">
                  No city lead data available yet.
                </div>
              ) : (
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
                          className="bg-[#009845] h-full rounded-full transition-all duration-500"
                        />
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Column 3: Recent Activity Feed */}
            <div className="bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/70 shadow-xs flex flex-col justify-between">
              <div>
                <h3 className="text-sm font-bold text-gray-900">Recent Activity</h3>
                <p className="text-xs text-gray-500 mt-0.5">Live platform transactions</p>
              </div>

              <div className="space-y-3 mt-3 overflow-y-auto max-h-[220px] pr-1">
                {recentActivities.length === 0 ? (
                  <div className="py-12 text-center text-xs text-gray-400 font-medium">
                    No recent activity recorded yet.
                  </div>
                ) : (
                  recentActivities.map((act) => {
                    const { icon: ActIcon, bg } = getActivityIcon(act.type);
                    return (
                      <div key={act.id} className="flex items-start gap-2.5 text-xs">
                        <div className={`w-6 h-6 rounded-lg ${bg} flex items-center justify-center shrink-0 mt-0.5`}>
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
                  })
                )}
              </div>
            </div>

          </div>

        </main>

      </div>

    </div>
  );
}
