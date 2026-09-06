"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import {
  Search,
  Bell,
  Menu,
  X,
  MoreVertical,
  Eye,
  Edit3,
  DollarSign,
  Gavel,
  Trash2,
  MapPin,
  Mail,
  Phone,
  Building2,
  Calendar,
  Sparkles,
  Check,
  AlertTriangle,
  MessageSquare,
  FileText,
  Send,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";

interface SellerPost {
  id: string;
  postId: string;
  title: string;
  category: "Solar Panels" | "Inverters" | "Batteries" | "Transformers" | "Cables";
  qty: number;
  condition: "Good" | "Fair" | "Scrap";
  status: "New" | "Under Review" | "Price Offered" | "Negotiation" | "Auction" | "Closed";
  priceExpected: number;
  offeredPrice?: number;
  submittedDate: string;
  sellerName: string;
  sellerCompany: string;
  sellerEmail: string;
  sellerPhone: string;
  city: string;
  area: string;
  address: string;
  brandModel: string;
  estimatedWeight: string;
  disassemblyState: string;
  images: string[];
}

const initialPosts: SellerPost[] = [
  {
    id: "1",
    postId: "SP001",
    title: "Solar Panels",
    category: "Solar Panels",
    qty: 200,
    condition: "Good",
    status: "New",
    priceExpected: 4500000,
    offeredPrice: 4200000,
    submittedDate: "2024-12-07",
    sellerName: "Sana Malik",
    sellerCompany: "Voltex Energy",
    sellerEmail: "sana.malik@voltex.pk",
    sellerPhone: "+92 300 1234567",
    city: "Karachi",
    area: "SITE Area",
    address: "Plot 45, Industrial Zone, SITE Area Karachi",
    brandModel: "Longi Solar 400W Monocrystalline",
    estimatedWeight: "4,200 kg",
    disassemblyState: "Ready for pickup / packed",
    images: [
      "/images/sign-in-img.jpg",
      "/images/otp-screen-img.jpg",
      "/images/reset-password-img.jpg",
    ],
  },
  {
    id: "2",
    postId: "SP002",
    title: "Industrial Inverters",
    category: "Inverters",
    qty: 10,
    condition: "Good",
    status: "Under Review",
    priceExpected: 850000,
    offeredPrice: 800000,
    submittedDate: "2024-12-05",
    sellerName: "Raza Ahmed",
    sellerCompany: "SolarTec Pvt Ltd",
    sellerEmail: "raza@solartec.pk",
    sellerPhone: "+92 321 5551234",
    city: "Lahore",
    area: "Gulberg III",
    address: "Industrial Complex, Gulberg III Lahore",
    brandModel: "Huawei SUN2000 50KTL",
    estimatedWeight: "550 kg",
    disassemblyState: "Dismantled and stored",
    images: [
      "/images/verify-email-screen.jpg",
      "/images/sign-in-img.jpg",
      "/images/otp-screen-img.jpg",
    ],
  },
  {
    id: "3",
    postId: "SP003",
    title: "Lithium Battery Bank 48V",
    category: "Batteries",
    qty: 25,
    condition: "Fair",
    status: "Price Offered",
    priceExpected: 1200000,
    offeredPrice: 1100000,
    submittedDate: "2024-12-03",
    sellerName: "Tariq Mehmood",
    sellerCompany: "EcoPower Solutions",
    sellerEmail: "tariq@ecopower.pk",
    sellerPhone: "+92 333 4445555",
    city: "Islamabad",
    area: "I-9 Industrial",
    address: "Street 4, Sector I-9/2 Islamabad",
    brandModel: "Pylontech US3000C",
    estimatedWeight: "800 kg",
    disassemblyState: "Disconnected in warehouse",
    images: [
      "/images/otp-screen-img.jpg",
      "/images/reset-password-img.jpg",
      "/images/verify-email-screen.jpg",
    ],
  },
  {
    id: "4",
    postId: "SP004",
    title: "Commercial Solar Panels",
    category: "Solar Panels",
    qty: 150,
    condition: "Good",
    status: "Negotiation",
    priceExpected: 3200000,
    offeredPrice: 3000000,
    submittedDate: "2024-12-02",
    sellerName: "Zubair Khan",
    sellerCompany: "GreenTech Systems",
    sellerEmail: "zubair@greentech.pk",
    sellerPhone: "+92 345 7778888",
    city: "Faisalabad",
    area: "Small Industrial Estate",
    address: "Millat Road, Faisalabad",
    brandModel: "JA Solar 450W",
    estimatedWeight: "3,300 kg",
    disassemblyState: "Stacked safely",
    images: [
      "/images/sign-in-img.jpg",
      "/images/verify-email-screen.jpg",
    ],
  },
  {
    id: "5",
    postId: "SP005",
    title: "Step-Up Transformers",
    category: "Transformers",
    qty: 4,
    condition: "Scrap",
    status: "Auction",
    priceExpected: 950000,
    offeredPrice: 900000,
    submittedDate: "2024-11-28",
    sellerName: "Asim Qureshi",
    sellerCompany: "Indus Heavy Industries",
    sellerEmail: "asim@indusheavy.pk",
    sellerPhone: "+92 312 9990000",
    city: "Multan",
    area: "Industrial Area",
    address: "Khanewal Road, Multan",
    brandModel: "Pel 500kVA",
    estimatedWeight: "6,500 kg",
    disassemblyState: "Decommissioned on pad",
    images: [
      "/images/otp-screen-img.jpg",
    ],
  },
  {
    id: "6",
    postId: "SP006",
    title: "Heavy Copper Cables",
    category: "Cables",
    qty: 50,
    condition: "Good",
    status: "Closed",
    priceExpected: 450000,
    offeredPrice: 450000,
    submittedDate: "2024-11-20",
    sellerName: "Hamza Ali",
    sellerCompany: "Rawal Electric Works",
    sellerEmail: "hamza@rawalelectric.pk",
    sellerPhone: "+92 301 1122334",
    city: "Rawalpindi",
    area: "IJP Road",
    address: "Sector 1-A, Rawalpindi",
    brandModel: "Pakistan Cables 16mm",
    estimatedWeight: "900 kg",
    disassemblyState: "Coiled on wooden drums",
    images: [
      "/images/reset-password-img.jpg",
    ],
  },
];

export default function SellerPostsPage() {
  const [posts, setPosts] = useState<SellerPost[]>(initialPosts);
  const [activeFilter, setActiveFilter] = useState("New");
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  // Active Menu ID for 3-dots
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
      const menuHeight = 310;
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
  const [selectedPost, setSelectedPost] = useState<SellerPost | null>(null);
  const [isDetailsOpen, setIsDetailsOpen] = useState(false);
  const [isEditOpen, setIsEditOpen] = useState(false);
  const [isSharePriceOpen, setIsSharePriceOpen] = useState(false);
  const [isWhatsAppOpen, setIsWhatsAppOpen] = useState(false);
  const [isAuctionOpen, setIsAuctionOpen] = useState(false);
  const [isSendQuotationOpen, setIsSendQuotationOpen] = useState(false);
  const [isDeleteOpen, setIsDeleteOpen] = useState(false);

  // Forms edit state
  const [editFormData, setEditFormData] = useState<Partial<SellerPost>>({});
  const [offeredPriceInput, setOfferedPriceInput] = useState<number>(0);
  const [adminNotes, setAdminNotes] = useState("");
  const [auctionStartBid, setAuctionStartBid] = useState<number>(0);
  const [auctionDuration, setAuctionDuration] = useState("3 Days");

  // Quotation form state
  const [quotationAmount, setQuotationAmount] = useState<number>(0);
  const [quotationValidity, setQuotationValidity] = useState("7 Days");
  const [quotationTerms, setQuotationTerms] = useState("Payment upon inspection and vehicle weighing.");

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
    { name: "Facebook Leads", icon: "/icons/facebook-leads.svg", href: "/facebook-leads" },
    { name: "Quotation History", icon: "/icons/quotation-history.svg", href: "/quotation-history" },
    { name: "My Inventory", icon: "/icons/inventory.svg", href: "/my-inventory" },
    { name: "Notifications", icon: "/icons/notifications.svg", href: "/notifications" },
    { name: "Settings", icon: "/icons/setting.svg", href: "/settings" },
  ];

  const filterTabs = [
    { name: "New", count: posts.filter((p) => p.status === "New").length },
    { name: "Under Review", count: posts.filter((p) => p.status === "Under Review").length },
    { name: "Price Offered", count: posts.filter((p) => p.status === "Price Offered").length },
    { name: "Negotiation", count: posts.filter((p) => p.status === "Negotiation").length },
    { name: "Auction", count: posts.filter((p) => p.status === "Auction").length },
    { name: "Closed", count: posts.filter((p) => p.status === "Closed").length },
  ];

  // Filtering
  const filteredPosts = posts.filter((p) => {
    if (activeFilter && p.status !== activeFilter) return false;
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const match =
        p.title.toLowerCase().includes(q) ||
        p.sellerName.toLowerCase().includes(q) ||
        p.category.toLowerCase().includes(q) ||
        p.postId.toLowerCase().includes(q) ||
        p.city.toLowerCase().includes(q);
      if (!match) return false;
    }
    return true;
  });

  // Action Handlers
  const handleOpenDetails = (post: SellerPost) => {
    setSelectedPost(post);
    setIsDetailsOpen(true);
    setActionMenuOpenId(null);
  };

  const handleOpenSharePrice = (post: SellerPost) => {
    setSelectedPost(post);
    setOfferedPriceInput(post.offeredPrice || Math.round(post.priceExpected * 0.9));
    setAdminNotes("");
    setIsSharePriceOpen(true);
    setActionMenuOpenId(null);
  };

  const handleSaveSharePrice = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedPost) return;
    setPosts((prev) =>
      prev.map((p) =>
        p.id === selectedPost.id
          ? { ...p, offeredPrice: offeredPriceInput, status: "Price Offered" }
          : p
      )
    );
    setIsSharePriceOpen(false);
    showToast(`Price PKR ${offeredPriceInput.toLocaleString()} shared with ${selectedPost.sellerName}!`);
  };

  const handleOpenEdit = (post: SellerPost) => {
    setSelectedPost(post);
    setEditFormData({ ...post });
    setIsEditOpen(true);
    setActionMenuOpenId(null);
  };

  const handleSaveEdit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedPost) return;
    setPosts((prev) =>
      prev.map((p) => (p.id === selectedPost.id ? ({ ...p, ...editFormData } as SellerPost) : p))
    );
    setIsEditOpen(false);
    showToast("Post updated successfully!");
  };

  const handleWhatsAppNegotiate = (post: SellerPost) => {
    setSelectedPost(post);
    setIsWhatsAppOpen(true);
    setActionMenuOpenId(null);
  };

  const launchWhatsApp = (post: SellerPost) => {
    const cleanPhone = post.sellerPhone.replace(/[^0-9]/g, "");
    const msg = encodeURIComponent(
      `Hello ${post.sellerName}, I am contacting you from Solar Scrap regarding your post ${post.postId} (${post.title}, Qty: ${post.qty}). We would like to discuss and negotiate the scrap valuation.`
    );
    window.open(`https://wa.me/${cleanPhone}?text=${msg}`, "_blank");
    showToast(`Opening WhatsApp chat with ${post.sellerName}...`);
    setIsWhatsAppOpen(false);
  };

  const handleOpenAuction = (post: SellerPost) => {
    setSelectedPost(post);
    setAuctionStartBid(post.offeredPrice ? Math.round(post.offeredPrice * 0.85) : 3800000);
    setIsAuctionOpen(true);
    setActionMenuOpenId(null);
  };

  const handleSaveAuction = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedPost) return;
    setPosts((prev) =>
      prev.map((p) => (p.id === selectedPost.id ? { ...p, status: "Auction" } : p))
    );
    setIsAuctionOpen(false);
    showToast(`Auction created for ${selectedPost.title}!`);
  };

  const handleOpenSendQuotation = (post: SellerPost) => {
    setSelectedPost(post);
    setQuotationAmount(post.offeredPrice || post.priceExpected);
    setIsSendQuotationOpen(true);
    setActionMenuOpenId(null);
  };

  const handleSaveSendQuotation = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedPost) return;
    setPosts((prev) =>
      prev.map((p) => (p.id === selectedPost.id ? { ...p, status: "Price Offered" } : p))
    );
    setIsSendQuotationOpen(false);
    showToast(`Formal Quotation sent to ${selectedPost.sellerEmail}!`);
  };

  const handleOpenDelete = (post: SellerPost) => {
    setSelectedPost(post);
    setIsDeleteOpen(true);
    setActionMenuOpenId(null);
  };

  const handleConfirmDelete = () => {
    if (!selectedPost) return;
    setPosts((prev) => prev.filter((p) => p.id !== selectedPost.id));
    setIsDeleteOpen(false);
    showToast("Post deleted successfully.");
  };

  return (
    <div className="min-h-screen w-full bg-[#f8fafc] flex flex-col lg:flex-row">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Seller Posts"
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
              className="w-full pl-10 pr-4 py-2 text-xs sm:text-sm bg-gray-50/70 border border-gray-200/80 rounded-xl outline-none focus:bg-white focus:border-[#00873D] focus:ring-2 focus:ring-[#00873D]/15 transition-all text-gray-800 placeholder:text-gray-400"
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
        <main className="flex-1 p-5 sm:p-7 md:p-8 space-y-5 overflow-y-auto">
          
          {/* Header Title */}
          <div>
            <h1 className="text-xl sm:text-2xl font-bold text-gray-900 tracking-tight">
              Seller Posts
            </h1>
            <p className="text-xs text-gray-500 mt-1">
              Review and manage all scrap posts submitted by sellers.
            </p>
          </div>

          {/* Filter Tabs & Search Bar Container */}
          <div className="bg-white rounded-2xl border border-gray-200/80 shadow-xs p-3 sm:p-4">
            <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-3 pb-3 border-b border-gray-100">
              
              {/* Filter Tabs (New 1, Under Review 1, Price Offered 1, etc.) */}
              <div className="flex items-center gap-2 overflow-x-auto pb-1 lg:pb-0 scrollbar-none">
                {filterTabs.map((tab) => {
                  const isActive = activeFilter === tab.name;
                  return (
                    <button
                      key={tab.name}
                      type="button"
                      onClick={() => setActiveFilter(tab.name)}
                      className={`px-3 py-1.5 rounded-xl text-xs font-medium transition-all duration-150 cursor-pointer whitespace-nowrap flex items-center gap-2 ${
                        isActive
                          ? "bg-emerald-50/80 text-[#00873D] border border-[#00873D]/30 shadow-xs font-semibold"
                          : "text-gray-600 hover:text-gray-900 hover:bg-gray-100/70 border border-transparent"
                      }`}
                    >
                      <span>{tab.name}</span>
                      <span
                        className={`text-[10px] px-1.5 py-0.2 rounded-full font-bold ${
                          isActive
                            ? "bg-emerald-100 text-[#00873D]"
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
              <div className="relative w-full lg:w-[260px] shrink-0">
                <Search className="w-3.5 h-3.5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search posts..."
                  className="w-full pl-9 pr-3 py-1.5 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#00873D] focus:ring-1 focus:ring-[#00873D]/20 text-gray-800 placeholder:text-gray-400"
                />
              </div>

            </div>

            {/* Seller Posts Data Table */}
            <div className="overflow-x-auto pt-1">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="border-b border-gray-100 text-[11px] font-semibold text-gray-400 uppercase tracking-wider">
                    <th className="py-3 px-3">POST ID</th>
                    <th className="py-3 px-3">SELLER</th>
                    <th className="py-3 px-3">EQUIPMENT</th>
                    <th className="py-3 px-3">QTY</th>
                    <th className="py-3 px-3">CONDITION</th>
                    <th className="py-3 px-3">PRICE DEMAND</th>
                    <th className="py-3 px-3">SUBMITTED</th>
                    <th className="py-3 px-3">STATUS</th>
                    <th className="py-3 px-2 text-right"></th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100 text-xs">
                  {filteredPosts.map((post) => (
                    <tr key={post.id} className="hover:bg-gray-50/60 transition-colors">
                      {/* POST ID */}
                      <td className="py-3.5 px-3 text-[12px] text-gray-600 whitespace-nowrap">
                        {post.postId}
                      </td>

                      {/* SELLER */}
                      <td className="py-3.5 px-3 whitespace-nowrap">
                        <div>
                          <p className="font-bold text-gray-900 text-xs">
                            {post.sellerName}
                          </p>
                          <p className="text-[11px] text-gray-400 font-normal">
                            {post.city}
                          </p>
                        </div>
                      </td>

                      {/* EQUIPMENT */}
                      <td className="py-3.5 px-3 whitespace-nowrap">
                        <div className="flex items-center gap-1.5 text-gray-800 font-medium">
                          <span className="text-amber-500">☀️</span>
                          <span>{post.title}</span>
                        </div>
                      </td>

                      {/* QTY */}
                      <td className="py-3.5 px-3 text-gray-800 font-medium whitespace-nowrap">
                        {post.qty}
                      </td>

                      {/* CONDITION */}
                      <td className="py-3.5 px-3 whitespace-nowrap">
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-[11px] font-medium bg-[#EAF7EE] text-[#00873D] border border-[#00873D]/30">
                          {post.condition}
                        </span>
                      </td>

                      {/* PRICE DEMAND */}
                      <td className="py-3.5 px-3 font-bold text-gray-900 whitespace-nowrap">
                        PKR {post.priceExpected.toLocaleString()}
                      </td>

                      {/* SUBMITTED */}
                      <td className="py-3.5 px-3 text-gray-500 whitespace-nowrap font-mono text-[11px]">
                        {post.submittedDate}
                      </td>

                      {/* STATUS */}
                      <td className="py-3.5 px-3 whitespace-nowrap">
                        <span
                          className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-[11px] font-medium ${
                            post.status === "New"
                              ? "bg-blue-50 text-blue-600 border border-blue-200"
                              : post.status === "Under Review"
                              ? "bg-amber-50 text-amber-700 border border-amber-200"
                              : post.status === "Price Offered"
                              ? "bg-purple-50 text-purple-700 border border-purple-200"
                              : post.status === "Negotiation"
                              ? "bg-orange-50 text-orange-700 border border-orange-200"
                              : post.status === "Auction"
                              ? "bg-emerald-50 text-emerald-700 border border-emerald-200"
                              : "bg-gray-100 text-gray-700 border border-gray-200"
                          }`}
                        >
                          {post.status}
                        </span>
                      </td>

                      {/* Triple Dots Action Menu */}
                      <td className="py-3.5 px-2 text-right relative whitespace-nowrap">
                        <button
                          type="button"
                          onClick={(e) => toggleActionMenu(e, post.id)}
                          className="p-1 rounded-lg text-gray-400 hover:text-gray-700 hover:bg-gray-100 transition-colors cursor-pointer"
                          aria-label="Actions"
                        >
                          <MoreVertical className="w-4 h-4" />
                        </button>

                        {/* Dropdown Menu popping out over all containers */}
                        {actionMenuOpenId === post.id && menuPos && (
                          <>
                            {/* Backdrop to close on outside click */}
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
                              className="w-[185px] sm:w-[195px] bg-white rounded-2xl shadow-[0_12px_35px_-5px_rgba(0,0,0,0.18),0_4px_12px_-2px_rgba(0,0,0,0.08)] border border-gray-100 py-2.5 px-1 z-[999] text-left"
                            >
                              
                              {/* 1. View Details */}
                              <button
                                type="button"
                                onClick={() => handleOpenDetails(post)}
                                className="w-full px-3 py-1.5 text-[12.5px] text-gray-700 hover:bg-gray-50 flex items-center gap-2.5 rounded-lg transition-colors cursor-pointer"
                              >
                                <Eye className="w-4 h-4 text-gray-400 stroke-[1.75] shrink-0" />
                                <span>View Details</span>
                              </button>

                              {/* 2. Share Price */}
                              <button
                                type="button"
                                onClick={() => handleOpenSharePrice(post)}
                                className="w-full px-3 py-1.5 text-[12.5px] text-gray-700 hover:bg-gray-50 flex items-center gap-2.5 rounded-lg transition-colors cursor-pointer"
                              >
                                <DollarSign className="w-4 h-4 text-gray-400 stroke-[1.75] shrink-0" />
                                <span>Share Price</span>
                              </button>

                              {/* 3. Edit Post */}
                              <button
                                type="button"
                                onClick={() => handleOpenEdit(post)}
                                className="w-full px-3 py-1.5 text-[12.5px] text-gray-700 hover:bg-gray-50 flex items-center gap-2.5 rounded-lg transition-colors cursor-pointer"
                              >
                                <Edit3 className="w-4 h-4 text-gray-400 stroke-[1.75] shrink-0" />
                                <span>Edit Post</span>
                              </button>

                              {/* 4. WhatsApp Negotiate (2 lines) */}
                              <button
                                type="button"
                                onClick={() => handleWhatsAppNegotiate(post)}
                                className="w-full px-3 py-1.5 text-[12.5px] text-gray-700 hover:bg-gray-50 flex items-start gap-2.5 rounded-lg transition-colors cursor-pointer text-left"
                              >
                                <MessageSquare className="w-4 h-4 text-gray-400 stroke-[1.75] shrink-0 mt-0.5" />
                                <span className="leading-tight">
                                  WhatsApp<br />Negotiate
                                </span>
                              </button>

                              {/* 5. Convert to Auction (2 lines) */}
                              <button
                                type="button"
                                onClick={() => handleOpenAuction(post)}
                                className="w-full px-3 py-1.5 text-[12.5px] text-gray-700 hover:bg-gray-50 flex items-start gap-2.5 rounded-lg transition-colors cursor-pointer text-left"
                              >
                                <Gavel className="w-4 h-4 text-gray-400 stroke-[1.75] shrink-0 mt-0.5" />
                                <span className="leading-tight">
                                  Convert to<br />Auction
                                </span>
                              </button>

                              {/* 6. Send Quotation */}
                              <button
                                type="button"
                                onClick={() => handleOpenSendQuotation(post)}
                                className="w-full px-3 py-1.5 text-[12.5px] text-gray-700 hover:bg-gray-50 flex items-center gap-2.5 rounded-lg transition-colors cursor-pointer"
                              >
                                <FileText className="w-4 h-4 text-gray-400 stroke-[1.75] shrink-0" />
                                <span>Send Quotation</span>
                              </button>

                              {/* 7. Delete Post (in red) */}
                              <button
                                type="button"
                                onClick={() => handleOpenDelete(post)}
                                className="w-full px-3 py-1.5 text-[12.5px] text-red-500 hover:bg-red-50 flex items-center gap-2.5 rounded-lg transition-colors cursor-pointer font-medium"
                              >
                                <Trash2 className="w-4 h-4 text-red-500 stroke-[1.75] shrink-0" />
                                <span>Delete Post</span>
                              </button>

                            </div>
                          </>
                        )}
                      </td>
                    </tr>
                  ))}

                  {filteredPosts.length === 0 && (
                    <tr>
                      <td colSpan={9} className="py-8 text-center text-xs text-gray-400">
                        No posts found under status &ldquo;{activeFilter}&rdquo;.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>

          </div>

        </main>
      </div>

      {/* ===================== 1. POST DETAILS MODAL ===================== */}
      {isDetailsOpen && selectedPost && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl sm:rounded-3xl max-w-[560px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100 max-h-[92vh] overflow-y-auto">
            
            {/* Header */}
            <div className="flex items-start justify-between pb-3 border-b border-gray-100">
              <div>
                <span className="text-[11px] font-bold text-[#00873D] uppercase tracking-wider">
                  {selectedPost.category}
                </span>
                <h2 className="text-lg font-bold text-gray-900 leading-tight">
                  {selectedPost.title}
                </h2>
                <p className="text-xs text-gray-500 flex items-center gap-1 mt-0.5">
                  <MapPin className="w-3 h-3" />
                  <span>{selectedPost.city}, {selectedPost.area}</span>
                  <span>•</span>
                  <span className="font-mono">{selectedPost.postId}</span>
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

            {/* Expected Price Banner */}
            <div className="mt-4 p-4 bg-emerald-50/90 rounded-2xl border border-emerald-200/80 flex items-center justify-between">
              <div>
                <p className="text-[10px] font-bold text-emerald-800 uppercase tracking-wider">
                  PRICE DEMAND
                </p>
                <p className="text-2xl font-black text-[#00873D] leading-tight">
                  PKR {selectedPost.priceExpected.toLocaleString()}
                </p>
              </div>
              <div className="w-10 h-10 rounded-xl bg-white text-amber-500 flex items-center justify-center shadow-xs border border-emerald-100">
                <Sparkles className="w-5 h-5" />
              </div>
            </div>

            {/* Photos Thumbnails */}
            <div className="mt-4">
              <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                ATTACHED PHOTOS
              </p>
              <div className="grid grid-cols-3 gap-2">
                {selectedPost.images.map((img, idx) => (
                  <div key={idx} className="relative h-20 rounded-xl overflow-hidden border border-gray-200 shadow-xs">
                    <Image src={img} alt="Post image" fill className="object-cover" />
                  </div>
                ))}
              </div>
            </div>

            {/* Specification Grid */}
            <div className="space-y-3 mt-4 text-xs">
              <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider">
                ITEM SPECIFICATIONS
              </p>
              <div className="grid grid-cols-2 gap-2">
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                  <p className="text-[10px] text-gray-400">Category</p>
                  <p className="font-semibold text-gray-800">{selectedPost.category}</p>
                </div>
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                  <p className="text-[10px] text-gray-400">Condition</p>
                  <p className="font-semibold text-gray-800">{selectedPost.condition}</p>
                </div>
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                  <p className="text-[10px] text-gray-400">Brand / Model</p>
                  <p className="font-semibold text-gray-800">{selectedPost.brandModel}</p>
                </div>
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                  <p className="text-[10px] text-gray-400">Est. Weight</p>
                  <p className="font-semibold text-gray-800">{selectedPost.estimatedWeight}</p>
                </div>
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                  <p className="text-[10px] text-gray-400">Disassembly State</p>
                  <p className="font-semibold text-gray-800">{selectedPost.disassemblyState}</p>
                </div>
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                  <p className="text-[10px] text-gray-400">Quantity</p>
                  <p className="font-semibold text-gray-800">{selectedPost.qty} Units</p>
                </div>
              </div>
            </div>

            {/* Seller Info Card */}
            <div className="mt-4 p-3 bg-gray-50 rounded-2xl border border-gray-100 text-xs">
              <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">
                SELLER INFORMATION
              </p>
              <div className="flex flex-wrap items-center justify-between gap-2">
                <div>
                  <p className="font-bold text-gray-900">{selectedPost.sellerName}</p>
                  <p className="text-[11px] text-gray-500">{selectedPost.sellerCompany}</p>
                </div>
                <div className="text-right text-[11px] text-gray-600">
                  <p>{selectedPost.sellerEmail}</p>
                  <p className="font-mono">{selectedPost.sellerPhone}</p>
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 mt-5 pt-3 border-t border-gray-100">
              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleOpenSharePrice(selectedPost);
                }}
                className="py-2.5 px-3 bg-[#00873D] hover:bg-[#007534] text-white text-xs font-semibold rounded-xl transition-colors cursor-pointer flex items-center justify-center gap-1.5 shadow-xs"
              >
                <DollarSign className="w-3.5 h-3.5" />
                <span>Share Price</span>
              </button>

              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleWhatsAppNegotiate(selectedPost);
                }}
                className="py-2.5 px-3 bg-emerald-50 hover:bg-emerald-100 text-emerald-800 text-xs font-semibold rounded-xl transition-colors cursor-pointer flex items-center justify-center gap-1.5 border border-emerald-200"
              >
                <MessageSquare className="w-3.5 h-3.5" />
                <span>WhatsApp</span>
              </button>

              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleOpenAuction(selectedPost);
                }}
                className="py-2.5 px-3 bg-blue-50 hover:bg-blue-100 text-blue-700 text-xs font-semibold rounded-xl border border-blue-200 transition-colors cursor-pointer flex items-center justify-center gap-1.5"
              >
                <Gavel className="w-3.5 h-3.5" />
                <span>Convert to Auction</span>
              </button>
            </div>

          </div>
        </div>
      )}

      {/* ===================== 2. SHARE PRICE MODAL ===================== */}
      {isSharePriceOpen && selectedPost && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[420px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100">
            <div className="flex items-center justify-between pb-3 border-b border-gray-100">
              <h3 className="text-base font-bold text-gray-900 flex items-center gap-2">
                <DollarSign className="w-4 h-4 text-[#00873D]" />
                <span>Share Price Offer</span>
              </h3>
              <button
                type="button"
                onClick={() => setIsSharePriceOpen(false)}
                className="w-6 h-6 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>

            <form onSubmit={handleSaveSharePrice} className="space-y-3.5 mt-3 text-xs">
              <div className="p-3 bg-gray-50 rounded-xl border border-gray-100">
                <p className="font-bold text-gray-800">{selectedPost.title} ({selectedPost.postId})</p>
                <p className="text-gray-500 mt-0.5">Seller: {selectedPost.sellerName} • {selectedPost.sellerPhone}</p>
                <p className="text-gray-500 mt-1">
                  Demand Price: <span className="font-semibold text-gray-800">PKR {selectedPost.priceExpected.toLocaleString()}</span>
                </p>
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Offered Price to Seller (PKR)</label>
                <input
                  type="number"
                  value={offeredPriceInput}
                  onChange={(e) => setOfferedPriceInput(Number(e.target.value))}
                  required
                  className="w-full px-3.5 py-2.5 border border-gray-200 rounded-xl outline-none focus:border-[#00873D] focus:ring-1 focus:ring-[#00873D]/20 font-bold text-gray-900 text-sm"
                />
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Valuation Note / Justification (Optional)</label>
                <textarea
                  rows={2}
                  value={adminNotes}
                  onChange={(e) => setAdminNotes(e.target.value)}
                  placeholder="e.g. Valuation based on current scrap copper and silicon index..."
                  className="w-full px-3.5 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D] resize-none"
                />
              </div>

              <div className="flex items-center justify-between pt-2 border-t border-gray-100 gap-2">
                <button
                  type="button"
                  onClick={() => {
                    const cleanPhone = selectedPost.sellerPhone.replace(/[^0-9]/g, "");
                    const msg = encodeURIComponent(
                      `Hello ${selectedPost.sellerName}, Solar Scrap has evaluated your post ${selectedPost.postId} (${selectedPost.title}). Our offered valuation is PKR ${offeredPriceInput.toLocaleString()}.`
                    );
                    window.open(`https://wa.me/${cleanPhone}?text=${msg}`, "_blank");
                  }}
                  className="px-3 py-2 bg-emerald-50 text-emerald-800 hover:bg-emerald-100 rounded-xl font-medium flex items-center gap-1.5 transition-colors cursor-pointer"
                >
                  <MessageSquare className="w-3.5 h-3.5" />
                  <span>Share WhatsApp</span>
                </button>

                <div className="flex items-center gap-2">
                  <button
                    type="button"
                    onClick={() => setIsSharePriceOpen(false)}
                    className="px-3.5 py-2 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-xl cursor-pointer"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="px-4 py-2 bg-[#00873D] hover:bg-[#007534] text-white font-semibold rounded-xl shadow-xs cursor-pointer"
                  >
                    Save &amp; Offer
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ===================== 3. EDIT POST MODAL ===================== */}
      {isEditOpen && selectedPost && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[440px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between pb-3 border-b border-gray-100">
              <h2 className="text-base font-bold text-gray-900 flex items-center gap-2">
                <Edit3 className="w-4 h-4 text-[#00873D]" />
                <span>Edit Seller Post</span>
              </h2>
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
                <label className="block text-gray-700 font-semibold mb-1">Post Title / Equipment</label>
                <input
                  type="text"
                  value={editFormData.title || ""}
                  onChange={(e) => setEditFormData({ ...editFormData, title: e.target.value })}
                  required
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D]"
                />
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block text-gray-700 font-semibold mb-1">City</label>
                  <input
                    type="text"
                    value={editFormData.city || ""}
                    onChange={(e) => setEditFormData({ ...editFormData, city: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D]"
                  />
                </div>
                <div>
                  <label className="block text-gray-700 font-semibold mb-1">Condition</label>
                  <select
                    value={editFormData.condition || "Good"}
                    onChange={(e) => setEditFormData({ ...editFormData, condition: e.target.value as "Good" | "Fair" | "Scrap" })}
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D] bg-white"
                  >
                    <option value="Good">Good</option>
                    <option value="Fair">Fair</option>
                    <option value="Scrap">Scrap</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block text-gray-700 font-semibold mb-1">Quantity</label>
                  <input
                    type="number"
                    value={editFormData.qty || 0}
                    onChange={(e) => setEditFormData({ ...editFormData, qty: Number(e.target.value) })}
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D]"
                  />
                </div>
                <div>
                  <label className="block text-gray-700 font-semibold mb-1">Demand Price (PKR)</label>
                  <input
                    type="number"
                    value={editFormData.priceExpected || 0}
                    onChange={(e) =>
                      setEditFormData({ ...editFormData, priceExpected: Number(e.target.value) })
                    }
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D]"
                  />
                </div>
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
                  className="px-5 py-2 bg-[#00873D] hover:bg-[#007534] text-white font-semibold rounded-xl shadow-xs cursor-pointer"
                >
                  Save Changes
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ===================== 4. WHATSAPP NEGOTIATE MODAL ===================== */}
      {isWhatsAppOpen && selectedPost && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[420px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100">
            <div className="flex items-center justify-between pb-3 border-b border-gray-100">
              <h3 className="text-base font-bold text-gray-900 flex items-center gap-2">
                <MessageSquare className="w-4 h-4 text-emerald-600" />
                <span>WhatsApp Negotiate</span>
              </h3>
              <button
                type="button"
                onClick={() => setIsWhatsAppOpen(false)}
                className="w-6 h-6 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>

            <div className="mt-3 text-xs space-y-3">
              <p className="text-gray-600">
                Start a direct WhatsApp conversation with <span className="font-bold text-gray-900">{selectedPost.sellerName}</span> ({selectedPost.sellerPhone}) to negotiate price, terms, or pickup logistics.
              </p>

              <div className="p-3 bg-gray-50 rounded-xl border border-gray-200/80 font-mono text-[11px] text-gray-700 leading-relaxed">
                &ldquo;Hello {selectedPost.sellerName}, I am contacting you from Solar Scrap regarding your post {selectedPost.postId} ({selectedPost.title}, Qty: {selectedPost.qty}). We would like to discuss and negotiate the scrap valuation.&rdquo;
              </div>

              <div className="flex items-center justify-end gap-2 pt-3 border-t border-gray-100">
                <button
                  type="button"
                  onClick={() => setIsWhatsAppOpen(false)}
                  className="px-3.5 py-2 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-xl cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="button"
                  onClick={() => launchWhatsApp(selectedPost)}
                  className="px-4 py-2 bg-[#25D366] hover:bg-[#20bd5a] text-white font-bold rounded-xl flex items-center gap-1.5 shadow-md shadow-emerald-600/20 cursor-pointer"
                >
                  <MessageSquare className="w-4 h-4" />
                  <span>Open WhatsApp</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ===================== 5. CONVERT TO AUCTION MODAL ===================== */}
      {isAuctionOpen && selectedPost && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[390px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100">
            <div className="flex items-center justify-between pb-2 border-b border-gray-100">
              <h3 className="text-sm font-bold text-gray-900 flex items-center gap-1.5">
                <Gavel className="w-4 h-4 text-blue-600" />
                <span>Convert to Auction</span>
              </h3>
              <button
                type="button"
                onClick={() => setIsAuctionOpen(false)}
                className="w-6 h-6 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>

            <form onSubmit={handleSaveAuction} className="space-y-3 mt-3 text-xs">
              <div className="p-2.5 bg-blue-50/70 border border-blue-100 rounded-xl text-blue-900">
                <p className="font-bold">{selectedPost.title} ({selectedPost.postId})</p>
                <p className="text-[11px] text-blue-700">Category: {selectedPost.category} • Qty: {selectedPost.qty}</p>
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Starting Bid (PKR)</label>
                <input
                  type="number"
                  value={auctionStartBid}
                  onChange={(e) => setAuctionStartBid(Number(e.target.value))}
                  required
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D] font-bold text-gray-900"
                />
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Auction Duration</label>
                <select
                  value={auctionDuration}
                  onChange={(e) => setAuctionDuration(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D] bg-white font-medium"
                >
                  <option value="24 Hours">24 Hours (1 Day)</option>
                  <option value="48 Hours">48 Hours (2 Days)</option>
                  <option value="3 Days">3 Days (72 Hours)</option>
                  <option value="5 Days">5 Days</option>
                  <option value="7 Days">7 Days (1 Week)</option>
                </select>
              </div>

              <div className="flex items-center justify-end gap-2 pt-2 border-t border-gray-100">
                <button
                  type="button"
                  onClick={() => setIsAuctionOpen(false)}
                  className="px-3.5 py-1.5 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-lg cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-1.5 bg-[#00873D] hover:bg-[#007534] text-white font-semibold rounded-lg shadow-xs cursor-pointer"
                >
                  Publish Auction
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ===================== 6. SEND QUOTATION MODAL ===================== */}
      {isSendQuotationOpen && selectedPost && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[440px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100">
            <div className="flex items-center justify-between pb-2 border-b border-gray-100">
              <h3 className="text-sm font-bold text-gray-900 flex items-center gap-1.5">
                <FileText className="w-4 h-4 text-[#00873D]" />
                <span>Send Formal Quotation</span>
              </h3>
              <button
                type="button"
                onClick={() => setIsSendQuotationOpen(false)}
                className="w-6 h-6 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>

            <form onSubmit={handleSaveSendQuotation} className="space-y-3 mt-3 text-xs">
              <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-100">
                <p className="font-bold text-gray-800">{selectedPost.title} • {selectedPost.qty} Units</p>
                <p className="text-gray-500 mt-0.5">To: {selectedPost.sellerName} ({selectedPost.sellerEmail})</p>
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Quoted Purchase Price (PKR)</label>
                <input
                  type="number"
                  value={quotationAmount}
                  onChange={(e) => setQuotationAmount(Number(e.target.value))}
                  required
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D] font-bold text-gray-900"
                />
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Quotation Validity</label>
                <select
                  value={quotationValidity}
                  onChange={(e) => setQuotationValidity(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D] bg-white font-medium"
                >
                  <option value="3 Days">3 Days</option>
                  <option value="7 Days">7 Days</option>
                  <option value="14 Days">14 Days</option>
                  <option value="30 Days">30 Days</option>
                </select>
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Payment &amp; Pickup Terms</label>
                <textarea
                  rows={2}
                  value={quotationTerms}
                  onChange={(e) => setQuotationTerms(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#00873D] resize-none"
                />
              </div>

              <div className="flex items-center justify-end gap-2 pt-2 border-t border-gray-100">
                <button
                  type="button"
                  onClick={() => setIsSendQuotationOpen(false)}
                  className="px-3.5 py-1.5 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-lg cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-1.5 bg-[#00873D] hover:bg-[#007534] text-white font-semibold rounded-lg shadow-xs cursor-pointer flex items-center gap-1.5"
                >
                  <Send className="w-3.5 h-3.5" />
                  <span>Send Quotation</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ===================== 7. DELETE POST CONFIRMATION MODAL ===================== */}
      {isDeleteOpen && selectedPost && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[340px] w-full p-5 shadow-2xl border border-gray-100">
            <div className="flex items-center justify-between pb-2 border-b border-gray-100">
              <h3 className="text-sm font-bold text-gray-900 flex items-center gap-1.5 text-red-600">
                <AlertTriangle className="w-4 h-4" />
                <span>Delete Post?</span>
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
              Are you sure you want to delete <span className="font-semibold text-gray-800">{selectedPost.title}</span>? This action cannot be undone.
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
          <Check className="w-4 h-4 text-[#00873D]" />
          <span>{toastMessage}</span>
        </div>
      )}

    </div>
  );
}
