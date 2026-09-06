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
  Phone,
  MessageCircle,
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
} from "lucide-react";
import Sidebar from "@/components/Sidebar";

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

const initialLeads: FacebookLead[] = [
  {
    id: "1",
    leadId: "FB001",
    name: "Kamran Sheikh",
    phone: "+92 300 1112222",
    email: "kamran@gmail.com",
    city: "Karachi",
    area: "Clifton",
    receivedDate: "2024-12-07",
    status: "New",
    source: "Facebook Campaign (Solar Scrap Ad #4)",
    notes: ["Customer requested valuation for 50 broken panels."],
  },
  {
    id: "2",
    leadId: "FB002",
    name: "Fatima Zahra",
    phone: "+92 321 3334444",
    email: "fatima@yahoo.com",
    city: "Lahore",
    area: "Johar Town",
    receivedDate: "2024-12-06",
    status: "Contacted",
    source: "Facebook Lead Form",
    notes: ["Spoke on phone, sending photos on WhatsApp."],
  },
  {
    id: "3",
    leadId: "FB003",
    name: "Imran Siddiqui",
    phone: "+92 333 5556666",
    email: "imran@hotmail.com",
    city: "Islamabad",
    area: "G-11",
    receivedDate: "2024-12-05",
    status: "Follow-up",
    source: "Facebook Direct Message",
    notes: ["Follow up scheduled for Monday morning."],
  },
  {
    id: "4",
    leadId: "FB004",
    name: "Zainab Hassan",
    phone: "+92 312 7778888",
    email: "zainab@gmail.com",
    city: "Karachi",
    area: "DHA",
    receivedDate: "2024-12-04",
    status: "Converted",
    source: "Facebook Boosted Post",
    notes: ["Deal finalized, converted to registered seller."],
  },
  {
    id: "5",
    leadId: "FB005",
    name: "Ahmed Raza",
    phone: "+92 345 9990000",
    email: "ahmed@live.com",
    city: "Rawalpindi",
    area: "Bahria Town",
    receivedDate: "2024-12-03",
    status: "New",
    source: "Facebook Solar Scrap Ad",
    notes: ["Newly registered lead via form."],
  },
];

export default function FacebookLeadsPage() {
  const [leads, setLeads] = useState<FacebookLead[]>(initialLeads);
  const [activeFilter, setActiveFilter] = useState("All");
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
      const menuHeight = 240;
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
    setLeads((prev) =>
      prev.map((l) => (l.id === selectedLead.id ? { ...l, status: newStatusInput } : l))
    );
    setIsUpdateStatusOpen(false);
    showToast(`Status updated to "${newStatusInput}" for ${selectedLead.name}!`);
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
    setLeads((prev) =>
      prev.map((l) =>
        l.id === selectedLead.id
          ? { ...l, notes: [...(l.notes || []), noteInput.trim()] }
          : l
      )
    );
    setIsAddNoteOpen(false);
    showToast("Note added successfully!");
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
    <div className="min-h-screen w-full bg-[#f8fafc] flex flex-col lg:flex-row">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Facebook Leads"
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
                        ? "border-2 border-[#009639]"
                        : "border-gray-200/80 hover:border-gray-300"
                    }`}
                  >
                    <div>
                      <p
                        className={`text-3xl font-bold tracking-tight leading-none ${
                          isCurrentActive ? "text-[#009639]" : "text-gray-900"
                        }`}
                      >
                        {stat.count}
                      </p>
                      <p className="text-xs font-medium text-gray-500 mt-2">
                        {stat.label}
                      </p>
                    </div>

                    {isCurrentActive && (
                      <div className="w-6 h-0.5 bg-[#009639] mt-3 rounded-full" />
                    )}
                  </button>
                );
              })}
            </div>

            {/* Leads Data Table Card (Exact as media_1787855792122.png) */}
            <div className="bg-white rounded-2xl border border-gray-200/80 shadow-xs overflow-hidden">
              
              {/* Table Top Header: Count & Search */}
              <div className="p-4 sm:p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-gray-100">
                <span className="text-xs text-gray-500 font-medium">
                  {filteredLeads.length} leads
                </span>

                <div className="relative w-full sm:w-[260px]">
                  <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                  <input
                    type="text"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    placeholder="Search leads..."
                    className="w-full pl-9 pr-3.5 py-2 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009639] focus:ring-1 focus:ring-[#009639]/20 text-gray-800 placeholder:text-gray-400 shadow-2xs"
                  />
                </div>
              </div>

              {/* Table */}
              <div className="overflow-x-auto">
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
                            className="font-bold text-gray-900 hover:text-[#009639] cursor-pointer text-xs"
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
                                className="w-44 bg-white rounded-xl shadow-[0_12px_35px_-5px_rgba(0,0,0,0.18),0_4px_12px_-2px_rgba(0,0,0,0.08)] border border-gray-100 py-1.5 z-[999] text-left"
                              >
                                <button
                                  type="button"
                                  onClick={() => handleOpenDetails(lead)}
                                  className="w-full px-3 py-1.5 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2 transition-colors cursor-pointer"
                                >
                                  <Eye className="w-3.5 h-3.5 text-gray-500" />
                                  <span>View Details</span>
                                </button>
                                
                                <a
                                  href={`tel:${lead.phone.replace(/\s+/g, "")}`}
                                  className="w-full px-3 py-1.5 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2 transition-colors cursor-pointer"
                                >
                                  <Phone className="w-3.5 h-3.5 text-gray-500" />
                                  <span>Call Lead</span>
                                </a>

                                <a
                                  href={`https://wa.me/${lead.phone.replace(/[^0-9]/g, "")}`}
                                  target="_blank"
                                  rel="noreferrer"
                                  className="w-full px-3 py-1.5 text-xs text-emerald-600 hover:bg-emerald-50 flex items-center gap-2 transition-colors cursor-pointer font-medium"
                                >
                                  <MessageCircle className="w-3.5 h-3.5" />
                                  <span>WhatsApp</span>
                                </a>

                                <button
                                  type="button"
                                  onClick={() => handleOpenAddNote(lead)}
                                  className="w-full px-3 py-1.5 text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2 transition-colors cursor-pointer"
                                >
                                  <FileText className="w-3.5 h-3.5 text-gray-500" />
                                  <span>Add Note</span>
                                </button>

                                <button
                                  type="button"
                                  onClick={() => handleOpenUpdateStatus(lead)}
                                  className="w-full px-3 py-1.5 text-xs text-blue-600 hover:bg-blue-50 flex items-center gap-2 transition-colors cursor-pointer font-medium"
                                >
                                  <RefreshCw className="w-3.5 h-3.5" />
                                  <span>Update Status</span>
                                </button>

                                <div className="border-t border-gray-100 my-1" />
                                <button
                                  type="button"
                                  onClick={() => handleOpenDelete(lead)}
                                  className="w-full px-3 py-1.5 text-xs text-red-600 hover:bg-red-50 flex items-center gap-2 transition-colors cursor-pointer"
                                >
                                  <Trash2 className="w-3.5 h-3.5" />
                                  <span>Delete Lead</span>
                                </button>
                              </div>
                            </>
                          )}
                        </td>
                      </tr>
                    ))}

                    {filteredLeads.length === 0 && (
                      <tr>
                        <td colSpan={9} className="py-8 text-center text-xs text-gray-400">
                          No leads found matching your criteria.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>

              {/* Table Footer */}
              <div className="px-5 py-3 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
                <span>
                  Showing {filteredLeads.length} of {leads.length} leads
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

      {/* ===================== 1. LEAD DETAILS MODAL ===================== */}
      {isDetailsOpen && selectedLead && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4 z-50 animate-fadeIn">
          <div className="bg-white rounded-2xl sm:rounded-3xl max-w-[460px] w-full p-5 sm:p-6 shadow-2xl border border-gray-100 max-h-[90vh] overflow-y-auto">
            
            <div className="flex items-center justify-between pb-3 border-b border-gray-100">
              <h2 className="text-base font-bold text-gray-900">Lead Details</h2>
              <button
                type="button"
                onClick={() => setIsDetailsOpen(false)}
                className="w-7 h-7 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 flex items-center justify-center transition-colors cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* Profile Header */}
            <div className="flex items-center justify-between mt-4 p-3.5 bg-gray-50 rounded-2xl border border-gray-100">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-[#009639] text-white font-bold text-base flex items-center justify-center shadow-xs">
                  {selectedLead.name.charAt(0)}
                </div>
                <div>
                  <h3 className="text-sm font-bold text-gray-900">{selectedLead.name}</h3>
                  <span className="inline-block mt-0.5 px-2 py-0.2 rounded-full text-[10px] font-semibold bg-blue-50 text-blue-700 border border-blue-200">
                    {selectedLead.status}
                  </span>
                </div>
              </div>
              <span className="text-[11px] font-mono font-bold text-gray-400">
                {selectedLead.leadId}
              </span>
            </div>

            {/* Details Fields */}
            <div className="space-y-2.5 mt-4 text-xs">
              <div className="flex items-center justify-between p-2.5 bg-gray-50/70 rounded-xl border border-gray-100">
                <span className="text-gray-500">Phone:</span>
                <span className="font-mono font-semibold text-gray-800">{selectedLead.phone}</span>
              </div>
              <div className="flex items-center justify-between p-2.5 bg-gray-50/70 rounded-xl border border-gray-100">
                <span className="text-gray-500">Email:</span>
                <span className="font-mono font-semibold text-gray-800">{selectedLead.email}</span>
              </div>
              <div className="flex items-center justify-between p-2.5 bg-gray-50/70 rounded-xl border border-gray-100">
                <span className="text-gray-500">City:</span>
                <span className="font-semibold text-gray-800">{selectedLead.city}</span>
              </div>
              <div className="flex items-center justify-between p-2.5 bg-gray-50/70 rounded-xl border border-gray-100">
                <span className="text-gray-500">Area:</span>
                <span className="font-semibold text-gray-800">{selectedLead.area}</span>
              </div>
              <div className="flex items-center justify-between p-2.5 bg-gray-50/70 rounded-xl border border-gray-100">
                <span className="text-gray-500">Lead Source:</span>
                <span className="font-medium text-gray-700">{selectedLead.source}</span>
              </div>
              <div className="flex items-center justify-between p-2.5 bg-gray-50/70 rounded-xl border border-gray-100">
                <span className="text-gray-500">Received Date:</span>
                <span className="font-mono text-gray-700">{selectedLead.receivedDate}</span>
              </div>
            </div>

            {/* Notes List */}
            {selectedLead.notes && selectedLead.notes.length > 0 && (
              <div className="mt-3 p-3 bg-amber-50/60 rounded-xl border border-amber-100 text-xs">
                <p className="font-bold text-amber-900 mb-1">Remarks / Notes:</p>
                <ul className="list-disc list-inside space-y-1 text-gray-700">
                  {selectedLead.notes.map((n, i) => (
                    <li key={i}>{n}</li>
                  ))}
                </ul>
              </div>
            )}

            {/* Buttons */}
            <div className="flex items-center gap-2.5 mt-5 pt-3 border-t border-gray-100">
              <button
                type="button"
                onClick={() => {
                  setIsDetailsOpen(false);
                  handleOpenUpdateStatus(selectedLead);
                }}
                className="flex-1 py-2.5 px-4 bg-[#009639] hover:bg-[#008230] text-white text-xs font-semibold rounded-xl shadow-xs transition-colors cursor-pointer"
              >
                Update Status
              </button>
              <button
                type="button"
                onClick={() => setIsDetailsOpen(false)}
                className="py-2.5 px-5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-semibold rounded-xl transition-colors cursor-pointer"
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
                      ? "border-[#009639] bg-emerald-50/60 text-[#009639] font-bold"
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
                    className="accent-[#009639]"
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
                  className="px-4 py-1.5 bg-[#009639] hover:bg-[#008230] text-white font-semibold rounded-lg shadow-xs cursor-pointer"
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
                className="w-full px-3 py-2 border border-gray-200 rounded-xl outline-none focus:border-[#009639] resize-none"
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
                  className="px-4 py-1.5 bg-[#009639] hover:bg-[#008230] text-white font-semibold rounded-lg shadow-xs cursor-pointer"
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
          <Check className="w-4 h-4 text-[#009639]" />
          <span>{toastMessage}</span>
        </div>
      )}

      </div>
  );
}
