"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import {
  Search,
  Bell,
  Sun,
  Menu,
  X,
  MoreVertical,
  Eye,
  Phone,
  MessageCircle,
  MessageSquare,
  FileText,
  RefreshCw,
  Trash2,
  MapPin,
  Mail,
  Calendar,
  CheckCircle2,
  Check,
  Share2,
  User,
  Sparkles,
  AlertTriangle,
  Clock,
  Gavel,
  Receipt,
  Filter,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";
import DoubleScrollContainer from "@/components/DoubleScrollContainer";
import { getAdminLeads, updateAdminLead, createAdminLead } from "@/lib/admin-api";
import { getSession, getAvatarUrl } from "@/lib/auth";

interface FacebookLead {
  id: string;
  leadId: string;
  name: string;
  phone: string;
  email: string;
  city: string;
  area: string;
  receivedDate: string;
  status: "New" | "Contacted" | "Follow-up" | "Converted";
  notes?: string[];
  source: string;
}

export default function FacebookLeadsPage() {
  const router = useRouter();
  const [leads, setLeads] = useState<FacebookLead[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSimulating, setIsSimulating] = useState(false);
  const [adminName, setAdminName] = useState("Admin Platform");
  const [adminPhotoUrl, setAdminPhotoUrl] = useState<string | null>(null);
  const [activeFilter, setActiveFilter] = useState("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  // Actions menu state
  const [actionMenuOpenId, setActionMenuOpenId] = useState<string | null>(null);
  const [menuPos, setMenuPos] = useState<{ top?: number; bottom?: number; right: number } | null>(null);

  useEffect(() => {
    const session = getSession();
    if (session?.user) {
      if (session.user.display_name) setAdminName(session.user.display_name);
      else if (session.user.email) setAdminName(session.user.email.split("@")[0]);
      if (session.user.profile_photo_url) setAdminPhotoUrl(session.user.profile_photo_url);
    }

    loadLeads();
  }, []);

  const loadLeads = () => {
    setIsLoading(true);
    getAdminLeads()
      .then((data) => {
        if (data && data.length > 0) {
          setLeads(
            data.map((l) => ({
              id: l.id,
              leadId: l.lead_id,
              name: l.name,
              phone: l.phone,
              email: l.email,
              city: l.city,
              area: l.area,
              receivedDate: l.received_date,
              status: l.status as any,
              source: l.source,
              notes: l.notes,
            }))
          );
        } else {
          // Fallback seeded leads if emulator is empty (matches Figma screenshot 3)
          setLeads([
            {
              id: "lead_demo_01",
              leadId: "FB001",
              name: "Kamran Sheikh",
              phone: "+92 300 1112222",
              email: "kamran@gmail.com",
              city: "Karachi",
              area: "Clifton",
              receivedDate: "2024-12-07",
              status: "New",
              source: "Facebook Campaign",
              notes: ["Customer submitted inquiry for 120x solar panels."],
            },
            {
              id: "lead_demo_02",
              leadId: "FB002",
              name: "Fatima Zahra",
              phone: "+92 321 3334444",
              email: "fatima@yahoo.com",
              city: "Lahore",
              area: "Johar Town",
              receivedDate: "2024-12-07",
              status: "New",
              source: "Facebook Campaign",
              notes: ["Inverter 15kW + battery bank ready for inspection."],
            },
            {
              id: "lead_demo_03",
              leadId: "FB003",
              name: "Imran Siddiqui",
              phone: "+92 333 5556666",
              email: "imran@hotmail.com",
              city: "Islamabad",
              area: "G-11",
              receivedDate: "2024-12-07",
              status: "Contacted",
              source: "Facebook Campaign",
              notes: ["400x Mono PERC panels. Awaiting site visit confirmation."],
            },
            {
              id: "lead_demo_04",
              leadId: "FB004",
              name: "Zainab Hassan",
              phone: "+92 312 7778888",
              email: "zainab@gmail.com",
              city: "Karachi",
              area: "DHA",
              receivedDate: "2024-12-07",
              status: "Follow-up",
              source: "Facebook Campaign",
              notes: ["Heavy DC Copper Cables ~500kg."],
            },
            {
              id: "lead_demo_05",
              leadId: "FB005",
              name: "Ahmed Raza",
              phone: "+92 345 9990000",
              email: "ahmed@live.com",
              city: "Rawalpindi",
              area: "Bahria Town",
              receivedDate: "2024-12-07",
              status: "Converted",
              source: "Facebook Campaign",
              notes: ["Narada Lithium 48V Battery Bank scrap offer."],
            },
          ]);
        }
      })
      .catch((err) => {
        console.error("Error loading leads from API:", err);
      })
      .finally(() => setIsLoading(false));
  };

  const handleSimulateLead = async () => {
    setIsSimulating(true);
    const cities = ["Karachi", "Lahore", "Islamabad", "Rawalpindi", "Faisalabad", "Multan"];
    const names = [
      "Malik Usman",
      "Kashif Munir",
      "Shehroz Khan",
      "Dr. Arshad",
      "Imran Rafiq",
      "Chaudhry Naveed",
    ];
    const randomCity = cities[Math.floor(Math.random() * cities.length)];
    const randomName = names[Math.floor(Math.random() * names.length)];
    const randomPhone = `+92 3${Math.floor(10 + Math.random() * 39)} ${Math.floor(1000000 + Math.random() * 9000000)}`;
    const randomLeadNumber = Math.floor(10500 + Math.random() * 500);

    const newLeadPayload = {
      lead_id: `LEAD-${randomLeadNumber}`,
      name: randomName,
      phone: randomPhone,
      email: `${randomName.toLowerCase().replace(/\s+/g, ".")}@gmail.com`,
      city: randomCity,
      area: `${randomCity} Central Sector`,
      received_date: "Just now",
      status: "New" as const,
      source: `Meta Ad (Lead Campaign - ${randomCity})`,
      notes: [`Instant Form inquiry: 15kW Commercial solar scrap removal in ${randomCity}.`],
    };

    try {
      const created = await createAdminLead(newLeadPayload);
      const leadItem: FacebookLead = {
        id: created.id || `lead-${Date.now()}`,
        leadId: created.lead_id || newLeadPayload.lead_id,
        name: created.name || newLeadPayload.name,
        phone: created.phone || newLeadPayload.phone,
        email: created.email || newLeadPayload.email,
        city: created.city || newLeadPayload.city,
        area: created.area || newLeadPayload.area,
        receivedDate: "Just now",
        status: "New",
        source: created.source || newLeadPayload.source,
        notes: created.notes || newLeadPayload.notes,
      };
      setLeads((prev) => [leadItem, ...prev]);
      showToast(`⚡ New simulated Facebook lead from ${randomName} (${randomCity}) received!`);
    } catch (err) {
      console.warn("API create failed, adding locally:", err);
      const localLead: FacebookLead = {
        id: `local-${Date.now()}`,
        leadId: newLeadPayload.lead_id,
        name: newLeadPayload.name,
        phone: newLeadPayload.phone,
        email: newLeadPayload.email,
        city: newLeadPayload.city,
        area: newLeadPayload.area,
        receivedDate: "Just now",
        status: "New",
        source: newLeadPayload.source,
        notes: newLeadPayload.notes,
      };
      setLeads((prev) => [localLead, ...prev]);
      showToast(`⚡ Simulated Meta Lead created: ${randomName}!`);
    } finally {
      setIsSimulating(false);
    }
  };

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
      const menuHeight = 190;
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
  const [selectedLead, setSelectedLead] = useState<FacebookLead | null>(null);
  const [isDetailsOpen, setIsDetailsOpen] = useState(false);
  const [isUpdateStatusOpen, setIsUpdateStatusOpen] = useState(false);
  const [isAddNoteOpen, setIsAddNoteOpen] = useState(false);
  const [isDeleteOpen, setIsDeleteOpen] = useState(false);

  // Form states
  const [newStatusInput, setNewStatusInput] = useState<FacebookLead["status"]>("New");
  const [noteInput, setNoteInput] = useState("");
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

  const statMetrics = [
    {
      id: "All",
      label: "Total Leads",
      count: leads.length,
    },
    {
      id: "New",
      label: "New",
      count: leads.filter((l) => l.status === "New").length,
    },
    {
      id: "Contacted",
      label: "Contacted",
      count: leads.filter((l) => l.status === "Contacted").length,
    },
    {
      id: "Follow-up",
      label: "Follow-up",
      count: leads.filter((l) => l.status === "Follow-up").length,
    },
    {
      id: "Converted",
      label: "Converted",
      count: leads.filter((l) => l.status === "Converted").length,
    },
  ];

  const filteredLeads = leads.filter((lead) => {
    if (activeFilter !== "All" && lead.status !== activeFilter) return false;
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const match =
        lead.name.toLowerCase().includes(q) ||
        lead.email.toLowerCase().includes(q) ||
        lead.phone.toLowerCase().includes(q) ||
        lead.city.toLowerCase().includes(q) ||
        lead.area.toLowerCase().includes(q) ||
        lead.leadId.toLowerCase().includes(q);
      if (!match) return false;
    }
    return true;
  });

  // Modal actions
  const handleOpenDetails = (lead: FacebookLead) => {
    setSelectedLead(lead);
    setIsDetailsOpen(true);
    setActionMenuOpenId(null);
  };

  const handleOpenUpdateStatus = (lead: FacebookLead) => {
    setSelectedLead(lead);
    setNewStatusInput(lead.status);
    setIsUpdateStatusOpen(true);
    setActionMenuOpenId(null);
  };

  const handleSaveStatus = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedLead) return;
    const targetLead = selectedLead;
    setLeads((prev) =>
      prev.map((l) => (l.id === targetLead.id ? { ...l, status: newStatusInput } : l))
    );
    updateAdminLead(targetLead.id, { status: newStatusInput }).catch((err) =>
      console.warn("Backend update error:", err)
    );
    setIsUpdateStatusOpen(false);
    showToast(`Status updated to "${newStatusInput}" for ${targetLead.name}!`);
  };

  const handleOpenAddNote = (lead: FacebookLead) => {
    setSelectedLead(lead);
    setNoteInput("");
    setIsAddNoteOpen(true);
    setActionMenuOpenId(null);
  };

  const handleSaveNote = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedLead || !noteInput.trim()) return;
    const targetLead = selectedLead;
    const updatedNotes = [...(targetLead.notes || []), noteInput.trim()];
    setLeads((prev) =>
      prev.map((l) =>
        l.id === targetLead.id
          ? { ...l, notes: updatedNotes }
          : l
      )
    );
    updateAdminLead(targetLead.id, { note: noteInput.trim() }).catch((err) =>
      console.warn("Backend note error:", err)
    );
    setIsAddNoteOpen(false);
    showToast("Note added successfully!");
  };

  const handleConvertToQuotation = (lead: FacebookLead) => {
    const params = new URLSearchParams({
      name: lead.name,
      phone: lead.phone,
      email: lead.email,
      city: lead.city,
      area: lead.area,
    });
    router.push(`/quotation-history/create?${params.toString()}`);
  };

  const handleConvertToAuction = (lead: FacebookLead) => {
    const params = new URLSearchParams({
      seller: lead.name,
      city: lead.city,
      category: "Solar Panels",
    });
    router.push(`/auctions/create?${params.toString()}`);
  };

  const handleOpenDelete = (lead: FacebookLead) => {
    setSelectedLead(lead);
    setIsDeleteOpen(true);
    setActionMenuOpenId(null);
  };

  const handleConfirmDelete = () => {
    if (!selectedLead) return;
    setLeads((prev) => prev.filter((l) => l.id !== selectedLead.id));
    setIsDeleteOpen(false);
    showToast("Lead removed permanently.");
  };

  return (
    <div className="flex h-screen w-full bg-[#F5F6FA] overflow-hidden">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Facebook Leads"
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
              <Link
                href="/notifications"
                className="relative p-2 text-gray-500 hover:text-gray-800 hover:bg-gray-100 rounded-full transition-colors"
                aria-label="Notifications"
              >
                <Bell className="w-4.5 h-4.5" />
                <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white" />
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
          <main className="flex-1 p-5 sm:p-7 md:p-8 space-y-6 overflow-y-auto">
            
            {/* Header Title */}
            <div>
              <h1 className="text-xl sm:text-2xl font-bold text-gray-900 tracking-tight">
                Facebook Leads
              </h1>
              <p className="text-xs text-gray-500 mt-0.5">
                Track and follow up on leads received from Facebook campaigns.
              </p>
            </div>

            {/* 5 Stat Cards Row (Exact as media_1787855792122.png) */}
            <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3 sm:gap-4">
              {statMetrics.map((stat) => {
                const isCurrentActive = activeFilter === stat.id;
                return (
                  <button
                    key={stat.id}
                    type="button"
                    onClick={() => setActiveFilter(stat.id)}
                    className={`bg-white rounded-2xl p-5 border text-left transition-all cursor-pointer flex flex-col justify-between shadow-2xs hover:shadow-xs min-h-[95px] ${
                      isCurrentActive
                        ? "border-2 border-[#009845]"
                        : "border-gray-200/80 hover:border-gray-300"
                    }`}
                  >
                    <div>
                      <p
                        className={`text-3xl font-bold tracking-tight leading-none ${
                          isCurrentActive ? "text-[#009845]" : "text-gray-900"
                        }`}
                      >
                        {stat.count}
                      </p>
                      <p className="text-xs font-medium text-gray-500 mt-2">
                        {stat.label}
                      </p>
                    </div>

                    {isCurrentActive && (
                      <div className="w-6 h-0.5 bg-[#009845] mt-3 rounded-full" />
                    )}
                  </button>
                );
              })}
            </div>

            {/* Leads Data Table Card (Exact as media_1787855792122.png) */}
            <div className="bg-white rounded-2xl border border-gray-200/80 shadow-xs overflow-hidden">
              
              {/* Table Top Header: Count, City Filter & Search */}
              <div className="p-4 sm:p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-gray-100">
                <div className="flex items-center gap-3">
                  <span className="text-xs text-gray-500 font-medium">
                    {filteredLeads.length} leads
                  </span>
                </div>

                <div className="relative w-full sm:w-[260px]">
                  <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                  <input
                    type="text"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    placeholder="Search leads..."
                    className="w-full pl-9 pr-3.5 py-2 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-1 focus:ring-[#009845]/20 text-gray-800 placeholder:text-gray-400 shadow-2xs"
                  />
                </div>
              </div>

              {/* Table with Dual Synced Scrollbars */}
              <DoubleScrollContainer>
                <table className="w-full text-left border-collapse">
                  <thead>
                    <tr className="border-b border-gray-100 bg-gray-50/40 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                      <th className="py-3.5 px-4 sm:px-5">LEAD ID</th>
                      <th className="py-3.5 px-4">NAME</th>
                      <th className="py-3.5 px-4">PHONE</th>
                      <th className="py-3.5 px-4">EMAIL</th>
                      <th className="py-3.5 px-4">CITY</th>
                      <th className="py-3.5 px-4">AREA</th>
                      <th className="py-3.5 px-4">RECEIVED</th>
                      <th className="py-3.5 px-4">STATUS</th>
                      <th className="py-3.5 px-4 text-right"></th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100 text-xs">
                    {filteredLeads.map((lead) => (
                      <tr key={lead.id} className="hover:bg-gray-50/60 transition-colors">
                        {/* Lead ID */}
                        <td className="py-4 px-4 sm:px-5 font-semibold text-xs text-gray-500 whitespace-nowrap">
                          {lead.leadId}
                        </td>

                        {/* Name */}
                        <td className="py-4 px-4 whitespace-nowrap">
                          <span
                            className="font-bold text-gray-900 hover:text-[#009845] cursor-pointer text-xs"
                            onClick={() => handleOpenDetails(lead)}
                          >
                            {lead.name}
                          </span>
                        </td>

                        {/* Phone */}
                        <td className="py-4 px-4 text-gray-600 whitespace-nowrap text-xs">
                          {lead.phone}
                        </td>

                        {/* Email */}
                        <td className="py-4 px-4 text-gray-600 whitespace-nowrap text-xs">
                          {lead.email}
                        </td>

                        {/* City */}
                        <td className="py-4 px-4 text-gray-600 whitespace-nowrap text-xs">
                          {lead.city}
                        </td>

                        {/* Area */}
                        <td className="py-4 px-4 text-gray-600 whitespace-nowrap text-xs">
                          {lead.area}
                        </td>

                        {/* Received Date */}
                        <td className="py-4 px-4 text-gray-500 whitespace-nowrap text-xs">
                          {lead.receivedDate}
                        </td>

                        {/* Status */}
                        <td className="py-4 px-4 whitespace-nowrap">
                          <span
                            className={`inline-flex items-center px-3 py-0.5 rounded-full text-xs font-semibold ${
                              lead.status === "New"
                                ? "bg-blue-50 text-blue-600 border border-blue-200"
                                : lead.status === "Contacted"
                                ? "bg-cyan-50 text-cyan-700 border border-cyan-200"
                                : lead.status === "Follow-up"
                                ? "bg-orange-50 text-orange-600 border border-orange-200"
                                : "bg-emerald-50 text-emerald-700 border border-emerald-200"
                            }`}
                          >
                            {lead.status}
                          </span>
                        </td>

                        {/* Actions 3-dots */}
                        <td className="py-4 px-4 text-right relative whitespace-nowrap">
                          <button
                            type="button"
                            onClick={(e) => toggleActionMenu(e, lead.id)}
                            className="p-1 rounded-lg text-gray-400 hover:text-gray-700 hover:bg-gray-100 transition-colors cursor-pointer"
                            aria-label="Actions"
                          >
                            <MoreVertical className="w-4 h-4" />
                          </button>

                          {/* Floating Dropdown */}
                          {actionMenuOpenId === lead.id && menuPos && (
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
                                className="w-44 bg-white rounded-2xl shadow-[0_12px_35px_-5px_rgba(0,0,0,0.14),0_4px_12px_-2px_rgba(0,0,0,0.06)] border border-gray-100 py-2 z-[999] text-left animate-fadeIn"
                              >
                                <button
                                  type="button"
                                  onClick={() => handleOpenDetails(lead)}
                                  className="w-full px-4 py-2 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2.5 transition-colors cursor-pointer"
                                >
                                  <Eye className="w-3.5 h-3.5 text-gray-500" />
                                  <span>View Details</span>
                                </button>

                                <a
                                  href={lead.phone ? `tel:${lead.phone.replace(/\s+/g, "")}` : "#"}
                                  onClick={() => {
                                    setActionMenuOpenId(null);
                                    setMenuPos(null);
                                  }}
                                  className="w-full px-4 py-2 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2.5 transition-colors cursor-pointer"
                                >
                                  <Phone className="w-3.5 h-3.5 text-gray-500" />
                                  <span>Contact</span>
                                </a>

                                <a
                                  href={lead.phone ? `https://wa.me/${lead.phone.replace(/[^0-9]/g, "")}` : "#"}
                                  target="_blank"
                                  rel="noreferrer"
                                  onClick={() => {
                                    setActionMenuOpenId(null);
                                    setMenuPos(null);
                                  }}
                                  className="w-full px-4 py-2 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2.5 transition-colors cursor-pointer"
                                >
                                  <MessageSquare className="w-3.5 h-3.5 text-gray-500" />
                                  <span>WhatsApp</span>
                                </a>

                                <button
                                  type="button"
                                  onClick={() => handleOpenAddNote(lead)}
                                  className="w-full px-4 py-2 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2.5 transition-colors cursor-pointer"
                                >
                                  <FileText className="w-3.5 h-3.5 text-gray-500" />
                                  <span>Add Note</span>
                                </button>

                                <button
                                  type="button"
                                  onClick={() => handleOpenUpdateStatus(lead)}
                                  className="w-full px-4 py-2 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2.5 transition-colors cursor-pointer"
                                >
                                  <RefreshCw className="w-3.5 h-3.5 text-gray-500" />
                                  <span>Update Status</span>
                                </button>

                                <button
                                  type="button"
                                  onClick={() => handleOpenDelete(lead)}
                                  className="w-full px-4 py-2 text-xs text-red-500 hover:bg-red-50/50 flex items-center gap-2.5 transition-colors cursor-pointer"
                                >
                                  <Trash2 className="w-3.5 h-3.5 text-red-500" />
                                  <span>Delete Lead</span>
                                </button>
                              </div>
                            </>
                          )}
                        </td>
                      </tr>
                    ))}

                    {isLoading ? (
                      <tr>
                        <td colSpan={9} className="py-12 text-center text-xs text-gray-400">
                          <div className="flex items-center justify-center gap-2">
                            <span className="w-4 h-4 border-2 border-[#009845] border-t-transparent rounded-full animate-spin" />
                            <span>Loading leads...</span>
                          </div>
                        </td>
                      </tr>
                    ) : filteredLeads.length === 0 ? (
                      <tr>
                        <td colSpan={9} className="py-8 text-center text-xs text-gray-400">
                          No leads found matching your criteria.
                        </td>
                      </tr>
                    ) : null}
                  </tbody>
                </table>
              </DoubleScrollContainer>

              {/* Table Footer */}
              <div className="px-5 py-3 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
                <span>
                  Showing {filteredLeads.length} of {leads.length} leads
                </span>
                <div className="flex items-center gap-1">
                  <span className="w-6 h-6 rounded-md bg-[#009845] text-white flex items-center justify-center font-bold text-[11px]">
                    1
                  </span>
                </div>
              </div>
            </div>

          </main>

        </div>

      {/* ===================== 1. LEAD DETAILS MODAL (Exact 1:1 with Figma) ===================== */}
      {isDetailsOpen && selectedLead && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[580px] w-full p-6 sm:p-7 shadow-2xl border border-gray-100">
            {/* Modal Header */}
            <div className="flex items-center justify-between pb-3.5 border-b border-gray-100">
              <h2 className="text-base font-bold text-gray-900">Lead Details</h2>
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
                  {selectedLead.name.charAt(0).toUpperCase()}
                </div>
                <div>
                  <h3 className="text-base font-bold text-gray-900 leading-tight">
                    {selectedLead.name}
                  </h3>
                  <span
                    className={`inline-block mt-1 px-3 py-0.5 rounded-full text-[11px] font-medium ${
                      selectedLead.status === "New"
                        ? "text-blue-600 border border-blue-200 bg-blue-50/40"
                        : selectedLead.status === "Contacted"
                        ? "text-blue-600 border border-blue-200 bg-blue-50/40"
                        : selectedLead.status === "Follow-up"
                        ? "text-amber-600 border border-amber-200 bg-amber-50/40"
                        : "text-[#009845] border border-[#009845]/40 bg-emerald-50/40"
                    }`}
                  >
                    {selectedLead.status}
                  </span>
                </div>
              </div>
              <span className="text-xs text-[#8F9CA9] font-normal">
                {selectedLead.leadId}
              </span>
            </div>

            {/* Key-Values List with hairline dividers */}
            <div className="text-[13px]">
              <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                <span className="text-[#8F9CA9] font-normal">Phone</span>
                <span className="font-bold text-gray-900 text-right">{selectedLead.phone}</span>
              </div>
              <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                <span className="text-[#8F9CA9] font-normal">Email</span>
                <span className="font-bold text-gray-900 text-right">{selectedLead.email}</span>
              </div>
              <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                <span className="text-[#8F9CA9] font-normal">City</span>
                <span className="font-bold text-gray-900 text-right">{selectedLead.city}</span>
              </div>
              <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                <span className="text-[#8F9CA9] font-normal">Area</span>
                <span className="font-bold text-gray-900 text-right">{selectedLead.area}</span>
              </div>
              <div className="flex items-center justify-between py-3 border-b border-gray-100/80">
                <span className="text-[#8F9CA9] font-normal">Lead Source</span>
                <span className="font-bold text-gray-900 text-right">{selectedLead.source || "Facebook Campaign"}</span>
              </div>
              <div className="flex items-center justify-between py-3">
                <span className="text-[#8F9CA9] font-normal">Received Date</span>
                <span className="font-bold text-gray-900 text-right">{selectedLead.receivedDate || "2024-12-07"}</span>
              </div>
            </div>

            {/* Footer Buttons (Strictly equal width, height, symmetrical on single line) */}
            <div className="pt-6 grid grid-cols-3 gap-3">
              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleConvertToQuotation(selectedLead);
                }}
                className="w-full h-10 px-3 bg-[#009845] hover:bg-[#00823b] text-white rounded-xl text-xs font-semibold transition-all cursor-pointer flex items-center justify-center whitespace-nowrap shadow-xs"
              >
                Create Quotation
              </button>

              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleOpenUpdateStatus(selectedLead);
                }}
                className="w-full h-10 px-3 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-xl text-xs font-semibold transition-all cursor-pointer flex items-center justify-center whitespace-nowrap shadow-2xs"
              >
                Update Status
              </button>

              <button
                type="button"
                onClick={() => setIsDetailsOpen(false)}
                className="w-full h-10 px-3 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-xl text-xs font-semibold transition-all cursor-pointer flex items-center justify-center whitespace-nowrap shadow-2xs"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ===================== 2. UPDATE LEAD STATUS MODAL ===================== */}
      {isUpdateStatusOpen && selectedLead && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[360px] w-full p-5 shadow-2xl border border-gray-100">
            
            <div className="flex items-center justify-between pb-2 border-b border-gray-100">
              <h3 className="text-sm font-bold text-gray-900">Update Lead Status</h3>
              <button
                type="button"
                onClick={() => setIsUpdateStatusOpen(false)}
                className="w-6 h-6 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>

            <p className="text-xs text-gray-500 mt-2">
              Update status for <span className="font-semibold text-gray-800">{selectedLead.name}</span>:
            </p>

            <form onSubmit={handleSaveStatus} className="space-y-2 mt-3 text-xs">
              {(["New", "Contacted", "Follow-up", "Converted"] as const).map((st) => (
                <label
                  key={st}
                  className={`flex items-center justify-between p-2.5 rounded-xl border cursor-pointer transition-all ${
                    newStatusInput === st
                      ? "border-[#009845] bg-emerald-50/60 text-[#009845] font-bold"
                      : "border-gray-200 text-gray-700 hover:bg-gray-50"
                  }`}
                >
                  <span>{st}</span>
                  <input
                    type="radio"
                    name="status"
                    value={st}
                    checked={newStatusInput === st}
                    onChange={() => setNewStatusInput(st)}
                    className="accent-[#009845]"
                  />
                </label>
              ))}

              <div className="flex items-center justify-end gap-2 pt-3 border-t border-gray-100">
                <button
                  type="button"
                  onClick={() => setIsUpdateStatusOpen(false)}
                  className="px-3.5 py-1.5 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-lg cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-1.5 bg-[#009845] hover:bg-[#008230] text-white font-semibold rounded-lg shadow-xs cursor-pointer"
                >
                  Update
                </button>
              </div>
            </form>

          </div>
        </div>
      )}

      {/* ===================== 3. ADD NOTE MODAL ===================== */}
      {isAddNoteOpen && selectedLead && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[380px] w-full p-5 shadow-2xl border border-gray-100">
            
            <div className="flex items-center justify-between pb-2 border-b border-gray-100">
              <h3 className="text-sm font-bold text-gray-900">Add Note</h3>
              <button
                type="button"
                onClick={() => setIsAddNoteOpen(false)}
                className="w-6 h-6 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>

            <p className="text-xs text-gray-500 mt-2">
              Add internal remarks for <span className="font-semibold text-gray-800">{selectedLead.name}</span>:
            </p>

            <form onSubmit={handleSaveNote} className="space-y-3 mt-3 text-xs">
              <textarea
                rows={3}
                value={noteInput}
                onChange={(e) => setNoteInput(e.target.value)}
                placeholder="e.g. Spoke with customer, interested in scrap panels..."
                required
                className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009845] resize-none"
              />

              <div className="flex items-center justify-end gap-2 pt-2 border-t border-gray-100">
                <button
                  type="button"
                  onClick={() => setIsAddNoteOpen(false)}
                  className="px-3.5 py-1.5 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-lg cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-1.5 bg-[#009845] hover:bg-[#008230] text-white font-semibold rounded-lg shadow-xs cursor-pointer"
                >
                  Save Note
                </button>
              </div>
            </form>

          </div>
        </div>
      )}

      {/* ===================== 4. DELETE LEAD CONFIRMATION MODAL ===================== */}
      {isDeleteOpen && selectedLead && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl max-w-[340px] w-full p-5 shadow-2xl border border-gray-100">
            
            <div className="flex items-center justify-between pb-2 border-b border-gray-100">
              <h3 className="text-sm font-bold text-gray-900 flex items-center gap-1.5 text-red-600">
                <AlertTriangle className="w-4 h-4" />
                <span>Delete Lead?</span>
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
              Are you sure you want to delete lead <span className="font-semibold text-gray-800">{selectedLead.name}</span>?
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
