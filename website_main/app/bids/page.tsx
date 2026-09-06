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
  MoreVertical,
  Eye,
  Trophy,
  Filter,
  MapPin,
  Calendar,
  Phone,
  CheckCircle2,
  Check,
  TrendingUp,
  Gavel,
  Clock,
  Layers,
  ShieldCheck,
  Building2,
  Mail,
  ChevronDown,
} from "lucide-react";

interface BidItem {
  id: string;
  bidderName: string;
  bidderAvatar: string;
  bidderCity: string;
  bidderCompany: string;
  bidderEmail: string;
  bidderPhone: string;
  bidAmount: number;
  auctionId: string;
  equipment: string;
  submittedDate: string;
  status: "Pending" | "Winner" | "Lost";
  isHighest?: boolean;
}

const initialBids: BidItem[] = [
  {
    id: "1",
    bidderName: "Hamza Khan",
    bidderAvatar: "H",
    bidderCity: "Faisalabad",
    bidderCompany: "Khan Scrap Metals",
    bidderEmail: "hamza@khanscrap.pk",
    bidderPhone: "+92 300 4445555",
    bidAmount: 195000,
    auctionId: "AUC001",
    equipment: "200x Solar Panels 400W",
    submittedDate: "2024-12-06",
    status: "Pending",
    isHighest: false,
  },
  {
    id: "2",
    bidderName: "Bilal Hussain",
    bidderAvatar: "B",
    bidderCity: "Lahore",
    bidderCompany: "Scrap King",
    bidderEmail: "bilal@scrapking.pk",
    bidderPhone: "+92 321 9876543",
    bidAmount: 210000,
    auctionId: "AUC001",
    equipment: "200x Solar Panels 400W",
    submittedDate: "2024-12-06",
    status: "Pending",
    isHighest: true,
  },
  {
    id: "3",
    bidderName: "Usman Ali",
    bidderAvatar: "U",
    bidderCity: "Karachi",
    bidderCompany: "Ali Metal Traders",
    bidderEmail: "usman@alimetals.pk",
    bidderPhone: "+92 311 8889999",
    bidAmount: 188000,
    auctionId: "AUC001",
    equipment: "200x Solar Panels 400W",
    submittedDate: "2024-12-05",
    status: "Pending",
    isHighest: false,
  },
  {
    id: "4",
    bidderName: "Hamza Khan",
    bidderAvatar: "H",
    bidderCity: "Faisalabad",
    bidderCompany: "Khan Scrap Metals",
    bidderEmail: "hamza@khanscrap.pk",
    bidderPhone: "+92 300 4445555",
    bidAmount: 7200000,
    auctionId: "AUC002",
    equipment: "Complete Solar System 50kW",
    submittedDate: "2024-12-05",
    status: "Pending",
    isHighest: true,
  },
  {
    id: "5",
    bidderName: "Bilal Hussain",
    bidderAvatar: "B",
    bidderCity: "Lahore",
    bidderCompany: "Scrap King",
    bidderEmail: "bilal@scrapking.pk",
    bidderPhone: "+92 321 9876543",
    bidAmount: 980000,
    auctionId: "AUC004",
    equipment: "50x JA Solar Panels 330W",
    submittedDate: "2024-11-25",
    status: "Winner",
    isHighest: true,
  },
  {
    id: "6",
    bidderName: "Hamza Khan",
    bidderAvatar: "H",
    bidderCity: "Faisalabad",
    bidderCompany: "Khan Scrap Metals",
    bidderEmail: "hamza@khanscrap.pk",
    bidderPhone: "+92 300 4445555",
    bidAmount: 920000,
    auctionId: "AUC004",
    equipment: "50x JA Solar Panels 330W",
    submittedDate: "2024-11-24",
    status: "Lost",
    isHighest: false,
  },
];

import { useEffect } from "react";
import { useRouter } from "next/navigation";

export default function BidsPage() {
  const router = useRouter();

  useEffect(() => {
    router.replace("/auctions");
  }, [router]);

  const [bids, setBids] = useState<BidItem[]>(initialBids);
  const [activeFilter, setActiveFilter] = useState("All");
  const [selectedAuctionFilter, setSelectedAuctionFilter] = useState("All Auctions");
  const [isAuctionDropdownOpen, setIsAuctionDropdownOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  // Modals state
  const [selectedBid, setSelectedBid] = useState<BidItem | null>(null);
  const [isDetailsOpen, setIsDetailsOpen] = useState(false);
  const [isWinnerModalOpen, setIsWinnerModalOpen] = useState(false);
  const [bidToSelectWinner, setBidToSelectWinner] = useState<BidItem | null>(null);
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
    { name: "All", count: bids.length, icon: null },
    { name: "Pending", count: bids.filter((b) => b.status === "Pending").length, icon: null },
    { name: "Winner", count: bids.filter((b) => b.status === "Winner").length, icon: Trophy },
    { name: "Lost", count: bids.filter((b) => b.status === "Lost").length, icon: null },
  ];

  const auctionOptions = ["All Auctions", "AUC001", "AUC002", "AUC004"];

  // Filtered Bids
  const filteredBids = bids.filter((bid) => {
    if (activeFilter !== "All" && bid.status !== activeFilter) return false;
    if (selectedAuctionFilter !== "All Auctions" && bid.auctionId !== selectedAuctionFilter) return false;
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const match =
        bid.bidderName.toLowerCase().includes(q) ||
        bid.auctionId.toLowerCase().includes(q) ||
        bid.equipment.toLowerCase().includes(q) ||
        bid.bidderCity.toLowerCase().includes(q);
      if (!match) return false;
    }
    return true;
  });

  const handleOpenWinnerModal = (bid: BidItem) => {
    setBidToSelectWinner(bid);
    setIsWinnerModalOpen(true);
  };

  const handleConfirmWinner = () => {
    if (!bidToSelectWinner) return;
    setBids((prev) =>
      prev.map((b) => {
        if (b.auctionId === bidToSelectWinner.auctionId) {
          if (b.id === bidToSelectWinner.id) {
            return { ...b, status: "Winner" };
          } else {
            return { ...b, status: "Lost" };
          }
        }
        return b;
      })
    );
    setIsWinnerModalOpen(false);
    showToast(`${bidToSelectWinner.bidderName} declared Winner for ${bidToSelectWinner.auctionId}!`);
    setBidToSelectWinner(null);
  };

  const handleOpenDetails = (bid: BidItem) => {
    setSelectedBid(bid);
    setIsDetailsOpen(true);
  };

  return (
    <div className="min-h-screen w-full bg-[#f8fafc] flex flex-col lg:flex-row">
      {/* ===================== SIDEBAR ===================== */}
      <aside className="w-full lg:w-[240px] xl:w-[250px] bg-[#111827] text-white flex flex-col justify-between p-3.5 sm:p-4 lg:p-4.5 xl:p-5 shrink-0 border-b lg:border-b-0 lg:border-r border-gray-800 lg:sticky lg:top-0 lg:h-screen lg:overflow-y-auto select-none">
        <div className="flex flex-col">
          {/* Logo */}
          <div className="flex items-center justify-between pb-4 lg:pb-5 border-b border-gray-800/80 shrink-0">
            <div className="flex items-center">
              <Image
                src="/images/solar-scrap-sidebar-logo.png"
                alt="Solar Scrap"
                width={130}
                height={52}
                className="w-[125px] sm:w-[130px] h-auto object-contain"
                priority
              />
            </div>

            {/* Mobile Menu Toggle */}
            <button
              type="button"
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="lg:hidden p-2 text-gray-400 hover:text-white rounded-lg hover:bg-gray-800"
            >
              {mobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
            </button>
          </div>

          {/* Navigation */}
          <nav className={`mt-3.5 lg:mt-4 space-y-1 lg:space-y-1.5 ${mobileMenuOpen ? "block" : "hidden lg:block"}`}>
            {navItems.map((item) => {
              const isActive = item.name === "Bids";
              return (
                <Link
                  key={item.name}
                  href={item.href}
                  onClick={() => setMobileMenuOpen(false)}
                  className={`w-full flex items-center gap-3 px-3.5 py-2 lg:py-2.5 rounded-xl text-xs font-medium transition-all duration-150 text-left ${
                    isActive
                      ? "bg-[#009639] text-white shadow-md shadow-[#009639]/30"
                      : "text-gray-400 hover:text-gray-200 hover:bg-gray-800/70"
                  }`}
                >
                  <span className="w-5 h-5 flex items-center justify-center shrink-0">
                    <Image
                      src={item.icon}
                      alt={item.name}
                      width={18}
                      height={18}
                      className={`w-4.5 h-4.5 object-contain ${
                        isActive ? "brightness-0 invert" : "opacity-60"
                      }`}
                    />
                  </span>
                  <span className="truncate">{item.name}</span>
                </Link>
              );
            })}
          </nav>
        </div>

        {/* Logout */}
        <div className={`pt-3.5 lg:pt-4 mt-auto border-t border-gray-800/80 shrink-0 ${mobileMenuOpen ? "block" : "hidden lg:block"}`}>
          <Link
            href="/"
            className="flex items-center gap-3 px-3.5 py-2 lg:py-2.5 rounded-xl text-xs font-medium text-white hover:text-red-400 hover:bg-red-950/20 transition-colors group"
          >
            <Image
              src="/icons/logout-button.svg"
              alt="Logout"
              width={18}
              height={18}
              className="w-4.5 h-4.5 object-contain opacity-80 group-hover:opacity-100"
            />
            <span>Logout</span>
          </Link>
        </div>
      </aside>

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
                Bid Management
              </h1>
              <p className="text-xs text-gray-500 mt-0.5">
                All bids across auctions — only admins can view all bids.
              </p>
            </div>

            {/* Filter Tabs & Search Controls Row */}
            <div className="flex flex-col xl:flex-row xl:items-center justify-between gap-3 pt-1">
              
              {/* Filter Tabs */}
              <div className="flex flex-wrap items-center gap-2">
                <div className="flex items-center gap-1.5 overflow-x-auto pb-1 sm:pb-0 scrollbar-none">
                  {filterTabs.map((tab) => {
                    const isActive = activeFilter === tab.name;
                    const TabIcon = tab.icon;
                    return (
                      <button
                        key={tab.name}
                        type="button"
                        onClick={() => setActiveFilter(tab.name)}
                        className={`px-3 sm:px-3.5 py-1.5 rounded-full text-xs font-medium transition-all duration-150 cursor-pointer whitespace-nowrap flex items-center gap-1.5 ${
                          isActive
                            ? "bg-[#009639] text-white shadow-sm"
                            : "text-gray-600 hover:text-gray-900 hover:bg-gray-200/60 bg-white border border-gray-200/60"
                        }`}
                      >
                        {TabIcon && <TabIcon className="w-3 h-3 text-amber-400" />}
                        <span>{tab.name}</span>
                        <span
                          className={`text-[10px] px-1.5 py-0.2 rounded-full ${
                            isActive ? "bg-white/20 text-white" : "bg-gray-100 text-gray-500"
                          }`}
                        >
                          ({tab.count})
                        </span>
                      </button>
                    );
                  })}
                </div>

                {/* Auction Dropdown Filter (Exact as media_1787855146415.png) */}
                <div className="relative flex items-center gap-2">
                  {/* Funnel Filter Icon */}
                  <Filter className="w-4 h-4 text-gray-500 shrink-0" strokeWidth={1.75} />

                  {/* Dropdown Button */}
                  <div className="relative">
                    <button
                      type="button"
                      onClick={() => setIsAuctionDropdownOpen(!isAuctionDropdownOpen)}
                      className="px-4 py-2 bg-white border border-gray-200/90 rounded-2xl flex items-center justify-between gap-3 text-xs sm:text-sm font-normal text-gray-700 shadow-2xs hover:border-gray-300 transition-all cursor-pointer min-w-[140px]"
                    >
                      <span className="font-normal text-gray-700">{selectedAuctionFilter}</span>
                      <ChevronDown
                        className={`w-4 h-4 text-gray-500 shrink-0 transition-transform duration-200 ${
                          isAuctionDropdownOpen ? "rotate-180" : ""
                        }`}
                      />
                    </button>

                    {/* Floating Options Menu */}
                    {isAuctionDropdownOpen && (
                      <div className="absolute left-0 top-full mt-1.5 w-48 bg-white rounded-2xl shadow-xl border border-gray-100 py-1.5 z-30 animate-fadeIn">
                        {auctionOptions.map((opt) => {
                          const isSelected = selectedAuctionFilter === opt;
                          return (
                            <button
                              key={opt}
                              type="button"
                              onClick={() => {
                                setSelectedAuctionFilter(opt);
                                setIsAuctionDropdownOpen(false);
                                showToast(`Filtered by ${opt}`);
                              }}
                              className={`w-full px-3.5 py-2 text-xs flex items-center justify-between transition-colors cursor-pointer text-left ${
                                isSelected
                                  ? "bg-emerald-50 text-[#009639] font-medium"
                                  : "text-gray-700 hover:bg-gray-50 font-normal"
                              }`}
                            >
                              <span>{opt}</span>
                              {isSelected && <Check className="w-3.5 h-3.5 text-[#009639]" />}
                            </button>
                          );
                        })}
                      </div>
                    )}
                  </div>
                </div>
              </div>

              {/* Table Search Input */}
              <div className="relative w-full xl:w-[260px]">
                <Search className="w-3.5 h-3.5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search dealer, auction..."
                  className="w-full pl-9 pr-3 py-1.5 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009639] focus:ring-1 focus:ring-[#009639]/20 text-gray-800 placeholder:text-gray-400 shadow-xs"
                />
              </div>

            </div>

            {/* Bids Grid (3 Columns) */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-5">
              {filteredBids.map((bid) => {
                const isWinner = bid.status === "Winner";
                const isLost = bid.status === "Lost";
                return (
                  <div
                    key={bid.id}
                    className={`bg-white rounded-2xl p-5 border shadow-sm hover:shadow-md transition-all flex flex-col justify-between relative ${
                      isWinner
                        ? "border-amber-400 ring-2 ring-amber-400/20"
                        : "border-gray-200/80"
                    }`}
                  >
                    <div>
                      {/* Bid Card Header */}
                      <div className="flex items-start justify-between gap-2 pb-3 border-b border-gray-100">
                        <div className="flex items-center gap-2.5">
                          <div className="w-8 h-8 rounded-full bg-[#009639] text-white flex items-center justify-center font-bold text-xs shadow-xs">
                            {bid.bidderAvatar}
                          </div>
                          <div>
                            <h3 className="text-xs font-bold text-gray-900 leading-tight">
                              {bid.bidderName}
                            </h3>
                            <p className="text-[11px] text-gray-400 flex items-center gap-0.5 mt-0.5">
                              <MapPin className="w-2.5 h-2.5" />
                              <span>{bid.bidderCity}</span>
                            </p>
                          </div>
                        </div>

                        {/* Status Badges */}
                        <div className="flex items-center gap-1.5">
                          {bid.isHighest && !isWinner && (
                            <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-50 text-emerald-700 border border-emerald-200">
                              Highest
                            </span>
                          )}

                          {isWinner && (
                            <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-amber-50 text-amber-700 border border-amber-300 flex items-center gap-1">
                              <Trophy className="w-3 h-3 text-amber-500" />
                              <span>Winner</span>
                            </span>
                          )}

                          {isLost && (
                            <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-red-50 text-red-600 border border-red-200">
                              Lost
                            </span>
                          )}

                          {bid.status === "Pending" && (
                            <span className="px-2 py-0.5 rounded-full text-[10px] font-semibold bg-blue-50 text-blue-600 border border-blue-200">
                              Pending
                            </span>
                          )}
                        </div>
                      </div>

                      {/* Bid Amount Block */}
                      <div className="py-3">
                        <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider">
                          BID AMOUNT
                        </p>
                        <p
                          className={`text-2xl font-black tracking-tight mt-0.5 ${
                            isWinner ? "text-amber-600" : "text-gray-900"
                          }`}
                        >
                          PKR {bid.bidAmount.toLocaleString()}
                        </p>
                      </div>

                      {/* Details List */}
                      <div className="space-y-1.5 text-xs pt-2 border-t border-gray-100">
                        <div className="flex items-center justify-between text-gray-500">
                          <span>Auction</span>
                          <span className="font-mono font-bold text-gray-800">{bid.auctionId}</span>
                        </div>
                        <div className="flex items-center justify-between text-gray-500">
                          <span>Equipment</span>
                          <span className="font-semibold text-gray-800 text-right truncate max-w-[160px]">
                            {bid.equipment}
                          </span>
                        </div>
                        <div className="flex items-center justify-between text-gray-500">
                          <span>Submitted</span>
                          <span className="font-mono text-gray-600 text-[11px]">
                            {bid.submittedDate}
                          </span>
                        </div>
                        <div className="flex items-center justify-between text-gray-500">
                          <span>Phone</span>
                          <span className="font-mono text-gray-600 text-[11px]">
                            {bid.bidderPhone}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Card Footer Actions */}
                    <div className="flex items-center justify-between gap-2 pt-4 mt-4 border-t border-gray-100">
                      {isWinner ? (
                        <div className="flex items-center gap-1.5 text-amber-700 bg-amber-50 px-3 py-1.5 rounded-xl border border-amber-200 text-xs font-bold">
                          <Trophy className="w-3.5 h-3.5 text-amber-600" />
                          <span>Winning Bid</span>
                        </div>
                      ) : (
                        <button
                          type="button"
                          onClick={() => handleOpenWinnerModal(bid)}
                          className="flex items-center gap-1.5 px-3 py-1.5 bg-amber-50/70 hover:bg-amber-100/80 text-amber-800 border border-amber-200/80 rounded-xl text-xs font-bold transition-colors cursor-pointer shadow-2xs"
                        >
                          <Trophy className="w-3.5 h-3.5 text-amber-600" />
                          <span>Select Winner</span>
                        </button>
                      )}

                      <div className="flex items-center gap-1">
                        <button
                          type="button"
                          onClick={() => handleOpenDetails(bid)}
                          className="p-1.5 rounded-lg text-gray-400 hover:text-gray-700 hover:bg-gray-100 transition-colors"
                          title="View Details"
                        >
                          <Eye className="w-4 h-4" />
                        </button>
                        <button
                          type="button"
                          onClick={() => handleOpenDetails(bid)}
                          className="p-1.5 rounded-lg text-gray-400 hover:text-gray-700 hover:bg-gray-100 transition-colors"
                          title="More options"
                        >
                          <MoreVertical className="w-4 h-4" />
                        </button>
                      </div>
                    </div>

                  </div>
                );
              })}
            </div>

            {filteredBids.length === 0 && (
              <div className="bg-white rounded-2xl p-12 text-center border border-gray-200/80">
                <Gavel className="w-8 h-8 text-gray-300 mx-auto mb-2" />
                <p className="text-sm font-semibold text-gray-600">No bids match your filters</p>
                <p className="text-xs text-gray-400 mt-0.5">Try resetting filter tabs or search query.</p>
              </div>
            )}

          </main>

        </div>

      {/* ===================== 1. SELECT WINNER MODAL ===================== */}
      {isWinnerModalOpen && bidToSelectWinner && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl sm:rounded-3xl max-w-[400px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100">
            
            <div className="flex items-center justify-between pb-3 border-b border-gray-100">
              <h2 className="text-base font-bold text-gray-900 flex items-center gap-2">
                <Trophy className="w-4 h-4 text-amber-500" />
                <span>Declare Winner</span>
              </h2>
              <button
                type="button"
                onClick={() => setIsWinnerModalOpen(false)}
                className="w-7 h-7 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="mt-4 p-4 bg-amber-50/70 border border-amber-200/80 rounded-2xl text-xs space-y-2">
              <p className="text-gray-600">
                Are you sure you want to select <span className="font-bold text-gray-900">{bidToSelectWinner.bidderName}</span> as the winning bidder for auction <span className="font-mono font-bold text-gray-900">{bidToSelectWinner.auctionId}</span>?
              </p>
              <div className="p-2.5 bg-white rounded-xl border border-amber-100 flex items-center justify-between">
                <span className="text-gray-500">Winning Amount:</span>
                <span className="text-base font-black text-amber-700">
                  PKR {bidToSelectWinner.bidAmount.toLocaleString()}
                </span>
              </div>
            </div>

            <div className="flex items-center justify-end gap-2 mt-5 pt-3 border-t border-gray-100">
              <button
                type="button"
                onClick={() => setIsWinnerModalOpen(false)}
                className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-semibold rounded-xl transition-colors cursor-pointer"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleConfirmWinner}
                className="px-5 py-2 bg-[#009639] hover:bg-[#008230] text-white text-xs font-semibold rounded-xl shadow-xs transition-colors cursor-pointer flex items-center gap-1.5"
              >
                <Check className="w-3.5 h-3.5" />
                <span>Confirm Winner</span>
              </button>
            </div>

          </div>
        </div>
      )}

      {/* ===================== 2. BID DETAILS MODAL ===================== */}
      {isDetailsOpen && selectedBid && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl sm:rounded-3xl max-w-[480px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100">
            
            <div className="flex items-center justify-between pb-3 border-b border-gray-100">
              <h2 className="text-base font-bold text-gray-900">Bid Details</h2>
              <button
                type="button"
                onClick={() => setIsDetailsOpen(false)}
                className="w-7 h-7 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="mt-4 p-4 bg-emerald-50 rounded-2xl border border-emerald-100 flex items-center justify-between">
              <div>
                <p className="text-[10px] font-bold text-emerald-800 uppercase tracking-wider">
                  OFFERED BID AMOUNT
                </p>
                <p className="text-2xl font-black text-[#009639] leading-tight">
                  PKR {selectedBid.bidAmount.toLocaleString()}
                </p>
              </div>
              <span className="px-2.5 py-1 bg-white rounded-full text-xs font-bold text-gray-800 border border-emerald-100">
                {selectedBid.status}
              </span>
            </div>

            <div className="space-y-2.5 mt-4 text-xs">
              <div className="p-3 bg-gray-50 rounded-xl border border-gray-100">
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">
                  BIDDER INFO
                </p>
                <div className="flex items-center justify-between">
                  <div>
                    <p className="font-bold text-gray-900">{selectedBid.bidderName}</p>
                    <p className="text-[11px] text-gray-500">{selectedBid.bidderCompany}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-mono text-gray-700">{selectedBid.bidderPhone}</p>
                    <p className="text-gray-500">{selectedBid.bidderEmail}</p>
                  </div>
                </div>
              </div>

              <div className="p-3 bg-gray-50 rounded-xl border border-gray-100">
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">
                  AUCTION INFO
                </p>
                <div className="flex items-center justify-between">
                  <span className="text-gray-500">Auction ID:</span>
                  <span className="font-mono font-bold text-gray-800">{selectedBid.auctionId}</span>
                </div>
                <div className="flex items-center justify-between mt-1">
                  <span className="text-gray-500">Equipment:</span>
                  <span className="font-medium text-gray-800">{selectedBid.equipment}</span>
                </div>
                <div className="flex items-center justify-between mt-1">
                  <span className="text-gray-500">Submitted Date:</span>
                  <span className="font-mono text-gray-600">{selectedBid.submittedDate}</span>
                </div>
              </div>
            </div>

            <div className="flex items-center justify-end gap-2 mt-5 pt-3 border-t border-gray-100">
              <button
                type="button"
                onClick={() => setIsDetailsOpen(false)}
                className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-semibold rounded-xl transition-colors cursor-pointer"
              >
                Close
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
