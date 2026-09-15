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
  Loader2,
  RefreshCw,
  CheckCircle,
  XCircle,
  Package,
  Layers,
  Zap,
  Scale,
  Tag,
  Award,
  User,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";
import { getSession, getAvatarUrl } from "@/lib/auth";
import { getAdminSellerPosts, updateAdminSellerPost } from "@/lib/admin-api";

const DEFAULT_POST_IMAGES = [
  "https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=600&q=80",
  "https://images.unsplash.com/photo-1508873696983-2df57046475a?auto=format&fit=crop&w=600&q=80",
  "https://images.unsplash.com/photo-1466611653911-95081537e5b7?auto=format&fit=crop&w=600&q=80",
];

interface SellerPost {
  id: string;
  postId: string;
  title: string;
  category: "Solar Panels" | "Inverters" | "Batteries" | "Transformers" | "Cables" | string;
  qty: number;
  condition: "Good" | "Fair" | "Scrap" | string;
  status: "New" | "Under Review" | "Price Offered" | "Negotiation" | "Auction" | "Closed" | string;
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
  wattsPerUnit?: string;
  manufacturer?: string;
  purchaseYear?: string;
  reasonForSale?: string;
}

export default function SellerPostsPage() {
  const [posts, setPosts] = useState<SellerPost[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [adminName, setAdminName] = useState("Admin Platform");
  const [adminPhotoUrl, setAdminPhotoUrl] = useState<string | null>(null);
  const [activeFilter, setActiveFilter] = useState("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const fetchPosts = async () => {
    setIsLoading(true);
    try {
      const data = await getAdminSellerPosts();
      const mapped: SellerPost[] = data.map((item) => {
        const backendUrl = process.env.NEXT_PUBLIC_BACKEND_URL || "";
        const images = (item.images || []).map((img) => {
          if (img.startsWith("http://") || img.startsWith("https://")) return img;
          if (img.startsWith("/")) return `${backendUrl}${img}`;
          return img;
        });

        const validImages = images.filter((img) => !img.includes("solar-panel.png") && !img.includes("solar-panels-preview.jpg"));
        const finalImages = validImages.length >= 3 ? validImages : DEFAULT_POST_IMAGES;

        return {
          id: item.id,
          postId: item.post_id || "SP001",
          title: item.title,
          category: item.category,
          qty: item.qty,
          condition: item.condition,
          status: item.status,
          priceExpected: item.price_expected,
          offeredPrice: item.offered_price || undefined,
          submittedDate: item.submitted_date,
          sellerName: item.seller_name,
          sellerCompany: item.seller_company,
          sellerEmail: item.seller_email,
          sellerPhone: item.seller_phone,
          city: item.city,
          area: item.area,
          address: item.address,
          brandModel: item.brand_model,
          estimatedWeight: item.estimated_weight,
          disassemblyState: item.disassembly_state,
          images: finalImages,
          wattsPerUnit: (item as any).watts_per_unit || "400W",
          manufacturer: (item as any).manufacturer || "Waaree Energies",
          purchaseYear: (item as any).purchase_year || "2019",
          reasonForSale: (item as any).reason_for_sale || "Project Decommission",
        };
      });
      setPosts(mapped);
    } catch (err: any) {
      console.error("Failed to load seller posts:", err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchPosts();
  }, []);

  useEffect(() => {
    const session = getSession();
    if (session?.user) {
      if (session.user.display_name) setAdminName(session.user.display_name);
      else if (session.user.email) setAdminName(session.user.email.split("@")[0]);
      if (session.user.profile_photo_url) setAdminPhotoUrl(session.user.profile_photo_url);
    }
  }, []);

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
    {
      name: "All",
      count: posts.length,
    },
    {
      name: "New",
      count: posts.filter((p) =>
        [
          "New",
          "Pending Approval",
          "pending",
          "created",
          "Price Offered",
          "price_offered",
          "offered",
          "Under Review",
          "in_review",
        ].includes(p.status)
      ).length,
    },
    {
      name: "Price Offered",
      count: posts.filter((p) => ["Price Offered", "price_offered", "offered"].includes(p.status)).length,
    },
    {
      name: "Under Review",
      count: posts.filter((p) => ["Under Review", "under_review", "in_review", "Review"].includes(p.status)).length,
    },
    {
      name: "Negotiation",
      count: posts.filter((p) => ["Negotiation", "negotiation", "in_negotiation"].includes(p.status)).length,
    },
    {
      name: "Auction",
      count: posts.filter((p) => ["Auction", "auction", "in_auction"].includes(p.status)).length,
    },
    {
      name: "Closed",
      count: posts.filter((p) => ["Closed", "closed", "Rejected", "rejected"].includes(p.status)).length,
    },
  ];

  // Filtering
  const filteredPosts = posts.filter((p) => {
    if (activeFilter === "All") {
      // Show all posts in the All tab
    } else if (activeFilter === "New") {
      if (
        ![
          "New",
          "Pending Approval",
          "pending",
          "created",
          "Price Offered",
          "price_offered",
          "offered",
          "Under Review",
          "in_review",
        ].includes(p.status)
      )
        return false;
    } else if (activeFilter === "Under Review") {
      if (!["Under Review", "under_review", "in_review", "Review"].includes(p.status)) return false;
    } else if (activeFilter === "Price Offered") {
      if (!["Price Offered", "price_offered", "offered"].includes(p.status)) return false;
    } else if (activeFilter === "Negotiation") {
      if (!["Negotiation", "negotiation", "in_negotiation"].includes(p.status)) return false;
    } else if (activeFilter === "Auction") {
      if (!["Auction", "auction", "in_auction"].includes(p.status)) return false;
    } else if (activeFilter === "Closed") {
      if (!["Closed", "closed", "Rejected", "rejected"].includes(p.status)) return false;
    } else if (activeFilter) {
      if (p.status !== activeFilter) return false;
    }

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
  const handleApprovePost = async (post: SellerPost) => {
    try {
      await updateAdminSellerPost(post.id, { status: "Approved" });
      setPosts((prev) =>
        prev.map((p) => (p.id === post.id ? { ...p, status: "Approved" } : p))
      );
      if (selectedPost && selectedPost.id === post.id) {
        setSelectedPost({ ...selectedPost, status: "Approved" });
      }
      showToast(`Post "${post.title}" has been approved and is now active on the marketplace!`);
    } catch (err: any) {
      showToast(`Error: ${err.message || "Failed to approve post"}`);
    } finally {
      setActionMenuOpenId(null);
    }
  };

  const handleRejectPost = async (post: SellerPost) => {
    try {
      await updateAdminSellerPost(post.id, { status: "Rejected" });
      setPosts((prev) =>
        prev.map((p) => (p.id === post.id ? { ...p, status: "Rejected" } : p))
      );
      if (selectedPost && selectedPost.id === post.id) {
        setSelectedPost({ ...selectedPost, status: "Rejected" });
      }
      showToast(`Post "${post.title}" has been rejected.`);
    } catch (err: any) {
      showToast(`Error: ${err.message || "Failed to reject post"}`);
    } finally {
      setActionMenuOpenId(null);
    }
  };

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

  const handleSaveSharePrice = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedPost) return;
    try {
      await updateAdminSellerPost(selectedPost.id, {
        status: "Price Offered",
        offered_price: offeredPriceInput,
        admin_notes: adminNotes,
      });
      setPosts((prev) =>
        prev.map((p) =>
          p.id === selectedPost.id
            ? { ...p, offeredPrice: offeredPriceInput, status: "Price Offered" }
            : p
        )
      );
      setIsSharePriceOpen(false);
      showToast(`Price PKR ${offeredPriceInput.toLocaleString()} shared with ${selectedPost.sellerName}! Notification sent to seller.`);
    } catch (err: any) {
      showToast(`Error: ${err.message || "Failed to update price offer"}`);
    }
  };

  const handleOpenEdit = (post: SellerPost) => {
    setSelectedPost(post);
    setEditFormData({ ...post });
    setIsEditOpen(true);
    setActionMenuOpenId(null);
  };

  const handleSaveEdit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedPost) return;
    try {
      await updateAdminSellerPost(selectedPost.id, {
        status: editFormData.status,
        offered_price: editFormData.offeredPrice,
        admin_notes: adminNotes,
      });
      setPosts((prev) =>
        prev.map((p) => (p.id === selectedPost.id ? ({ ...p, ...editFormData } as SellerPost) : p))
      );
      setIsEditOpen(false);
      showToast("Post updated successfully!");
    } catch (err: any) {
      showToast(`Error: ${err.message || "Failed to update post"}`);
    }
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

  const handleSaveAuction = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedPost) return;
    try {
      await updateAdminSellerPost(selectedPost.id, {
        status: "Auction",
        admin_notes: `Auction start bid: PKR ${auctionStartBid.toLocaleString()}, duration: ${auctionDuration}`,
      });

      const catIcons: Record<string, string> = {
        "Solar Panels": "☀️",
        "Inverters": "⚡",
        "Batteries": "🔋",
      };

      const newAuction = {
        id: `auc-${Date.now()}`,
        auctionId: `AUC${Math.floor(100 + Math.random() * 900)}`,
        title: selectedPost.title,
        icon: catIcons[selectedPost.category] || "☀️",
        category: selectedPost.category,
        categoryColor:
          selectedPost.category === "Solar Panels"
            ? "bg-blue-50 text-blue-700 border-blue-200"
            : selectedPost.category === "Inverters"
            ? "bg-amber-50 text-amber-700 border-amber-200"
            : selectedPost.category === "Batteries"
            ? "bg-emerald-50 text-emerald-700 border-emerald-200"
            : "bg-purple-50 text-purple-700 border-purple-200",
        qty: `${selectedPost.qty} Units`,
        sellerName: selectedPost.sellerName,
        sellerCompany: selectedPost.sellerCompany || "Solar Enterprise",
        sellerCity: selectedPost.city || "Karachi",
        startingPrice: auctionStartBid,
        priceDemand: selectedPost.priceExpected,
        startingBid: auctionStartBid,
        currentHighBid: 0,
        highestBidderName: "No Bids Yet",
        highestBidderCompany: "Awaiting Verified Dealers",
        highestBidderCity: "-",
        totalBids: 0,
        status: "Active" as const,
        createdAt: "Today, Just now",
        endsIn: auctionDuration,
        endDate: "10 Mar 2026",
        reservePrice: auctionStartBid,
        images: selectedPost.images && selectedPost.images.length > 0 ? selectedPost.images : ["/images/solar-panel.png"],
      };

      try {
        const stored = localStorage.getItem("solar_scrap_auctions");
        let list = [];
        if (stored) {
          try {
            list = JSON.parse(stored);
          } catch {}
        }
        list = [newAuction, ...list];
        localStorage.setItem("solar_scrap_auctions", JSON.stringify(list));
      } catch (errLocal) {
        console.error("Failed to store auction in localStorage:", errLocal);
      }

      setPosts((prev) =>
        prev.map((p) => (p.id === selectedPost.id ? { ...p, status: "Auction" } : p))
      );
      setIsAuctionOpen(false);
      showToast(`Auction created for ${selectedPost.title}! Live bidding enabled.`);
    } catch (err: any) {
      showToast(`Error: ${err.message || "Failed to convert to auction"}`);
    }
  };

  const handleOpenSendQuotation = (post: SellerPost) => {
    setSelectedPost(post);
    setQuotationAmount(post.offeredPrice || post.priceExpected);
    setIsSendQuotationOpen(true);
    setActionMenuOpenId(null);
  };

  const handleSaveSendQuotation = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedPost) return;
    try {
      await updateAdminSellerPost(selectedPost.id, {
        status: "Price Offered",
        offered_price: quotationAmount,
        admin_notes: `Formal quotation valid for ${quotationValidity}. Terms: ${quotationTerms}`,
      });

      const newQuotation = {
        id: `QT-2026-${Math.floor(100 + Math.random() * 900)}`,
        name: selectedPost.sellerName,
        avatarLetter: (selectedPost.sellerName || "U").charAt(0).toUpperCase(),
        company: selectedPost.sellerCompany || "Enterprise",
        email: selectedPost.sellerEmail,
        phone: selectedPost.sellerPhone || "+92 300 0000000",
        city: selectedPost.city || "Karachi",
        totalAmount: quotationAmount,
        status: "Pending" as const,
        date: "Today",
        itemsCount: selectedPost.qty,
        equipmentType: selectedPost.title,
      };

      try {
        const storedQ = localStorage.getItem("solar_scrap_quotations");
        let qList = [];
        if (storedQ) {
          try {
            qList = JSON.parse(storedQ);
          } catch {}
        }
        qList = [newQuotation, ...qList];
        localStorage.setItem("solar_scrap_quotations", JSON.stringify(qList));
      } catch (errLocal) {
        console.error("Failed to store quotation in localStorage:", errLocal);
      }

      setPosts((prev) =>
        prev.map((p) => (p.id === selectedPost.id ? { ...p, status: "Price Offered", offeredPrice: quotationAmount } : p))
      );
      setIsSendQuotationOpen(false);
      showToast(`Formal Quotation sent to ${selectedPost.sellerEmail}!`);
    } catch (err: any) {
      showToast(`Error: ${err.message || "Failed to send quotation"}`);
    }
  };

  const handleOpenDelete = (post: SellerPost) => {
    setSelectedPost(post);
    setIsDeleteOpen(true);
    setActionMenuOpenId(null);
  };

  const handleConfirmDelete = async () => {
    if (!selectedPost) return;
    try {
      await updateAdminSellerPost(selectedPost.id, { status: "Closed" });
      setPosts((prev) => prev.filter((p) => p.id !== selectedPost.id));
      setIsDeleteOpen(false);
      showToast("Post closed/archived successfully.");
    } catch (err: any) {
      showToast(`Error: ${err.message || "Failed to close post"}`);
    }
  };

  return (
    <div className="flex h-screen w-full bg-[#F5F6FA] overflow-hidden">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Seller Posts"
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
          <div className="bg-white rounded-2xl border border-gray-200/80 shadow-xs p-4 sm:p-6 pb-0 overflow-hidden">
            <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-3 pb-3 border-b border-gray-100">
              
              {/* Filter Tabs (New 1, Under Review 1, Price Offered 1, Negotiation 1, Auction 1, Closed 1) */}
              <div className="flex items-center gap-6 sm:gap-8 overflow-x-auto pb-0 scrollbar-none">
                {filterTabs.map((tab) => {
                  const isActive = activeFilter === tab.name;
                  return (
                    <button
                      key={tab.name}
                      type="button"
                      onClick={() => setActiveFilter(tab.name)}
                      className={`pb-3 text-xs transition-all duration-150 cursor-pointer whitespace-nowrap flex items-center gap-2 border-b-2 -mb-[13px] ${
                        isActive
                          ? "text-[#009845] border-[#009845] font-semibold"
                          : "text-gray-500 hover:text-gray-900 border-transparent font-medium"
                      }`}
                    >
                      <span>{tab.name}</span>
                      <span
                        className={`text-[10px] px-1.5 py-0.2 rounded-full font-medium ${
                          isActive
                            ? "bg-emerald-50 text-[#009845] border border-emerald-200"
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
                  className="w-full pl-9 pr-3.5 py-1.5 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-1 focus:ring-[#009845]/20 text-gray-800 placeholder:text-gray-400"
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
                  {isLoading && (
                    <tr>
                      <td colSpan={9} className="py-12 text-center text-xs text-gray-400">
                        <div className="flex items-center justify-center gap-2">
                          <Loader2 className="w-4 h-4 text-[#009845] animate-spin" />
                          <span>Loading live seller posts from database...</span>
                        </div>
                      </td>
                    </tr>
                  )}
                  {!isLoading && filteredPosts.map((post) => (
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
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-[11px] font-medium bg-[#EAF7EE] text-[#009845] border border-[#009845]/30">
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
                            ["New", "Pending", "Pending Approval", "pending", "created"].includes(post.status)
                              ? "bg-blue-50 text-blue-600 border border-blue-200"
                              : post.status === "Under Review"
                              ? "bg-amber-50 text-amber-700 border border-amber-200"
                              : ["Price Offered", "price_offered", "offered"].includes(post.status)
                              ? "bg-purple-50 text-purple-700 border border-purple-200 font-semibold"
                              : post.status === "Negotiation"
                              ? "bg-orange-50 text-orange-700 border border-orange-200"
                              : post.status === "Auction"
                              ? "bg-emerald-50 text-emerald-700 border border-emerald-200"
                              : post.status === "Approved"
                              ? "bg-emerald-50 text-emerald-700 border border-emerald-200"
                              : ["Rejected", "rejected"].includes(post.status)
                              ? "bg-red-50 text-red-600 border border-red-200"
                              : "bg-gray-100 text-gray-700 border border-gray-200"
                          }`}
                        >
                          {["Pending Approval", "pending", "created"].includes(post.status)
                            ? "New"
                            : ["Price Offered", "price_offered", "offered"].includes(post.status)
                            ? post.offeredPrice
                              ? `Offered: Rs ${post.offeredPrice.toLocaleString()}`
                              : "Price Offered"
                            : post.status}
                        </span>
                      </td>

                      {/* Triple Dots Action Menu & Quick To Auction Button */}
                      <td className="py-3.5 px-2 text-right relative whitespace-nowrap">
                        <div className="flex items-center justify-end gap-1.5">
                          <button
                            type="button"
                            onClick={() => handleOpenAuction(post)}
                            className="inline-flex items-center gap-1 px-2.5 py-1 text-[11px] font-semibold text-white bg-[#009845] hover:bg-[#008230] rounded-lg shadow-xs transition-colors cursor-pointer"
                            title="Make live on Auction List"
                          >
                            <Gavel className="w-3 h-3" />
                            <span>To Auction</span>
                          </button>

                          <button
                            type="button"
                            onClick={(e) => toggleActionMenu(e, post.id)}
                            className="p-1 rounded-lg text-gray-400 hover:text-gray-700 hover:bg-gray-100 transition-colors cursor-pointer"
                            aria-label="Actions"
                          >
                            <MoreVertical className="w-4 h-4" />
                          </button>
                        </div>

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

                              {/* 1b. Approve Post */}
                              <button
                                type="button"
                                onClick={() => handleApprovePost(post)}
                                className="w-full px-3 py-1.5 text-[12.5px] text-emerald-700 hover:bg-emerald-50 flex items-center gap-2.5 rounded-lg transition-colors cursor-pointer font-medium"
                              >
                                <CheckCircle className="w-4 h-4 text-emerald-600 stroke-[1.75] shrink-0" />
                                <span>Approve Post</span>
                              </button>

                              {/* 1c. Reject Post */}
                              <button
                                type="button"
                                onClick={() => handleRejectPost(post)}
                                className="w-full px-3 py-1.5 text-[12.5px] text-red-600 hover:bg-red-50 flex items-center gap-2.5 rounded-lg transition-colors cursor-pointer font-medium"
                              >
                                <XCircle className="w-4 h-4 text-red-500 stroke-[1.75] shrink-0" />
                                <span>Reject Post</span>
                              </button>

                              {/* 2. Share Price */}
                              <button
                                type="button"
                                onClick={() => handleOpenSharePrice(post)}
                                className="w-full px-3 py-1.5 text-[12.5px] text-gray-700 hover:bg-gray-50 flex items-center gap-2.5 rounded-lg transition-colors cursor-pointer"
                              >
                                <span className="w-4 h-4 text-[10px] font-bold text-gray-500 rounded bg-gray-100 flex items-center justify-center shrink-0">Rs</span>
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

                  {!isLoading && filteredPosts.length === 0 && (
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

      {/* ===================== 1. POST DETAILS MODAL (Exact 1:1 with Figma) ===================== */}
      {isDetailsOpen && selectedPost && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-[28px] max-w-[580px] w-full p-6 sm:p-7 shadow-2xl border border-gray-100 max-h-[92vh] overflow-y-auto">
            
            {/* Header */}
            <div className="flex items-start justify-between pb-1">
              <div>
                <span className="text-[11px] font-semibold text-gray-400 tracking-wider">
                  {selectedPost.postId || "SP001"}
                </span>
                <h2 className="text-base sm:text-lg font-bold text-gray-900 leading-tight mt-0.5">
                  {selectedPost.title}
                </h2>
                <div className="flex items-center gap-2 mt-2">
                  <span className="inline-flex items-center gap-1.5 px-3 py-0.5 rounded-full text-xs font-medium text-[#009845] border border-emerald-200 bg-emerald-50/70">
                    <span>☀️</span>
                    <span>{selectedPost.category || "Solar Panels"} • {selectedPost.condition || "Good Condition"}</span>
                  </span>
                  <span className="inline-flex items-center px-3 py-0.5 rounded-full text-xs font-medium text-blue-600 border border-blue-200 bg-blue-50/60">
                    {selectedPost.status || "New"}
                  </span>
                </div>
              </div>
              <button
                type="button"
                onClick={() => setIsDetailsOpen(false)}
                className="text-gray-400 hover:text-gray-600 transition-colors cursor-pointer p-1 -mr-1"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* Price Demand Banner */}
            <div className="mt-4 p-4 sm:p-4.5 bg-[#F0FDF4] rounded-2xl border border-emerald-100/90 flex items-center justify-between">
              <div>
                <p className="text-[11px] font-bold text-[#009845] tracking-wider uppercase">
                  PRICE DEMAND
                </p>
                <p className="text-2xl sm:text-[28px] font-black text-[#009845] leading-tight mt-0.5">
                  PKR {selectedPost.priceExpected.toLocaleString()}
                </p>
              </div>
              <div className="text-3xl sm:text-4xl select-none pr-1">
                ☀️
              </div>
            </div>

            {/* Photos Thumbnails */}
            <div className="mt-5">
              <p className="text-[11px] font-bold text-gray-400 uppercase tracking-wider mb-2.5">
                IMAGES ({selectedPost.images.length || 3})
              </p>
              <div className="grid grid-cols-3 gap-2.5 sm:gap-3">
                {(selectedPost.images.length >= 3 ? selectedPost.images : DEFAULT_POST_IMAGES).slice(0, 3).map((img, idx) => (
                  <div key={idx} className="relative h-24 sm:h-28 rounded-2xl overflow-hidden border border-gray-100 shadow-2xs">
                    <Image src={img} alt="Post image" fill unoptimized className="object-cover" />
                  </div>
                ))}
              </div>
            </div>

            {/* Equipment Details Grid */}
            <div className="mt-5">
              <p className="text-[11px] font-bold text-gray-400 uppercase tracking-wider mb-2.5">
                EQUIPMENT DETAILS
              </p>
              <div className="grid grid-cols-2 gap-2.5 sm:gap-3 text-xs">
                {/* 1. Category */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <Package className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div>
                    <p className="text-[11px] text-gray-400 font-normal">Category</p>
                    <p className="font-bold text-gray-900 mt-0.5">{selectedPost.category || "Solar Panels"}</p>
                  </div>
                </div>

                {/* 2. Quantity */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <Layers className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div>
                    <p className="text-[11px] text-gray-400 font-normal">Quantity</p>
                    <p className="font-bold text-gray-900 mt-0.5">{selectedPost.qty} units</p>
                  </div>
                </div>

                {/* 3. Watts per Unit */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <Zap className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div>
                    <p className="text-[11px] text-gray-400 font-normal">Watts per Unit</p>
                    <p className="font-bold text-gray-900 mt-0.5">{selectedPost.wattsPerUnit || "400W"}</p>
                  </div>
                </div>

                {/* 4. Manufacturer */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <Building2 className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div>
                    <p className="text-[11px] text-gray-400 font-normal">Manufacturer</p>
                    <p className="font-bold text-gray-900 mt-0.5">{selectedPost.manufacturer || "Waaree Energies"}</p>
                  </div>
                </div>

                {/* 5. Purchase Year */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <Calendar className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div>
                    <p className="text-[11px] text-gray-400 font-normal">Purchase Year</p>
                    <p className="font-bold text-gray-900 mt-0.5">{selectedPost.purchaseYear || "2019"}</p>
                  </div>
                </div>

                {/* 6. Weight */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <Scale className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div>
                    <p className="text-[11px] text-gray-400 font-normal">Weight</p>
                    <p className="font-bold text-gray-900 mt-0.5">{selectedPost.estimatedWeight || "~2,400 kg"}</p>
                  </div>
                </div>

                {/* 7. Reason for Sale */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <Tag className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div>
                    <p className="text-[11px] text-gray-400 font-normal">Reason for Sale</p>
                    <p className="font-bold text-gray-900 mt-0.5">{selectedPost.reasonForSale || "Project Decommission"}</p>
                  </div>
                </div>

                {/* 8. Condition */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <Award className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div>
                    <p className="text-[11px] text-gray-400 font-normal">Condition</p>
                    <p className="font-bold text-gray-900 mt-0.5">{selectedPost.condition || "Good"}</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Pickup Location Card */}
            <div className="mt-5">
              <p className="text-[11px] font-bold text-gray-400 uppercase tracking-wider mb-2.5">
                PICKUP LOCATION
              </p>
              <div className="p-3.5 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-3">
                <MapPin className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                <div>
                  <p className="text-[13px] font-bold text-gray-900">
                    {selectedPost.city}, {selectedPost.area || "PECHS"}
                  </p>
                  <p className="text-[11px] text-gray-500 mt-0.5">
                    {selectedPost.address || `Plot 45, ${selectedPost.area || "PECHS Block 2"}, ${selectedPost.city}`}
                  </p>
                </div>
              </div>
            </div>

            {/* Contact Information Cards */}
            <div className="mt-5">
              <p className="text-[11px] font-bold text-gray-400 uppercase tracking-wider mb-2.5">
                CONTACT INFORMATION
              </p>
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-2.5 text-xs">
                {/* Seller */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <User className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div>
                    <p className="text-[11px] text-gray-400 font-normal">Seller</p>
                    <p className="font-bold text-gray-900 mt-0.5">{selectedPost.sellerName}</p>
                  </div>
                </div>

                {/* Phone */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <Phone className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div>
                    <p className="text-[11px] text-gray-400 font-normal">Phone</p>
                    <p className="font-bold text-gray-900 mt-0.5">{selectedPost.sellerPhone}</p>
                  </div>
                </div>

                {/* Email */}
                <div className="p-3 bg-gray-50/80 rounded-2xl border border-gray-100/80 flex items-start gap-2.5">
                  <Mail className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
                  <div className="min-w-0">
                    <p className="text-[11px] text-gray-400 font-normal">Email</p>
                    <p className="font-bold text-gray-900 mt-0.5 truncate">{selectedPost.sellerEmail || `${selectedPost.sellerName.toLowerCase().replace(/\s+/g, '')}@voltex.pk`}</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Action Buttons (Exact 3 Figma buttons, equal width and narrow height) */}
            <div className="pt-5 mt-2 grid grid-cols-3 gap-2.5">
              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleOpenEdit(selectedPost);
                }}
                className="w-full h-9 px-2 bg-[#009845] hover:bg-[#00823b] text-white rounded-xl text-xs font-semibold transition-all cursor-pointer flex items-center justify-center whitespace-nowrap shadow-xs"
              >
                Edit Post
              </button>

              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleOpenSendQuotation(selectedPost);
                }}
                className="w-full h-9 px-2 bg-white hover:bg-emerald-50/40 text-[#009845] border border-gray-200 rounded-xl text-xs font-semibold transition-all cursor-pointer flex items-center justify-center whitespace-nowrap"
              >
                Send Quotation
              </button>

              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleOpenAuction(selectedPost);
                }}
                className="w-full h-9 px-2 bg-white hover:bg-purple-50/40 text-[#6366F1] border border-indigo-200 rounded-xl text-xs font-semibold transition-all cursor-pointer flex items-center justify-center whitespace-nowrap"
              >
                Convert to Auction
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
                <span className="w-6 h-6 rounded-lg bg-emerald-50 text-[#009845] font-black text-xs flex items-center justify-center border border-[#009845]/20 shadow-2xs">Rs</span>
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
                  Demand Price: <span className="font-semibold text-gray-800">Rs. {selectedPost.priceExpected.toLocaleString()}</span>
                </p>
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Offered Price to Seller (Rs)</label>
                <input
                  type="number"
                  value={offeredPriceInput}
                  onChange={(e) => setOfferedPriceInput(Number(e.target.value))}
                  required
                  className="w-full px-3.5 py-2.5 border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-1 focus:ring-[#009845]/20 font-bold text-gray-900 text-sm"
                />
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Valuation Note / Justification (Optional)</label>
                <textarea
                  rows={2}
                  value={adminNotes}
                  onChange={(e) => setAdminNotes(e.target.value)}
                  placeholder="e.g. Valuation based on current scrap copper and silicon index..."
                  className="w-full px-3.5 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845] resize-none"
                />
              </div>

              <div className="flex items-center justify-between pt-2 border-t border-gray-100 gap-2">
                <button
                  type="button"
                  onClick={() => {
                    const cleanPhone = selectedPost.sellerPhone.replace(/[^0-9]/g, "");
                    const msg = encodeURIComponent(
                      `Hello ${selectedPost.sellerName}, Solar Scrap has evaluated your post ${selectedPost.postId} (${selectedPost.title}). Our offered valuation is Rs. ${offeredPriceInput.toLocaleString()}.`
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
                    className="px-4 py-2 bg-[#009845] hover:bg-[#008230] text-white font-semibold rounded-xl shadow-xs cursor-pointer"
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
                <Edit3 className="w-4 h-4 text-[#009845]" />
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
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845]"
                />
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block text-gray-700 font-semibold mb-1">City</label>
                  <input
                    type="text"
                    value={editFormData.city || ""}
                    onChange={(e) => setEditFormData({ ...editFormData, city: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845]"
                  />
                </div>
                <div>
                  <label className="block text-gray-700 font-semibold mb-1">Condition</label>
                  <select
                    value={editFormData.condition || "Good"}
                    onChange={(e) => setEditFormData({ ...editFormData, condition: e.target.value as "Good" | "Fair" | "Scrap" })}
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845] bg-white"
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
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845]"
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
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845]"
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
                  className="px-5 py-2 bg-[#009845] hover:bg-[#008230] text-white font-semibold rounded-xl shadow-xs cursor-pointer"
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
                <label className="block text-gray-700 font-semibold mb-1">Starting Bid (Rs)</label>
                <input
                  type="number"
                  value={auctionStartBid}
                  onChange={(e) => setAuctionStartBid(Number(e.target.value))}
                  required
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845] font-bold text-gray-900"
                />
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Auction Duration</label>
                <select
                  value={auctionDuration}
                  onChange={(e) => setAuctionDuration(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845] bg-white font-medium"
                >
                  <option value="24 Hours">24 Hours (1 Day)</option>
                  <option value="48 Hours">48 Hours (2 Days)</option>
                  <option value="3 Days">3 Days (72 Hours)</option>
                  <option value="5 Days">5 Days</option>
                  <option value="7 Days">7 Days (1 Week)</option>
                </select>
              </div>

              <div className="flex flex-col sm:flex-row items-center justify-between gap-3 pt-2 border-t border-gray-100">
                <Link
                  href={`/auctions/create?category=${encodeURIComponent(selectedPost.category)}&seller=${encodeURIComponent(selectedPost.sellerName)}&city=${encodeURIComponent(selectedPost.city)}&title=${encodeURIComponent(selectedPost.title)}&basePrice=${auctionStartBid}`}
                  className="text-xs text-blue-600 hover:text-blue-700 font-semibold hover:underline flex items-center gap-1"
                >
                  <Gavel className="w-3.5 h-3.5" />
                  <span>Open Full Auction Studio &rarr;</span>
                </Link>

                <div className="flex items-center gap-2 w-full sm:w-auto justify-end">
                  <button
                    type="button"
                    onClick={() => setIsAuctionOpen(false)}
                    className="px-3.5 py-1.5 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-lg cursor-pointer"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="px-4 py-1.5 bg-[#009845] hover:bg-[#008230] text-white font-semibold rounded-lg shadow-xs cursor-pointer"
                  >
                    Publish Auction
                  </button>
                </div>
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
                <FileText className="w-4 h-4 text-[#009845]" />
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
                <label className="block text-gray-700 font-semibold mb-1">Quoted Purchase Price (Rs)</label>
                <input
                  type="number"
                  value={quotationAmount}
                  onChange={(e) => setQuotationAmount(Number(e.target.value))}
                  required
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845] font-bold text-gray-900"
                />
              </div>

              <div>
                <label className="block text-gray-700 font-semibold mb-1">Quotation Validity</label>
                <select
                  value={quotationValidity}
                  onChange={(e) => setQuotationValidity(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845] bg-white font-medium"
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
                  className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845] resize-none"
                />
              </div>

              <div className="flex flex-col sm:flex-row items-center justify-between gap-3 pt-2 border-t border-gray-100">
                <Link
                  href={`/quotation-history/create?name=${encodeURIComponent(selectedPost.sellerName)}&phone=${encodeURIComponent(selectedPost.sellerPhone)}&city=${encodeURIComponent(selectedPost.city)}&area=${encodeURIComponent(selectedPost.area)}`}
                  className="text-xs text-[#009845] hover:text-[#008230] font-semibold hover:underline flex items-center gap-1"
                >
                  <FileText className="w-3.5 h-3.5" />
                  <span>Open Invoice Generator &rarr;</span>
                </Link>

                <div className="flex items-center gap-2 w-full sm:w-auto justify-end">
                  <button
                    type="button"
                    onClick={() => setIsSendQuotationOpen(false)}
                    className="px-3.5 py-1.5 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-lg cursor-pointer"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="px-4 py-1.5 bg-[#009845] hover:bg-[#008230] text-white font-semibold rounded-lg shadow-xs cursor-pointer flex items-center gap-1.5"
                  >
                    <Send className="w-3.5 h-3.5" />
                    <span>Send Quotation</span>
                  </button>
                </div>
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
          <Check className="w-4 h-4 text-[#009845]" />
          <span>{toastMessage}</span>
        </div>
      )}

    </div>
  );
}
