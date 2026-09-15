"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import {
  ArrowLeft,
  Search,
  Bell,
  Plus,
  Trash2,
  CheckCircle,
  Building,
  Calendar,
  MapPin,
  Phone,
  User,
  Mail,
  Download,
  FileText,
} from "lucide-react";
import { getSession, getAvatarUrl } from "@/lib/auth";

interface LineItem {
  id: string;
  name: string;
  qty: number;
  rate: number;
}

export default function CreateQuotationPage() {
  const router = useRouter();

  const [adminName, setAdminName] = useState("Admin Platform");
  const [adminPhotoUrl, setAdminPhotoUrl] = useState<string | null>(null);

  useEffect(() => {
    const session = getSession();
    if (session?.user) {
      if (session.user.display_name) setAdminName(session.user.display_name);
      else if (session.user.email) setAdminName(session.user.email.split("@")[0]);
      if (session.user.profile_photo_url) setAdminPhotoUrl(session.user.profile_photo_url);
    }

    if (typeof window !== "undefined") {
      const sp = new URLSearchParams(window.location.search);
      const nameParam = sp.get("name");
      const phoneParam = sp.get("phone");
      const cityParam = sp.get("city");
      const areaParam = sp.get("area");
      if (nameParam) setCustomerName(nameParam);
      if (phoneParam) setPhone(phoneParam);
      if (cityParam || areaParam) {
        setLocation([areaParam, cityParam].filter(Boolean).join(", "));
      }
    }
  }, []);

  // Form State
  const [customerName, setCustomerName] = useState("");
  const [phone, setPhone] = useState("");
  const [date, setDate] = useState(() => new Date().toISOString().split("T")[0]);
  const [validTill, setValidTill] = useState(() => {
    const d = new Date();
    d.setDate(d.getDate() + 7);
    return d.toISOString().split("T")[0];
  });
  const [location, setLocation] = useState("");
  const [companyName, setCompanyName] = useState("Solar Scrap Official");
  const [adjustment, setAdjustment] = useState<number>(0);
  const [isSaving, setIsSaving] = useState(false);

  // Line items state
  const [items, setItems] = useState<LineItem[]>([
    {
      id: "1",
      name: "Longi 550W Tier-1 Mono PERC Panel (Used)",
      qty: 24,
      rate: 11500,
    },
    {
      id: "2",
      name: "GoodWe 10kW On-Grid Inverter (Working Scrap)",
      qty: 1,
      rate: 185000,
    },
  ]);

  const [toast, setToast] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 3000);
  };

  const SCRAP_PRESETS = [
    { name: "Longi / Canadian 550W Used Solar Panel", qty: 20, rate: 11500 },
    { name: "Inverex Nitrox 8kW Hybrid Inverter", qty: 1, rate: 215000 },
    { name: "Daewoo 200Ah Deep Cycle Tubular Battery", qty: 4, rate: 27500 },
    { name: "16mm Pure Copper DC Solar Cable (Scrap)", qty: 50, rate: 1400 },
    { name: "Galvanized Solar Structure Rails (per kg)", qty: 80, rate: 450 },
  ];

  const addPresetItem = (preset: { name: string; qty: number; rate: number }) => {
    setItems((prev) => [
      ...prev,
      {
        id: Date.now().toString(),
        name: preset.name,
        qty: preset.qty,
        rate: preset.rate,
      },
    ]);
    showToast(`Added ${preset.name}!`);
  };

  const addItem = () => {
    setItems([
      ...items,
      {
        id: Date.now().toString(),
        name: "New Solar Item",
        qty: 1,
        rate: 10000,
      },
    ]);
  };

  const removeItem = (id: string) => {
    if (items.length <= 1) return;
    setItems(items.filter((item) => item.id !== id));
  };

  const updateItem = (
    id: string,
    field: "name" | "qty" | "rate",
    value: string | number
  ) => {
    setItems(
      items.map((item) => {
        if (item.id === id) {
          return { ...item, [field]: value };
        }
        return item;
      })
    );
  };

  const subTotal = items.reduce((sum, item) => sum + item.qty * item.rate, 0);
  const totalOffer = Math.max(0, subTotal - adjustment);

  const formatNumber = (num: number) => {
    return new Intl.NumberFormat("en-PK").format(num);
  };

  const handleSaveAndIssue = () => {
    if (!customerName.trim()) {
      showToast("Please enter a customer name.");
      return;
    }
    setIsSaving(true);
    const newId = `QT-${Date.now().toString().slice(-5)}`;
    const newQuote = {
      id: newId,
      quotationNumber: `#${newId}`,
      name: customerName.trim(),
      avatarLetter: customerName.trim().charAt(0).toUpperCase(),
      company: companyName || "Solar Scrap Client",
      email: `${customerName.trim().toLowerCase().replace(/\s+/g, ".")}@gmail.com`,
      phone: phone || "+92 300 1234567",
      status: "Approved",
      date: date,
      validTill: validTill,
      totalAmount: totalOffer,
      itemsCount: items.length,
      items: items,
      location: location || "Pakistan",
    };

    try {
      const existing = localStorage.getItem("solar_scrap_quotations");
      const list = existing ? JSON.parse(existing) : [];
      localStorage.setItem("solar_scrap_quotations", JSON.stringify([newQuote, ...list]));
      showToast("Quotation & Invoice saved successfully!");
      setTimeout(() => {
        router.push("/quotation-history");
      }, 900);
    } catch (e) {
      console.error(e);
      showToast("Saved locally!");
    } finally {
      setIsSaving(false);
    }
  };

  const [isInvoice, setIsInvoice] = useState(false);

  const handleWhatsAppShare = () => {
    const cleanPhone = phone.replace(/[^0-9]/g, "");
    const lines = items
      .map(
        (it, idx) =>
          `${idx + 1}. ${it.name} x ${it.qty} = PKR ${formatNumber(it.qty * it.rate)}`
      )
      .join("\n");

    const header = isInvoice
      ? "*SOLAR SCRAP OFFICIAL COMMERCIAL INVOICE*"
      : "*SOLAR SCRAP OFFICIAL ESTIMATED QUOTATION*";
    const ref = isInvoice ? "Invoice No: #INV-2024-005" : "Quote No: #QT-2024-005";
    const dateLine = isInvoice
      ? `Invoice Date: ${date}\nDue Date: Upon Receipt / Settled`
      : `Date: ${date}\nValid Till: ${validTill}`;

    const message = `${header}\n${ref}\n${dateLine}\nCustomer: ${customerName || "Valued Client"}\nLocation: ${location || "Pakistan"}\n\n*Line Items:*\n${lines}\n\n*Total Amount:* PKR ${formatNumber(totalOffer)}\n\nThank you for choosing Solar Scrap!`;

    const url = cleanPhone
      ? `https://wa.me/${cleanPhone}?text=${encodeURIComponent(message)}`
      : `https://wa.me/?text=${encodeURIComponent(message)}`;
    window.open(url, "_blank");
  };

  const handlePrintPdf = () => {
    const originalTitle = document.title;
    const cleanCustomer = (customerName || "Customer").trim().replace(/[^a-zA-Z0-9_-]/g, "_");
    const docType = isInvoice ? "Invoice" : "Quotation";
    const refId = isInvoice ? "INV-2024-005" : "QT-2024-005";
    document.title = `Solar_Scrap_${docType}_${cleanCustomer}_${refId}`;
    window.print();
    setTimeout(() => {
      document.title = originalTitle;
    }, 1500);
  };

  return (
    <div className="min-h-screen bg-[#F5F6FA] flex flex-col">
      {/* Toast Notification */}
      {toast && (
        <div className="fixed top-6 right-6 z-50 bg-[#009845] text-white px-5 py-3 rounded-xl shadow-lg flex items-center gap-2 text-sm font-semibold animate-fade-in">
          <CheckCircle className="w-5 h-5" />
          <span>{toast}</span>
        </div>
      )}

      {/* Top Header */}
      <header className="h-20 bg-white border-b border-gray-100 flex items-center justify-between px-6 lg:px-12 shrink-0">
        <div className="flex items-center gap-4 flex-1">
          <div className="relative max-w-md w-full">
            <Search className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search users, posts, auctions, bids..."
              className="w-full pl-10 pr-4 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
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
          <div className="flex items-center gap-3 pl-2">
            <span className="text-sm font-semibold text-gray-800 hidden sm:inline-block">
              {adminName}
            </span>
            <div className="w-9 h-9 rounded-full bg-emerald-700 overflow-hidden ring-1 ring-gray-200 flex items-center justify-center text-white font-bold text-sm select-none">
              {adminPhotoUrl ? (
                /* eslint-disable-next-line @next/next/no-img-element */
                <img
                  src={getAvatarUrl(adminPhotoUrl)!}
                  alt={adminName}
                  className="w-full h-full object-cover"
                />
              ) : (
                <span>{adminName ? adminName.charAt(0).toUpperCase() : "A"}</span>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="flex-1 p-6 lg:p-10 max-w-7xl mx-auto w-full space-y-6 print:p-0 print:m-0 print:max-w-none print:w-full print:space-y-0">
        {/* Back Button */}
        <div className="no-print print:hidden">
          <button
            onClick={() => router.push("/quotation-history")}
            className="inline-flex items-center gap-2 px-6 py-2 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-lg text-sm font-semibold shadow-xs transition-colors cursor-pointer"
          >
            <ArrowLeft className="w-4 h-4 text-gray-500" />
            <span>Back</span>
          </button>
        </div>

        {/* 2-Column Builder Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start print:block print:w-full">
          {/* Left Column: Input Form Card */}
          <div className="lg:col-span-6 bg-white rounded-2xl border border-gray-100 p-6 lg:p-8 shadow-xs space-y-8 print:hidden">
            {/* Customer Header Tag (Exact as Screenshot 3) */}
            <div className="flex items-center justify-between pb-6 border-b border-gray-100">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full overflow-hidden bg-[#009845] text-white flex items-center justify-center font-bold text-sm select-none">
                  <span>{(customerName.trim() || "Kamran Sheikh").charAt(0).toUpperCase()}</span>
                </div>
                <div>
                  <h3 className="text-base font-bold text-gray-900">
                    {customerName.trim() || "Kamran Sheikh"}
                  </h3>
                  <span className="text-xs text-gray-400 font-medium">QT ID: FB001</span>
                </div>
              </div>
              <span className="px-3 py-1 bg-emerald-50 text-[#009845] border border-emerald-200 rounded-full text-xs font-semibold">
                New
              </span>
            </div>

            {/* Section 1: Personal Details */}
            <div className="space-y-4">
              <h4 className="text-sm font-bold text-gray-900">
                Personal details:
              </h4>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1.5">
                    Name:
                  </label>
                  <input
                    type="text"
                    value={customerName}
                    onChange={(e) => setCustomerName(e.target.value)}
                    className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                    placeholder="Kamran sheikh"
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1.5">
                    Phone:
                  </label>
                  <input
                    type="text"
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                    placeholder="+92 301 0000 000"
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1.5">
                    Date:
                  </label>
                  <input
                    type="text"
                    value={date}
                    onChange={(e) => setDate(e.target.value)}
                    className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                    placeholder="DD-MM-YYYY"
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1.5">
                    Valid Till:
                  </label>
                  <input
                    type="text"
                    value={validTill}
                    onChange={(e) => setValidTill(e.target.value)}
                    className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                    placeholder="DD-MM-YYYY"
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1.5">
                    Location:
                  </label>
                  <input
                    type="text"
                    value={location}
                    onChange={(e) => setLocation(e.target.value)}
                    className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                    placeholder="Town-City-Country"
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1.5">
                    Company name:
                  </label>
                  <input
                    type="text"
                    value={companyName}
                    onChange={(e) => setCompanyName(e.target.value)}
                    className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                    placeholder="Solar scrap"
                  />
                </div>
              </div>
            </div>

            {/* Section 2: Item Details */}
            <div className="space-y-4 pt-4 border-t border-gray-100">
              <h4 className="text-sm font-bold text-gray-900">
                Item details:
              </h4>

              <div className="space-y-4">
                {items.map((item, index) => (
                  <div
                    key={item.id}
                    className="p-3.5 rounded-xl bg-gray-50 border border-gray-100 space-y-3 relative group"
                  >
                    <div className="flex items-center justify-between">
                      <span className="text-xs font-bold text-gray-500">
                        Item #{index + 1}
                      </span>
                      {items.length > 1 && (
                        <button
                          type="button"
                          onClick={() => removeItem(item.id)}
                          className="text-gray-400 hover:text-red-500 transition-colors p-1 cursor-pointer"
                          title="Remove Item"
                        >
                          <Trash2 className="w-3.5 h-3.5" />
                        </button>
                      )}
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                      <div>
                        <label className="block text-[11px] font-medium text-gray-600 mb-1">
                          Item Name:
                        </label>
                        <input
                          type="text"
                          value={item.name}
                          onChange={(e) =>
                            updateItem(item.id, "name", e.target.value)
                          }
                          className="w-full px-3 py-1.5 bg-white border border-gray-200 rounded-lg text-xs text-gray-800 focus:outline-none focus:ring-1 focus:ring-[#009845]"
                          placeholder="Solar Panel"
                        />
                      </div>

                      <div>
                        <label className="block text-[11px] font-medium text-gray-600 mb-1">
                          QTY:
                        </label>
                        <input
                          type="number"
                          min="1"
                          value={item.qty}
                          onChange={(e) =>
                            updateItem(
                              item.id,
                              "qty",
                              parseInt(e.target.value) || 0
                            )
                          }
                          className="w-full px-3 py-1.5 bg-white border border-gray-200 rounded-lg text-xs text-gray-800 focus:outline-none focus:ring-1 focus:ring-[#009845]"
                          placeholder="20"
                        />
                      </div>

                      <div>
                        <label className="block text-[11px] font-medium text-gray-600 mb-1">
                          Rate (PKR):
                        </label>
                        <input
                          type="number"
                          min="0"
                          value={item.rate}
                          onChange={(e) =>
                            updateItem(
                              item.id,
                              "rate",
                              parseFloat(e.target.value) || 0
                            )
                          }
                          className="w-full px-3 py-1.5 bg-white border border-gray-200 rounded-lg text-xs text-gray-800 focus:outline-none focus:ring-1 focus:ring-[#009845]"
                          placeholder="000,000"
                        />
                      </div>

                      <div>
                        <label className="block text-[11px] font-medium text-gray-600 mb-1">
                          Amount (PKR):
                        </label>
                        <input
                          type="text"
                          disabled
                          value={formatNumber(item.qty * item.rate)}
                          className="w-full px-3 py-1.5 bg-gray-100/70 border border-gray-200 rounded-lg text-xs font-semibold text-gray-800 cursor-not-allowed"
                        />
                      </div>
                    </div>
                  </div>
                ))}
              </div>

              {/* Subtotals in Form */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-4 border-t border-gray-100">
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1.5">
                    Sub total:
                  </label>
                  <input
                    type="text"
                    disabled
                    value={formatNumber(subTotal)}
                    className="w-full px-3.5 py-2 bg-gray-100/80 border border-gray-200 rounded-xl text-xs font-semibold text-gray-800 cursor-not-allowed"
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1.5">
                    Adjustment:
                  </label>
                  <input
                    type="number"
                    value={adjustment}
                    onChange={(e) =>
                      setAdjustment(parseFloat(e.target.value) || 0)
                    }
                    className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                    placeholder="00"
                  />
                </div>
              </div>

              <div className="flex justify-end pt-1">
                <button
                  type="button"
                  onClick={addItem}
                  className="text-xs font-bold text-[#009845] hover:text-[#00823b] flex items-center gap-1 cursor-pointer"
                >
                  <Plus className="w-3.5 h-3.5" />
                  <span>+ Add Item</span>
                </button>
              </div>
            </div>
          </div>

          {/* Right Column: Live Quotation Document & Actions */}
          <div className="lg:col-span-6 space-y-4 print:w-full print:space-y-0">
            {/* The Isolated Printable Slip matching Figma Exactly */}
            <div
              id="printable-quotation"
              className="bg-white rounded-3xl border border-gray-200/70 p-4 sm:p-5 shadow-sm flex flex-col gap-3 select-none print:border-none print:shadow-none print:p-0 print:m-0 print:w-full print:max-w-none print:gap-4"
            >
              {/* ===================== BOX 1: HEADER & RECIPIENT METADATA ===================== */}
              <div className="print-card bg-[#F4F6F8] rounded-2xl p-4 sm:p-5 print:p-6 print:rounded-2xl border border-gray-200/60">
                {/* Logo & Quotation Heading */}
                <div className="flex items-start justify-between gap-4">
                  <div className="flex items-center">
                    <Image
                      src="/images/solar-scrap-img.png"
                      alt="Solar Scrap"
                      width={140}
                      height={65}
                      className="w-[110px] sm:w-[120px] print:w-[140px] h-auto object-contain"
                      priority
                    />
                  </div>

                  <div className="text-right">
                    {isInvoice ? (
                      <div>
                        <div className="flex items-center justify-end gap-1.5 mb-1">
                          <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-[#E6F9ED] text-[#009845] border border-[#009845]/40 uppercase tracking-wider print:text-xs">
                            Paid / Issued
                          </span>
                        </div>
                        <h2 className="text-xl print:text-2xl font-black text-gray-900 tracking-tight leading-tight">
                          Commercial Invoice
                        </h2>
                        <p className="text-[11px] print:text-xs font-mono text-gray-500 mt-0.5">
                          #INV-2024-005
                        </p>
                      </div>
                    ) : (
                      <div>
                        <h2 className="text-xl print:text-2xl font-black text-gray-900 tracking-tight leading-tight">
                          Quotation
                        </h2>
                        <p className="text-[11px] print:text-xs font-mono text-gray-500 mt-0.5">
                          #Qt-2024-005
                        </p>
                      </div>
                    )}
                  </div>
                </div>

                <div className="border-t border-gray-200/70 my-3 print:my-4" />

                {/* Details Row */}
                <div className="flex justify-between items-start gap-4 text-xs print:text-sm">
                  <div>
                    <p className="text-xs print:text-xs font-bold text-gray-500 uppercase tracking-wider">
                      {isInvoice ? "Invoice To:" : "Quotation To:"}
                    </p>
                    <p className="text-xs print:text-sm font-bold text-gray-900 mt-0.5">
                      {customerName || "Ahmed Raza"}
                    </p>
                    <p className="text-[11px] print:text-xs text-gray-600 mt-0.5">
                      {phone || "+92 345 9990000"}
                    </p>
                    <p className="text-[11px] print:text-xs text-gray-600">
                      {location || "Rawalpindi, Bahria Town"}
                    </p>
                  </div>

                  <div className="space-y-1 text-right text-[11px] print:text-xs">
                    <p className="flex justify-end gap-2">
                      <span className="font-bold text-gray-900">
                        {isInvoice ? "Invoice Date:" : "Date:"}
                      </span>
                      <span className="text-gray-700 font-medium">{date || "03 Dec 2024"}</span>
                    </p>
                    <p className="flex justify-end gap-2">
                      <span className="font-bold text-gray-900">
                        {isInvoice ? "Due Date:" : "Valid Till:"}
                      </span>
                      <span className="text-gray-700 font-medium">
                        {isInvoice ? "Upon Receipt / Settled" : (validTill || "10 Dec 2024")}
                      </span>
                    </p>
                    <p className="flex justify-end gap-2">
                      <span className="font-bold text-gray-900">From:</span>
                      <span className="text-gray-700 font-medium">{companyName || "Solar Scrap Official"}</span>
                    </p>
                  </div>
                </div>
              </div>

              {/* ===================== BOX 2: ITEMS TABLE, TOTALS & TERMS ===================== */}
              <div className="print-card bg-[#F4F6F8] rounded-2xl p-4 sm:p-5 print:p-6 print:rounded-2xl border border-gray-200/60 space-y-3">
                {/* Table Headers */}
                <div className="grid grid-cols-12 text-[11px] print:text-xs font-bold text-gray-700 pb-2 print:pb-2.5 border-b border-gray-200/70 uppercase tracking-wider">
                  <div className="col-span-6">Items &amp; Description</div>
                  <div className="col-span-2 text-center">QTY</div>
                  <div className="col-span-2 text-right">Rate ( PKR )</div>
                  <div className="col-span-2 text-right">Amount ( PKR )</div>
                </div>

                {/* Item Rows */}
                <div className="space-y-2 text-xs text-gray-800">
                  {items.map((item, idx) => (
                    <div
                      key={item.id}
                      className="grid grid-cols-12 items-center text-[11px] print:text-xs pb-2 print:py-2 border-b border-gray-200/60"
                    >
                      <div className="col-span-6 text-gray-800 font-medium truncate print:whitespace-normal print:overflow-visible pr-2">
                        {idx + 1}. {item.name}
                      </div>
                      <div className="col-span-2 text-center text-gray-700 font-medium">
                        {item.qty}
                      </div>
                      <div className="col-span-2 text-right text-gray-700">
                        {formatNumber(item.rate)}
                      </div>
                      <div className="col-span-2 text-right font-bold text-gray-900">
                        {formatNumber(item.qty * item.rate)}
                      </div>
                    </div>
                  ))}
                </div>

                {/* Subtotal & Adjustment */}
                <div className="pt-1.5 print:pt-2 space-y-1 text-xs print:text-sm">
                  <div className="flex justify-between items-center text-gray-900 font-semibold text-[11px] print:text-xs">
                    <span>Sub total</span>
                    <span>PKR {formatNumber(subTotal)}</span>
                  </div>
                  <div className="flex justify-between items-center text-gray-600 font-medium text-[11px] print:text-xs">
                    <span>Adjustment</span>
                    <span>PKR {adjustment === 0 ? "00" : formatNumber(adjustment)}</span>
                  </div>
                </div>

                {/* Solid Green Total Offer / Total Amount Bar */}
                <div className="print-highlight bg-[#009845] text-white rounded-xl px-4 py-2.5 print:py-3.5 print:px-6 flex justify-between items-center font-bold text-xs print:text-sm shadow-xs mt-1">
                  <span className="uppercase tracking-wider">{isInvoice ? "Total Amount ( PKR )" : "Total Offer ( PKR )"}</span>
                  <span className="text-sm print:text-base font-black">PKR {formatNumber(totalOffer)}</span>
                </div>

                <div className="border-t border-gray-200/70 pt-2 print:pt-3" />

                {/* Terms & Conditions */}
                <div className="space-y-1 text-[11px] print:text-xs text-gray-600">
                  <p className="font-bold text-gray-900">Terms &amp; Conditions</p>
                  {isInvoice ? (
                    <>
                      <p className="text-[10px] print:text-xs text-gray-500">
                        • Official commercial invoice for inspected solar scrap &amp; equipment.
                      </p>
                      <p className="text-[10px] print:text-xs text-gray-500">
                        • Certified transaction and equipment handover.
                      </p>
                    </>
                  ) : (
                    <>
                      <p className="text-[10px] print:text-xs text-gray-500">
                        • This is an estimated offer and valid for the mentioned date only.
                      </p>
                      <p className="text-[10px] print:text-xs text-gray-500">
                        • Final price may vary after physical inspection.
                      </p>
                    </>
                  )}
                  <p className="font-bold text-gray-900 pt-1 text-[11px] print:text-xs">Thank you for choosing Solar Scrap.</p>
                </div>
              </div>

              {/* ===================== OFFICIAL SIGNATURES & CORPORATE FOOTER (PRINT ONLY) ===================== */}
              <div className="hidden print:block pt-8 space-y-10">
                <div className="grid grid-cols-2 gap-12 pt-6">
                  <div className="space-y-14">
                    <div className="border-b-2 border-gray-400 w-52" />
                    <div>
                      <p className="text-xs font-bold text-gray-900">Customer Acceptance</p>
                      <p className="text-[10px] text-gray-500">Authorized Signature &amp; Date</p>
                    </div>
                  </div>
                  <div className="space-y-14 flex flex-col items-end">
                    <div className="border-b-2 border-gray-400 w-52" />
                    <div className="text-right">
                      <p className="text-xs font-bold text-gray-900">Solar Scrap Representative</p>
                      <p className="text-[10px] text-gray-500">Official Stamp &amp; Signature</p>
                    </div>
                  </div>
                </div>

                <div className="border-t border-gray-300 pt-3 flex justify-between items-center text-[10px] text-gray-500">
                  <span>Solar Scrap Official • Official Quotation &amp; Commercial Invoice Document</span>
                  <span>support@solarscrap.pk • Verified Platform System</span>
                </div>
              </div>
            </div>

            {/* ===================== BOX 3: QUOTATION / INVOICE ACTIONS (NO PRINT) ===================== */}
            <div className="no-print bg-[#F4F6F8] rounded-2xl p-4 sm:p-5 border border-gray-200/60 space-y-3">
              <div className="flex items-center justify-between">
                <h4 className="text-xs font-bold text-gray-900">
                  {isInvoice ? "Invoice Actions" : "Quotation Actions"}
                </h4>
                {isInvoice && (
                  <span className="text-[11px] font-bold text-[#009845] bg-[#E6F9ED] px-2.5 py-0.5 rounded-full border border-[#009845]/30">
                    Invoice Mode Active
                  </span>
                )}
              </div>

              <div className="grid grid-cols-2 gap-3">
                <button
                  type="button"
                  onClick={handleWhatsAppShare}
                  className="w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-[#009845] hover:bg-[#00823b] text-white rounded-xl text-xs font-bold shadow-xs transition-colors cursor-pointer"
                >
                  <Image
                    src="/icons/whatsapp.svg"
                    alt="WhatsApp"
                    width={16}
                    height={16}
                    className="object-contain"
                  />
                  <span>Send to what&apos;sapp</span>
                </button>

                <button
                  type="button"
                  onClick={() => {
                    const subject = isInvoice
                      ? `Solar Scrap Commercial Invoice - ${customerName}`
                      : `Solar Scrap Quotation - ${customerName}`;
                    const mailto = `mailto:?subject=${encodeURIComponent(subject)}&body=Please find the estimated total of PKR ${formatNumber(totalOffer)}`;
                    window.location.href = mailto;
                  }}
                  className="w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-[#0070F3] hover:bg-[#0060df] text-white rounded-xl text-xs font-bold shadow-xs transition-colors cursor-pointer"
                >
                  <Mail className="w-4 h-4" />
                  <span>Send Via Email</span>
                </button>

                <button
                  type="button"
                  onClick={handlePrintPdf}
                  className="w-full flex items-center justify-center gap-2 py-2.5 px-4 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-xl text-xs font-semibold shadow-2xs transition-colors cursor-pointer"
                >
                  <Download className="w-3.5 h-3.5 text-gray-500" />
                  <span>{isInvoice ? "Download Invoice PDF" : "Download pdf"}</span>
                </button>

                <button
                  type="button"
                  onClick={() => {
                    const next = !isInvoice;
                    setIsInvoice(next);
                    showToast(next ? "Converted to Commercial Invoice view!" : "Switched back to Quotation view!");
                  }}
                  className={`w-full flex items-center justify-center gap-2 py-2.5 px-4 rounded-xl text-xs font-semibold shadow-2xs transition-colors cursor-pointer ${
                    isInvoice
                      ? "bg-[#E6F9ED] text-[#009845] border border-[#009845]/40 hover:bg-[#d5f5e0]"
                      : "bg-white hover:bg-gray-50 text-gray-700 border border-gray-200"
                  }`}
                >
                  <FileText className="w-3.5 h-3.5" />
                  <span>{isInvoice ? "Switch to Quotation" : "Convert to Invoice"}</span>
                </button>
              </div>

              <div className="pt-2 border-t border-gray-200/60 flex justify-end">
                <button
                  type="button"
                  onClick={handleSaveAndIssue}
                  disabled={isSaving}
                  className="text-xs font-bold text-[#009845] hover:text-[#00823b] flex items-center gap-1.5 cursor-pointer py-1 disabled:opacity-50"
                >
                  <CheckCircle className="w-4 h-4" />
                  <span>{isSaving ? "Saving..." : (isInvoice ? "Save & Issue Invoice" : "Save Quotation to Records")}</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
