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
  CheckCircle,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";
import DoubleScrollContainer from "@/components/DoubleScrollContainer";
import { getSession, getAvatarUrl } from "@/lib/auth";
import QuotationModal from "@/components/QuotationModal";

interface InventoryItem {
  id: string;
  name: string;
  avatarLetter: string;
  company: string;
  email: string;
  phone: string;
  city?: string;
  qty: string;
  purchasedDate: string;
  item: string; // e.g. "Solar", "Battery"
  itemTitle: string;
  condition: "Working Grade A" | "Refurbished Grade B" | "Pure Scrap";
  pricePaid: number;
  estimatedValue: number;
  status: "In Stock" | "Allocated to Auction" | "Sold";
}

const INITIAL_INVENTORY: InventoryItem[] = [
  {
    id: "INV-ITEM-01",
    name: "Bilal Hussain",
    avatarLetter: "B",
    company: "Scrap King",
    email: "bilal@scrapking.pk",
    phone: "+92 321 9876543",
    city: "Lahore",
    qty: "20",
    purchasedDate: "2024-12-03",
    item: "Solar",
    itemTitle: "Longi 550W Solar Panels (Used)",
    condition: "Working Grade A",
    pricePaid: 240000,
    estimatedValue: 456880,
    status: "In Stock",
  },
  {
    id: "INV-ITEM-02",
    name: "Tariq Mehmood",
    avatarLetter: "T",
    company: "Green Deal",
    email: "tariq@greendeal.pk",
    phone: "+92 312 7778888",
    city: "Karachi",
    qty: "02",
    purchasedDate: "2024-12-06",
    item: "Battery",
    itemTitle: "Daewoo 200Ah Tubular Batteries",
    condition: "Working Grade A",
    pricePaid: 220000,
    estimatedValue: 380000,
    status: "In Stock",
  },
  {
    id: "INV-ITEM-03",
    name: "Hamza Khan",
    avatarLetter: "H",
    company: "MetalZon",
    email: "hamza@metalzon.pk",
    phone: "+92 300 4445555",
    city: "Faisalabad",
    qty: "24",
    purchasedDate: "2024-11-10",
    item: "Solar",
    itemTitle: "Canadian Solar 540W Mono Panels",
    condition: "Working Grade A",
    pricePaid: 240000,
    estimatedValue: 420000,
    status: "In Stock",
  },
  {
    id: "INV-ITEM-04",
    name: "Usman Ali",
    avatarLetter: "U",
    company: "RecyclePlus",
    email: "usman@recycleplus.pk",
    phone: "+92 311 8889999",
    city: "Lahore",
    qty: "04",
    purchasedDate: "2024-11-25",
    item: "battery",
    itemTitle: "Narada 48V Lithium Battery",
    condition: "Refurbished Grade B",
    pricePaid: 290000,
    estimatedValue: 456880,
    status: "In Stock",
  },
];

export default function MyInventoryPage() {
  const router = useRouter();
  const [inventory, setInventory] = useState<InventoryItem[]>(INITIAL_INVENTORY);
  const [adminName, setAdminName] = useState("Admin Platform");
  const [adminPhotoUrl, setAdminPhotoUrl] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<"All" | "Solar" | "Batteries">("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [selectedItem, setSelectedItem] = useState<InventoryItem | null>(null);
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
      const stored = localStorage.getItem("solar_scrap_inventory");
      if (stored) {
        const parsed = JSON.parse(stored);
        if (Array.isArray(parsed) && parsed.length > 0 && parsed[0].name === "Bilal Hussain") {
          setInventory(parsed);
        } else {
          setInventory(INITIAL_INVENTORY);
          localStorage.setItem("solar_scrap_inventory", JSON.stringify(INITIAL_INVENTORY));
        }
      } else {
        setInventory(INITIAL_INVENTORY);
        localStorage.setItem("solar_scrap_inventory", JSON.stringify(INITIAL_INVENTORY));
      }
    } catch {
      setInventory(INITIAL_INVENTORY);
    }
  }, []);

  const filterTabs: ("All" | "Solar" | "Batteries")[] = ["All", "Solar", "Batteries"];

  const filteredInventory = inventory.filter((item) => {
    if (activeTab === "Solar" && !item.item.toLowerCase().includes("solar")) return false;
    if (activeTab === "Batteries" && !item.item.toLowerCase().includes("batter")) return false;

    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const match =
        item.name.toLowerCase().includes(q) ||
        item.company.toLowerCase().includes(q) ||
        item.email.toLowerCase().includes(q) ||
        item.phone.toLowerCase().includes(q) ||
        item.itemTitle.toLowerCase().includes(q) ||
        item.item.toLowerCase().includes(q);
      if (!match) return false;
    }

    return true;
  });

  return (
    <div className="flex h-screen bg-[#F5F6FA] overflow-hidden">
      {/* Toast */}
      {toast && (
        <div className="fixed top-6 right-6 z-50 bg-[#009845] text-white px-5 py-3 rounded-xl shadow-lg flex items-center gap-2 text-sm font-semibold animate-fade-in">
          <CheckCircle className="w-5 h-5" />
          <span>{toast}</span>
        </div>
      )}

      {/* Unified Sidebar Navigation */}
      <Sidebar
        activeItem="My Inventory"
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
                placeholder="Search inventory, parts, models..."
                value={topSearch}
                onChange={(e) => setTopSearch(e.target.value)}
                className="w-full pl-10 pr-4 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
              />
            </div>
          </div>

          <div className="flex items-center gap-4">
            <Link
              href="/notifications"
              className="relative p-2 text-gray-400 hover:text-gray-600 rounded-full hover:bg-gray-50"
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
            {/* Header Title */}
            <div>
              <h1 className="text-2xl font-bold text-gray-900 tracking-tight">
                My Inventory
              </h1>
              <p className="text-sm text-gray-500 mt-1">
                View all the items you have purchased uptill now
              </p>
            </div>

            {/* Inventory Main White Card Container (Filters & Search Inside) */}
            <div className="bg-white rounded-2xl shadow-xs border border-gray-200/80 overflow-hidden">
              {/* Filter Tabs & Search Controls */}
              <div className="p-4 sm:p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-100">
                {/* Category Tabs */}
                <div className="flex items-center gap-2">
                  {filterTabs.map((tab) => {
                    const isActive = activeTab === tab;
                    return (
                      <button
                        key={tab}
                        type="button"
                        onClick={() => setActiveTab(tab)}
                        className={`px-4 py-1.5 rounded-full text-xs font-medium transition-all cursor-pointer ${
                          isActive
                            ? "bg-[#009845] text-white font-semibold shadow-xs"
                            : "text-gray-600 hover:text-gray-900 font-normal"
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
                    className="w-full pl-8 pr-3.5 py-1.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-[#009845]/20 focus:border-[#009845] shadow-2xs"
                  />
                </div>
              </div>

              {/* Table with Dual Synced Scrollbars */}
              <DoubleScrollContainer>
                <table className="w-full text-left border-collapse">
                  <thead>
                    <tr className="border-b border-gray-100 bg-gray-50/50 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                      <th className="py-3 px-4 sm:px-6">NAME</th>
                      <th className="py-3 px-4">COMPANY</th>
                      <th className="py-3 px-4">EMAIL</th>
                      <th className="py-3 px-4">PHONE</th>
                      <th className="py-3 px-4">QTY</th>
                      <th className="py-3 px-4">PURCHASED DATE</th>
                      <th className="py-3 px-4">ITEM</th>
                      <th className="py-3 px-4 sm:px-6 text-right"></th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100 text-xs">
                    {filteredInventory.length === 0 ? (
                      <tr>
                        <td
                          colSpan={8}
                          className="py-10 text-center text-sm text-gray-500"
                        >
                          No inventory items found matching your criteria.
                        </td>
                      </tr>
                    ) : (
                      filteredInventory.map((item) => (
                        <tr
                          key={item.id}
                          className="hover:bg-gray-50/60 transition-colors"
                        >
                          {/* Name + Solid Green Circle Avatar with White Letter */}
                          <td className="py-2.5 sm:py-3 px-4 sm:px-6 whitespace-nowrap">
                            <div className="flex items-center gap-2.5">
                              <div className="w-7.5 h-7.5 rounded-full bg-[#009845] text-white flex items-center justify-center font-bold text-xs select-none shadow-2xs">
                                {item.avatarLetter}
                              </div>
                              <span className="text-xs font-bold text-gray-900">
                                {item.name}
                              </span>
                            </div>
                          </td>

                          {/* Company */}
                          <td className="py-2.5 sm:py-3 px-4 whitespace-nowrap text-xs text-gray-700">
                            {item.company}
                          </td>

                          {/* Email */}
                          <td className="py-2.5 sm:py-3 px-4 whitespace-nowrap text-xs text-gray-600">
                            {item.email}
                          </td>

                          {/* Phone */}
                          <td className="py-2.5 sm:py-3 px-4 whitespace-nowrap text-xs text-gray-600">
                            {item.phone}
                          </td>

                          {/* Qty */}
                          <td className="py-2.5 sm:py-3 px-4 whitespace-nowrap text-xs text-gray-600">
                            {item.qty}
                          </td>

                          {/* Purchased Date */}
                          <td className="py-2.5 sm:py-3 px-4 whitespace-nowrap text-xs text-gray-500 font-mono">
                            {item.purchasedDate}
                          </td>

                          {/* Item */}
                          <td className="py-2.5 sm:py-3 px-4 whitespace-nowrap text-xs text-gray-600">
                            {item.item}
                          </td>

                          {/* Action (Squared-off View Button matching Figma 1:1) */}
                          <td className="py-2.5 sm:py-3 px-4 sm:px-6 whitespace-nowrap text-right">
                            <button
                              type="button"
                              onClick={() => setSelectedItem(item)}
                              className="px-3.5 py-1 bg-[#009845] hover:bg-[#00823b] text-white rounded-md text-xs font-semibold transition-all cursor-pointer shadow-2xs"
                            >
                              View
                            </button>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </DoubleScrollContainer>

              {/* Table Footer / Pagination matching Figma */}
              <div className="py-3 px-4 sm:px-6 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
                <span>
                  Showing {filteredInventory.length} of {inventory.length} records
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

      {/* Modal */}
      {selectedItem && (
        <QuotationModal
          isOpen={!!selectedItem}
          onClose={() => setSelectedItem(null)}
          data={{
            quotationId: selectedItem.id,
            customerName: selectedItem.name,
            phone: selectedItem.phone,
            location: selectedItem.city || "Rawalpindi, Bahria Town",
            date: selectedItem.purchasedDate,
            validTill: "10 Dec 2024",
            fromCompany: selectedItem.company,
            items: [
              {
                name: selectedItem.itemTitle,
                qty: selectedItem.qty,
                rate: Math.round(selectedItem.estimatedValue / (parseInt(selectedItem.qty) || 1)),
                amount: selectedItem.estimatedValue,
              },
            ],
            subTotal: selectedItem.estimatedValue,
            totalOffer: selectedItem.estimatedValue,
            status: selectedItem.status,
          }}
        />
      )}
    </div>
  );
}
