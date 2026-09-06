"use client";

import { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import {
  Search,
  Bell,
  Menu,
  X,
  Eye,
  Calendar,
  Layers,
  Phone,
  Mail,
  Building,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";
import { navItems } from "../components/nav-items";

interface InventoryItem {
  id: string;
  name: string;
  avatarLetter: string;
  company: string;
  email: string;
  phone: string;
  qty: string;
  purchasedDate: string;
  itemType: "Solar" | "Battery" | "Inverter";
  itemTitle: string;
  pricePaid: string;
}

const initialInventory: InventoryItem[] = [
  {
    id: "1",
    name: "Bilal Hussain",
    avatarLetter: "B",
    company: "Scrap King",
    email: "bilal@scrapking.pk",
    phone: "+92 321 9876543",
    qty: "20",
    purchasedDate: "2024-12-03",
    itemType: "Solar",
    itemTitle: "Longi 550W Tier 1 Solar Panels (A Grade)",
    pricePaid: "PKR 240,000",
  },
  {
    id: "2",
    name: "Tariq Mehmood",
    avatarLetter: "T",
    company: "Green Deal",
    email: "tariq@greendeal.pk",
    phone: "+92 312 7778888",
    qty: "02",
    purchasedDate: "2024-12-06",
    itemType: "Battery",
    itemTitle: "Narada 48V 100Ah Lithium LiFePO4 Batteries",
    pricePaid: "PKR 180,000",
  },
  {
    id: "3",
    name: "Hamza Khan",
    avatarLetter: "H",
    company: "MetalZon",
    email: "hamza@metalzon.pk",
    phone: "+92 300 4445555",
    qty: "24",
    purchasedDate: "2024-11-10",
    itemType: "Solar",
    itemTitle: "Jinko 545W Bifacial Solar Panels",
    pricePaid: "PKR 290,000",
  },
  {
    id: "4",
    name: "Usman Ali",
    avatarLetter: "U",
    company: "RecyclePlus",
    email: "usman@recycleplus.pk",
    phone: "+92 311 8889999",
    qty: "04",
    purchasedDate: "2024-11-25",
    itemType: "Battery",
    itemTitle: "Phoenix Tubular Deep Cycle Batteries 230Ah",
    pricePaid: "PKR 145,000",
  },
];

export default function MyInventoryPage() {
  const [inventory] = useState<InventoryItem[]>(initialInventory);
  const [activeTab, setActiveTab] = useState<"All" | "Solar" | "Batteries">("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [selectedItem, setSelectedItem] = useState<InventoryItem | null>(null);

  const filterTabs: ("All" | "Solar" | "Batteries")[] = ["All", "Solar", "Batteries"];

  const filteredInventory = inventory.filter((item) => {
    if (activeTab === "Solar" && item.itemType !== "Solar") return false;
    if (activeTab === "Batteries" && item.itemType !== "Battery") return false;

    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const match =
        item.name.toLowerCase().includes(q) ||
        item.company.toLowerCase().includes(q) ||
        item.email.toLowerCase().includes(q) ||
        item.phone.toLowerCase().includes(q) ||
        item.itemType.toLowerCase().includes(q);
      if (!match) return false;
    }

    return true;
  });

  return (
    <div className="flex h-screen bg-[#F8F9FA] overflow-hidden">
      {/* Unified Sidebar Navigation matching Quotation History */}
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
                className="w-full pl-10 pr-4 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
              />
            </div>
          </div>

          <div className="flex items-center gap-4">
            <button className="relative p-2 text-gray-400 hover:text-gray-600 rounded-full hover:bg-gray-50">
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
            {/* Header Title */}
            <div>
              <h1 className="text-2xl font-bold text-gray-900 tracking-tight">
                My Inventory
              </h1>
              <p className="text-sm text-gray-500 mt-1">
                View all the items you have purchased uptil now
              </p>
            </div>

            {/* Filter Tabs & Search Card */}
            <div className="bg-white rounded-xl shadow-xs border border-gray-100 p-4">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                {/* Category Tabs */}
                <div className="flex items-center gap-2">
                  {filterTabs.map((tab) => (
                    <button
                      key={tab}
                      onClick={() => setActiveTab(tab)}
                      className={`px-4 py-1.5 rounded-md text-xs font-semibold whitespace-nowrap transition-colors ${
                        activeTab === tab
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

            {/* Inventory Table Card */}
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
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider text-center">
                        QTY
                      </th>
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                        Purchased Date
                      </th>
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                        Item
                      </th>
                      <th className="py-3.5 px-6 text-[11px] font-bold text-gray-400 uppercase tracking-wider text-right">
                        Action
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {filteredInventory.length === 0 ? (
                      <tr>
                        <td
                          colSpan={8}
                          className="py-12 text-center text-sm text-gray-500"
                        >
                          No inventory items found.
                        </td>
                      </tr>
                    ) : (
                      filteredInventory.map((item) => (
                        <tr
                          key={item.id}
                          className="hover:bg-gray-50/70 transition-colors"
                        >
                          <td className="py-4 px-6 whitespace-nowrap">
                            <div className="flex items-center gap-3">
                              <div className="w-8 h-8 rounded-full bg-[#009845] text-white flex items-center justify-center font-bold text-xs">
                                {item.avatarLetter}
                              </div>
                              <span className="text-sm font-semibold text-gray-900">
                                {item.name}
                              </span>
                            </div>
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-sm text-gray-700">
                            {item.company}
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-sm text-gray-600">
                            {item.email}
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-sm text-gray-600">
                            {item.phone}
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-sm font-semibold text-gray-800 text-center">
                            {item.qty}
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-sm text-gray-500">
                            {item.purchasedDate}
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap">
                            <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 border border-gray-200">
                              {item.itemType}
                            </span>
                          </td>
                          <td className="py-4 px-6 whitespace-nowrap text-right">
                            <button
                              onClick={() => setSelectedItem(item)}
                              className="inline-flex items-center justify-center px-4 py-1.5 bg-[#009845] hover:bg-[#00823b] text-white rounded-md text-xs font-semibold transition-colors"
                            >
                              View
                            </button>
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
                  Showing {filteredInventory.length} of {inventory.length}{" "}
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

      {/* Inventory Item Details / Quotation Document Modal (Matching Figma 1481:4470) */}
      {selectedItem && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-xs flex items-center justify-center p-4 overflow-y-auto">
          <div className="bg-white rounded-2xl max-w-2xl w-full p-6 sm:p-8 shadow-2xl border border-gray-100 space-y-6 animate-scale-up my-8 max-h-[90vh] overflow-y-auto">
            {/* Modal Header & Close */}
            <div className="flex items-center justify-between pb-4 border-b border-gray-100">
              <span className="text-xs font-bold text-gray-400 uppercase tracking-wider">
                Purchase Quotation & Invoice View
              </span>
              <button
                onClick={() => setSelectedItem(null)}
                className="p-1.5 text-gray-400 hover:text-gray-700 rounded-lg hover:bg-gray-100 transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Complete Document Body Matching Figma */}
            <div className="bg-white rounded-2xl border border-gray-200/80 p-6 sm:p-8 space-y-6 shadow-xs">
              {/* Document Brand Header */}
              <div className="flex items-center justify-between pb-4 border-b border-gray-100">
                <Image
                  src="/images/solar-scrap-img.png"
                  alt="Solar Scrap Logo"
                  width={130}
                  height={67}
                  className="w-[120px] sm:w-[130px] h-auto object-contain"
                  priority
                />

                <div className="text-right">
                  <h3 className="text-xl font-black text-gray-900 tracking-tight">
                    Quotation
                  </h3>
                  <span className="text-xs font-bold text-gray-400">
                    #Qt-2024-005
                  </span>
                </div>
              </div>

              {/* To & Metadata Section */}
              <div className="flex flex-col sm:flex-row justify-between items-start gap-4 text-xs">
                <div>
                  <p className="text-[11px] font-bold text-gray-400 uppercase tracking-wider mb-1">
                    To,
                  </p>
                  <h4 className="text-base font-bold text-gray-900">
                    {selectedItem.name}
                  </h4>
                  <p className="text-gray-600 mt-0.5">{selectedItem.phone}</p>
                  <p className="text-gray-500 mt-0.5">Rawalpindi, Bahria Town</p>
                  <p className="text-gray-400 mt-0.5">{selectedItem.company}</p>
                </div>

                <div className="text-left sm:text-right space-y-1">
                  <p className="text-gray-500">
                    <span className="font-semibold text-gray-700 mr-2">Date:</span>
                    03 Dec 2024
                  </p>
                  <p className="text-gray-500">
                    <span className="font-semibold text-gray-700 mr-2">Valid Till:</span>
                    10 Dec 2024
                  </p>
                  <p className="text-gray-500">
                    <span className="font-semibold text-gray-700 mr-2">From:</span>
                    SolarTec Pvt Ltd
                  </p>
                </div>
              </div>

              {/* Items Table Box */}
              <div className="bg-[#F9FAFB] rounded-xl p-4 sm:p-5 space-y-3.5 border border-gray-100">
                <div className="grid grid-cols-12 text-[11px] font-bold text-gray-500 border-b border-gray-200/80 pb-2">
                  <div className="col-span-6">Items</div>
                  <div className="col-span-2 text-center">QTY</div>
                  <div className="col-span-2 text-right">Rate ( PKR )</div>
                  <div className="col-span-2 text-right">Amount ( PKR )</div>
                </div>

                <div className="space-y-2 py-1 text-xs">
                  <div className="grid grid-cols-12 items-center text-gray-800">
                    <div className="col-span-6 font-medium">
                      1. {selectedItem.itemTitle}
                    </div>
                    <div className="col-span-2 text-center text-gray-600">
                      {selectedItem.qty}
                    </div>
                    <div className="col-span-2 text-right text-gray-600">
                      12,000
                    </div>
                    <div className="col-span-2 text-right font-semibold text-gray-900">
                      240,000
                    </div>
                  </div>
                </div>

                {/* Subtotals */}
                <div className="border-t border-gray-200/80 pt-3 space-y-1 text-xs">
                  <div className="flex justify-between items-center text-gray-700">
                    <span className="font-bold">Sub total</span>
                    <span className="font-bold text-gray-900">456,880</span>
                  </div>
                  <div className="flex justify-between items-center text-gray-500">
                    <span>Adjustment</span>
                    <span>00</span>
                  </div>
                </div>

                {/* Total Offer Green Banner */}
                <div className="bg-[#009845] text-white rounded-lg px-4 py-2.5 flex justify-between items-center font-bold text-sm shadow-xs">
                  <span>Total Offer ( PKR )</span>
                  <span>456,880</span>
                </div>
              </div>

              {/* Terms & Conditions */}
              <div className="space-y-1.5 text-xs text-gray-500 pt-1">
                <h5 className="font-bold text-gray-800">Terms & Conditions</h5>
                <ul className="list-disc pl-4 space-y-0.5">
                  <li>This is an estimated offer and valid for the mentioned date only.</li>
                  <li>Final price may vary after physical inspection.</li>
                </ul>
                <p className="font-bold text-gray-800 pt-2">Thank you</p>
              </div>
            </div>

            {/* Quotation Actions Panel */}
            <div className="bg-white rounded-xl border border-gray-200/80 p-5 space-y-3 shadow-xs">
              <h5 className="text-xs font-bold text-gray-900">
                Quotation Actions
              </h5>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <button
                  type="button"
                  onClick={() => alert("Downloading official PDF for " + selectedItem.name)}
                  className="flex items-center justify-center gap-2 py-2.5 px-4 bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 rounded-xl text-xs font-bold transition-colors"
                >
                  <Image
                    src="/icons/file.svg"
                    alt="PDF"
                    width={16}
                    height={16}
                    className="opacity-70"
                  />
                  <span>Download pdf</span>
                </button>

                <button
                  type="button"
                  onClick={() => alert("Quotation converted to official Invoice!")}
                  className="flex items-center justify-center gap-2 py-2.5 px-4 bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 rounded-xl text-xs font-bold transition-colors"
                >
                  <Image
                    src="/icons/file.svg"
                    alt="Invoice"
                    width={16}
                    height={16}
                    className="opacity-70"
                  />
                  <span>Convert to Invoice</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
