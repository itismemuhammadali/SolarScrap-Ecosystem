"use client";

import { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import {
  ShieldCheck,
  CheckCircle2,
  Phone,
  MessageCircle,
  Clock,
  Truck,
  DollarSign,
  Star,
  MapPin,
  Sparkles,
  ArrowRight,
  TrendingUp,
  AlertCircle,
  HelpCircle,
  ChevronRight,
  Loader2,
  Building2,
  Lock,
  Layers,
  Zap,
} from "lucide-react";
import { submitPublicLead } from "@/lib/admin-api";

const CATEGORIES = [
  {
    id: "Solar Panels",
    name: "Solar Panels",
    desc: "Mono, Poly, Broken, Grade B/C",
    image: "/images/solar-panel.jpg",
    icon: "☀️",
    rate: "PKR 38 – 55 / Watt",
  },
  {
    id: "Inverters",
    name: "Inverters",
    desc: "Hybrid, On-Grid, Off-Grid, Industrial",
    image: "/images/inverter.png",
    icon: "⚡",
    rate: "PKR 25k – 350k / Unit",
  },
  {
    id: "Batteries",
    name: "Batteries",
    desc: "Lithium LiFePO4, Tubular, Gel, Lead Acid",
    image: "/images/battery.jpg",
    icon: "🔋",
    rate: "PKR 330 – 380 / kg",
  },
  {
    id: "Cables",
    name: "Cables & Wires",
    desc: "Solar DC, AC Armored, Pure Copper Scrap",
    image: "/images/cables.jpg",
    icon: "🔌",
    rate: "PKR 2,400 – 2,650 / kg",
  },
  {
    id: "Structure",
    name: "Mounting Structures",
    desc: "GI Channels, Aluminum Rails, MS Frames",
    image: "/images/structure.png",
    icon: "🏗️",
    rate: "PKR 140 – 210 / kg",
  },
  {
    id: "Complete System",
    name: "Complete Plant",
    desc: "Decommissioned 20kW – 500kW+ Plants",
    image: "/images/complete-solar-system.jpg",
    icon: "🏭",
    rate: "Bulk Project Valuation",
  },
];

const CATEGORY_CONFIG: Record<
  string,
  {
    quantityLabel: string;
    quantityPlaceholder: string;
    conditions: { id: string; label: string }[];
    specLabel: string;
    specPlaceholder: string;
  }
> = {
  "Solar Panels": {
    quantityLabel: "Number of Solar Panels",
    quantityPlaceholder: "e.g. 50 Panels, 120 Panels...",
    conditions: [
      { id: "Working", label: "Working / Surplus" },
      { id: "Low Output / Defective", label: "Low Output / Minor Fault" },
      { id: "Broken / Scrap", label: "Broken Glass / Scrap" },
    ],
    specLabel: "Watts per Panel & Brand (from Section 9.2)",
    specPlaceholder: "e.g. 400W Mono PERC, 540W Longi, Canadian Solar, Jinko...",
  },
  "Inverters": {
    quantityLabel: "Number of Inverters / Units",
    quantityPlaceholder: "e.g. 1 Unit, 3 Inverters...",
    conditions: [
      { id: "Working", label: "Working / Reusable" },
      { id: "Faulty PCB", label: "Faulty PCB / Error Code" },
      { id: "Burnt / Dead", label: "Burnt / Dead Scrap" },
    ],
    specLabel: "Company / Brand Name & Rated Power",
    specPlaceholder: "e.g. Huawei Sun2000 10kW Hybrid, GoodWe 20kW, Sungrow...",
  },
  "Batteries": {
    quantityLabel: "Battery Quantity or Total Weight",
    quantityPlaceholder: "e.g. 16 Batteries or 450 kg...",
    conditions: [
      { id: "Backup Reduced", label: "Backup Reduced" },
      { id: "Dead / Discharged", label: "Dead / Discharged" },
      { id: "Swollen / Scrap", label: "Swollen / Heavy Scrap" },
    ],
    specLabel: "Battery Type & Ah / Voltage Details",
    specPlaceholder: "e.g. Lithium LiFePO4 48V 100Ah, Tubular 200Ah, Gel...",
  },
  "Cables": {
    quantityLabel: "Total Weight (kg) or Length (Meters)",
    quantityPlaceholder: "e.g. 250 kg Copper or 800 meters...",
    conditions: [
      { id: "Pure Copper Scrap", label: "Pure Copper Scrap" },
      { id: "Mixed Insulated", label: "Mixed Insulated Cables" },
      { id: "Unused Fresh Roll", label: "New / Unused Rolls" },
    ],
    specLabel: "Cable Thickness / Size Specification",
    specPlaceholder: "e.g. Solar DC 4mm/6mm, 4-core AC Armored 16mm/25mm...",
  },
  "Structure": {
    quantityLabel: "Approx. Weight (kg) or Structure for X Panels",
    quantityPlaceholder: "e.g. 600 kg GI or Structure for 40 Panels...",
    conditions: [
      { id: "Good Condition", label: "Good Reusable" },
      { id: "Bent / Dismantled", label: "Bent / Dismantled" },
      { id: "Rusted / Scrap Metal", label: "Rusted Metal Scrap" },
    ],
    specLabel: "Mounting Structure Type & Material",
    specPlaceholder: "e.g. Hot-Dip Galvanized Iron (GI), Aluminum Rails, L2/L3...",
  },
  "Complete System": {
    quantityLabel: "Total Plant Capacity (kW / MW)",
    quantityPlaceholder: "e.g. 30 kW Commercial, 100 kW Rooftop, 500 kW...",
    conditions: [
      { id: "Operational", label: "Operational Plant" },
      { id: "Decommissioned", label: "Decommissioned System" },
      { id: "Damaged", label: "Storm / Fire Damaged" },
    ],
    specLabel: "Plant Details & Inclusions",
    specPlaceholder: "e.g. Factory Rooftop Plant with Inverters + Structure + Cables...",
  },
};

const CITIES = [
  "Karachi",
  "Lahore",
  "Islamabad",
  "Rawalpindi",
  "Faisalabad",
  "Multan",
  "Gujranwala",
  "Peshawar",
  "Quetta",
  "Sialkot",
  "Hyderabad",
  "Other",
];

export default function FacebookLeadPage() {
  const [intent, setIntent] = useState<"Selling Scrap" | "Buying in Bulk">("Selling Scrap");
  const [selectedCategory, setSelectedCategory] = useState("Solar Panels");
  const [condition, setCondition] = useState("Broken / Scrap");
  const [quantity, setQuantity] = useState("");
  const [specs, setSpecs] = useState("");
  const [askingPrice, setAskingPrice] = useState("");
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [email, setEmail] = useState("");
  const [city, setCity] = useState("Karachi");
  const [area, setArea] = useState("");
  const [remarks, setRemarks] = useState("");

  const activeConfig = CATEGORY_CONFIG[selectedCategory] || CATEGORY_CONFIG["Solar Panels"];

  const handleCategorySelect = (catId: string) => {
    setSelectedCategory(catId);
    const cfg = CATEGORY_CONFIG[catId];
    if (cfg && cfg.conditions.length > 0) {
      setCondition(cfg.conditions[0].id);
    }
  };

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [submittedLead, setSubmittedLead] = useState<{
    lead_id: string;
    name: string;
    phone: string;
    city: string;
    category: string;
  } | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage("");

    if (!name.trim()) {
      setErrorMessage("Please enter your name.");
      return;
    }

    const cleanPhone = phone.trim();
    if (!cleanPhone || cleanPhone.length < 10) {
      setErrorMessage("Please enter a valid Pakistani mobile/WhatsApp number.");
      return;
    }

    setIsSubmitting(true);

    try {
      const combinedSpecs = [condition, specs.trim()].filter(Boolean).join(" | ");
      const res = await submitPublicLead({
        name: name.trim(),
        phone: cleanPhone,
        email: email.trim() || undefined,
        city: city.trim(),
        area: area.trim() || undefined,
        category: selectedCategory,
        quantity: quantity.trim() || undefined,
        specs: combinedSpecs,
        asking_price: askingPrice.trim() || undefined,
        remarks: remarks.trim() || undefined,
        intent: intent,
        source: "Meta / Facebook Ad Campaign",
      });

      setSubmittedLead({
        lead_id: res.lead_id || "FB-LEAD",
        name: name.trim(),
        phone: cleanPhone,
        city: city.trim(),
        category: selectedCategory,
      });
      window.scrollTo({ top: 0, behavior: "smooth" });
    } catch (err: any) {
      console.error(err);
      setErrorMessage(err.message || "Failed to submit. Please check your connection and try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleReset = () => {
    setSubmittedLead(null);
    setQuantity("");
    setSpecs("");
    setAskingPrice("");
    setName("");
    setPhone("");
    setEmail("");
    setArea("");
    setRemarks("");
  };

  return (
    <div className="min-h-screen bg-[#F8FAFC] text-gray-900 flex flex-col selection:bg-[#009845]/20 selection:text-[#009845]">
      {/* Top Banner Notice: Official Meta Ad Landing Portal */}
      <div className="bg-[#009845] text-white text-xs font-semibold py-2 px-4 text-center flex items-center justify-center gap-2 shadow-xs">
        <Sparkles className="w-3.5 h-3.5 text-amber-300 animate-pulse" />
        <span>Official SolarScrap Pakistan Partner Offer — Free Site Valuation & Instant Cash Payment</span>
      </div>

      {/* Standalone Brand Header (NO admin sidebar, NO admin links) */}
      <header className="sticky top-0 z-30 bg-white/95 backdrop-blur-md border-b border-gray-200/80 px-4 sm:px-8 py-3.5">
        <div className="max-w-6xl mx-auto flex items-center justify-between gap-3">
          {/* Official SolarScrap Brand Logo from /images */}
          <div className="flex items-center gap-3">
            <Image
              src="/images/solar-scrap-img.png"
              alt="Solar Scrap"
              width={165}
              height={55}
              className="w-[135px] sm:w-[160px] h-auto object-contain"
              priority
            />
            <span className="hidden sm:inline-block px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-50 text-[#009845] border border-emerald-200 uppercase tracking-wider">
              Verified Partner
            </span>
          </div>

          {/* Direct WhatsApp Call/Chat Helpline */}
          <div className="flex items-center gap-2 sm:gap-3">
            <a
              href="https://wa.me/923001234567?text=Hi%20SolarScrap,%20I%20saw%20your%20Facebook%20ad%20and%20want%20to%20sell%20solar%20scrap."
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-1.5 px-3 sm:px-4 py-1.5 sm:py-2 bg-[#25D366]/10 hover:bg-[#25D366]/20 text-[#128C7E] border border-[#25D366]/30 rounded-full text-xs font-bold transition-all"
            >
              <MessageCircle className="w-3.5 h-3.5 text-[#25D366] fill-[#25D366]" />
              <span className="hidden sm:inline">WhatsApp Us:</span>
              <span className="font-mono text-xs">+92 300 1234567</span>
            </a>
          </div>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="flex-1 max-w-6xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-6 sm:py-10">
        {submittedLead ? (
          /* ================= SUCCESS CONFIRMATION VIEW ================= */
          <div className="max-w-xl mx-auto bg-white rounded-3xl p-6 sm:p-10 border border-gray-200/90 shadow-xl text-center animate-fadeIn">
            {/* Animated Green Badge */}
            <div className="w-16 h-16 mx-auto rounded-full bg-emerald-50 border-2 border-emerald-200 flex items-center justify-center text-[#009845] shadow-xs mb-4">
              <CheckCircle2 className="w-9 h-9 text-[#009845]" />
            </div>

            <span className="px-3 py-1 rounded-full text-xs font-bold bg-[#009845]/10 text-[#009845] border border-[#009845]/20 font-mono">
              Reference ID: {submittedLead.lead_id}
            </span>

            <h1 className="text-xl sm:text-2xl font-black text-gray-900 tracking-tight mt-3">
              Inquiry Received Successfully!
            </h1>
            <p className="text-xs sm:text-sm text-gray-600 mt-2 max-w-md mx-auto leading-relaxed">
              Thank you, <strong className="text-gray-900">{submittedLead.name}</strong>! Our solar scrap evaluation
              officer for <strong className="text-gray-900">{submittedLead.city}</strong> will contact you on{" "}
              <strong className="text-[#009845]">{submittedLead.phone}</strong> within 15–30 minutes with our best offer.
            </p>

            {/* Next Steps Card */}
            <div className="mt-6 p-4 sm:p-5 bg-gray-50/90 rounded-2xl border border-gray-100 text-left text-xs space-y-3">
              <p className="font-bold text-gray-900 flex items-center gap-1.5">
                <Clock className="w-4 h-4 text-[#009845]" />
                What happens next?
              </p>
              <div className="space-y-2 text-gray-600">
                <div className="flex items-start gap-2">
                  <span className="w-5 h-5 rounded-full bg-emerald-100 text-[#009845] font-bold text-[10px] flex items-center justify-center shrink-0 mt-0.5">
                    1
                  </span>
                  <span>We evaluate your <strong>{submittedLead.category}</strong> based on today&apos;s live scrap market prices.</span>
                </div>
                <div className="flex items-start gap-2">
                  <span className="w-5 h-5 rounded-full bg-emerald-100 text-[#009845] font-bold text-[10px] flex items-center justify-center shrink-0 mt-0.5">
                    2
                  </span>
                  <span>We contact you with a guaranteed price offer & free doorstep pickup schedule.</span>
                </div>
                <div className="flex items-start gap-2">
                  <span className="w-5 h-5 rounded-full bg-emerald-100 text-[#009845] font-bold text-[10px] flex items-center justify-center shrink-0 mt-0.5">
                    3
                  </span>
                  <span>100% advance cash or bank transfer payment before loading your equipment.</span>
                </div>
              </div>
            </div>

            {/* Instant WhatsApp Action */}
            <div className="mt-6 space-y-3">
              <a
                href={`https://wa.me/923001234567?text=Hello%20SolarScrap,%20I%20just%20submitted%20lead%20${submittedLead.lead_id}%20for%20${encodeURIComponent(
                  submittedLead.category
                )}%20in%20${encodeURIComponent(submittedLead.city)}.%20Please%20provide%20my%20quote.`}
                target="_blank"
                rel="noopener noreferrer"
                className="w-full py-3.5 px-5 bg-[#25D366] hover:bg-[#1EBE5D] text-white font-bold text-xs sm:text-sm rounded-xl shadow-md transition-all flex items-center justify-center gap-2"
              >
                <MessageCircle className="w-4 h-4 fill-white" />
                <span>Chat Instantly on WhatsApp</span>
                <ArrowRight className="w-4 h-4" />
              </a>

              <button
                type="button"
                onClick={handleReset}
                className="w-full py-2.5 px-4 bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 font-semibold text-xs rounded-xl transition-colors cursor-pointer"
              >
                Submit Another Item / Inquiry
              </button>
            </div>
          </div>
        ) : (
          /* ================= HERO + LEAD FORM SPLIT VIEW ================= */
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-10 items-start">
            {/* Left Column: Hero, Trust Highlights, Today's Rates (5 Cols) */}
            <div className="lg:col-span-5 space-y-6">
              {/* Badge & Headline */}
              <div>
                <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-50 border border-emerald-200 text-[#009845] text-xs font-bold mb-3">
                  <Sparkles className="w-3.5 h-3.5 text-amber-500" />
                  <span>Meta / Facebook Special Deal</span>
                </div>
                <h1 className="text-2xl sm:text-3xl lg:text-4xl font-black text-gray-900 tracking-tight leading-tight">
                  Turn Your Solar Scrap Into{" "}
                  <span className="text-[#009845] underline decoration-[#009845]/30 decoration-wavy">
                    Instant Cash
                  </span>
                </h1>
                <p className="text-xs sm:text-sm text-gray-600 mt-2.5 leading-relaxed">
                  Get Pakistan&apos;s highest daily market scrap rates for Solar Panels, Inverters, Batteries, Cables &
                  Mounting Structures. 500+ verified buyers ready for immediate pickup.
                </p>
              </div>

              {/* 4 Value Pillars */}
              <div className="grid grid-cols-2 gap-3 pt-1">
                <div className="bg-white p-3.5 rounded-2xl border border-gray-200/80 shadow-2xs">
                  <div className="w-8 h-8 rounded-xl bg-emerald-50 flex items-center justify-center text-[#009845] mb-2 font-bold">
                    <TrendingUp className="w-4 h-4 text-[#009845]" />
                  </div>
                  <h4 className="text-xs font-bold text-gray-900">Highest Daily Rates</h4>
                  <p className="text-[11px] text-gray-500 mt-0.5">Direct factory & recycler prices, no middlemen.</p>
                </div>

                <div className="bg-white p-3.5 rounded-2xl border border-gray-200/80 shadow-2xs">
                  <div className="w-8 h-8 rounded-xl bg-blue-50 flex items-center justify-center text-blue-600 mb-2 font-bold">
                    <DollarSign className="w-4 h-4 text-blue-600" />
                  </div>
                  <h4 className="text-xs font-bold text-gray-900">Immediate Payment</h4>
                  <p className="text-[11px] text-gray-500 mt-0.5">Cash or instant online bank transfer on site.</p>
                </div>

                <div className="bg-white p-3.5 rounded-2xl border border-gray-200/80 shadow-2xs">
                  <div className="w-8 h-8 rounded-xl bg-amber-50 flex items-center justify-center text-amber-600 mb-2 font-bold">
                    <Truck className="w-4 h-4 text-amber-600" />
                  </div>
                  <h4 className="text-xs font-bold text-gray-900">Free Doorstep Pickup</h4>
                  <p className="text-[11px] text-gray-500 mt-0.5">We send transport & labor to your site.</p>
                </div>

                <div className="bg-white p-3.5 rounded-2xl border border-gray-200/80 shadow-2xs">
                  <div className="w-8 h-8 rounded-xl bg-purple-50 flex items-center justify-center text-purple-600 mb-2 font-bold">
                    <ShieldCheck className="w-4 h-4 text-purple-600" />
                  </div>
                  <h4 className="text-xs font-bold text-gray-900">100% Confidential</h4>
                  <p className="text-[11px] text-gray-500 mt-0.5">Verified EPCs & registered scrap traders.</p>
                </div>
              </div>

              {/* Today's Estimated Market Scrap Rates Card */}
              <div className="bg-gradient-to-br from-gray-900 to-gray-800 text-white rounded-2xl p-4 sm:p-5 shadow-lg border border-gray-700/60 space-y-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <span className="w-2 h-2 rounded-full bg-emerald-400 animate-ping" />
                    <span className="text-xs font-bold uppercase tracking-wider text-emerald-400">
                      Today&apos;s Live Scrap Rates
                    </span>
                  </div>
                  <span className="text-[10px] text-gray-400 font-mono">Updated Daily</span>
                </div>

                <div className="divide-y divide-gray-700/60 text-xs">
                  <div className="flex items-center justify-between py-1.5">
                    <span className="text-gray-300">☀️ Solar Panels (Mono/Poly)</span>
                    <span className="font-bold text-emerald-300 font-mono">PKR 38 – 55 / Watt</span>
                  </div>
                  <div className="flex items-center justify-between py-1.5">
                    <span className="text-gray-300">🔋 Solar Batteries (Lead/Gel)</span>
                    <span className="font-bold text-emerald-300 font-mono">PKR 330 – 380 / kg</span>
                  </div>
                  <div className="flex items-center justify-between py-1.5">
                    <span className="text-gray-300">🔌 Pure Copper Solar Cables</span>
                    <span className="font-bold text-emerald-300 font-mono">PKR 2,400 – 2,650 / kg</span>
                  </div>
                  <div className="flex items-center justify-between py-1.5">
                    <span className="text-gray-300">⚡ Inverters (Scrap / Working)</span>
                    <span className="font-bold text-emerald-300 font-mono">PKR 25,000 – 350,000</span>
                  </div>
                </div>
              </div>

              {/* Social Proof Quote */}
              <div className="bg-white rounded-2xl p-4 border border-gray-200/80 flex items-start gap-3 shadow-2xs">
                <div className="w-9 h-9 rounded-full bg-amber-100 flex items-center justify-center text-amber-700 font-black text-sm shrink-0">
                  ★
                </div>
                <div className="text-xs">
                  <p className="text-gray-700 italic">
                    &ldquo;Sold 120 damaged panels from our DHA project in Karachi within 24 hours. Instant cash before
                    loading.&rdquo;
                  </p>
                  <p className="text-[11px] text-gray-400 font-semibold mt-1">
                    — Engr. Tariq Mahmood, Solar EPC Contractor
                  </p>
                </div>
              </div>
            </div>

            {/* Right Column: Interactive Lead Capture Form (7 Cols) */}
            <div className="lg:col-span-7">
              <div className="bg-white rounded-3xl p-5 sm:p-7 md:p-8 border border-gray-200/90 shadow-xl relative overflow-hidden">
                {/* Form Top Header */}
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pb-4 border-b border-gray-100">
                  <div>
                    <h2 className="text-lg sm:text-xl font-bold text-gray-900 tracking-tight flex items-center gap-2">
                      <span>Get Instant Scrap Valuation</span>
                      <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-[#009845] text-white">
                        Free
                      </span>
                    </h2>
                    <p className="text-xs text-gray-500 mt-0.5">
                      Fill in 60 seconds — We respond with valuation within 15 mins.
                    </p>
                  </div>

                  {/* Intent Toggle */}
                  <div className="flex items-center bg-gray-100/90 p-1 rounded-xl shrink-0">
                    <button
                      type="button"
                      onClick={() => setIntent("Selling Scrap")}
                      className={`px-3 py-1 rounded-lg text-xs font-bold transition-all cursor-pointer ${
                        intent === "Selling Scrap"
                          ? "bg-[#009845] text-white shadow-xs"
                          : "text-gray-600 hover:text-gray-900"
                      }`}
                    >
                      Selling Scrap
                    </button>
                    <button
                      type="button"
                      onClick={() => setIntent("Buying in Bulk")}
                      className={`px-3 py-1 rounded-lg text-xs font-bold transition-all cursor-pointer ${
                        intent === "Buying in Bulk"
                          ? "bg-[#009845] text-white shadow-xs"
                          : "text-gray-600 hover:text-gray-900"
                      }`}
                    >
                      Buying Bulk
                    </button>
                  </div>
                </div>

                {/* The Form */}
                <form onSubmit={handleSubmit} className="mt-5 space-y-4">
                  {/* Step 1: Category Selector (Mobile Friendly Clickable Tiles) */}
                  <div>
                    <label className="block text-xs font-bold text-gray-800 mb-2">
                      1. Select Equipment / Scrap Category <span className="text-red-500">*</span>
                    </label>
                    <div className="grid grid-cols-2 sm:grid-cols-3 gap-2 sm:gap-2.5">
                      {CATEGORIES.map((cat) => {
                        const isSelected = selectedCategory === cat.id;
                        return (
                          <button
                            key={cat.id}
                            type="button"
                            onClick={() => handleCategorySelect(cat.id)}
                            className={`p-2.5 sm:p-3 rounded-2xl border text-left transition-all cursor-pointer flex flex-col justify-between relative ${
                              isSelected
                                ? "bg-emerald-50/80 border-[#009845] ring-2 ring-[#009845]/20 shadow-xs"
                                : "bg-gray-50/70 hover:bg-gray-100/80 border-gray-200 text-gray-700"
                            }`}
                          >
                            <div className="flex items-center justify-between">
                              <span className="text-xl">{cat.icon}</span>
                              {isSelected && (
                                <CheckCircle2 className="w-4 h-4 text-[#009845] fill-[#009845]/15 shrink-0" />
                              )}
                            </div>
                            <div className="mt-2">
                              <p className={`text-xs font-bold leading-tight ${isSelected ? "text-[#009845]" : "text-gray-900"}`}>
                                {cat.name}
                              </p>
                              <p className="text-[10px] text-gray-400 truncate mt-0.5">{cat.desc}</p>
                            </div>
                          </button>
                        );
                      })}
                    </div>
                  </div>

                  {/* Step 2: Dynamic Quantity & Condition based on selected category */}
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
                    <div>
                      <label className="block text-xs font-bold text-gray-800 mb-1">
                        2. {activeConfig.quantityLabel}
                      </label>
                      <input
                        type="text"
                        value={quantity}
                        onChange={(e) => setQuantity(e.target.value)}
                        placeholder={activeConfig.quantityPlaceholder}
                        className="w-full px-3.5 py-2.5 bg-gray-50/70 border border-gray-200 rounded-xl text-xs sm:text-sm text-gray-900 outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-bold text-gray-800 mb-1">Condition</label>
                      <div className="grid grid-cols-3 gap-1.5">
                        {activeConfig.conditions.map((c) => (
                          <button
                            key={c.id}
                            type="button"
                            onClick={() => setCondition(c.id)}
                            className={`py-2 px-1 text-[11px] font-semibold rounded-xl border text-center transition-all cursor-pointer truncate ${
                              condition === c.id
                                ? "bg-[#009845] text-white border-[#009845] shadow-xs"
                                : "bg-gray-50 border-gray-200 text-gray-600 hover:bg-gray-100"
                            }`}
                            title={c.label}
                          >
                            {c.label.split("/")[0].trim()}
                          </button>
                        ))}
                      </div>
                    </div>
                  </div>

                  {/* Step 2.5: Category-Specific Specification / Brand input */}
                  <div>
                    <label className="block text-xs font-bold text-gray-800 mb-1">
                      {activeConfig.specLabel} <span className="text-gray-400 font-normal">(Optional)</span>
                    </label>
                    <input
                      type="text"
                      value={specs}
                      onChange={(e) => setSpecs(e.target.value)}
                      placeholder={activeConfig.specPlaceholder}
                      className="w-full px-3.5 py-2.5 bg-gray-50/70 border border-gray-200 rounded-xl text-xs sm:text-sm text-gray-900 outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all"
                    />
                  </div>

                  {/* Step 3: Expected Asking Price (Optional) */}
                  <div>
                    <label className="block text-xs font-bold text-gray-800 mb-1">
                      3. Expected Asking Price (PKR) <span className="text-gray-400 font-normal">(Optional)</span>
                    </label>
                    <div className="relative">
                      <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-xs font-bold text-gray-400 font-mono">
                        PKR
                      </span>
                      <input
                        type="number"
                        value={askingPrice}
                        onChange={(e) => setAskingPrice(e.target.value)}
                        placeholder="Leave blank to receive our best market offer"
                        className="w-full pl-12 pr-3.5 py-2.5 bg-gray-50/70 border border-gray-200 rounded-xl text-xs sm:text-sm text-gray-900 outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all"
                      />
                    </div>
                  </div>

                  {/* Step 4: Contact Information */}
                  <div className="pt-2 border-t border-gray-100 space-y-3">
                    <p className="text-xs font-black text-gray-900 tracking-tight uppercase">
                      4. Your Contact & Location Details
                    </p>

                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                      <div>
                        <label className="block text-xs font-semibold text-gray-700 mb-1">
                          Full Name <span className="text-red-500">*</span>
                        </label>
                        <input
                          type="text"
                          required
                          value={name}
                          onChange={(e) => setName(e.target.value)}
                          placeholder="e.g. Muhammad Ali"
                          className="w-full px-3.5 py-2.5 bg-gray-50/70 border border-gray-200 rounded-xl text-xs sm:text-sm text-gray-900 outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all"
                        />
                      </div>

                      <div>
                        <label className="block text-xs font-semibold text-gray-700 mb-1">
                          WhatsApp / Phone Number <span className="text-red-500">*</span>
                        </label>
                        <div className="relative">
                          <span className="absolute left-3 top-1/2 -translate-y-1/2 text-xs font-bold text-gray-500">
                            🇵🇰 +92
                          </span>
                          <input
                            type="tel"
                            required
                            value={phone}
                            onChange={(e) => setPhone(e.target.value)}
                            placeholder="300 1234567"
                            className="w-full pl-14 pr-3.5 py-2.5 bg-gray-50/70 border border-gray-200 rounded-xl text-xs sm:text-sm text-gray-900 outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all font-mono"
                          />
                        </div>
                      </div>
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                      <div>
                        <label className="block text-xs font-semibold text-gray-700 mb-1">
                          City <span className="text-red-500">*</span>
                        </label>
                        <select
                          value={city}
                          onChange={(e) => setCity(e.target.value)}
                          className="w-full px-3.5 py-2.5 bg-gray-50/70 border border-gray-200 rounded-xl text-xs sm:text-sm text-gray-900 outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all cursor-pointer"
                        >
                          {CITIES.map((c) => (
                            <option key={c} value={c}>
                              {c}
                            </option>
                          ))}
                        </select>
                      </div>

                      <div>
                        <label className="block text-xs font-semibold text-gray-700 mb-1">Area / Location</label>
                        <input
                          type="text"
                          value={area}
                          onChange={(e) => setArea(e.target.value)}
                          placeholder="e.g. SITE Area, DHA, I-9, Sundar"
                          className="w-full px-3.5 py-2.5 bg-gray-50/70 border border-gray-200 rounded-xl text-xs sm:text-sm text-gray-900 outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all"
                        />
                      </div>
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-gray-700 mb-1">
                        Any Additional Details / Brand Names <span className="text-gray-400 font-normal">(Optional)</span>
                      </label>
                      <textarea
                        rows={2}
                        value={remarks}
                        onChange={(e) => setRemarks(e.target.value)}
                        placeholder="e.g. Huawei 10kW inverter with minor fault, 80 Canadian solar panels..."
                        className="w-full px-3.5 py-2 bg-gray-50/70 border border-gray-200 rounded-xl text-xs text-gray-900 outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all resize-none"
                      />
                    </div>
                  </div>

                  {/* Error Message */}
                  {errorMessage && (
                    <div className="p-3 bg-red-50 border border-red-200 rounded-xl text-xs text-red-600 flex items-center gap-2">
                      <AlertCircle className="w-4 h-4 shrink-0 text-red-500" />
                      <span>{errorMessage}</span>
                    </div>
                  )}

                  {/* Submit Button (Mobile Tap Target: 52px height) */}
                  <div className="pt-2">
                    <button
                      type="submit"
                      disabled={isSubmitting}
                      className="w-full min-h-[52px] py-3.5 px-6 bg-[#009845] hover:bg-[#00823B] active:bg-[#007033] text-white font-bold text-sm sm:text-base rounded-2xl shadow-lg hover:shadow-emerald-600/30 transition-all flex items-center justify-center gap-2 cursor-pointer disabled:opacity-60"
                    >
                      {isSubmitting ? (
                        <>
                          <Loader2 className="w-5 h-5 animate-spin" />
                          <span>Submitting Inquiry...</span>
                        </>
                      ) : (
                        <>
                          <Zap className="w-5 h-5 fill-amber-300 text-amber-300" />
                          <span>Get Best Scrap Valuation & Callback</span>
                          <ArrowRight className="w-4 h-4" />
                        </>
                      )}
                    </button>

                    <p className="text-[11px] text-gray-400 text-center mt-2 flex items-center justify-center gap-1.5">
                      <Lock className="w-3 h-3 text-gray-400" />
                      <span>100% Free & Confidential. No spam, guaranteed callback.</span>
                    </p>
                  </div>
                </form>
              </div>
            </div>
          </div>
        )}

        {/* Bottom Social Proof & Trust Badges Section */}
        <section className="mt-12 sm:mt-16 pt-10 border-t border-gray-200/80">
          <div className="text-center max-w-2xl mx-auto mb-8">
            <h3 className="text-lg sm:text-xl font-bold text-gray-900 tracking-tight">
              Trusted by 500+ Solar Companies, EPC Contractors & Scrap Dealers
            </h3>
            <p className="text-xs sm:text-sm text-gray-500 mt-1">
              Pakistan&apos;s most reliable ecosystem for transparent, verified solar scrap recycling and trading.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
            <div className="bg-white p-5 rounded-2xl border border-gray-200/80 shadow-2xs">
              <div className="flex items-center gap-1 text-amber-400 mb-2">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} className="w-3.5 h-3.5 fill-amber-400" />
                ))}
              </div>
              <p className="text-xs text-gray-700 italic">
                &ldquo;We replaced 250 kW plant panels in Multan. SolarScrap sent trucks with weighing scale and transferred
                PKR 4.2M in advance before dispatch.&rdquo;
              </p>
              <p className="text-[11px] font-bold text-gray-900 mt-3">
                Solar Edge Energy — Multan
              </p>
            </div>

            <div className="bg-white p-5 rounded-2xl border border-gray-200/80 shadow-2xs">
              <div className="flex items-center gap-1 text-amber-400 mb-2">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} className="w-3.5 h-3.5 fill-amber-400" />
                ))}
              </div>
              <p className="text-xs text-gray-700 italic">
                &ldquo;As a registered scrap dealer in Lahore, I get continuous verified bulk solar lots directly without
                fraud risks.&rdquo;
              </p>
              <p className="text-[11px] font-bold text-gray-900 mt-3">
                Lahore Green Metals & Scrap Traders
              </p>
            </div>

            <div className="bg-white p-5 rounded-2xl border border-gray-200/80 shadow-2xs">
              <div className="flex items-center gap-1 text-amber-400 mb-2">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} className="w-3.5 h-3.5 fill-amber-400" />
                ))}
              </div>
              <p className="text-xs text-gray-700 italic">
                &ldquo;The rate transparency is unmatched. We get fair market prices for our burnt inverters and copper
                cables with zero hassle.&rdquo;
              </p>
              <p className="text-[11px] font-bold text-gray-900 mt-3">
                Indus Solar Engineering — Karachi
              </p>
            </div>
          </div>
        </section>
      </main>

      {/* Clean Footer (No admin links) */}
      <footer className="mt-12 bg-white border-t border-gray-200/80 py-6 px-4 text-center text-xs text-gray-500 space-y-2">
        <div className="flex items-center justify-center gap-2 text-gray-700 font-bold">
          <span>☀️ SolarScrap Pakistan</span>
          <span>•</span>
          <span>Official Meta Ad Landing Portal</span>
        </div>
        <p className="text-[11px] text-gray-400 max-w-md mx-auto">
          All inquiries submitted through this portal are processed confidentially. Powered by SolarScrap verified dealer network.
        </p>
        <p className="text-[11px] text-gray-400">
          © {new Date().getFullYear()} SolarScrap Technologies. All rights reserved.
        </p>
      </footer>
    </div>
  );
}
