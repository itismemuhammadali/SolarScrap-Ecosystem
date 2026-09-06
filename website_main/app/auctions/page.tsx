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
  Edit3,
  Gavel,
  Trash2,
  MapPin,
  Mail,
  Phone,
  Building2,
  Calendar,
  Clock,
  Sparkles,
  Check,
  AlertTriangle,
  StopCircle,
  Trophy,
  TrendingUp,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";

interface AuctionItem {
  id: string;
  auctionId: string;
  title: string;
  icon: string;
  category: "Solar Panels" | "Inverters" | "Transformers" | "Batteries" | "Complete System";
  categoryColor: string;
  qty: string;
  sellerName: string;
  sellerCompany: string;
  sellerCity: string;
  startingPrice: number;
  priceDemand: number;
  startingBid: number;
  currentHighBid: number;
  highestBidderName: string;
  highestBidderCompany: string;
  highestBidderCity: string;
  totalBids: number;
  status: "Draft" | "Active" | "Closed";
  createdAt: string;
  endsIn: string;
  endDate: string;
  reservePrice: number;
  images: string[];
}

const initialAuctions: AuctionItem[] = [
  {
    id: "1",
    auctionId: "AUC001",
    title: "200x Solar Panels 400W",
    icon: "☀️",
    category: "Solar Panels",
    categoryColor: "bg-amber-400",
    qty: "200 units",
    sellerName: "Sana Malik",
    sellerCompany: "Sana Solar Tech",
    sellerCity: "Karachi",
    startingPrice: 3800000,
    priceDemand: 4500000,
    startingBid: 3800000,
    currentHighBid: 4200000,
    highestBidderName: "Bilal Hussain",
    highestBidderCompany: "Scrap King",
    highestBidderCity: "Lahore",
    totalBids: 7,
    status: "Active",
    createdAt: "2024-12-04",
    endsIn: "2d 14h left",
    endDate: "2024-12-10",
    reservePrice: 4000000,
    images: [
      "/images/sign-in-img.jpg",
      "/images/otp-screen-img.jpg",
      "/images/reset-password-img.jpg",
    ],
  },
  {
    id: "2",
    auctionId: "AUC002",
    title: "Complete Solar System",
    icon: "🟡",
    category: "Complete System",
    categoryColor: "bg-amber-500",
    qty: "1 units",
    sellerName: "Sana Malik",
    sellerCompany: "Sana Solar Tech",
    sellerCity: "Karachi",
    startingPrice: 7000000,
    priceDemand: 8500000,
    startingBid: 7000000,
    currentHighBid: 7800000,
    highestBidderName: "Tariq Mehmood",
    highestBidderCompany: "Green Recyclers",
    highestBidderCity: "Karachi",
    totalBids: 3,
    status: "Active",
    createdAt: "2024-12-05",
    endsIn: "1d 8h left",
    endDate: "2024-12-09",
    reservePrice: 7500000,
    images: [
      "/images/verify-email-screen.jpg",
      "/images/sign-in-img.jpg",
      "/images/otp-screen-img.jpg",
    ],
  },
  {
    id: "3",
    auctionId: "AUC003",
    title: "500x Solar Panels 450W",
    icon: "☀️",
    category: "Solar Panels",
    categoryColor: "bg-amber-400",
    qty: "500 units",
    sellerName: "Hamza Farooq",
    sellerCompany: "EcoPower Ltd",
    sellerCity: "Lahore",
    startingPrice: 5500000,
    priceDemand: 6200000,
    startingBid: 5500000,
    currentHighBid: 0,
    highestBidderName: "-",
    highestBidderCompany: "-",
    highestBidderCity: "-",
    totalBids: 0,
    status: "Draft",
    createdAt: "2024-12-06",
    endsIn: "Draft",
    endDate: "2024-12-15",
    reservePrice: 5800000,
    images: [
      "/images/sign-in-img.jpg",
      "/images/otp-screen-img.jpg",
    ],
  },
  {
    id: "4",
    auctionId: "AUC004",
    title: "100x Solar Inverters 10kW",
    icon: "⚡",
    category: "Inverters",
    categoryColor: "bg-blue-500",
    qty: "100 units",
    sellerName: "Tariq Mehmood",
    sellerCompany: "Green Power EPC",
    sellerCity: "Islamabad",
    startingPrice: 2800000,
    priceDemand: 3400000,
    startingBid: 2800000,
    currentHighBid: 3200000,
    highestBidderName: "Rashid Ali",
    highestBidderCompany: "National Scrap",
    highestBidderCity: "Karachi",
    totalBids: 11,
    status: "Closed",
    createdAt: "2024-12-01",
    endsIn: "Closed",
    endDate: "2024-12-03",
    reservePrice: 3000000,
    images: [
      "/images/verify-email-screen.jpg",
      "/images/reset-password-img.jpg",
    ],
  },
];

export default function AuctionsPage() {
  const [auctions, setAuctions] = useState<AuctionItem[]>(initialAuctions);
  const [activeFilter, setActiveFilter] = useState("Active");
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  // Actions menu state
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
      const menuHeight = 180;
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

  // Modals state
  const [selectedAuction, setSelectedAuction] = useState<AuctionItem | null>(null);
  const [isDetailsOpen, setIsDetailsOpen] = useState(false);
  const [isEditOpen, setIsEditOpen] = useState(false);
  const [isCloseAuctionOpen, setIsCloseAuctionOpen] = useState(false);
  const [isDeleteOpen, setIsDeleteOpen] = useState(false);

  // Edit form state
  const [editFormData, setEditFormData] = useState<Partial<AuctionItem>>({});
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3000);
  };

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

  const filterTabs = [
    { name: "Draft", count: auctions.filter((a) => a.status === "Draft").length },
    { name: "Active", count: auctions.filter((a) => a.status === "Active").length },
    { name: "Closed", count: auctions.filter((a) => a.status === "Closed").length },
  ];

  const filteredAuctions = auctions.filter((a) => {
    if (activeFilter !== "All" && a.status !== activeFilter) return false;
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const match =
        a.title.toLowerCase().includes(q) ||
        a.auctionId.toLowerCase().includes(q) ||
        a.sellerName.toLowerCase().includes(q) ||
        a.sellerCity.toLowerCase().includes(q) ||
        a.category.toLowerCase().includes(q);
      if (!match) return false;
    }
    return true;
  });

  // Modal Handlers
  const handleOpenDetails = (auction: AuctionItem) => {
    setSelectedAuction(auction);
    setIsDetailsOpen(true);
    setActionMenuOpenId(null);
  };

  const handleOpenEdit = (auction: AuctionItem) => {
    setSelectedAuction(auction);
    setEditFormData({ ...auction });
    setIsEditOpen(true);
    setActionMenuOpenId(null);
  };

  const handleSaveEdit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedAuction) return;
    setAuctions((prev) =>
      prev.map((a) => (a.id === selectedAuction.id ? ({ ...a, ...editFormData } as AuctionItem) : a))
    );
    setIsEditOpen(false);
    showToast("Auction updated successfully!");
  };

  const handleOpenCloseAuction = (auction: AuctionItem) => {
    setSelectedAuction(auction);
    setIsCloseAuctionOpen(true);
    setActionMenuOpenId(null);
  };

  const handleConfirmCloseAuction = () => {
    if (!selectedAuction) return;
    setAuctions((prev) =>
      prev.map((a) =>
        a.id === selectedAuction.id ? { ...a, status: "Closed", endsIn: "Auction Ended" } : a
      )
    );
    setIsCloseAuctionOpen(false);
    showToast(`Auction ${selectedAuction.auctionId} closed. Winner: ${selectedAuction.highestBidderName}!`);
  };

  const handleOpenDelete = (auction: AuctionItem) => {
    setSelectedAuction(auction);
    setIsDeleteOpen(true);
    setActionMenuOpenId(null);
  };

  const handleConfirmDelete = () => {
    if (!selectedAuction) return;
    setAuctions((prev) => prev.filter((a) => a.id !== selectedAuction.id));
    setIsDeleteOpen(false);
    showToast("Auction deleted permanently.");
  };

  return (
    <div className="min-h-screen w-full bg-[#f8fafc] flex flex-col lg:flex-row">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Auctions"
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
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div>
                <h1 className="text-xl sm:text-2xl font-bold text-gray-900 tracking-tight">
                  Auctions
                </h1>
                <p className="text-xs text-gray-500 mt-0.5">
                  Manage ongoing, live, and closed scrap auctions on the platform.
                </p>
              </div>
              <Link
                href="/auctions/create"
                className="inline-flex items-center justify-center gap-2 px-4 py-2 bg-[#009639] hover:bg-[#008232] text-white rounded-xl text-xs font-bold shadow-xs transition-colors shrink-0"
              >
                <span>+ Create Auction</span>
              </Link>
            </div>

            {/* Filter Tabs & Search Bar (Exact as media_1787852094444.png) */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-200/80 pb-0">
              
              {/* Filter Tabs */}
              <div className="flex items-center gap-6 overflow-x-auto scrollbar-none">
                {filterTabs.map((tab) => {
                  const isActive = activeFilter === tab.name;
                  return (
                    <button
                      key={tab.name}
                      type="button"
                      onClick={() => setActiveFilter(tab.name)}
                      className={`pb-3 text-xs font-bold transition-all duration-150 cursor-pointer whitespace-nowrap flex items-center gap-2 border-b-2 -mb-[1px] ${
                        isActive
                          ? "border-[#009639] text-[#009639]"
                          : "border-transparent text-gray-500 hover:text-gray-900"
                      }`}
                    >
                      <span>{tab.name}</span>
                      <span
                        className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                          isActive
                            ? "bg-emerald-50 text-[#009639]"
                            : "bg-gray-100 text-gray-500"
                        }`}
                      >
                        {tab.count}
                      </span>
                    </button>
                  );
                })}
              </div>

              {/* Table Search Input */}
              <div className="relative w-full sm:w-[260px] pb-2 sm:pb-3">
                <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search auctions..."
                  className="w-full pl-9 pr-3.5 py-2 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009639] focus:ring-1 focus:ring-[#009639]/20 text-gray-800 placeholder:text-gray-400 shadow-2xs"
                />
              </div>

            </div>

            {/* Auctions Data Table (Exact as media_1787852094444.png) */}
            <div className="bg-white rounded-2xl border border-gray-200/80 shadow-xs overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left border-collapse">
                  <thead>
                    <tr className="border-b border-gray-100 bg-gray-50/50 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                      <th className="py-3.5 px-4 sm:px-5">ID</th>
                      <th className="py-3.5 px-4">EQUIPMENT</th>
                      <th className="py-3.5 px-4">SELLER</th>
                      <th className="py-3.5 px-4">LOCATION</th>
                      <th className="py-3.5 px-4">STARTING PRICE</th>
                      <th className="py-3.5 px-4">PRICE DEMAND</th>
                      <th className="py-3.5 px-4">BIDS</th>
                      <th className="py-3.5 px-4">STATUS</th>
                      <th className="py-3.5 px-4">CREATED</th>
                      <th className="py-3.5 px-4 text-right"></th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100 text-xs">
                    {filteredAuctions.map((auction) => (
                      <tr key={auction.id} className="hover:bg-gray-50/60 transition-colors">
                        {/* ID */}
                        <td className="py-4 px-4 sm:px-5 font-semibold text-xs text-gray-500 whitespace-nowrap">
                          {auction.auctionId}
                        </td>

                        {/* Equipment */}
                        <td className="py-4 px-4 whitespace-nowrap">
                          <div className="flex items-center gap-2.5">
                            <span className="text-base leading-none select-none">{auction.icon}</span>
                            <div>
                              <p
                                className="font-bold text-gray-900 hover:text-[#009639] cursor-pointer"
                                onClick={() => handleOpenDetails(auction)}
                              >
                                {auction.title}
                              </p>
                              <p className="text-[11px] text-gray-400 font-normal">{auction.qty}</p>
                            </div>
                          </div>
                        </td>

                        {/* Seller */}
                        <td className="py-4 px-4 whitespace-nowrap font-semibold text-gray-800 text-xs">
                          {auction.sellerName}
                        </td>

                        {/* Location */}
                        <td className="py-4 px-4 whitespace-nowrap text-gray-600 text-xs font-medium">
                          {auction.sellerCity}
                        </td>

                        {/* Starting Price */}
                        <td className="py-4 px-4 whitespace-nowrap font-black text-gray-900 text-xs">
                          PKR {auction.startingPrice.toLocaleString()}
                        </td>

                        {/* Price Demand */}
                        <td className="py-4 px-4 whitespace-nowrap text-gray-500 text-xs">
                          PKR {auction.priceDemand.toLocaleString()}
                        </td>

                        {/* Bids */}
                        <td className="py-4 px-4 whitespace-nowrap">
                          <span className="inline-flex items-center justify-center w-6 h-6 rounded-full bg-emerald-50 text-[#009639] font-bold text-xs">
                            {auction.totalBids}
                          </span>
                        </td>

                        {/* Status */}
                        <td className="py-4 px-4 whitespace-nowrap">
                          <span
                            className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold ${
                              auction.status === "Active"
                                ? "bg-emerald-50 text-emerald-700 border border-emerald-200"
                                : auction.status === "Draft"
                                ? "bg-gray-100 text-gray-600"
                                : "bg-red-50 text-red-600 border border-red-200"
                            }`}
                          >
                            {auction.status}
                          </span>
                        </td>

                        {/* Created */}
                        <td className="py-4 px-4 whitespace-nowrap text-gray-500 text-xs">
                          {auction.createdAt}
                        </td>

                        {/* Actions 3-dots */}
                        <td className="py-4 px-4 text-right relative whitespace-nowrap">
                          <button
                            type="button"
                            onClick={(e) => toggleActionMenu(e, auction.id)}
                            className="p-1 rounded-lg text-gray-400 hover:text-gray-700 hover:bg-gray-100 transition-colors cursor-pointer"
                            aria-label="Actions"
                          >
                            <MoreVertical className="w-4 h-4" />
                          </button>

                          {/* Floating Dropdown */}
                          {actionMenuOpenId === auction.id && menuPos && (
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
                                className="w-44 bg-white rounded-xl shadow-[0_12px_35px_-5px_rgba(0,0,0,0.18),0_4px_12px_-2px_rgba(0,0,0,0.08)] border border-gray-100 py-1.5 z-[999] text-left"
                              >
                                <button
                                  type="button"
                                  onClick={() => handleOpenDetails(auction)}
                                  className="w-full px-3 py-1.5 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2 transition-colors cursor-pointer"
                                >
                                  <Eye className="w-3.5 h-3.5 text-gray-500" />
                                  <span>View Details</span>
                                </button>
                                <button
                                  type="button"
                                  onClick={() => handleOpenEdit(auction)}
                                  className="w-full px-3 py-1.5 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2 transition-colors cursor-pointer"
                                >
                                  <Edit3 className="w-3.5 h-3.5 text-gray-500" />
                                  <span>Edit Auction</span>
                                </button>
                                <button
                                  type="button"
                                  onClick={() => handleOpenCloseAuction(auction)}
                                  className="w-full px-3 py-1.5 text-xs text-amber-600 hover:bg-amber-50 flex items-center gap-2 transition-colors cursor-pointer font-medium"
                                >
                                  <StopCircle className="w-3.5 h-3.5" />
                                  <span>Close / End Auction</span>
                                </button>
                                <div className="border-t border-gray-100 my-1" />
                                <button
                                  type="button"
                                  onClick={() => handleOpenDelete(auction)}
                                  className="w-full px-3 py-1.5 text-xs text-red-600 hover:bg-red-50 flex items-center gap-2 transition-colors cursor-pointer"
                                >
                                  <Trash2 className="w-3.5 h-3.5" />
                                  <span>Delete Auction</span>
                                </button>
                              </div>
                            </>
                          )}
                        </td>
                      </tr>
                    ))}

                    {filteredAuctions.length === 0 && (
                      <tr>
                        <td colSpan={9} className="py-8 text-center text-xs text-gray-400">
                          No auctions found.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>

              {/* Table Footer */}
              <div className="px-5 py-3 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
                <span>
                  Showing {filteredAuctions.length} of {auctions.length} auctions
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

      {/* ===================== 1. AUCTION DETAILS MODAL ===================== */}
      {isDetailsOpen && selectedAuction && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl sm:rounded-3xl max-w-[560px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100 max-h-[92vh] overflow-y-auto">
            
            {/* Header */}
            <div className="flex items-start justify-between pb-3 border-b border-gray-100">
              <div>
                <span className="text-[11px] font-bold text-[#009639] uppercase tracking-wider">
                  {selectedAuction.category}
                </span>
                <h2 className="text-lg font-bold text-gray-900 leading-tight">
                  {selectedAuction.title}
                </h2>
                <p className="text-xs text-gray-500 flex items-center gap-1.5 mt-0.5">
                  <span className="inline-block px-2 py-0.2 bg-emerald-50 text-emerald-700 rounded-full font-semibold text-[10px]">
                    {selectedAuction.status}
                  </span>
                  <span>•</span>
                  <span className="font-mono">{selectedAuction.auctionId}</span>
                </p>
              </div>
              <button
                type="button"
                onClick={() => setIsDetailsOpen(false)}
                className="w-7 h-7 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* Starting Bid vs Current High Bid Banners */}
            <div className="grid grid-cols-2 gap-3 mt-4">
              <div className="p-3.5 bg-emerald-50/90 rounded-2xl border border-emerald-200/80">
                <p className="text-[10px] font-bold text-emerald-800 uppercase tracking-wider">
                  STARTING BID
                </p>
                <p className="text-xl font-black text-[#009639] mt-0.5 leading-tight">
                  PKR {selectedAuction.startingBid.toLocaleString()}
                </p>
              </div>

              <div className="p-3.5 bg-gray-50 rounded-2xl border border-gray-200">
                <p className="text-[10px] font-bold text-gray-500 uppercase tracking-wider">
                  CURRENT HIGH BID
                </p>
                <p className="text-xl font-black text-gray-900 mt-0.5 leading-tight">
                  PKR {selectedAuction.currentHighBid.toLocaleString()}
                </p>
              </div>
            </div>

            {/* Photos */}
            <div className="mt-4">
              <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                AUCTION PHOTOS
              </p>
              <div className="grid grid-cols-3 gap-2">
                {selectedAuction.images.map((img, idx) => (
                  <div key={idx} className="relative h-20 rounded-xl overflow-hidden border border-gray-200 shadow-xs">
                    <Image src={img} alt="Auction Image" fill className="object-cover" />
                  </div>
                ))}
              </div>
            </div>

            {/* Specification Grid */}
            <div className="space-y-3 mt-4 text-xs">
              <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider">
                AUCTION DETAILS
              </p>
              <div className="grid grid-cols-2 gap-2">
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                  <p className="text-[10px] text-gray-400">Category</p>
                  <p className="font-semibold text-gray-800">{selectedAuction.category}</p>
                </div>
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                  <p className="text-[10px] text-gray-400">Quantity</p>
                  <p className="font-semibold text-gray-800">{selectedAuction.qty}</p>
                </div>
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                  <p className="text-[10px] text-gray-400">Reserve Price</p>
                  <p className="font-semibold text-gray-800">PKR {selectedAuction.reservePrice.toLocaleString()}</p>
                </div>
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                  <p className="text-[10px] text-gray-400">Total Bids Placed</p>
                  <p className="font-semibold text-gray-800">{selectedAuction.totalBids} Bids</p>
                </div>
              </div>
            </div>

            {/* Seller & Highest Bidder Cards */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 mt-4 text-xs">
              <div className="p-3 bg-gray-50 rounded-2xl border border-gray-100">
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">
                  SELLER
                </p>
                <p className="font-bold text-gray-900">{selectedAuction.sellerName}</p>
                <p className="text-[11px] text-gray-500">{selectedAuction.sellerCompany}</p>
                <p className="text-[10px] text-gray-400 mt-0.5">{selectedAuction.sellerCity}</p>
              </div>

              <div className="p-3 bg-emerald-50/50 rounded-2xl border border-emerald-100">
                <div className="flex items-center justify-between mb-1">
                  <p className="text-[10px] font-bold text-emerald-800 uppercase tracking-wider">
                    HIGHEST BIDDER
                  </p>
                  <Trophy className="w-3.5 h-3.5 text-amber-500" />
                </div>
                <p className="font-bold text-gray-900">{selectedAuction.highestBidderName}</p>
                <p className="text-[11px] text-gray-500">{selectedAuction.highestBidderCompany}</p>
                <p className="text-[10px] text-gray-400 mt-0.5">{selectedAuction.highestBidderCity}</p>
              </div>
            </div>

            {/* Modal Actions */}
            <div className="grid grid-cols-2 gap-2.5 mt-5 pt-3 border-t border-gray-100">
              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleOpenEdit(selectedAuction);
                }}
                className="py-2.5 px-4 bg-[#009639] hover:bg-[#008230] text-white text-xs font-semibold rounded-xl shadow-xs transition-colors cursor-pointer flex items-center justify-center gap-1.5"
              >
                <Edit3 className="w-3.5 h-3.5" />
                <span>Edit Auction</span>
              </button>

              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleOpenCloseAuction(selectedAuction);
                }}
                className="py-2.5 px-4 bg-red-50 hover:bg-red-100 text-red-600 text-xs font-semibold rounded-xl border border-red-200 transition-colors cursor-pointer flex items-center justify-center gap-1.5"
              >
                <StopCircle className="w-3.5 h-3.5" />
                <span>Close Auction</span>
              </button>
            </div>

          </div>
        </div>
      )}

      {/* ===================== 2. EDIT AUCTION MODAL ===================== */}
      {isEditOpen && selectedAuction && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[420px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100 max-h-[90vh] overflow-y-auto">
            
            <div className="flex items-center justify-between pb-3 border-b border-gray-100">
              <h2 className="text-base font-bold text-gray-900">Edit Auction</h2>
              <button
                type="button"
                onClick={() => setIsEditOpen(false)}
                className="w-7 h-7 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <form onSubmit={handleSaveEdit} className="space-y-3 mt-4 text-xs">
              <div>
                <label className="block text-gray-700 font-semibold mb-1">Auction Title</label>
                <input
                  type="text"
                  value={editFormData.title || ""}
                  onChange={(e) => setEditFormData({ ...editFormData, title: e.target.value })}
                  required
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009639]"
                />
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block text-gray-700 font-semibold mb-1">Starting Bid (PKR)</label>
                  <input
                    type="number"
                    value={editFormData.startingBid || 0}
                    onChange={(e) =>
                      setEditFormData({ ...editFormData, startingBid: Number(e.target.value) })
                    }
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009639]"
                  />
                </div>
                <div>
                  <label className="block text-gray-700 font-semibold mb-1">Reserve Price (PKR)</label>
                  <input
                    type="number"
                    value={editFormData.reservePrice || 0}
                    onChange={(e) =>
                      setEditFormData({ ...editFormData, reservePrice: Number(e.target.value) })
                    }
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009639]"
                  />
                </div>
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">End Date</label>
                <input
                  type="date"
                  value={editFormData.endDate || ""}
                  onChange={(e) => setEditFormData({ ...editFormData, endDate: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009639]"
                />
              </div>

              <div className="flex items-center justify-end gap-2 pt-3 border-t border-gray-100">
                <button
                  type="button"
                  onClick={() => setIsEditOpen(false)}
                  className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-xl font-medium cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-[#009639] hover:bg-[#008230] text-white font-semibold rounded-xl shadow-xs cursor-pointer"
                >
                  Save Auction
                </button>
              </div>
            </form>

          </div>
        </div>
      )}

      {/* ===================== 3. CLOSE AUCTION EARLY CONFIRMATION MODAL ===================== */}
      {isCloseAuctionOpen && selectedAuction && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[360px] w-full p-5 shadow-2xl border border-gray-100">
            
            <div className="flex items-center justify-between pb-2 border-b border-gray-100">
              <h3 className="text-sm font-bold text-gray-900 flex items-center gap-1.5 text-amber-600">
                <StopCircle className="w-4 h-4" />
                <span>Close Auction Early?</span>
              </h3>
              <button
                type="button"
                onClick={() => setIsCloseAuctionOpen(false)}
                className="w-6 h-6 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>

            <p className="text-xs text-gray-500 mt-3 leading-relaxed">
              Are you sure you want to end <span className="font-semibold text-gray-800">{selectedAuction.auctionId}</span>? The highest bidder (<span className="font-semibold text-gray-800">{selectedAuction.highestBidderName}</span> with <span className="text-[#009639] font-bold">PKR {selectedAuction.currentHighBid.toLocaleString()}</span>) will be declared winner.
            </p>

            <div className="flex items-center justify-end gap-2 mt-5">
              <button
                type="button"
                onClick={() => setIsCloseAuctionOpen(false)}
                className="px-3.5 py-1.5 text-xs font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors cursor-pointer"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleConfirmCloseAuction}
                className="px-4 py-1.5 text-xs font-semibold text-white bg-amber-600 hover:bg-amber-700 rounded-lg transition-colors shadow-xs cursor-pointer"
              >
                Close Auction
              </button>
            </div>

          </div>
        </div>
      )}

      {/* ===================== 4. DELETE AUCTION CONFIRMATION MODAL ===================== */}
      {isDeleteOpen && selectedAuction && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[340px] w-full p-5 shadow-2xl border border-gray-100">
            
            <div className="flex items-center justify-between pb-2 border-b border-gray-100">
              <h3 className="text-sm font-bold text-gray-900 flex items-center gap-1.5 text-red-600">
                <AlertTriangle className="w-4 h-4" />
                <span>Delete Auction?</span>
              </h3>
              <button
                type="button"
                onClick={() => setIsDeleteOpen(false)}
                className="w-6 h-6 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>

            <p className="text-xs text-gray-500 mt-3 leading-relaxed">
              This action cannot be undone and will permanently delete auction <span className="font-semibold text-gray-800">{selectedAuction.auctionId}</span> and all associated bids.
            </p>

            <div className="flex items-center justify-end gap-2 mt-5">
              <button
                type="button"
                onClick={() => setIsDeleteOpen(false)}
                className="px-3.5 py-1.5 text-xs font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors cursor-pointer"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleConfirmDelete}
                className="px-4 py-1.5 text-xs font-semibold text-white bg-red-600 hover:bg-red-700 rounded-lg transition-colors shadow-xs cursor-pointer"
              >
                Delete
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
