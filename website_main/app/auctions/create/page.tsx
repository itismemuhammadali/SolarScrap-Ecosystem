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
  Camera,
  MapPin,
  Phone,
  Check,
  ChevronDown,
  ChevronUp,
  Trash2,
  CheckCircle,
  Sun,
  Battery,
  Cpu,
  Cable,
  Grid3X3,
  Boxes,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";
import { navItems } from "../../components/nav-items";

interface EquipmentListing {
  category: string;
  fullName: string;
  phoneNumber: string;
  email: string;
  numberOfUnits: string;
  watts: string;
  priceDemand: string;
  city: string;
  locality: string;
  completeAddress: string;
  condition: string;
  manufacturer: string;
  purchaseYear: string;
  weight: string;
  reason: string;
}

const initialListing: EquipmentListing = {
  category: "Solar Panels",
  fullName: "Abdul Rehman",
  phoneNumber: "+92 301 2345678",
  email: "abdul@suntech.com",
  numberOfUnits: "200",
  watts: "400",
  priceDemand: "Rs 45,000,000",
  city: "Karachi",
  locality: "DHA Phase 7, Karachi",
  completeAddress: "DHA Phase 7, Sector B, Plot 42, Karachi",
  condition: "Scrap",
  manufacturer: "Waaree Energies",
  purchaseYear: "2019",
  weight: "~2,400 kg",
  reason: "Project Decommission",
};

const categories = [
  { id: "Solar Panels", label: "Solar Panels", icon: Sun },
  { id: "Batteries", label: "Batteries", icon: Battery },
  { id: "Inverters", label: "Inverters", icon: Cpu },
  { id: "Cables", label: "Cables", icon: Cable },
  { id: "Structure", label: "Structure", icon: Grid3X3 },
  { id: "Complete Solar System", label: "Complete Solar System", icon: Boxes },
];

const conditions = [
  "Scrap",
  "Bullet Hit",
  "Shatter glass",
  "Good Conditions",
  "Other",
];

export default function CreateAuctionPage() {
  const router = useRouter();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [topSearch, setTopSearch] = useState("");

  // Primary Listing State
  const [selectedCategory, setSelectedCategory] = useState("Solar Panels");
  const [listing, setListing] = useState<EquipmentListing>(initialListing);
  const [selectedCondition, setSelectedCondition] = useState("Scrap");

  // Secondary Category Listing (Step 2 - Multi-equipment)
  const [hasSecondListing, setHasSecondListing] = useState(false);
  const [secondCategoryOpen, setSecondCategoryOpen] = useState(true);
  const [secondCategory, setSecondCategory] = useState("Batteries");
  const [secondListing, setSecondListing] = useState<EquipmentListing>({
    category: "Batteries",
    fullName: "Abdul Rehman",
    phoneNumber: "+92 301 2345678",
    email: "abdul@suntech.com",
    numberOfUnits: "16",
    watts: "100Ah",
    priceDemand: "Rs 1,200,000",
    city: "Karachi",
    locality: "DHA Phase 7, Karachi",
    completeAddress: "DHA Phase 7, Sector B, Plot 42, Karachi",
    condition: "Good Conditions",
    manufacturer: "Narada LiFePO4",
    purchaseYear: "2021",
    weight: "~600 kg",
    reason: "Capacity Upgrade",
  });

  const [toast, setToast] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 3500);
  };

  const handleClearListing = () => {
    setListing({
      category: selectedCategory,
      fullName: "",
      phoneNumber: "",
      email: "",
      numberOfUnits: "",
      watts: "",
      priceDemand: "",
      city: "",
      locality: "",
      completeAddress: "",
      condition: "Scrap",
      manufacturer: "",
      purchaseYear: "",
      weight: "",
      reason: "",
    });
    showToast("Listing form cleared.");
  };

  const handleSubmitAuction = () => {
    showToast("Auction listing submitted successfully! Redirecting...");
    setTimeout(() => {
      router.push("/auctions");
    }, 1500);
  };

  return (
    <div className="flex h-screen bg-[#F8F9FA] overflow-hidden">
      {/* Toast Notification */}
      {toast && (
        <div className="fixed top-6 right-6 z-50 bg-[#009845] text-white px-5 py-3 rounded-xl shadow-lg flex items-center gap-2 text-sm font-semibold animate-fade-in">
          <CheckCircle className="w-5 h-5" />
          <span>{toast}</span>
        </div>
      )}

      {/* Unified Sidebar Navigation matching Quotation History */}
      <Sidebar
        activeItem="Auctions"
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
          <div className="max-w-6xl mx-auto space-y-8">
            {/* Title Header */}
            <div>
              <h1 className="text-2xl font-bold text-gray-900 tracking-tight">
                Create Auction
              </h1>
              <p className="text-sm text-gray-500 mt-1">
                select the Equipment and create your own auction.
              </p>
            </div>

            {/* Equipment Category Selection Cards */}
            <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3 sm:gap-4">
              {categories.map((cat) => {
                const isSelected = selectedCategory === cat.id;
                const Icon = cat.icon;
                return (
                  <button
                    key={cat.id}
                    type="button"
                    onClick={() => setSelectedCategory(cat.id)}
                    className={`relative p-4 rounded-2xl border flex flex-col items-center justify-center gap-3 transition-all ${
                      isSelected
                        ? "border-[#009845] bg-emerald-50/40 shadow-xs ring-1 ring-[#009845]"
                        : "border-gray-200 bg-white hover:border-gray-300 hover:bg-gray-50/80"
                    }`}
                  >
                    <div
                      className={`w-12 h-12 rounded-xl flex items-center justify-center ${
                        isSelected
                          ? "bg-[#009845] text-white"
                          : "bg-gray-100 text-gray-600"
                      }`}
                    >
                      <Icon className="w-6 h-6" />
                    </div>
                    <span
                      className={`text-xs font-bold text-center ${
                        isSelected ? "text-[#009845]" : "text-gray-700"
                      }`}
                    >
                      {cat.label}
                    </span>
                    {isSelected && (
                      <span className="w-2 h-2 rounded-full bg-[#009845]"></span>
                    )}
                  </button>
                );
              })}
            </div>

            {/* Section 1: Equipment Details Form */}
            <div className="bg-white rounded-2xl border border-gray-100 p-6 sm:p-8 shadow-xs space-y-6">
              <div className="flex items-center gap-2.5 pb-4 border-b border-gray-100">
                <div className="w-7 h-7 rounded-lg bg-emerald-100 text-[#009845] flex items-center justify-center">
                  <Sun className="w-4 h-4" />
                </div>
                <h3 className="text-base font-bold text-gray-900">
                  {selectedCategory} Details:
                </h3>
              </div>

              {/* Form Grid */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                    Full Name
                  </label>
                  <input
                    type="text"
                    value={listing.fullName}
                    onChange={(e) =>
                      setListing({ ...listing, fullName: e.target.value })
                    }
                    placeholder="Karachi"
                    className="w-full px-3.5 py-2.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                    Phone Number
                  </label>
                  <input
                    type="text"
                    value={listing.phoneNumber}
                    onChange={(e) =>
                      setListing({ ...listing, phoneNumber: e.target.value })
                    }
                    placeholder="+92 3012345678"
                    className="w-full px-3.5 py-2.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                    Email address
                  </label>
                  <input
                    type="email"
                    value={listing.email}
                    onChange={(e) =>
                      setListing({ ...listing, email: e.target.value })
                    }
                    placeholder="abdul@suntech.com"
                    className="w-full px-3.5 py-2.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                    Number of Units / Panels
                  </label>
                  <input
                    type="text"
                    value={listing.numberOfUnits}
                    onChange={(e) =>
                      setListing({ ...listing, numberOfUnits: e.target.value })
                    }
                    placeholder="e.g. 200"
                    className="w-full px-3.5 py-2.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                    Watts per Panel / Capacity
                  </label>
                  <input
                    type="text"
                    value={listing.watts}
                    onChange={(e) =>
                      setListing({ ...listing, watts: e.target.value })
                    }
                    placeholder="400"
                    className="w-full px-3.5 py-2.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                    Price Demand
                  </label>
                  <input
                    type="text"
                    value={listing.priceDemand}
                    onChange={(e) =>
                      setListing({ ...listing, priceDemand: e.target.value })
                    }
                    placeholder="Rs 45,000,000"
                    className="w-full px-3.5 py-2.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                    City
                  </label>
                  <input
                    type="text"
                    value={listing.city}
                    onChange={(e) =>
                      setListing({ ...listing, city: e.target.value })
                    }
                    placeholder="Karachi"
                    className="w-full px-3.5 py-2.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                    Area / Locality (Optional)
                  </label>
                  <input
                    type="text"
                    value={listing.locality}
                    onChange={(e) =>
                      setListing({ ...listing, locality: e.target.value })
                    }
                    placeholder="DHA Phase 7, Karachi"
                    className="w-full px-3.5 py-2.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                    Complete Address
                  </label>
                  <input
                    type="text"
                    value={listing.completeAddress}
                    onChange={(e) =>
                      setListing({
                        ...listing,
                        completeAddress: e.target.value,
                      })
                    }
                    placeholder="Any defects, special conditions, original info..."
                    className="w-full px-3.5 py-2.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>
              </div>

              {/* Panel Condition */}
              <div className="space-y-2 pt-2">
                <label className="block text-xs font-semibold text-gray-700">
                  Panel Condition
                </label>
                <div className="flex flex-wrap gap-2.5">
                  {conditions.map((c) => {
                    const isSelected = selectedCondition === c;
                    return (
                      <button
                        key={c}
                        type="button"
                        onClick={() => setSelectedCondition(c)}
                        className={`px-5 py-2 rounded-xl text-xs font-semibold border transition-all ${
                          isSelected
                            ? "border-[#009845] bg-emerald-50 text-[#009845] ring-1 ring-[#009845]"
                            : "border-gray-200 bg-white text-gray-600 hover:border-gray-300"
                        }`}
                      >
                        {c}
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Add Images Slots */}
              <div className="space-y-2 pt-2">
                <label className="block text-xs font-semibold text-gray-700">
                  Add images:
                </label>
                <div className="grid grid-cols-2 sm:grid-cols-5 gap-3">
                  {[1, 2, 3, 4, 5].map((slot) => (
                    <div
                      key={slot}
                      className="border-2 border-dashed border-gray-200 hover:border-[#009845] rounded-xl p-4 flex flex-col items-center justify-center gap-2 cursor-pointer transition-colors bg-gray-50/50 hover:bg-emerald-50/20 aspect-square"
                      onClick={() => showToast(`Upload photo slot #${slot}`)}
                    >
                      <Camera className="w-5 h-5 text-gray-400" />
                      <span className="text-[11px] font-medium text-gray-500">
                        Add Photo
                      </span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Clear Listing Button */}
              <div className="flex justify-end pt-2">
                <button
                  type="button"
                  onClick={handleClearListing}
                  className="px-4 py-2 text-xs font-semibold text-gray-600 hover:text-red-500 border border-gray-200 hover:border-red-200 rounded-lg transition-colors"
                >
                  Clear Listing
                </button>
              </div>
            </div>

            {/* Live Listing Preview Card */}
            <div className="space-y-3">
              <span className="inline-block px-3 py-1 bg-sky-100 text-sky-800 rounded-full text-xs font-bold">
                Preview
              </span>

              <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 bg-white rounded-2xl border border-gray-100 p-6 sm:p-8 shadow-xs">
                {/* Left Preview Details */}
                <div className="lg:col-span-7 space-y-4">
                  <div>
                    <h3 className="text-xl font-bold text-gray-900">
                      {listing.numberOfUnits || "200"}x {listing.category}{" "}
                      {listing.watts ? `${listing.watts}W` : ""}
                    </h3>
                    <p className="text-xs text-gray-500 mt-0.5">
                      {listing.category} · {selectedCondition}
                    </p>
                  </div>

                  <div className="border border-gray-100 rounded-xl overflow-hidden divide-y divide-gray-100 text-xs">
                    <div className="flex justify-between py-2.5 px-4 bg-gray-50/50">
                      <span className="text-gray-500">Equipment</span>
                      <span className="font-semibold text-gray-800">
                        {listing.numberOfUnits || "200"} {listing.category},{" "}
                        {listing.watts ? `${listing.watts}W each` : ""}
                      </span>
                    </div>
                    <div className="flex justify-between py-2.5 px-4">
                      <span className="text-gray-500">Manufacturer</span>
                      <span className="font-semibold text-gray-800">
                        {listing.manufacturer}
                      </span>
                    </div>
                    <div className="flex justify-between py-2.5 px-4 bg-gray-50/50">
                      <span className="text-gray-500">Purchase Year</span>
                      <span className="font-semibold text-gray-800">
                        {listing.purchaseYear}
                      </span>
                    </div>
                    <div className="flex justify-between py-2.5 px-4">
                      <span className="text-gray-500">Weight</span>
                      <span className="font-semibold text-gray-800">
                        {listing.weight}
                      </span>
                    </div>
                    <div className="flex justify-between py-2.5 px-4 bg-gray-50/50">
                      <span className="text-gray-500">Reason</span>
                      <span className="font-semibold text-gray-800">
                        {listing.reason}
                      </span>
                    </div>
                  </div>
                </div>

                {/* Right Preview Images & Contact */}
                <div className="lg:col-span-5 space-y-4">
                  <div>
                    <h4 className="text-xs font-bold text-gray-700 mb-2">
                      Images (3)
                    </h4>
                    <div className="grid grid-cols-4 gap-2">
                      <div className="aspect-square bg-slate-200 rounded-lg overflow-hidden relative">
                        <Image
                          src="/images/seller-post-image.jpg"
                          alt="Solar Scrap Item"
                          fill
                          className="object-cover"
                        />
                      </div>
                      <div className="aspect-square bg-slate-200 rounded-lg overflow-hidden relative">
                        <Image
                          src="/images/scrap-dealers-image.jpg"
                          alt="Solar Panels"
                          fill
                          className="object-cover"
                        />
                      </div>
                      <div className="aspect-square bg-slate-200 rounded-lg overflow-hidden relative">
                        <Image
                          src="/images/change-password.jpg"
                          alt="Item photo"
                          fill
                          className="object-cover"
                        />
                      </div>
                      <div className="aspect-square bg-slate-800 rounded-lg flex items-center justify-center text-white font-bold text-xs">
                        7+
                      </div>
                    </div>
                  </div>

                  <div className="bg-gray-50 rounded-xl p-4 space-y-2 text-xs">
                    <h4 className="font-bold text-gray-800">Location & Contact</h4>
                    <div className="flex items-center gap-2 text-gray-600">
                      <MapPin className="w-4 h-4 text-emerald-600 shrink-0" />
                      <span>{listing.locality || "DHA Phase 7, Karachi"}</span>
                    </div>
                    <div className="flex items-center gap-2 text-gray-600">
                      <Phone className="w-4 h-4 text-emerald-600 shrink-0" />
                      <span>{listing.phoneNumber || "+92 1234 56789"}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Step 2 Multi-Category Accordion */}
            {hasSecondListing && (
              <div className="bg-white rounded-2xl border border-gray-100 p-6 sm:p-8 shadow-xs space-y-6">
                <div
                  className="flex items-center justify-between cursor-pointer"
                  onClick={() => setSecondCategoryOpen(!secondCategoryOpen)}
                >
                  <div className="flex items-center gap-2.5">
                    <div className="w-7 h-7 rounded-lg bg-emerald-100 text-[#009845] flex items-center justify-center">
                      <Battery className="w-4 h-4" />
                    </div>
                    <h3 className="text-base font-bold text-gray-900">
                      {secondCategory} Details (Item #2)
                    </h3>
                  </div>
                  <div className="flex items-center gap-2">
                    <button
                      type="button"
                      onClick={(e) => {
                        e.stopPropagation();
                        setHasSecondListing(false);
                      }}
                      className="text-xs text-red-500 hover:text-red-600 font-medium mr-2"
                    >
                      Remove
                    </button>
                    {secondCategoryOpen ? (
                      <ChevronUp className="w-5 h-5 text-gray-400" />
                    ) : (
                      <ChevronDown className="w-5 h-5 text-gray-400" />
                    )}
                  </div>
                </div>

                {secondCategoryOpen && (
                  <div className="space-y-6 pt-4 border-t border-gray-100">
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
                      <div>
                        <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                          Units / Qty
                        </label>
                        <input
                          type="text"
                          value={secondListing.numberOfUnits}
                          onChange={(e) =>
                            setSecondListing({
                              ...secondListing,
                              numberOfUnits: e.target.value,
                            })
                          }
                          className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800"
                        />
                      </div>
                      <div>
                        <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                          Capacity
                        </label>
                        <input
                          type="text"
                          value={secondListing.watts}
                          onChange={(e) =>
                            setSecondListing({
                              ...secondListing,
                              watts: e.target.value,
                            })
                          }
                          className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800"
                        />
                      </div>
                      <div>
                        <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                          Price Demand
                        </label>
                        <input
                          type="text"
                          value={secondListing.priceDemand}
                          onChange={(e) =>
                            setSecondListing({
                              ...secondListing,
                              priceDemand: e.target.value,
                            })
                          }
                          className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800"
                        />
                      </div>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Bottom Action Buttons */}
            <div className="flex flex-col sm:flex-row items-center justify-end gap-3 pt-4 border-t border-gray-200">
              {!hasSecondListing && (
                <button
                  type="button"
                  onClick={() => {
                    setHasSecondListing(true);
                    showToast("Added second item section (Batteries) to this auction.");
                  }}
                  className="w-full sm:w-auto px-6 py-3 border border-[#009845] text-[#009845] hover:bg-emerald-50/50 rounded-xl text-xs font-bold transition-colors"
                >
                  Create Another Listing
                </button>
              )}

              <button
                type="button"
                onClick={handleSubmitAuction}
                className="w-full sm:w-auto px-8 py-3 bg-[#009845] hover:bg-[#00823b] text-white rounded-xl text-xs font-bold shadow-xs transition-colors"
              >
                Submit Listing
              </button>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
