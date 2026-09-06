"use client";

import { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import {
  Search,
  Bell,
  Sun,
  Menu,
  X,
  User,
  TrendingUp,
  Share2,
  FileText,
  Gavel,
  CheckCircle2,
  CheckCheck,
  Trash2,
  Clock,
  ExternalLink,
  Filter,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";

interface NotificationItem {
  id: string;
  type: "seller" | "bid" | "lead" | "post" | "auction";
  title: string;
  subtitle?: string;
  time: string;
  unread: boolean;
  link: string;
  iconBg: string;
  iconColor: string;
  IconComponent: any;
}

const initialNotifications: NotificationItem[] = [
  {
    id: "1",
    type: "seller",
    title: "New seller registration — Raza Ahmed (SolarTec Pvt Ltd) requires approval",
    subtitle: "New EPC seller registered from Karachi. Verification documents pending review.",
    time: "5m ago",
    unread: true,
    link: "/sellers",
    iconBg: "bg-amber-50 border-amber-100",
    iconColor: "text-amber-500",
    IconComponent: User,
  },
  {
    id: "2",
    type: "bid",
    title: "New bid of PKR 210,000 placed by Bilal Hussain on AUC001",
    subtitle: "New highest bid on 500x Solar Panels 400W auction.",
    time: "18m ago",
    unread: true,
    link: "/bids",
    iconBg: "bg-indigo-50 border-indigo-100",
    iconColor: "text-indigo-500",
    IconComponent: TrendingUp,
  },
  {
    id: "3",
    type: "lead",
    title: "New Facebook lead received — Kamran Sheikh, Karachi",
    subtitle: "Lead submitted interest via Solar Scrap Facebook Ad campaign.",
    time: "1h ago",
    unread: true,
    link: "/facebook-leads",
    iconBg: "bg-sky-50 border-sky-100",
    iconColor: "text-sky-500",
    IconComponent: Share2,
  },
  {
    id: "4",
    type: "post",
    title: "New seller post submitted by Sana Malik — 200x Solar Panels 400W",
    subtitle: "Post submitted from Islamabad under Category: Solar Panels.",
    time: "2h ago",
    unread: false,
    link: "/seller-posts",
    iconBg: "bg-teal-50 border-teal-100",
    iconColor: "text-teal-600",
    IconComponent: FileText,
  },
  {
    id: "5",
    type: "auction",
    title: "Auction AUC002 now has 2 active bids",
    subtitle: "Transformer 500kVA auction received second competitive bid.",
    time: "3h ago",
    unread: false,
    link: "/auctions",
    iconBg: "bg-purple-50 border-purple-100",
    iconColor: "text-purple-600",
    IconComponent: Gavel,
  },
];

export default function NotificationsPage() {
  const [notifications, setNotifications] = useState<NotificationItem[]>(initialNotifications);
  const [activeFilter, setActiveFilter] = useState("All");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [selectedNotification, setSelectedNotification] = useState<NotificationItem | null>(null);

  const unreadCount = notifications.filter((n) => n.unread).length;

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

  const handleMarkAllRead = () => {
    setNotifications((prev) => prev.map((n) => ({ ...n, unread: false })));
  };

  const handleItemClick = (item: NotificationItem) => {
    setNotifications((prev) =>
      prev.map((n) => (n.id === item.id ? { ...n, unread: false } : n))
    );
    setSelectedNotification(item);
  };

  const handleDeleteItem = (id: string, e: React.MouseEvent) => {
    e.stopPropagation();
    setNotifications((prev) => prev.filter((n) => n.id !== id));
  };

  const filteredNotifications = notifications.filter((item) => {
    if (activeFilter === "Unread" && !item.unread) return false;
    if (activeFilter === "Sellers" && item.type !== "seller" && item.type !== "post") return false;
    if (activeFilter === "Auctions & Bids" && item.type !== "auction" && item.type !== "bid") return false;
    if (activeFilter === "Leads" && item.type !== "lead") return false;
    return true;
  });

  return (
    <div className="min-h-screen w-full bg-[#f8fafc] flex flex-col lg:flex-row">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Notifications"
        mobileMenuOpen={mobileMenuOpen}
        setMobileMenuOpen={setMobileMenuOpen}
      />

      {/* ===================== MAIN CONTENT AREA ===================== */}
      <div className="flex-1 bg-[#f8fafc] flex flex-col min-w-0 min-h-screen">
        
        {/* Top Navbar */}
        <header className="sticky top-0 z-20 bg-white border-b border-gray-200/80 px-5 sm:px-8 py-3.5 flex items-center justify-between gap-4">
            <div className="relative flex-1 max-w-[420px]">
              <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                value={topSearch}
                onChange={(e) => setTopSearch(e.target.value)}
                placeholder="Search users, posts, auctions, bids..."
                className="w-full pl-10 pr-4 py-2 text-xs sm:text-sm bg-gray-50/70 border border-gray-200/80 rounded-xl outline-none focus:bg-white focus:border-[#009639] focus:ring-2 focus:ring-[#009639]/15 transition-all text-gray-800 placeholder:text-gray-400"
              />
            </div>

            <div className="flex items-center gap-4 sm:gap-6">
              <Link
                href="/notifications"
                className="relative p-2 text-[#009639] hover:bg-gray-100 rounded-full transition-colors"
                aria-label="Notifications"
              >
                <Bell className="w-4.5 h-4.5" />
                {unreadCount > 0 && (
                  <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white" />
                )}
              </Link>

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

          {/* Main Body */}
          <main className="flex-1 p-5 sm:p-7 md:p-8 space-y-5 overflow-y-auto">
            
            {/* Header Title & Actions */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-1">
              <div>
                <h1 className="text-xl sm:text-2xl font-bold text-gray-900 tracking-tight">
                  Notifications
                </h1>
                <p className="text-xs text-gray-500 mt-0.5">
                  {unreadCount} unread notifications
                </p>
              </div>

              <div className="flex items-center gap-2">
                <button
                  type="button"
                  onClick={handleMarkAllRead}
                  className="flex items-center gap-1.5 px-3.5 py-1.5 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-xl text-xs font-semibold shadow-2xs transition-colors cursor-pointer"
                >
                  <CheckCheck className="w-3.5 h-3.5 text-[#009639]" />
                  <span>Mark all as read</span>
                </button>
              </div>
            </div>

            {/* Filter Tabs */}
            <div className="flex items-center gap-1.5 overflow-x-auto pb-1 scrollbar-none">
              {["All", "Unread", "Sellers", "Auctions & Bids", "Leads"].map((filter) => {
                const isActive = activeFilter === filter;
                return (
                  <button
                    key={filter}
                    type="button"
                    onClick={() => setActiveFilter(filter)}
                    className={`px-3 py-1.5 rounded-full text-xs font-medium transition-all duration-150 cursor-pointer whitespace-nowrap ${
                      isActive
                        ? "bg-[#009639] text-white shadow-xs"
                        : "text-gray-600 hover:text-gray-900 hover:bg-gray-200/60 bg-white border border-gray-200/70"
                    }`}
                  >
                    {filter}
                  </button>
                );
              })}
            </div>

            {/* Notification Cards List */}
            <div className="space-y-2.5">
              {filteredNotifications.map((item) => {
                const Icon = item.IconComponent;
                return (
                  <div
                    key={item.id}
                    onClick={() => handleItemClick(item)}
                    className={`w-full bg-white rounded-2xl p-4 border transition-all cursor-pointer flex items-center justify-between gap-4 shadow-2xs hover:shadow-xs group ${
                      item.unread
                        ? "border-gray-200/90 hover:border-[#009639]/40 bg-white"
                        : "border-gray-100 bg-gray-50/40 opacity-90"
                    }`}
                  >
                    <div className="flex items-center gap-3.5 min-w-0">
                      {/* Left Icon with tinted container */}
                      <div
                        className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 border ${item.iconBg}`}
                      >
                        <Icon className={`w-5 h-5 ${item.iconColor}`} />
                      </div>

                      {/* Content text */}
                      <div className="min-w-0">
                        <p
                          className={`text-xs sm:text-sm text-gray-900 leading-snug truncate ${
                            item.unread ? "font-semibold" : "font-normal text-gray-700"
                          }`}
                        >
                          {item.title}
                        </p>
                        <p className="text-[11px] text-gray-400 font-medium mt-0.5">
                          {item.time}
                        </p>
                      </div>
                    </div>

                    {/* Right side: Green Unread Indicator / Delete Button */}
                    <div className="flex items-center gap-3 shrink-0">
                      {item.unread && (
                        <span className="w-2.5 h-2.5 rounded-full bg-[#009639] shadow-xs" />
                      )}

                      <button
                        type="button"
                        onClick={(e) => handleDeleteItem(item.id, e)}
                        className="opacity-0 group-hover:opacity-100 p-1.5 text-gray-400 hover:text-red-500 rounded-lg hover:bg-gray-100 transition-all cursor-pointer"
                        title="Dismiss"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </div>
                );
              })}

              {filteredNotifications.length === 0 && (
                <div className="bg-white rounded-2xl p-12 text-center border border-gray-200/80">
                  <Bell className="w-8 h-8 text-gray-300 mx-auto mb-2" />
                  <p className="text-sm font-semibold text-gray-700">No notifications found</p>
                  <p className="text-xs text-gray-400 mt-0.5">All caught up with latest updates!</p>
                </div>
              )}
            </div>

          </main>

        </div>

      {/* ===================== NOTIFICATION DETAIL MODAL ===================== */}
      {selectedNotification && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl sm:rounded-3xl max-w-[440px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100">
            <div className="flex items-center justify-between pb-3 border-b border-gray-100">
              <h2 className="text-base font-bold text-gray-900">Notification Detail</h2>
              <button
                type="button"
                onClick={() => setSelectedNotification(null)}
                className="w-7 h-7 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="mt-4 p-3.5 bg-gray-50 rounded-2xl border border-gray-100">
              <div className="flex items-center gap-3">
                <div
                  className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 border ${selectedNotification.iconBg}`}
                >
                  <selectedNotification.IconComponent className={`w-5 h-5 ${selectedNotification.iconColor}`} />
                </div>
                <div>
                  <p className="text-xs font-bold text-gray-900 leading-snug">
                    {selectedNotification.title}
                  </p>
                  <p className="text-[11px] text-gray-400 mt-0.5">{selectedNotification.time}</p>
                </div>
              </div>
            </div>

            <p className="text-xs text-gray-600 mt-3.5 leading-relaxed bg-white p-3 rounded-xl border border-gray-100">
              {selectedNotification.subtitle}
            </p>

            <div className="flex items-center justify-end gap-2 mt-5 pt-3 border-t border-gray-100">
              <button
                type="button"
                onClick={() => setSelectedNotification(null)}
                className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-semibold rounded-xl transition-colors cursor-pointer"
              >
                Close
              </button>
              <Link
                href={selectedNotification.link}
                className="px-5 py-2 bg-[#009639] hover:bg-[#008230] text-white text-xs font-semibold rounded-xl shadow-xs transition-colors cursor-pointer flex items-center gap-1.5"
              >
                <span>View Relevant Screen</span>
                <ExternalLink className="w-3.5 h-3.5" />
              </Link>
            </div>
          </div>
        </div>
      )}

      </div>
  );
}
