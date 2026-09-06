"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import {
  Search,
  Bell,
  Sun,
  Menu,
  X,
  MoreVertical,
  Eye,
  CheckCircle,
  Mail,
  Phone,
  Building2,
  Briefcase,
  MapPin,
  Calendar,
  ShieldCheck,
  Check,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";

interface ScrapDealer {
  id: string;
  name: string;
  avatarLetter: string;
  company: string;
  email: string;
  phone: string;
  status: "Pending" | "Approved" | "Rejected";
  activityStatus: "Active" | "Inactive";
  joined: string;
  role: string;
  city: string;
  area: string;
}

const initialDealers: ScrapDealer[] = [
  {
    id: "1",
    name: "Bilal Hussain",
    avatarLetter: "B",
    company: "Scrap King",
    email: "bilal@scrapking.pk",
    phone: "+92 321 9876543",
    status: "Pending",
    activityStatus: "Active",
    joined: "2024-12-03",
    role: "Dealer",
    city: "Lahore",
    area: "Badami Bagh",
  },
  {
    id: "2",
    name: "Tariq Mehmood",
    avatarLetter: "T",
    company: "Green Recyclers",
    email: "tariq@greenrecv.pk",
    phone: "+92 312 7778888",
    status: "Pending",
    activityStatus: "Active",
    joined: "2024-12-06",
    role: "Dealer",
    city: "Karachi",
    area: "Shershah Scrap Market",
  },
  {
    id: "3",
    name: "Haroon Khan",
    avatarLetter: "H",
    company: "MetalsPK",
    email: "haroon@metalspk.pk",
    phone: "+92 300 4445555",
    status: "Approved",
    activityStatus: "Active",
    joined: "2024-11-18",
    role: "Certified Dealer",
    city: "Rawalpindi",
    area: "I-9 Industrial Area",
  },
  {
    id: "4",
    name: "Sarmad Ali",
    avatarLetter: "S",
    company: "Al-Raziq Scrap",
    email: "sarmad@alraziqscrap.pk",
    phone: "+92 341 8889999",
    status: "Approved",
    activityStatus: "Active",
    joined: "2024-11-25",
    role: "Scrap Dealer",
    city: "Faisalabad",
    area: "Samundri Road",
  },
];

export default function ScrapDealersPage() {
  const [dealers, setDealers] = useState<ScrapDealer[]>(initialDealers);
  const [activeFilter, setActiveFilter] = useState("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  // Actions Dropdown & Modals State
  const [actionMenuOpenId, setActionMenuOpenId] = useState<string | null>(null);
  const [menuPos, setMenuPos] = useState<{ top?: number; bottom?: number; right: number } | null>(null);

  useEffect(() => {
    const handleClose = () => {
      if (actionMenuOpenId) {
        setActionMenuOpenId(null);
        setMenuPos(null);
      }
    };
    window.addEventListener("scroll", handleClose, true);
    window.addEventListener("resize", handleClose);
    return () => {
      window.removeEventListener("scroll", handleClose, true);
      window.removeEventListener("resize", handleClose);
    };
  }, [actionMenuOpenId]);

  const toggleActionMenu = (e: React.MouseEvent<HTMLButtonElement>, id: string) => {
    e.stopPropagation();
    if (actionMenuOpenId === id) {
      setActionMenuOpenId(null);
      setMenuPos(null);
    } else {
      const rect = e.currentTarget.getBoundingClientRect();
      const spaceBelow = window.innerHeight - rect.bottom;
      const menuHeight = 120;
      if (spaceBelow < menuHeight) {
        setMenuPos({
          bottom: window.innerHeight - rect.top + 6,
          right: Math.max(16, window.innerWidth - rect.right),
        });
      } else {
        setMenuPos({
          top: rect.bottom + 6,
          right: Math.max(16, window.innerWidth - rect.right),
        });
      }
      setActionMenuOpenId(id);
    }
  };
  const [selectedUser, setSelectedUser] = useState<ScrapDealer | null>(null);
  const [isDetailsModalOpen, setIsDetailsModalOpen] = useState(false);
  const [isActivateModalOpen, setIsActivateModalOpen] = useState(false);
  const [userToActivate, setUserToActivate] = useState<ScrapDealer | null>(null);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

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

  const filterTabs = ["All", "Approved", "Pending", "Rejected", "Active", "Inactive"];

  // Filter dealers by tab and search query
  const filteredDealers = dealers.filter((dealer) => {
    // Tab filter
    if (activeFilter === "Approved" && dealer.status !== "Approved") return false;
    if (activeFilter === "Pending" && dealer.status !== "Pending") return false;
    if (activeFilter === "Rejected" && dealer.status !== "Rejected") return false;
    if (activeFilter === "Active" && dealer.activityStatus !== "Active") return false;
    if (activeFilter === "Inactive" && dealer.activityStatus !== "Inactive") return false;

    // Search query
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const match =
        dealer.name.toLowerCase().includes(q) ||
        dealer.email.toLowerCase().includes(q) ||
        dealer.phone.toLowerCase().includes(q) ||
        dealer.company.toLowerCase().includes(q);
      if (!match) return false;
    }

    return true;
  });

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => {
      setToastMessage(null);
    }, 3000);
  };

  const handleOpenDetails = (dealer: ScrapDealer) => {
    setSelectedUser(dealer);
    setIsDetailsModalOpen(true);
    setActionMenuOpenId(null);
  };

  const handleOpenActivate = (dealer: ScrapDealer) => {
    setUserToActivate(dealer);
    setIsActivateModalOpen(true);
    setActionMenuOpenId(null);
  };

  const handleConfirmActivate = () => {
    if (!userToActivate) return;
    setDealers((prev) =>
      prev.map((d) =>
        d.id === userToActivate.id ? { ...d, status: "Approved", activityStatus: "Active" } : d
      )
    );
    setIsActivateModalOpen(false);
    showToast(`${userToActivate.name} has been activated successfully!`);
    setUserToActivate(null);
  };

  return (
    <div className="min-h-screen w-full bg-[#f8fafc] flex flex-col lg:flex-row">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Scrap Dealers"
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
              <button
                type="button"
                className="relative p-2 text-gray-500 hover:text-gray-800 hover:bg-gray-100 rounded-full transition-colors"
                aria-label="Notifications"
              >
                <Bell className="w-4.5 h-4.5" />
                <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white" />
              </button>

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
          <main className="flex-1 p-5 sm:p-7 md:p-8 space-y-6 overflow-y-auto">
            
            {/* Header Title */}
            <div>
              <h1 className="text-xl sm:text-2xl font-bold text-gray-900 tracking-tight">
                Scrap Dealers
              </h1>
              <p className="text-xs text-gray-500 mt-0.5">
                Manage all scrap dealers on the platform.
              </p>
            </div>

            {/* Filter Tabs & Search Bar Row */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pt-1">
              
              {/* Filter Tabs */}
              <div className="flex items-center gap-1.5 overflow-x-auto pb-1 sm:pb-0 scrollbar-none">
                {filterTabs.map((tab) => {
                  const isActive = activeFilter === tab;
                  return (
                    <button
                      key={tab}
                      type="button"
                      onClick={() => setActiveFilter(tab)}
                      className={`px-3 sm:px-3.5 py-1.5 rounded-full text-xs font-medium transition-all duration-150 cursor-pointer whitespace-nowrap ${
                        isActive
                          ? "bg-[#009639] text-white shadow-sm"
                          : "text-gray-600 hover:text-gray-900 hover:bg-gray-200/60"
                      }`}
                    >
                      {tab}
                    </button>
                  );
                })}
              </div>

              {/* Table Search Input */}
              <div className="relative w-full sm:w-[260px]">
                <Search className="w-3.5 h-3.5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search by name, email, phone..."
                  className="w-full pl-9 pr-3 py-1.5 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009639] focus:ring-1 focus:ring-[#009639]/20 text-gray-800 placeholder:text-gray-400"
                />
              </div>

            </div>

            {/* Dealers Data Table */}
            <div className="bg-white rounded-2xl border border-gray-200/80 shadow-sm overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left border-collapse">
                  <thead>
                    <tr className="border-b border-gray-100 bg-gray-50/50 text-[11px] font-semibold text-gray-400 uppercase tracking-wider">
                      <th className="py-3 px-4 sm:px-5">NAME</th>
                      <th className="py-3 px-4">COMPANY</th>
                      <th className="py-3 px-4">EMAIL</th>
                      <th className="py-3 px-4">PHONE</th>
                      <th className="py-3 px-4">STATUS</th>
                      <th className="py-3 px-4">JOINED</th>
                      <th className="py-3 px-4 text-right">ACTIONS</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100 text-xs">
                    {filteredDealers.map((dealer) => (
                      <tr key={dealer.id} className="hover:bg-gray-50/70 transition-colors">
                        {/* Name & Avatar */}
                        <td className="py-3.5 px-4 sm:px-5 font-semibold text-gray-900 whitespace-nowrap">
                          <div className="flex items-center gap-2.5">
                            <div className="w-6 h-6 rounded-full bg-[#009639] text-white flex items-center justify-center font-bold text-[10px]">
                              {dealer.avatarLetter}
                            </div>
                            <span>{dealer.name}</span>
                          </div>
                        </td>

                        {/* Company */}
                        <td className="py-3.5 px-4 text-gray-600 whitespace-nowrap">
                          {dealer.company}
                        </td>

                        {/* Email */}
                        <td className="py-3.5 px-4 text-gray-600 whitespace-nowrap font-mono text-[11px]">
                          {dealer.email}
                        </td>

                        {/* Phone */}
                        <td className="py-3.5 px-4 text-gray-600 whitespace-nowrap">
                          {dealer.phone}
                        </td>

                        {/* Status */}
                        <td className="py-3.5 px-4 whitespace-nowrap">
                          <span
                            className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-semibold ${
                              dealer.status === "Approved"
                                ? "bg-emerald-50 text-emerald-700 border border-emerald-200"
                                : dealer.status === "Pending"
                                ? "bg-amber-50 text-amber-700 border border-amber-200"
                                : "bg-red-50 text-red-700 border border-red-200"
                            }`}
                          >
                            {dealer.status}
                          </span>
                        </td>

                        {/* Joined */}
                        <td className="py-3.5 px-4 text-gray-500 whitespace-nowrap font-mono text-[11px]">
                          {dealer.joined}
                        </td>

                        {/* Actions 3-dots */}
                        <td className="py-3.5 px-4 text-right relative whitespace-nowrap">
                          <button
                            type="button"
                            onClick={(e) => toggleActionMenu(e, dealer.id)}
                            className="p-1 rounded-lg text-gray-400 hover:text-gray-700 hover:bg-gray-100 transition-colors cursor-pointer"
                            aria-label="Actions"
                          >
                            <MoreVertical className="w-4 h-4" />
                          </button>

                          {/* Floating Action Menu Dropdown */}
                          {actionMenuOpenId === dealer.id && menuPos && (
                            <>
                              <div
                                className="fixed inset-0 z-[998]"
                                onClick={() => {
                                  setActionMenuOpenId(null);
                                  setMenuPos(null);
                                }}
                              />
                              <div
                                style={{
                                  position: "fixed",
                                  top: menuPos.top !== undefined ? `${menuPos.top}px` : "auto",
                                  bottom: menuPos.bottom !== undefined ? `${menuPos.bottom}px` : "auto",
                                  right: `${menuPos.right}px`,
                                }}
                                className="w-36 bg-white rounded-xl shadow-[0_12px_35px_-5px_rgba(0,0,0,0.18),0_4px_12px_-2px_rgba(0,0,0,0.08)] border border-gray-100 py-1.5 z-[999] text-left"
                              >
                                <button
                                  type="button"
                                  onClick={() => handleOpenDetails(dealer)}
                                  className="w-full px-3 py-1.5 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2 transition-colors cursor-pointer"
                                >
                                  <Eye className="w-3.5 h-3.5 text-gray-500" />
                                  <span>View Details</span>
                                </button>
                                <button
                                  type="button"
                                  onClick={() => handleOpenActivate(dealer)}
                                  className="w-full px-3 py-1.5 text-xs text-emerald-600 hover:bg-emerald-50 flex items-center gap-2 transition-colors cursor-pointer"
                                >
                                  <CheckCircle className="w-3.5 h-3.5" />
                                  <span>Activate</span>
                                </button>
                              </div>
                            </>
                          )}
                        </td>
                      </tr>
                    ))}

                    {filteredDealers.length === 0 && (
                      <tr>
                        <td colSpan={7} className="py-8 text-center text-xs text-gray-400">
                          No scrap dealers found matching your criteria.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>

              {/* Table Footer */}
              <div className="px-5 py-3 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
                <span>
                  Showing {filteredDealers.length} of {dealers.length} accounts
                </span>
                <div className="flex items-center gap-1">
                  <span className="w-6 h-6 rounded-md bg-[#009639] text-white flex items-center justify-center font-bold text-[11px]">
                    1
                  </span>
                </div>
              </div>
            </div>

          </main>

        </div>

      {/* ===================== 1. USER DETAILS MODAL ===================== */}
      {isDetailsModalOpen && selectedUser && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl sm:rounded-3xl max-w-[500px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100 max-h-[90vh] overflow-y-auto">
            
            {/* Modal Header */}
            <div className="flex items-center justify-between pb-3 border-b border-gray-100">
              <h2 className="text-base font-bold text-gray-900">User Details</h2>
              <button
                type="button"
                onClick={() => setIsDetailsModalOpen(false)}
                className="w-7 h-7 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* User Profile Header Card */}
            <div className="flex items-center justify-between mt-4 p-3 bg-gray-50/80 rounded-2xl border border-gray-100">
              <div className="flex items-center gap-3">
                <div className="w-11 h-11 rounded-xl bg-[#009639] text-white font-bold text-lg flex items-center justify-center shadow-xs">
                  {selectedUser.avatarLetter}
                </div>
                <div>
                  <h3 className="text-sm font-bold text-gray-900 leading-tight">
                    {selectedUser.name}
                  </h3>
                  <p className="text-[11px] text-gray-500">{selectedUser.role}</p>
                  <span className="inline-block mt-1 px-2 py-0.5 rounded-full text-[10px] font-semibold bg-amber-50 text-amber-700 border border-amber-200">
                    {selectedUser.status}
                  </span>
                </div>
              </div>
              <span className="text-[10px] font-bold text-gray-400 bg-white px-2 py-1 rounded-md border border-gray-200">
                DEALER
              </span>
            </div>

            {/* Grid Information Cards */}
            <div className="space-y-3.5 mt-4 text-xs">
              
              {/* Personal Information */}
              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1.5">
                  PERSONAL INFORMATION
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                  <div className="p-2.5 bg-gray-50/70 rounded-xl border border-gray-100 flex items-start gap-2">
                    <Mail className="w-3.5 h-3.5 text-gray-400 mt-0.5 shrink-0" />
                    <div>
                      <p className="text-[10px] text-gray-400">Email</p>
                      <p className="font-semibold text-gray-800 break-all">{selectedUser.email}</p>
                    </div>
                  </div>
                  <div className="p-2.5 bg-gray-50/70 rounded-xl border border-gray-100 flex items-start gap-2">
                    <Phone className="w-3.5 h-3.5 text-gray-400 mt-0.5 shrink-0" />
                    <div>
                      <p className="text-[10px] text-gray-400">Phone</p>
                      <p className="font-semibold text-gray-800">{selectedUser.phone}</p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Business Information */}
              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1.5">
                  BUSINESS INFORMATION
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                  <div className="p-2.5 bg-gray-50/70 rounded-xl border border-gray-100 flex items-start gap-2">
                    <Building2 className="w-3.5 h-3.5 text-gray-400 mt-0.5 shrink-0" />
                    <div>
                      <p className="text-[10px] text-gray-400">Company</p>
                      <p className="font-semibold text-gray-800">{selectedUser.company}</p>
                    </div>
                  </div>
                  <div className="p-2.5 bg-gray-50/70 rounded-xl border border-gray-100 flex items-start gap-2">
                    <Briefcase className="w-3.5 h-3.5 text-gray-400 mt-0.5 shrink-0" />
                    <div>
                      <p className="text-[10px] text-gray-400">Role</p>
                      <p className="font-semibold text-gray-800">{selectedUser.role}</p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Location */}
              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1.5">
                  LOCATION
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                  <div className="p-2.5 bg-gray-50/70 rounded-xl border border-gray-100 flex items-start gap-2">
                    <MapPin className="w-3.5 h-3.5 text-gray-400 mt-0.5 shrink-0" />
                    <div>
                      <p className="text-[10px] text-gray-400">City</p>
                      <p className="font-semibold text-gray-800">{selectedUser.city}</p>
                    </div>
                  </div>
                  <div className="p-2.5 bg-gray-50/70 rounded-xl border border-gray-100 flex items-start gap-2">
                    <MapPin className="w-3.5 h-3.5 text-gray-400 mt-0.5 shrink-0" />
                    <div>
                      <p className="text-[10px] text-gray-400">Area</p>
                      <p className="font-semibold text-gray-800">{selectedUser.area}</p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Account Information */}
              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1.5">
                  ACCOUNT INFORMATION
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                  <div className="p-2.5 bg-gray-50/70 rounded-xl border border-gray-100 flex items-start gap-2">
                    <Calendar className="w-3.5 h-3.5 text-gray-400 mt-0.5 shrink-0" />
                    <div>
                      <p className="text-[10px] text-gray-400">Registration Date</p>
                      <p className="font-semibold text-gray-800">{selectedUser.joined}</p>
                    </div>
                  </div>
                  <div className="p-2.5 bg-gray-50/70 rounded-xl border border-gray-100 flex items-start gap-2">
                    <ShieldCheck className="w-3.5 h-3.5 text-gray-400 mt-0.5 shrink-0" />
                    <div>
                      <p className="text-[10px] text-gray-400">Account Status</p>
                      <p className="font-semibold text-gray-800">{selectedUser.status}</p>
                    </div>
                  </div>
                </div>
              </div>

            </div>

            {/* Modal Buttons */}
            <div className="flex items-center gap-2.5 mt-5 pt-3 border-t border-gray-100">
              <button
                type="button"
                onClick={() => {
                  setIsDetailsModalOpen(false);
                  handleOpenActivate(selectedUser);
                }}
                className="flex-1 py-2.5 px-4 bg-[#009639] hover:bg-[#008230] text-white text-xs font-semibold rounded-xl shadow-xs transition-colors cursor-pointer"
              >
                Edit User
              </button>
              <button
                type="button"
                onClick={() => setIsDetailsModalOpen(false)}
                className="py-2.5 px-5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-semibold rounded-xl transition-colors cursor-pointer"
              >
                Close
              </button>
            </div>

          </div>
        </div>
      )}

      {/* ===================== 2. ACTIVATE USER CONFIRMATION MODAL ===================== */}
      {isActivateModalOpen && userToActivate && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[340px] w-full p-5 shadow-2xl border border-gray-100">
            
            {/* Header */}
            <div className="flex items-center justify-between pb-2 border-b border-gray-100">
              <h3 className="text-sm font-bold text-gray-900">Activate User?</h3>
              <button
                type="button"
                onClick={() => setIsActivateModalOpen(false)}
                className="w-6 h-6 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>

            {/* Message Body */}
            <p className="text-xs text-gray-500 mt-3 leading-relaxed">
              <span className="font-semibold text-gray-800">{userToActivate.name}</span> will be able to access the platform again.
            </p>

            {/* Buttons */}
            <div className="flex items-center justify-end gap-2 mt-5">
              <button
                type="button"
                onClick={() => setIsActivateModalOpen(false)}
                className="px-3.5 py-1.5 text-xs font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors cursor-pointer"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleConfirmActivate}
                className="px-4 py-1.5 text-xs font-semibold text-white bg-[#009639] hover:bg-[#008230] rounded-lg transition-colors shadow-xs cursor-pointer"
              >
                Activate
              </button>
            </div>

          </div>
        </div>
      )}

      {/* ===================== TOAST NOTIFICATION ===================== */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 bg-gray-900 text-white text-xs px-4 py-3 rounded-xl shadow-2xl flex items-center gap-2 z-50 animate-slideUp">
          <Check className="w-4 h-4 text-[#009639]" />
          <span>{toastMessage}</span>
        </div>
      )}

      </div>
  );
}
