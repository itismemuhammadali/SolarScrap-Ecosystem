"use client";

import { useState, useEffect, useCallback } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import {
  Search,
  Bell,
  User,
  TrendingUp,
  Share2,
  FileText,
  Gavel,
  CheckCheck,
  Trash2,
  ExternalLink,
  RefreshCw,
  X,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";
import { getSession, getAvatarUrl } from "@/lib/auth";
import {
  getAdminNotifications,
  markAdminNotificationRead,
  markAllAdminNotificationsRead,
  deleteAdminNotification,
} from "@/lib/admin-api";
import { AdminNotificationItem } from "@/lib/types";

interface DisplayNotification {
  id: string;
  type: string;
  title: string;
  subtitle?: string;
  time: string;
  unread: boolean;
  link: string;
  iconBg: string;
  iconColor: string;
  IconComponent: any;
}

function formatTimeAgo(isoString?: string | null): string {
  if (!isoString) return "Just now";
  try {
    const d = new Date(isoString);
    if (isNaN(d.getTime())) return "Recently";
    const now = new Date();
    const diffSec = Math.floor((now.getTime() - d.getTime()) / 1000);
    if (diffSec < 60) return "Just now";
    const diffMin = Math.floor(diffSec / 60);
    if (diffMin < 60) return `${diffMin}m ago`;
    const diffHours = Math.floor(diffMin / 60);
    if (diffHours < 24) return `${diffHours}h ago`;
    const diffDays = Math.floor(diffHours / 24);
    if (diffDays < 7) return `${diffDays}d ago`;
    return d.toLocaleDateString();
  } catch {
    return "Recently";
  }
}

function getNotificationVisuals(type: string) {
  switch (type) {
    case "new_user_registered":
    case "seller":
      return {
        icon: User,
        iconBg: "bg-blue-50 border-blue-100",
        iconColor: "text-blue-600",
        defaultLink: "/sellers",
      };
    case "new_pending_post":
    case "post":
      return {
        icon: FileText,
        iconBg: "bg-amber-50 border-amber-100",
        iconColor: "text-amber-600",
        defaultLink: "/seller-posts",
      };
    case "auction_created":
    case "auction":
      return {
        icon: Gavel,
        iconBg: "bg-emerald-50 border-emerald-100",
        iconColor: "text-[#009845]",
        defaultLink: "/auctions",
      };
    case "new_bid":
    case "bid":
    case "bid_won":
      return {
        icon: TrendingUp,
        iconBg: "bg-rose-50 border-rose-100",
        iconColor: "text-rose-600",
        defaultLink: "/bids",
      };
    case "lead":
      return {
        icon: Share2,
        iconBg: "bg-indigo-50 border-indigo-100",
        iconColor: "text-indigo-600",
        defaultLink: "/facebook-leads",
      };
    default:
      return {
        icon: Bell,
        iconBg: "bg-emerald-50 border-emerald-100",
        iconColor: "text-[#009845]",
        defaultLink: "/dashboard",
      };
  }
}

export default function NotificationsPage() {
  const router = useRouter();
  const [notifications, setNotifications] = useState<DisplayNotification[]>([]);
  const [adminName, setAdminName] = useState("Admin");
  const [adminPhotoUrl, setAdminPhotoUrl] = useState<string | null>(null);
  const [activeFilter, setActiveFilter] = useState("All");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [selectedNotification, setSelectedNotification] = useState<DisplayNotification | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const session = getSession();
    if (session?.user) {
      if (session.user.display_name) setAdminName(session.user.display_name);
      else if (session.user.email) setAdminName(session.user.email.split("@")[0]);
      if (session.user.profile_photo_url) setAdminPhotoUrl(session.user.profile_photo_url);
    }
  }, []);

  const fetchNotifications = useCallback(async () => {
    try {
      setIsLoading(true);
      const data: AdminNotificationItem[] = await getAdminNotifications();
      if (Array.isArray(data)) {
        const mapped: DisplayNotification[] = data.map((item) => {
          const visuals = getNotificationVisuals(item.type);
          let link = visuals.defaultLink;
          if (item.entity_type === "user") link = "/sellers";
          else if (item.entity_type === "listing") link = "/seller-posts";
          else if (item.entity_type === "bid") link = "/bids";

          return {
            id: item.id,
            type: item.type,
            title: item.title,
            subtitle: item.description,
            time: formatTimeAgo(item.created_at),
            unread: !item.is_read,
            link,
            iconBg: visuals.iconBg,
            iconColor: visuals.iconColor,
            IconComponent: visuals.icon,
          };
        });

        setNotifications(mapped);

        const unread = mapped.filter((n) => n.unread).length;
        if (typeof window !== "undefined") {
          localStorage.setItem("admin_unread_count", unread.toString());
        }
      }
    } catch (err) {
      console.error("Failed to load admin notifications:", err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  // Fetch on mount and poll every 15 seconds
  useEffect(() => {
    fetchNotifications();
    const interval = setInterval(fetchNotifications, 15000);
    return () => clearInterval(interval);
  }, [fetchNotifications]);

  const unreadCount = notifications.filter((n) => n.unread).length;

  const handleMarkAllRead = async () => {
    try {
      await markAllAdminNotificationsRead();
      setNotifications((prev) => prev.map((n) => ({ ...n, unread: false })));
      if (typeof window !== "undefined") {
        localStorage.setItem("admin_unread_count", "0");
      }
    } catch (err) {
      console.error("Failed to mark all notifications as read:", err);
    }
  };

  const handleItemClick = async (item: DisplayNotification) => {
    if (item.unread) {
      try {
        await markAdminNotificationRead(item.id);
        setNotifications((prev) =>
          prev.map((n) => (n.id === item.id ? { ...n, unread: false } : n))
        );
        const newUnread = Math.max(0, unreadCount - 1);
        if (typeof window !== "undefined") {
          localStorage.setItem("admin_unread_count", newUnread.toString());
        }
      } catch (err) {
        console.error("Failed to mark notification read:", err);
      }
    }
    setSelectedNotification({ ...item, unread: false });
  };

  const handleDeleteItem = async (id: string, e: React.MouseEvent) => {
    e.stopPropagation();
    try {
      await deleteAdminNotification(id);
      const remaining = notifications.filter((n) => n.id !== id);
      setNotifications(remaining);
      const unread = remaining.filter((n) => n.unread).length;
      if (typeof window !== "undefined") {
        localStorage.setItem("admin_unread_count", unread.toString());
      }
      if (selectedNotification?.id === id) {
        setSelectedNotification(null);
      }
    } catch (err) {
      console.error("Failed to delete notification:", err);
    }
  };

  const filteredNotifications = notifications.filter((item) => {
    if (activeFilter === "Unread" && !item.unread) return false;
    if (
      activeFilter === "Sellers" &&
      item.type !== "new_user_registered" &&
      item.type !== "seller" &&
      item.type !== "new_pending_post" &&
      item.type !== "post"
    ) {
      return false;
    }
    if (
      activeFilter === "Auctions & Bids" &&
      item.type !== "auction_created" &&
      item.type !== "auction" &&
      item.type !== "new_bid" &&
      item.type !== "bid" &&
      item.type !== "bid_won"
    ) {
      return false;
    }
    if (activeFilter === "Leads" && item.type !== "lead") return false;

    if (topSearch.trim()) {
      const q = topSearch.toLowerCase();
      const match =
        item.title.toLowerCase().includes(q) ||
        (item.subtitle && item.subtitle.toLowerCase().includes(q));
      if (!match) return false;
    }

    return true;
  });

  return (
    <div className="flex h-screen w-full bg-[#F5F6FA] overflow-hidden">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Notifications"
        mobileMenuOpen={mobileMenuOpen}
        setMobileMenuOpen={setMobileMenuOpen}
      />

      {/* ===================== MAIN CONTENT AREA ===================== */}
      <div className="flex-1 bg-[#F5F6FA] flex flex-col min-w-0 h-screen overflow-hidden">
        
        {/* Top Navbar */}
        <header className="sticky top-0 z-20 bg-white border-b border-gray-200/80 px-5 sm:px-8 py-3.5 flex items-center justify-between gap-4">
          <div className="relative flex-1 max-w-[420px]">
            <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={topSearch}
              onChange={(e) => setTopSearch(e.target.value)}
              placeholder="Search notifications..."
              className="w-full pl-10 pr-4 py-2 text-xs sm:text-sm bg-gray-50/70 border border-gray-200/80 rounded-xl outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all text-gray-800 placeholder:text-gray-400"
            />
          </div>

          <div className="flex items-center gap-3 sm:gap-5">
            <button
              type="button"
              onClick={fetchNotifications}
              disabled={isLoading}
              className="p-2 text-gray-500 hover:text-gray-800 hover:bg-gray-100 rounded-full transition-colors cursor-pointer"
              title="Refresh Notifications"
            >
              <RefreshCw className={`w-4 h-4 ${isLoading ? "animate-spin text-[#009845]" : ""}`} />
            </button>

            <Link
              href="/notifications"
              className="relative p-2 text-[#009845] hover:bg-gray-100 rounded-full transition-colors"
              aria-label="Notifications"
            >
              <Bell className="w-4.5 h-4.5" />
              {unreadCount > 0 && (
                <span className="absolute top-1 right-1 flex items-center justify-center min-w-4 h-4 px-1 text-[10px] font-bold text-white bg-red-500 rounded-full ring-2 ring-white">
                  {unreadCount > 9 ? "9+" : unreadCount}
                </span>
              )}
            </Link>

            <div className="flex items-center gap-3 pl-2 sm:border-l border-gray-200">
              <span className="hidden sm:inline-block text-xs font-semibold text-gray-800">
                Admin Platform
              </span>
              <div className="relative w-8.5 h-8.5 sm:w-9 sm:h-9 rounded-full overflow-hidden ring-2 ring-gray-100 shadow-sm bg-emerald-700 flex items-center justify-center text-white font-bold text-sm select-none">
                {adminPhotoUrl ? (
                  /* eslint-disable-next-line @next/next/no-img-element */
                  <img
                    src={getAvatarUrl(adminPhotoUrl)!}
                    alt={adminName || "Admin Platform"}
                    className="w-full h-full object-cover"
                  />
                ) : (
                  <span>{adminName ? adminName.charAt(0).toUpperCase() : "A"}</span>
                )}
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
                {unreadCount} unread notification{unreadCount === 1 ? "" : "s"}
              </p>
            </div>

            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={handleMarkAllRead}
                className="flex items-center gap-1.5 px-3.5 py-1.5 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-xl text-xs font-semibold shadow-2xs transition-colors cursor-pointer"
              >
                <CheckCheck className="w-3.5 h-3.5 text-[#009845]" />
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
                      ? "bg-[#009845] text-white shadow-xs"
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
                      ? "border-emerald-200/80 hover:border-[#009845] bg-white ring-1 ring-emerald-500/10"
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
                          item.unread ? "font-bold text-gray-950" : "font-normal text-gray-700"
                        }`}
                      >
                        {item.title}
                      </p>
                      {item.subtitle && (
                        <p className="text-[11px] text-gray-500 truncate mt-0.5 max-w-xl">
                          {item.subtitle}
                        </p>
                      )}
                      <p className="text-[10px] text-gray-400 font-medium mt-0.5">
                        {item.time}
                      </p>
                    </div>
                  </div>

                  {/* Right side: Green Unread Indicator / Delete Button */}
                  <div className="flex items-center gap-3 shrink-0">
                    {item.unread && (
                      <span className="w-2.5 h-2.5 rounded-full bg-[#009845] shadow-xs ring-2 ring-emerald-200" />
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
          <div className="bg-white rounded-2xl sm:rounded-3xl max-w-[460px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100">
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

            {selectedNotification.subtitle && (
              <p className="text-xs text-gray-600 mt-3.5 leading-relaxed bg-white p-3.5 rounded-xl border border-gray-100">
                {selectedNotification.subtitle}
              </p>
            )}

            <div className="flex items-center justify-end gap-2 mt-5 pt-3 border-t border-gray-100">
              <button
                type="button"
                onClick={() => setSelectedNotification(null)}
                className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-semibold rounded-xl transition-colors cursor-pointer"
              >
                Close
              </button>
              <button
                type="button"
                onClick={() => {
                  const link = selectedNotification.link;
                  setSelectedNotification(null);
                  router.push(link);
                }}
                className="px-5 py-2 bg-[#009845] hover:bg-[#008230] text-white text-xs font-semibold rounded-xl shadow-xs transition-colors cursor-pointer flex items-center gap-1.5"
              >
                <span>View Relevant Screen</span>
                <ExternalLink className="w-3.5 h-3.5" />
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
}
