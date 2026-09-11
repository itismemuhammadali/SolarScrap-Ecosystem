"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import {
  Search,
  Bell,
  Menu,
  X,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";
import { getSession, getAvatarUrl } from "@/lib/auth";
import QuotationModal from "@/components/QuotationModal";

interface QuotationRecord {
  id: string;
  name: string;
  avatarLetter: string;
  company: string;
  email: string;
  phone: string;
  city?: string;
  totalAmount?: number;
  status: "Pending" | "Approved" | "Rejected";
  date: string;
  itemsCount?: number;
  equipmentType?: string;
}

const INITIAL_QUOTATIONS: QuotationRecord[] = [
  {
    id: "#Qt-2024-001",
    name: "Raza Ahmed",
    avatarLetter: "R",
    company: "SolarTec Pvt Ltd",
    email: "raza@solartec.pk",
    phone: "+92 300 1234567",
    city: "Rawalpindi, Bahria Town",
    totalAmount: 456880,
    status: "Pending",
    date: "2024-12-01",
    itemsCount: 20,
    equipmentType: "Longi 550W Solar Panel (Used)",
  },
  {
    id: "#Qt-2024-002",
    name: "Nadia Iqbal",
    avatarLetter: "N",
    company: "Sun Energy Co",
    email: "nadia@sunenergy.pk",
    phone: "+92 333 5551234",
    city: "Lahore",
    totalAmount: 380000,
    status: "Pending",
    date: "2024-12-05",
    itemsCount: 24,
    equipmentType: "GoodWe 10kW On-Grid Inverters",
  },
  {
    id: "#Qt-2024-003",
    name: "Sana Malik",
    avatarLetter: "S",
    company: "Voltex Systems",
    email: "sana@voltex.pk",
    phone: "+92 345 2223333",
    city: "Karachi",
    totalAmount: 240000,
    status: "Approved",
    date: "2024-11-15",
    itemsCount: 15,
    equipmentType: "Canadian Solar 540W Panels",
  },
  {
    id: "#Qt-2024-004",
    name: "Ayesha Farooq",
    avatarLetter: "A",
    company: "CleanPower EPC",
    email: "ayesha@cleanpower.pk",
    phone: "+92 332 6667777",
    city: "Islamabad",
    totalAmount: 195000,
    status: "Approved",
    date: "2024-11-20",
    itemsCount: 8,
    equipmentType: "Daewoo 200Ah Tubular Batteries",
  },
];

export default function QuotationHistoryPage() {
  const router = useRouter();
  const [quotations, setQuotations] = useState<QuotationRecord[]>(INITIAL_QUOTATIONS);
  const [adminName, setAdminName] = useState("Admin Platform");
  const [adminPhotoUrl, setAdminPhotoUrl] = useState<string | null>(null);
  const [activeFilter, setActiveFilter] = useState("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [selectedQuotation, setSelectedQuotation] = useState<QuotationRecord | null>(null);
  const [toast, setToast] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 3000);
  };

  useEffect(() => {
    const session = getSession();
    if (session?.user) {
      if (session.user.display_name) setAdminName(session.user.display_name);
      else if (session.user.email) setAdminName(session.user.email.split("@")[0]);
      if (session.user.profile_photo_url) setAdminPhotoUrl(session.user.profile_photo_url);
    }

    try {
      const stored = localStorage.getItem("solar_scrap_quotations");
      if (stored) {
        const parsed = JSON.parse(stored);
        if (Array.isArray(parsed) && parsed.length > 0) {
          setQuotations(parsed);
        } else {
          setQuotations(INITIAL_QUOTATIONS);
        }
      } else {
        setQuotations(INITIAL_QUOTATIONS);
        localStorage.setItem("solar_scrap_quotations", JSON.stringify(INITIAL_QUOTATIONS));
      }
    } catch {
      setQuotations(INITIAL_QUOTATIONS);
    }
  }, []);

  const toggleStatus = (id: string) => {
    const nextStatusMap: Record<string, "Pending" | "Approved" | "Rejected"> = {
      Pending: "Approved",
      Approved: "Rejected",
      Rejected: "Pending",
    };
    const updated = quotations.map((q) => {
      if (q.id === id) {
        return { ...q, status: nextStatusMap[q.status] || "Pending" };
      }
      return q;
    });
    setQuotations(updated);
    try {
      localStorage.setItem("solar_scrap_quotations", JSON.stringify(updated));
    } catch (e) {
      console.error(e);
    }
  };

  const filterTabs = ["All", "Approved", "Pending", "Rejected"];

  const filteredQuotations = quotations.filter((q) => {
    if (activeFilter === "Approved" && q.status !== "Approved") return false;
    if (activeFilter === "Pending" && q.status !== "Pending") return false;
    if (activeFilter === "Rejected" && q.status !== "Rejected") return false;

    if (searchQuery.trim()) {
      const term = searchQuery.toLowerCase();
      const match =
        q.name.toLowerCase().includes(term) ||
        q.company.toLowerCase().includes(term) ||
        q.email.toLowerCase().includes(term) ||
        q.phone.toLowerCase().includes(term);
      if (!match) return false;
    }

    return true;
  });

  return (
    <div className="flex h-screen bg-[#F5F6FA] overflow-hidden">
      {/* Unified Sidebar Navigation */}
      <Sidebar
        activeItem="Quotation history"
        mobileMenuOpen={mobileMenuOpen}
        setMobileMenuOpen={setMobileMenuOpen}
      />

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        {/* Top Header */}
        <header className="h-20 bg-white border-b border-gray-100 flex items-center justify-between px-6 lg:px-8 shrink-0">
          <div className="flex items-center gap-4 flex-1">
            <button
              onClick={() => setMobileMenuOpen(true)}
              className="lg:hidden p-2 text-gray-500 hover:text-gray-700 rounded-lg hover:bg-gray-100 cursor-pointer"
            >
              <Menu className="w-6 h-6" />
            </button>
            <div className="relative max-w-md w-full">
              <Search className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="Search users, posts, auctions, bids..."
                value={topSearch}
                onChange={(e) => setTopSearch(e.target.value)}
                className="w-full pl-10 pr-4 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
              />
            </div>
          </div>

          <div className="flex items-center gap-4">
            <Link
              href="/notifications"
              className="relative p-2 text-gray-400 hover:text-gray-600 rounded-full hover:bg-gray-50 transition-colors"
              aria-label="Notifications"
            >
              <Bell className="w-5 h-5" />
              <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white"></span>
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

        {/* Page Content */}
        <main className="flex-1 overflow-y-auto p-6 lg:p-8">
          <div className="max-w-7xl mx-auto space-y-6">
            {/* Title & Action Bar */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div>
                <h1 className="text-2xl font-bold text-gray-900 tracking-tight">
                  Quotation History
                </h1>
                <p className="text-sm text-gray-500 mt-1">
                  Create or Manage your Quotations.
                </p>
              </div>

              <Link
                href="/quotation-history/create"
                className="inline-flex items-center justify-center px-6 py-2.5 bg-[#009845] hover:bg-[#00823b] text-white rounded-lg text-sm font-semibold shadow-xs hover:shadow transition-all cursor-pointer"
              >
                Create Quotations
              </Link>
            </div>

            {/* Quotations Main Card Container (Filters & Search Inside Card) */}
            <div className="bg-white rounded-2xl shadow-xs border border-gray-200/80 overflow-hidden">
              {/* Filter Tabs & Search Controls inside the White Box */}
              <div className="p-4 sm:p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-100">
                {/* Status Pills */}
                <div className="flex items-center gap-1.5">
                  {filterTabs.map((tab) => {
                    const isActive = activeFilter === tab;
                    return (
                      <button
                        key={tab}
                        onClick={() => setActiveFilter(tab)}
                        className={`px-4 py-1.5 rounded-full text-xs font-medium transition-all cursor-pointer ${
                          isActive
                            ? "bg-[#009845] text-white font-semibold shadow-xs"
                            : "text-gray-600 hover:text-gray-900 hover:bg-gray-50 font-normal"
                        }`}
                      >
                        {tab}
                      </button>
                    );
                  })}
                </div>

                {/* Search Bar */}
                <div className="relative w-full sm:w-80">
                  <Search className="w-3.5 h-3.5 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
                  <input
                    type="text"
                    placeholder="Search by name, email, phone..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="w-full pl-9 pr-4 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-[#009845]/20 focus:border-[#009845] shadow-2xs"
                  />
                </div>
              </div>

              {/* Table */}
              <div className="overflow-x-auto">
                <table className="w-full text-left border-collapse">
                  <thead>
                    <tr className="border-b border-gray-100 bg-gray-50/50 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                      <th className="py-3.5 px-6">NAME</th>
                      <th className="py-3.5 px-6">COMPANY</th>
                      <th className="py-3.5 px-6">EMAIL</th>
                      <th className="py-3.5 px-6">PHONE</th>
                      <th className="py-3.5 px-6">STATUS</th>
                      <th className="py-3.5 px-6">DATE</th>
                      <th className="py-3.5 px-6 text-right"></th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100 text-xs">
                    {filteredQuotations.length === 0 ? (
                      <tr>
                        <td
                          colSpan={7}
                          className="py-12 text-center text-sm text-gray-500"
                        >
                          No quotations found matching your criteria.
                        </td>
                      </tr>
                    ) : (
                      filteredQuotations.map((q) => (
                        <tr
                          key={q.id}
                          className="hover:bg-gray-50/60 transition-colors"
                        >
                          {/* Name with Green Avatar (matching Figma 1:1) */}
                          <td className="py-4 px-6 whitespace-nowrap">
                            <div className="flex items-center gap-3">
                              <div className="w-8 h-8 rounded-full bg-[#009845] text-white flex items-center justify-center font-bold text-xs select-none shadow-2xs">
                                {q.avatarLetter}
                              </div>
                              <span className="text-xs font-bold text-gray-900">
                                {q.name}
                              </span>
                            </div>
                          </td>

                          {/* Company */}
                          <td className="py-4 px-6 whitespace-nowrap text-xs text-gray-700">
                            {q.company}
                          </td>

                          {/* Email */}
                          <td className="py-4 px-6 whitespace-nowrap text-xs text-gray-600">
                            {q.email}
                          </td>

                          {/* Phone */}
                          <td className="py-4 px-6 whitespace-nowrap text-xs text-gray-600">
                            {q.phone}
                          </td>

                          {/* Status Badge */}
                          <td className="py-4 px-6 whitespace-nowrap">
                            <button
                              type="button"
                              onClick={() => toggleStatus(q.id)}
                              title="Click to toggle status"
                              className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-[11px] font-semibold transition-all cursor-pointer ${
                                q.status === "Approved"
                                  ? "bg-emerald-50 text-[#009845] border border-[#009845]/30"
                                  : q.status === "Pending"
                                  ? "bg-amber-50 text-amber-600 border border-amber-200"
                                  : "bg-red-50 text-red-600 border border-red-200"
                              }`}
                            >
                              {q.status}
                            </button>
                          </td>

                          {/* Date */}
                          <td className="py-4 px-6 whitespace-nowrap text-xs text-gray-500">
                            {q.date}
                          </td>

                          {/* Action (Squared-off View Quotation Button matching Figma 1:1) */}
                          <td className="py-4 px-6 whitespace-nowrap text-right">
                            <button
                              type="button"
                              onClick={() => setSelectedQuotation(q)}
                              className="px-4 py-1.5 bg-[#009845] hover:bg-[#00823b] text-white rounded-md text-xs font-semibold transition-all cursor-pointer shadow-2xs"
                            >
                              View Quotation
                            </button>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>

              {/* Table Footer / Pagination matching Figma */}
              <div className="py-4 px-6 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
                <span>
                  Showing {filteredQuotations.length} of {quotations.length} records
                </span>
                <div className="flex items-center gap-1.5">
                  <button className="w-7 h-7 rounded-md bg-[#009845] text-white font-semibold flex items-center justify-center text-xs shadow-2xs">
                    1
                  </button>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>

      {/* Exact Figma Quotation Modal */}
      {selectedQuotation && (
        <QuotationModal
          isOpen={!!selectedQuotation}
          onClose={() => setSelectedQuotation(null)}
          data={{
            quotationId: selectedQuotation.id || "#Qt-2024-005",
            customerName: selectedQuotation.name,
            phone: selectedQuotation.phone,
            location: selectedQuotation.city || "Rawalpindi, Bahria Town",
            date: "03 Dec 2024",
            validTill: "10 Dec 2024",
            fromCompany: "Solartao Pvt Ltd",
            items: [
              {
                name: selectedQuotation.equipmentType || "Longi 550W Solar Panel (Used)",
                qty: selectedQuotation.itemsCount || 20,
                rate: 12000,
                amount: 240000,
              },
            ],
            subTotal: selectedQuotation.totalAmount || 240000,
            totalOffer: selectedQuotation.totalAmount || 240000,
            status: selectedQuotation.status,
          }}
        />
      )}
    </div>
  );
}
