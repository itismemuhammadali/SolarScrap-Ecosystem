"use client";

import { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import {
  Search,
  Bell,
  Menu,
  X,
  Plus,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";
import { navItems } from "../components/nav-items";

interface QuotationRecord {
  id: string;
  name: string;
  avatarLetter: string;
  company: string;
  email: string;
  phone: string;
  status: "Pending" | "Approved" | "Rejected";
  date: string;
}

const initialQuotations: QuotationRecord[] = [
  {
    id: "1",
    name: "Raza Ahmed",
    avatarLetter: "R",
    company: "SolarTec Pvt Ltd",
    email: "raza@solartec.pk",
    phone: "+92 300 1234567",
    status: "Pending",
    date: "2024-12-01",
  },
  {
    id: "2",
    name: "Nadia Iqbal",
    avatarLetter: "N",
    company: "Sun Energy Co",
    email: "nadia@sunenergy.pk",
    phone: "+92 333 5551234",
    status: "Pending",
    date: "2024-12-05",
  },
  {
    id: "3",
    name: "Sana Malik",
    avatarLetter: "S",
    company: "Voltex Systems",
    email: "sana@voltex.pk",
    phone: "+92 345 2223333",
    status: "Approved",
    date: "2024-11-15",
  },
  {
    id: "4",
    name: "Ayesha Farooq",
    avatarLetter: "A",
    company: "CleanPower EPC",
    email: "ayesha@cleanpower.pk",
    phone: "+92 332 6667777",
    status: "Approved",
    date: "2024-11-20",
  },
];

export default function QuotationHistoryPage() {
  const router = useRouter();
  const [quotations] = useState<QuotationRecord[]>(initialQuotations);
  const [activeFilter, setActiveFilter] = useState("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

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
    <div className="flex h-screen bg-[#F8F9FA] overflow-hidden">
      {/* Unified Sidebar Navigation matching Quotation History */}
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
              className="lg:hidden p-2 text-gray-500 hover:text-gray-700 rounded-lg hover:bg-gray-100"
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
            <button className="relative p-2 text-gray-400 hover:text-gray-600 rounded-full hover:bg-gray-50 transition-colors">
              <Bell className="w-5 h-5" />
              <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white"></span>
            </button>
            <div className="flex items-center gap-3 pl-2">
              <span className="text-sm font-semibold text-gray-800 hidden sm:inline-block">
                Admin Platform
              </span>
              <div className="w-9 h-9 rounded-full bg-slate-200 overflow-hidden ring-1 ring-gray-200">
                <Image
                  src="/images/admin-avatar.jpg"
                  alt="Admin"
                  width={36}
                  height={36}
                  className="w-full h-full object-cover"
                />
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
                className="inline-flex items-center justify-center gap-2 px-5 py-2.5 bg-[#009845] hover:bg-[#00823b] text-white rounded-lg text-sm font-semibold shadow-sm transition-colors"
              >
                <Plus className="w-4 h-4" />
                <span>Create Quotations</span>
              </Link>
            </div>

            {/* Filter Tabs & Search Card */}
            <div className="bg-white rounded-xl shadow-xs border border-gray-100 p-4">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                {/* Status Tabs */}
                <div className="flex items-center gap-2 overflow-x-auto pb-1 md:pb-0">
                  {filterTabs.map((tab) => (
                    <button
                      key={tab}
                      onClick={() => setActiveFilter(tab)}
                      className={`px-4 py-1.5 rounded-md text-xs font-semibold whitespace-nowrap transition-colors ${
                        activeFilter === tab
                          ? "bg-[#009845] text-white shadow-xs"
                          : "text-gray-600 hover:text-gray-900 hover:bg-gray-100"
                      }`}
                    >
                      {tab}
                    </button>
                  ))}
                </div>

                {/* Search Bar */}
                <div className="relative w-full md:w-80">
                  <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
                  <input
                    type="text"
                    placeholder="Search by name, email, phone…"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="w-full pl-9 pr-4 py-1.5 bg-white border border-gray-200 rounded-lg text-xs text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>
              </div>
            </div>

            {/* Quotations Table */}
            <div className="bg-white rounded-xl shadow-xs border border-gray-100 overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left border-collapse">
                  <thead>
                    <tr className="border-b border-gray-100 bg-gray-50/50">
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                        Name
                      </th>
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                        Company
                      </th>
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                        Email
                      </th>
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                        Phone
                      </th>
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                        Status
                      </th>
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                        Date
                      </th>
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider text-right">
                        Action
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
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
                          className="hover:bg-gray-50/70 transition-colors"
                        >
                          <td className="py-4 px-6 whitespace-nowrap">
                            <div className="flex items-center gap-3">
                              <div className="w-8 h-8 rounded-full bg-[#009845] text-white flex items-center justify-center font-bold text-xs">
                                {q.avatarLetter}
                              </div>
                              <span className="text-sm font-semibold text-gray-900">
                                {q.name}
                              </span>
                            </div>
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-sm text-gray-700">
                            {q.company}
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-sm text-gray-600">
                            {q.email}
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-sm text-gray-600">
                            {q.phone}
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap">
                            <span
                              className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border ${
                                q.status === "Approved"
                                  ? "bg-emerald-50 text-emerald-700 border-emerald-200"
                                  : q.status === "Pending"
                                  ? "bg-amber-50 text-amber-700 border-amber-200"
                                  : "bg-red-50 text-red-700 border-red-200"
                              }`}
                            >
                              {q.status}
                            </span>
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-sm text-gray-500">
                            {q.date}
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-right">
                            <Link
                              href={`/quotation-history/view?id=${q.id}`}
                              className="inline-flex items-center justify-center px-4 py-1.5 bg-[#009845] hover:bg-[#00823b] text-white rounded-md text-xs font-semibold transition-colors"
                            >
                              View Quotation
                            </Link>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>

              {/* Table Footer / Pagination */}
              <div className="py-4 px-6 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
                <span>
                  Showing {filteredQuotations.length} of {quotations.length}{" "}
                  records
                </span>
                <div className="flex items-center gap-1">
                  <button className="w-7 h-7 rounded-md bg-[#009845] text-white font-semibold flex items-center justify-center text-xs">
                    1
                  </button>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
