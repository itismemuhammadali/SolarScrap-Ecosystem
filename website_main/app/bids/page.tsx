"use client";

import { Suspense, useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import Sidebar from "@/components/Sidebar";
import { getSession, getAvatarUrl } from "@/lib/auth";
import {
  Search,
  Bell,
  X,
  MoreVertical,
  Eye,
  Trophy,
  MapPin,
  Calendar,
  Phone,
  Check,
  Building2,
  Mail,
  Gavel,
  ArrowLeft,
  Loader2,
  MessageSquare,
  ExternalLink,
  User,
} from "lucide-react";
import { getAdminBids, getAdminAuctionDetail, acceptAdminBid } from "@/lib/admin-api";

interface BidItem {
  id: string;
  bidderId?: string;
  bidderName: string;
  bidderAvatar?: string;
  bidderCity: string;
  bidderCompany?: string;
  bidderEmail?: string;
  bidderPhone: string;
  bidAmount: number;
  auctionId: string;
  listingId?: string;
  equipment: string;
  submittedDate: string;
  status: "Pending" | "Winner" | "Lost" | string;
  isHighest?: boolean;
}

function BidsPageContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const auctionIdParam = searchParams.get("auctionId");
  const currentAuctionId = auctionIdParam || "AUC001";

  const [bids, setBids] = useState<BidItem[]>([]);
  const [auctionDetail, setAuctionDetail] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [activeFilter, setActiveFilter] = useState("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [adminName, setAdminName] = useState("Admin Platform");
  const [adminPhotoUrl, setAdminPhotoUrl] = useState<string | null>(null);

  useEffect(() => {
    const session = getSession();
    if (session?.user) {
      if (session.user.display_name) setAdminName(session.user.display_name);
      else if (session.user.email) setAdminName(session.user.email.split("@")[0]);
      if (session.user.profile_photo_url) setAdminPhotoUrl(session.user.profile_photo_url);
    }
  }, []);

  const fetchData = async () => {
    try {
      const [liveBids, detail] = await Promise.allSettled([
        getAdminBids(currentAuctionId),
        getAdminAuctionDetail(currentAuctionId),
      ]);
      if (liveBids.status === "fulfilled" && Array.isArray(liveBids.value)) {
        setBids(liveBids.value);
      }
      if (detail.status === "fulfilled" && detail.value) {
        setAuctionDetail(detail.value);
      }
    } catch (err) {
      console.error("Failed to fetch auction bids:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    setLoading(true);
    fetchData();
    const interval = setInterval(fetchData, 8000);
    return () => clearInterval(interval);
  }, [currentAuctionId]);

  // Modals state
  const [selectedBid, setSelectedBid] = useState<BidItem | null>(null);
  const [isDetailsOpen, setIsDetailsOpen] = useState(false);
  const [isWinnerModalOpen, setIsWinnerModalOpen] = useState(false);
  const [bidToSelectWinner, setBidToSelectWinner] = useState<BidItem | null>(null);
  const [isProfileModalOpen, setIsProfileModalOpen] = useState(false);
  const [profileBuyer, setProfileBuyer] = useState<BidItem | null>(null);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3000);
  };

  const handleOpenBuyerProfile = (bid: BidItem) => {
    setProfileBuyer(bid);
    setIsProfileModalOpen(true);
  };

  // Sort all bids descending by bidAmount so highest bids come first
  const sortedBids = [...bids].sort((a, b) => b.bidAmount - a.bidAmount);

  const filterTabs = [
    { name: "All", count: bids.length, icon: null },
    { name: "Pending", count: bids.filter((b) => b.status === "Pending").length, icon: null },
    { name: "Winner", count: bids.filter((b) => b.status === "Winner").length, icon: Trophy },
    { name: "Lost", count: bids.filter((b) => b.status === "Lost").length, icon: null },
  ];

  // Filtered Bids - STRICTLY TOP 3 BIDS
  const filteredBids = sortedBids
    .filter((bid) => {
      if (activeFilter !== "All" && bid.status !== activeFilter) return false;
      if (searchQuery.trim()) {
        const q = searchQuery.toLowerCase();
        const match =
          bid.bidderName.toLowerCase().includes(q) ||
          (bid.bidderCompany && bid.bidderCompany.toLowerCase().includes(q)) ||
          bid.auctionId.toLowerCase().includes(q) ||
          bid.equipment.toLowerCase().includes(q) ||
          bid.bidderCity.toLowerCase().includes(q) ||
          (bid.bidderPhone && bid.bidderPhone.toLowerCase().includes(q)) ||
          (bid.bidderEmail && bid.bidderEmail.toLowerCase().includes(q));
        if (!match) return false;
      }
      return true;
    })
    .slice(0, 3); // Requirement: Only the top 3 bids should be displayed

  const handleOpenWinnerModal = (bid: BidItem) => {
    setBidToSelectWinner(bid);
    setIsWinnerModalOpen(true);
  };

  const handleConfirmWinner = async () => {
    if (!bidToSelectWinner) return;
    try {
      await acceptAdminBid(bidToSelectWinner.id);
      showToast(`${bidToSelectWinner.bidderName} declared Winner for ${bidToSelectWinner.auctionId}!`);
      fetchData();
    } catch (err: any) {
      console.error(err);
      showToast(err.message || "Failed to accept bid");
    }
    setIsWinnerModalOpen(false);
    setBidToSelectWinner(null);
  };

  const handleOpenDetails = (bid: BidItem) => {
    setSelectedBid(bid);
    setIsDetailsOpen(true);
  };

  return (
    <div className="flex h-screen w-full bg-[#F5F6FA] overflow-hidden">
      {/* Sidebar */}
      <Sidebar
        activeItem="Auctions"
        mobileMenuOpen={mobileMenuOpen}
        setMobileMenuOpen={setMobileMenuOpen}
      />

      {/* Main Content Area */}
      <div className="flex-1 bg-[#F5F6FA] flex flex-col min-w-0 h-screen overflow-hidden">
        {/* Top Navbar */}
        <header className="sticky top-0 z-20 bg-white border-b border-gray-200/80 px-5 sm:px-8 py-3.5 flex items-center justify-between gap-4">
          <div className="relative flex-1 max-w-[420px]">
            <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={topSearch}
              onChange={(e) => setTopSearch(e.target.value)}
              placeholder="Search users, posts, auctions, bids..."
              className="w-full pl-10 pr-4 py-2 text-xs sm:text-sm bg-gray-50/70 border border-gray-200/80 rounded-xl outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all text-gray-800 placeholder:text-gray-400"
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
                {adminName}
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

        {/* Main Body */}
        <main className="flex-1 p-5 sm:p-7 md:p-8 space-y-5 overflow-y-auto">
          {/* Back Button & Heading */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
            <div>
              <div className="flex items-center gap-3">
                <button
                  type="button"
                  onClick={() => router.push("/auctions")}
                  className="px-3.5 py-1.5 bg-white border border-gray-200/90 rounded-xl text-xs font-semibold text-gray-700 hover:bg-gray-50 shadow-2xs transition-all cursor-pointer inline-flex items-center gap-1.5"
                >
                  <ArrowLeft className="w-3.5 h-3.5 text-gray-500" />
                  <span>Back to Auctions</span>
                </button>
                <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-[#009845]/10 text-[#009845] border border-[#009845]/20 font-mono">
                  {currentAuctionId}
                </span>
              </div>
              <h1 className="text-xl sm:text-2xl font-bold text-gray-900 tracking-tight mt-2.5">
                {auctionDetail?.title || `Auction : ${currentAuctionId}`}
              </h1>
              <p className="text-xs text-gray-500 mt-1">
                Live bidding activity — bids placed by verified buyers update in real-time.
              </p>
            </div>
          </div>

          {/* Auction Summary Card */}
          {auctionDetail && (
            <div className="bg-white rounded-2xl p-5 sm:p-6 border border-gray-200/80 shadow-2xs">
              <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-5">
                {/* Left: Icon, Category, Status, Title, Seller */}
                <div className="flex items-start gap-4">
                  <div className="w-12 h-12 rounded-2xl bg-emerald-50 border border-emerald-100 flex items-center justify-center text-2xl shrink-0 shadow-2xs">
                    {auctionDetail.icon || "☀️"}
                  </div>
                  <div>
                    <div className="flex flex-wrap items-center gap-2">
                      <span
                        className={`px-2.5 py-0.5 rounded-full text-xs font-semibold ${
                          auctionDetail.status === "Active"
                            ? "bg-emerald-50 text-emerald-700 border border-emerald-200"
                            : auctionDetail.status === "Closed"
                            ? "bg-gray-100 text-gray-700 border border-gray-200"
                            : "bg-amber-50 text-amber-700 border border-amber-200"
                        }`}
                      >
                        {auctionDetail.status || "Active"}
                      </span>
                      <span className="text-xs text-gray-400 font-medium">
                        {auctionDetail.category || "Solar Equipment"}
                      </span>
                      {auctionDetail.endDate && (
                        <>
                          <span className="text-gray-300">•</span>
                          <span className="text-xs text-gray-500 flex items-center gap-1">
                            <Calendar className="w-3 h-3 text-gray-400" />
                            {auctionDetail.endDate}
                          </span>
                        </>
                      )}
                    </div>
                    <h2 className="text-base sm:text-lg font-bold text-gray-900 mt-1">
                      {auctionDetail.title}
                    </h2>
                    <p className="text-xs text-gray-500 mt-1 flex flex-wrap items-center gap-2 sm:gap-3">
                      <span>
                        Seller: <strong className="text-gray-700">{auctionDetail.sellerName || "Admin"}</strong>
                        {auctionDetail.sellerCity ? ` (${auctionDetail.sellerCity})` : ""}
                      </span>
                      <span>•</span>
                      <span>
                        Qty: <strong className="text-gray-700">{auctionDetail.qty || "1 Lot"}</strong>
                      </span>
                    </p>
                  </div>
                </div>

                {/* Right: Metrics Grid */}
                <div className="grid grid-cols-3 gap-3 sm:gap-4 lg:min-w-[420px] pt-3 lg:pt-0 border-t lg:border-t-0 border-gray-100">
                  <div className="bg-gray-50/80 rounded-xl p-3 border border-gray-100">
                    <p className="text-[11px] font-medium text-gray-400">Starting Price</p>
                    <p className="text-sm sm:text-base font-bold text-gray-800 mt-0.5">
                      PKR {(auctionDetail.startingPrice || auctionDetail.priceDemand || 0).toLocaleString()}
                    </p>
                  </div>
                  <div className="bg-emerald-50/60 rounded-xl p-3 border border-emerald-100">
                    <p className="text-[11px] font-medium text-emerald-700">Highest Bid</p>
                    <p className="text-sm sm:text-base font-bold text-[#009845] mt-0.5">
                      PKR {(bids.length > 0 ? Math.max(...bids.map((b) => b.bidAmount)) : (auctionDetail.currentHighBid || 0)).toLocaleString()}
                    </p>
                  </div>
                  <div className="bg-gray-50/80 rounded-xl p-3 border border-gray-100">
                    <p className="text-[11px] font-medium text-gray-400">Total Bids</p>
                    <p className="text-sm sm:text-base font-bold text-gray-800 mt-0.5">
                      {bids.length}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Filter Tabs & Search Row */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pt-1">
            {/* Filter Tabs */}
            <div className="flex items-center gap-2 overflow-x-auto pb-1 sm:pb-0 scrollbar-none">
              {filterTabs.map((tab) => {
                const isActive = activeFilter === tab.name;
                const TabIcon = tab.icon;
                return (
                  <button
                    key={tab.name}
                    type="button"
                    onClick={() => setActiveFilter(tab.name)}
                    className={`px-3.5 py-1.5 rounded-full text-xs font-medium transition-all duration-150 cursor-pointer whitespace-nowrap flex items-center gap-1.5 ${
                      isActive
                        ? "bg-[#009845] text-white shadow-xs font-semibold"
                        : "text-gray-600 hover:text-gray-900 hover:bg-gray-100 bg-white border border-gray-200/80"
                    }`}
                  >
                    {TabIcon && <TabIcon className={`w-3.5 h-3.5 ${isActive ? "text-white" : "text-amber-500"}`} />}
                    <span>
                      {tab.name} ({tab.count})
                    </span>
                  </button>
                );
              })}
            </div>

            {/* Search Input */}
            <div className="relative w-full sm:w-[240px]">
              <Search className="w-3.5 h-3.5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search buyer, company..."
                className="w-full pl-8 pr-3 py-1.5 text-xs bg-white border border-gray-200/90 rounded-xl outline-none focus:border-[#009845] focus:ring-1 focus:ring-[#009845]/20 text-gray-800 placeholder:text-gray-400 shadow-2xs"
              />
            </div>
          </div>

          {/* Loading State */}
          {loading && bids.length === 0 && (
            <div className="bg-white rounded-2xl p-16 text-center border border-gray-200/80 shadow-2xs flex flex-col items-center justify-center">
              <Loader2 className="w-8 h-8 text-[#009845] animate-spin mb-3" />
              <p className="text-sm font-semibold text-gray-700">Loading auction bids...</p>
              <p className="text-xs text-gray-400 mt-1">Fetching live bids from the database</p>
            </div>
          )}

          {/* Top 3 Bids Header Banner */}
          <div className="flex items-center justify-between px-1">
            <div className="flex items-center gap-2">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-[#009845]/10 text-[#009845] border border-[#009845]/20 shadow-2xs">
                <Trophy className="w-3.5 h-3.5 text-amber-500" />
                <span>Top 3 Highest Bids</span>
              </span>
              <span className="text-xs text-gray-500 hidden sm:inline">
                Ranked by offer amount • Click buyer or contact buttons to reach out directly
              </span>
            </div>
            {bids.length > 3 && (
              <span className="text-[11px] text-gray-400 font-medium">
                Showing top 3 of {bids.length} total bids
              </span>
            )}
          </div>

          {/* Bids Grid (3 Columns) - Displays ONLY Top 3 */}
          {filteredBids.length > 0 && (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
              {filteredBids.map((bid, index) => {
                const isWinner = bid.status === "Winner";
                const isLost = bid.status === "Lost";
                const isPending = bid.status === "Pending";
                const rank = index + 1;
                const cleanPhone = bid.bidderPhone ? bid.bidderPhone.replace(/[^0-9]/g, "") : "";

                return (
                  <div
                    key={bid.id}
                    className="bg-white rounded-2xl p-5 border border-gray-200/80 shadow-2xs hover:shadow-md transition-all flex flex-col justify-between"
                  >
                    <div>
                      {/* Top Row: Avatar, Name, Location & Badges */}
                      <div className="flex items-start justify-between gap-2">
                        <div className="flex items-center gap-2.5">
                          <button
                            type="button"
                            onClick={() => handleOpenBuyerProfile(bid)}
                            className="w-10 h-10 rounded-full bg-[#009845] text-white flex items-center justify-center font-bold text-sm shrink-0 shadow-2xs select-none hover:opacity-90 transition-opacity cursor-pointer ring-2 ring-transparent hover:ring-[#009845]/30"
                            title="Click to view Buyer Profile"
                          >
                            {bid.bidderName ? bid.bidderName.charAt(0).toUpperCase() : "B"}
                          </button>
                          <div>
                            <button
                              type="button"
                              onClick={() => handleOpenBuyerProfile(bid)}
                              className="text-xs sm:text-sm font-bold text-gray-900 leading-tight hover:text-[#009845] transition-colors cursor-pointer text-left flex items-center gap-1 group"
                              title="Click to view Buyer Profile"
                            >
                              <span>{bid.bidderName}</span>
                              <ExternalLink className="w-3 h-3 text-gray-400 group-hover:text-[#009845] opacity-0 group-hover:opacity-100 transition-opacity" />
                            </button>
                            <p className="text-[11px] text-gray-400 flex items-center gap-1 mt-0.5">
                              <MapPin className="w-2.5 h-2.5 text-gray-400" />
                              <span>{bid.bidderCity}</span>
                              {bid.bidderCompany && (
                                <>
                                  <span>•</span>
                                  <span className="truncate max-w-[110px]">{bid.bidderCompany}</span>
                                </>
                              )}
                            </p>
                          </div>
                        </div>

                        {/* Badges: Rank & Status */}
                        <div className="flex flex-col items-end gap-1 shrink-0">
                          {/* Top 3 Rank Badge */}
                          <span
                            className={`px-2 py-0.5 rounded-full text-[10px] font-bold flex items-center gap-1 shadow-2xs ${
                              rank === 1
                                ? "bg-amber-50 text-amber-700 border border-amber-300"
                                : rank === 2
                                ? "bg-slate-100 text-slate-700 border border-slate-300"
                                : "bg-amber-900/10 text-amber-900 border border-amber-900/20"
                            }`}
                          >
                            <span>{rank === 1 ? "🥇 #1 Highest" : rank === 2 ? "🥈 #2 Bid" : "🥉 #3 Bid"}</span>
                          </span>

                          {/* Status Badge */}
                          {isPending && (
                            <span className="px-2 py-0.2 rounded-full text-[10px] font-semibold bg-blue-50 text-blue-600 border border-blue-200">
                              Pending
                            </span>
                          )}

                          {isWinner && (
                            <span className="px-2 py-0.2 rounded-full text-[10px] font-semibold text-[#009845] border border-[#009845]/40 bg-emerald-50/50 flex items-center gap-1">
                              <Trophy className="w-2.5 h-2.5 text-amber-500" />
                              <span>Winner</span>
                            </span>
                          )}

                          {isLost && (
                            <span className="px-2 py-0.2 rounded-full text-[10px] font-semibold bg-red-50 text-red-500 border border-red-200">
                              Lost
                            </span>
                          )}
                        </div>
                      </div>

                      {/* Bid Amount Box */}
                      <div className="bg-gray-50/80 border border-gray-100 rounded-xl p-3 sm:p-3.5 my-3.5">
                        <p className="text-[11px] font-medium text-gray-400">
                          Bid Amount
                        </p>
                        <p
                          className={`text-xl sm:text-2xl font-bold tracking-tight mt-1 ${
                            isWinner || rank === 1 ? "text-[#009845]" : "text-gray-900"
                          }`}
                        >
                          PKR {bid.bidAmount.toLocaleString()}
                        </p>
                      </div>

                      {/* Details List */}
                      <div className="space-y-1.5 text-xs">
                        <div className="flex items-center justify-between text-gray-400">
                          <span>Auction</span>
                          <span className="font-semibold text-gray-900">{bid.auctionId}</span>
                        </div>
                        <div className="flex items-center justify-between text-gray-400">
                          <span>Equipment</span>
                          <span className="font-semibold text-gray-900 text-right truncate max-w-[170px]">
                            {bid.equipment}
                          </span>
                        </div>
                        <div className="flex items-center justify-between text-gray-400">
                          <span>Submitted</span>
                          <span className="text-gray-600">{bid.submittedDate}</span>
                        </div>
                        <div className="flex items-center justify-between text-gray-400">
                          <span>Phone</span>
                          {bid.bidderPhone ? (
                            <a
                              href={`tel:${bid.bidderPhone}`}
                              className="font-medium text-gray-800 hover:text-[#009845] hover:underline flex items-center gap-1 transition-colors"
                              title="Click to call"
                            >
                              <Phone className="w-2.5 h-2.5 text-[#009845]" />
                              <span>{bid.bidderPhone}</span>
                            </a>
                          ) : (
                            <span className="text-gray-400">N/A</span>
                          )}
                        </div>
                        {bid.bidderEmail && (
                          <div className="flex items-center justify-between text-gray-400">
                            <span>Email</span>
                            <a
                              href={`mailto:${bid.bidderEmail}?subject=${encodeURIComponent(`Regarding your bid on ${bid.equipment} (${bid.auctionId})`)}`}
                              className="font-medium text-gray-800 hover:text-[#009845] hover:underline truncate max-w-[170px] text-right transition-colors"
                              title="Click to email"
                            >
                              <span>{bid.bidderEmail}</span>
                            </a>
                          </div>
                        )}
                      </div>
                    </div>

                    {/* Quick Contact & Action Buttons */}
                    <div className="pt-3.5 mt-3 border-t border-gray-100 space-y-2.5">
                      {/* Direct Quick Contact Buttons (WhatsApp, Call, Email, Profile) */}
                      <div className="flex items-center gap-1.5">
                        {/* WhatsApp Button */}
                        {bid.bidderPhone ? (
                          <a
                            href={`https://wa.me/${cleanPhone}?text=${encodeURIComponent(
                              `Hello ${bid.bidderName}, I am contacting you from Solar Scrap regarding your bid of PKR ${bid.bidAmount.toLocaleString()} on ${bid.equipment} (${bid.auctionId}).`
                            )}`}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="flex-1 py-1.5 px-2 rounded-xl bg-emerald-50 hover:bg-emerald-100 text-[#009845] border border-emerald-200/90 text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors cursor-pointer shadow-2xs"
                            title="Chat on WhatsApp"
                          >
                            <MessageSquare className="w-3.5 h-3.5 text-[#25D366]" />
                            <span>WhatsApp</span>
                          </a>
                        ) : (
                          <button
                            disabled
                            className="flex-1 py-1.5 px-2 rounded-xl bg-gray-50 border border-gray-200 text-gray-300 text-xs font-semibold flex items-center justify-center gap-1.5 cursor-not-allowed"
                          >
                            <MessageSquare className="w-3.5 h-3.5" />
                            <span>WhatsApp</span>
                          </button>
                        )}

                        {/* Call Phone Button */}
                        {bid.bidderPhone && (
                          <a
                            href={`tel:${bid.bidderPhone}`}
                            className="py-1.5 px-2.5 rounded-xl bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 text-xs font-semibold flex items-center justify-center gap-1 transition-colors cursor-pointer shadow-2xs"
                            title="Call Phone"
                          >
                            <Phone className="w-3.5 h-3.5 text-gray-600" />
                            <span>Call</span>
                          </a>
                        )}

                        {/* Email Button */}
                        {bid.bidderEmail && (
                          <a
                            href={`mailto:${bid.bidderEmail}?subject=${encodeURIComponent(
                              `Regarding your bid on ${bid.equipment} (${bid.auctionId})`
                            )}`}
                            className="py-1.5 px-2.5 rounded-xl bg-blue-50 hover:bg-blue-100 text-blue-700 border border-blue-200 text-xs font-semibold flex items-center justify-center gap-1 transition-colors cursor-pointer shadow-2xs"
                            title="Send Email"
                          >
                            <Mail className="w-3.5 h-3.5 text-blue-600" />
                            <span>Email</span>
                          </a>
                        )}

                        {/* View Profile Button */}
                        <button
                          type="button"
                          onClick={() => handleOpenBuyerProfile(bid)}
                          className="py-1.5 px-2.5 rounded-xl bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 text-xs font-semibold flex items-center justify-center gap-1 transition-colors cursor-pointer shadow-2xs"
                          title="View Buyer Profile"
                        >
                          <User className="w-3.5 h-3.5 text-gray-600" />
                          <span className="hidden sm:inline">Profile</span>
                        </button>
                      </div>

                      {/* Card Footer: Select Winner on left, View details on right */}
                      <div className="flex items-center justify-between pt-1">
                        <button
                          type="button"
                          onClick={() => handleOpenWinnerModal(bid)}
                          className="flex items-center gap-1.5 px-3 py-1.5 bg-amber-50/70 hover:bg-amber-100/90 text-[#D97706] border border-amber-300 rounded-xl text-xs font-semibold transition-colors cursor-pointer shadow-2xs"
                        >
                          <Trophy className="w-3.5 h-3.5 text-amber-500" />
                          <span>Select Winner</span>
                        </button>

                        <div className="flex items-center gap-1">
                          <button
                            type="button"
                            onClick={() => handleOpenDetails(bid)}
                            className="p-1.5 rounded-lg text-gray-400 hover:text-gray-600 hover:bg-gray-100 transition-colors cursor-pointer"
                            title="View full bid details"
                          >
                            <Eye className="w-4 h-4" />
                          </button>
                          <button
                            type="button"
                            onClick={() => handleOpenBuyerProfile(bid)}
                            className="p-1.5 rounded-lg text-gray-400 hover:text-gray-600 hover:bg-gray-100 transition-colors cursor-pointer"
                            title="View buyer profile"
                          >
                            <MoreVertical className="w-4 h-4" />
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}

          {/* Empty State */}
          {!loading && filteredBids.length === 0 && (
            <div className="bg-white rounded-2xl p-12 text-center border border-gray-200/80 shadow-2xs">
              <div className="w-14 h-14 mx-auto rounded-2xl bg-gray-50 border border-gray-200 flex items-center justify-center text-gray-400 mb-3">
                <Gavel className="w-7 h-7 text-gray-400" />
              </div>
              <h3 className="text-base font-bold text-gray-800">No bids found</h3>
              <p className="text-xs text-gray-500 max-w-md mx-auto mt-1">
                {activeFilter !== "All"
                  ? `There are no bids with status "${activeFilter}" for this auction.`
                  : `No bids have been submitted for ${currentAuctionId} yet. When buyers place bids from the mobile app, they will appear here live.`}
              </p>
              {activeFilter !== "All" && (
                <button
                  type="button"
                  onClick={() => setActiveFilter("All")}
                  className="mt-4 px-4 py-1.5 text-xs font-semibold text-[#009845] bg-[#009845]/10 rounded-xl hover:bg-[#009845]/20 transition-colors cursor-pointer"
                >
                  Show All Bids
                </button>
              )}
            </div>
          )}
        </main>
      </div>

      {/* Select Winner Modal */}
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
                Are you sure you want to select{" "}
                <span className="font-bold text-gray-900">{bidToSelectWinner.bidderName}</span> as the winning bidder for auction{" "}
                <span className="font-mono font-bold text-gray-900">{bidToSelectWinner.auctionId}</span>?
              </p>
              <div className="pt-2 border-t border-amber-200/60 flex items-center justify-between font-medium">
                <span className="text-gray-500">Winning Bid Amount:</span>
                <span className="text-sm font-black text-amber-700">
                  PKR {bidToSelectWinner.bidAmount.toLocaleString()}
                </span>
              </div>
            </div>

            <div className="mt-5 flex items-center justify-end gap-2.5">
              <button
                type="button"
                onClick={() => setIsWinnerModalOpen(false)}
                className="px-4 py-2 border border-gray-200 text-gray-600 hover:bg-gray-50 rounded-xl text-xs font-semibold transition-colors cursor-pointer"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleConfirmWinner}
                className="px-4 py-2 bg-amber-500 hover:bg-amber-600 text-white rounded-xl text-xs font-bold shadow-xs transition-colors cursor-pointer flex items-center gap-1.5"
              >
                <Trophy className="w-3.5 h-3.5" />
                <span>Confirm & Declare Winner</span>
              </button>
            </div>
          </div>
        </div>
      )}      {/* Details Modal */}
      {isDetailsOpen && selectedBid && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[460px] w-full p-6 sm:p-7 shadow-2xl border border-gray-100">
            {/* Modal Header */}
            <div className="flex items-center justify-between pb-3.5 border-b border-gray-100">
              <h2 className="text-base font-bold text-gray-900">Bid Details</h2>
              <button
                type="button"
                onClick={() => setIsDetailsOpen(false)}
                className="text-gray-400 hover:text-gray-600 transition-colors cursor-pointer p-1 -mr-1"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* Profile Row */}
            <div className="flex items-center justify-between py-4 border-b border-gray-100">
              <div className="flex items-center gap-3.5">
                <div className="w-12 h-12 rounded-xl bg-[#009845] text-white font-bold text-lg flex items-center justify-center shrink-0 shadow-xs select-none">
                  {selectedBid.bidderName.charAt(0).toUpperCase()}
                </div>
                <div>
                  <h3 className="text-base font-bold text-gray-900 leading-tight">
                    {selectedBid.bidderName}
                  </h3>
                  <span className="inline-block mt-1 px-3 py-0.5 rounded-full text-[11px] font-medium text-[#009845] border border-[#009845]/40 bg-emerald-50/40">
                    {selectedBid.status}
                  </span>
                </div>
              </div>
              <span className="text-xs text-[#8F9CA9] font-normal">
                {selectedBid.auctionId}
              </span>
            </div>

            {/* Key-Values List with hairline dividers */}
            <div className="text-[13px]">
              <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                <span className="text-[#8F9CA9] font-normal">Bid Amount</span>
                <span className="font-bold text-sm text-[#009845] text-right">
                  PKR {selectedBid.bidAmount.toLocaleString()}
                </span>
              </div>
              <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                <span className="text-[#8F9CA9] font-normal">Equipment</span>
                <span className="font-bold text-gray-900 text-right">{selectedBid.equipment}</span>
              </div>
              <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                <span className="text-[#8F9CA9] font-normal">Phone</span>
                <span className="font-bold text-gray-900 text-right">{selectedBid.bidderPhone}</span>
              </div>
              {selectedBid.bidderEmail && (
                <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                  <span className="text-[#8F9CA9] font-normal">Email</span>
                  <span className="font-bold text-gray-900 text-right">{selectedBid.bidderEmail}</span>
                </div>
              )}
              {selectedBid.bidderCompany && (
                <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                  <span className="text-[#8F9CA9] font-normal">Company</span>
                  <span className="font-bold text-gray-900 text-right">{selectedBid.bidderCompany}</span>
                </div>
              )}
              <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                <span className="text-[#8F9CA9] font-normal">City</span>
                <span className="font-bold text-gray-900 text-right">{selectedBid.bidderCity}</span>
              </div>
              <div className="flex items-center justify-between py-3">
                <span className="text-[#8F9CA9] font-normal">Submitted Date</span>
                <span className="font-bold text-gray-900 text-right">{selectedBid.submittedDate}</span>
              </div>
            </div>

            {/* Quick Contact Options inside Details Modal */}
            <div className="pt-4 border-t border-gray-100 space-y-2">
              <p className="text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                Direct Contact Admin Actions
              </p>
              <div className="grid grid-cols-3 gap-2">
                {selectedBid.bidderPhone ? (
                  <a
                    href={`https://wa.me/${selectedBid.bidderPhone.replace(/[^0-9]/g, "")}?text=${encodeURIComponent(
                      `Hello ${selectedBid.bidderName}, I am contacting you from Solar Scrap regarding your bid of PKR ${selectedBid.bidAmount.toLocaleString()} on ${selectedBid.equipment} (${selectedBid.auctionId}).`
                    )}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="py-2 px-2.5 rounded-xl bg-emerald-50 hover:bg-emerald-100 text-[#009845] border border-emerald-200 text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors cursor-pointer"
                    title="WhatsApp"
                  >
                    <MessageSquare className="w-3.5 h-3.5 text-[#25D366]" />
                    <span>WhatsApp</span>
                  </a>
                ) : (
                  <button disabled className="py-2 px-2.5 rounded-xl bg-gray-100 text-gray-400 text-xs font-medium cursor-not-allowed">
                    WhatsApp N/A
                  </button>
                )}

                {selectedBid.bidderPhone ? (
                  <a
                    href={`tel:${selectedBid.bidderPhone}`}
                    className="py-2 px-2.5 rounded-xl bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors cursor-pointer"
                    title="Call"
                  >
                    <Phone className="w-3.5 h-3.5 text-gray-600" />
                    <span>Call</span>
                  </a>
                ) : (
                  <button disabled className="py-2 px-2.5 rounded-xl bg-gray-100 text-gray-400 text-xs font-medium cursor-not-allowed">
                    Call N/A
                  </button>
                )}

                {selectedBid.bidderEmail ? (
                  <a
                    href={`mailto:${selectedBid.bidderEmail}?subject=${encodeURIComponent(
                      `Regarding your bid on ${selectedBid.equipment} (${selectedBid.auctionId})`
                    )}`}
                    className="py-2 px-2.5 rounded-xl bg-blue-50 hover:bg-blue-100 text-blue-700 border border-blue-200 text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors cursor-pointer"
                    title="Email"
                  >
                    <Mail className="w-3.5 h-3.5 text-blue-600" />
                    <span>Email</span>
                  </a>
                ) : (
                  <button disabled className="py-2 px-2.5 rounded-xl bg-gray-100 text-gray-400 text-xs font-medium cursor-not-allowed">
                    Email N/A
                  </button>
                )}
              </div>
            </div>

            {/* Footer Buttons */}
            <div className="pt-4 flex items-center justify-between gap-3">
              <Link
                href={`/scrap-dealers?search=${encodeURIComponent(selectedBid.bidderName)}`}
                className="text-xs font-semibold text-[#009845] hover:underline flex items-center gap-1"
              >
                <span>View in Scrap Dealers</span>
                <ExternalLink className="w-3 h-3" />
              </Link>
              <button
                type="button"
                onClick={() => setIsDetailsOpen(false)}
                className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-xl text-xs font-semibold transition-all cursor-pointer"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Buyer Profile Modal */}
      {isProfileModalOpen && profileBuyer && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl sm:rounded-3xl max-w-[480px] w-full p-6 sm:p-7 shadow-2xl border border-gray-100">
            {/* Header */}
            <div className="flex items-center justify-between pb-3.5 border-b border-gray-100">
              <div className="flex items-center gap-2">
                <User className="w-4 h-4 text-[#009845]" />
                <h2 className="text-base font-bold text-gray-900">Buyer Profile</h2>
              </div>
              <button
                type="button"
                onClick={() => setIsProfileModalOpen(false)}
                className="w-7 h-7 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* Buyer Identity */}
            <div className="flex items-center justify-between py-4 border-b border-gray-100">
              <div className="flex items-center gap-3.5">
                <div className="w-12 h-12 rounded-xl bg-[#009845] text-white font-bold text-lg flex items-center justify-center shrink-0 shadow-xs select-none">
                  {profileBuyer.bidderName ? profileBuyer.bidderName.charAt(0).toUpperCase() : "B"}
                </div>
                <div>
                  <h3 className="text-base font-bold text-gray-900 leading-tight">
                    {profileBuyer.bidderName}
                  </h3>
                  <p className="text-xs text-gray-500 mt-0.5">
                    {profileBuyer.bidderCompany || "Verified Scrap Dealer / Buyer"}
                  </p>
                  <div className="flex items-center gap-1.5 mt-1.5">
                    <span className="px-2.5 py-0.5 rounded-full text-[10px] font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
                      Verified Buyer
                    </span>
                    <span className="px-2.5 py-0.5 rounded-full text-[10px] font-semibold bg-gray-100 text-gray-600 border border-gray-200">
                      {profileBuyer.bidderCity}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            {/* Direct Contact Actions Box */}
            <div className="my-4 p-4 rounded-2xl bg-[#EAF7EE]/60 border border-[#009845]/20 space-y-2.5">
              <p className="text-[11px] font-bold text-emerald-800 uppercase tracking-wider">
                Direct Contact Options
              </p>
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-2">
                {/* WhatsApp */}
                {profileBuyer.bidderPhone ? (
                  <a
                    href={`https://wa.me/${profileBuyer.bidderPhone.replace(/[^0-9]/g, "")}?text=${encodeURIComponent(
                      `Hello ${profileBuyer.bidderName}, I am contacting you from Solar Scrap regarding your bid of PKR ${profileBuyer.bidAmount.toLocaleString()} on ${profileBuyer.equipment} (${profileBuyer.auctionId}).`
                    )}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="py-2 px-3 rounded-xl bg-[#009845] hover:bg-[#008230] text-white text-xs font-semibold flex items-center justify-center gap-1.5 shadow-xs transition-colors cursor-pointer"
                  >
                    <MessageSquare className="w-3.5 h-3.5 text-white" />
                    <span>WhatsApp</span>
                  </a>
                ) : (
                  <button disabled className="py-2 px-3 rounded-xl bg-gray-200 text-gray-400 text-xs font-medium cursor-not-allowed">
                    WhatsApp N/A
                  </button>
                )}

                {/* Call */}
                {profileBuyer.bidderPhone ? (
                  <a
                    href={`tel:${profileBuyer.bidderPhone}`}
                    className="py-2 px-3 rounded-xl bg-white hover:bg-gray-50 text-gray-800 border border-gray-200 text-xs font-semibold flex items-center justify-center gap-1.5 shadow-xs transition-colors cursor-pointer"
                  >
                    <Phone className="w-3.5 h-3.5 text-gray-600" />
                    <span>Call</span>
                  </a>
                ) : (
                  <button disabled className="py-2 px-3 rounded-xl bg-gray-200 text-gray-400 text-xs font-medium cursor-not-allowed">
                    Phone N/A
                  </button>
                )}

                {/* Email */}
                {profileBuyer.bidderEmail ? (
                  <a
                    href={`mailto:${profileBuyer.bidderEmail}?subject=${encodeURIComponent(
                      `Regarding your bid on ${profileBuyer.equipment} (${profileBuyer.auctionId})`
                    )}`}
                    className="py-2 px-3 rounded-xl bg-white hover:bg-gray-50 text-blue-700 border border-blue-200 text-xs font-semibold flex items-center justify-center gap-1.5 shadow-xs transition-colors cursor-pointer"
                  >
                    <Mail className="w-3.5 h-3.5 text-blue-600" />
                    <span>Email</span>
                  </a>
                ) : (
                  <button disabled className="py-2 px-3 rounded-xl bg-gray-200 text-gray-400 text-xs font-medium cursor-not-allowed">
                    Email N/A
                  </button>
                )}
              </div>
            </div>

            {/* Profile Key Values */}
            <div className="text-xs space-y-2.5 border-b border-gray-100 pb-4">
              <div className="flex items-center justify-between text-gray-500">
                <span>Phone</span>
                {profileBuyer.bidderPhone ? (
                  <a href={`tel:${profileBuyer.bidderPhone}`} className="font-semibold text-gray-900 hover:text-[#009845] hover:underline">
                    {profileBuyer.bidderPhone}
                  </a>
                ) : (
                  <span className="text-gray-400">Not provided</span>
                )}
              </div>
              <div className="flex items-center justify-between text-gray-500">
                <span>Email</span>
                {profileBuyer.bidderEmail ? (
                  <a href={`mailto:${profileBuyer.bidderEmail}`} className="font-semibold text-gray-900 hover:text-[#009845] hover:underline">
                    {profileBuyer.bidderEmail}
                  </a>
                ) : (
                  <span className="text-gray-400">Not provided</span>
                )}
              </div>
              <div className="flex items-center justify-between text-gray-500">
                <span>Company</span>
                <span className="font-semibold text-gray-900">{profileBuyer.bidderCompany || "—"}</span>
              </div>
              <div className="flex items-center justify-between text-gray-500">
                <span>City</span>
                <span className="font-semibold text-gray-900">{profileBuyer.bidderCity}</span>
              </div>
              <div className="flex items-center justify-between text-gray-500">
                <span>Current Bid Placed</span>
                <span className="font-bold text-sm text-[#009845]">
                  PKR {profileBuyer.bidAmount.toLocaleString()}
                </span>
              </div>
              <div className="flex items-center justify-between text-gray-500">
                <span>Auction</span>
                <span className="font-mono font-semibold text-gray-900">{profileBuyer.auctionId}</span>
              </div>
            </div>

            {/* Footer Navigation */}
            <div className="pt-4 flex items-center justify-between gap-3">
              <Link
                href={`/scrap-dealers?search=${encodeURIComponent(profileBuyer.bidderName)}`}
                className="text-xs font-semibold text-[#009845] hover:underline flex items-center gap-1"
              >
                <span>Open in Scrap Dealers Directory</span>
                <ExternalLink className="w-3 h-3" />
              </Link>
              <button
                type="button"
                onClick={() => setIsProfileModalOpen(false)}
                className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-xl text-xs font-semibold transition-colors cursor-pointer"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Toast */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 z-50 bg-gray-900 text-white text-xs px-4 py-2.5 rounded-xl shadow-lg border border-gray-700 animate-fadeIn flex items-center gap-2">
          <Check className="w-4 h-4 text-emerald-400" />
          <span>{toastMessage}</span>
        </div>
      )}
    </div>
  );
}

export default function BidsPage() {
  return (
    <Suspense
      fallback={
        <div className="flex h-screen w-full items-center justify-center bg-[#F5F6FA] text-sm text-gray-500">
          Loading auction bids...
        </div>
      }
    >
      <BidsPageContent />
    </Suspense>
  );
}
