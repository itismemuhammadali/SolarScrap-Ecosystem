"use client";

import { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import {
  Search,
  Bell,
  ArrowLeft,
  Plus,
  Trash2,
  Download,
  FileText,
  Mail,
  CheckCircle,
} from "lucide-react";

interface LineItem {
  id: string;
  name: string;
  qty: number;
  rate: number;
}

export default function CreateQuotationPage() {
  const router = useRouter();

  // Form State
  const [customerName, setCustomerName] = useState("Ahmed Raza");
  const [phone, setPhone] = useState("+92 345 9990000");
  const [date, setDate] = useState("2024-12-03");
  const [validTill, setValidTill] = useState("2024-12-10");
  const [location, setLocation] = useState("Rawalpindi, Bahria Town");
  const [companyName, setCompanyName] = useState("Solar scrap");
  const [adjustment, setAdjustment] = useState<number>(0);

  // Line items state
  const [items, setItems] = useState<LineItem[]>([
    {
      id: "1",
      name: "Longi 550W Solar Panel (Used)",
      qty: 20,
      rate: 12000,
    },
    {
      id: "2",
      name: "Solar Inverter 5kW GoodWe",
      qty: 1,
      rate: 216880,
    },
  ]);

  const [toast, setToast] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 3000);
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

  return (
    <div className="min-h-screen bg-[#F8F9FA] flex flex-col">
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

      {/* Main Content Area */}
      <main className="flex-1 p-6 lg:p-10 max-w-7xl mx-auto w-full space-y-6">
        {/* Back Button */}
        <div>
          <button
            onClick={() => router.push("/quotation-history")}
            className="inline-flex items-center gap-2 px-6 py-2 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-lg text-sm font-semibold shadow-xs transition-colors"
          >
            <ArrowLeft className="w-4 h-4 text-gray-500" />
            <span>Back</span>
          </button>
        </div>

        {/* 2-Column Builder Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          {/* Left Column: Input Form Card */}
          <div className="lg:col-span-6 bg-white rounded-2xl border border-gray-100 p-6 lg:p-8 shadow-xs space-y-8">
            {/* Customer Header Tag */}
            <div className="flex items-center justify-between pb-6 border-b border-gray-100">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-slate-800 text-white flex items-center justify-center font-bold text-sm">
                  KS
                </div>
                <div>
                  <h3 className="text-base font-bold text-gray-900">
                    Kamran Sheikh
                  </h3>
                  <span className="text-xs text-gray-400">QT ID: FB001</span>
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
                    placeholder="Enter customer name"
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
                    placeholder="+92 300 0000000"
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1.5">
                    Date:
                  </label>
                  <input
                    type="date"
                    value={date}
                    onChange={(e) => setDate(e.target.value)}
                    className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1.5">
                    Valid Till:
                  </label>
                  <input
                    type="date"
                    value={validTill}
                    onChange={(e) => setValidTill(e.target.value)}
                    className="w-full px-3.5 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845]"
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
                    placeholder="Company Name"
                  />
                </div>
              </div>
            </div>

            {/* Section 2: Item Details */}
            <div className="space-y-4 pt-4 border-t border-gray-100">
              <div className="flex items-center justify-between">
                <h4 className="text-sm font-bold text-gray-900">
                  Item details:
                </h4>
                <button
                  type="button"
                  onClick={addItem}
                  className="text-xs font-semibold text-[#009845] hover:text-[#00823b] flex items-center gap-1"
                >
                  <Plus className="w-3.5 h-3.5" />
                  <span>Add Item</span>
                </button>
              </div>

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
                          className="text-gray-400 hover:text-red-500 transition-colors p-1"
                          title="Remove Item"
                        >
                          <Trash2 className="w-3.5 h-3.5" />
                        </button>
                      )}
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-12 gap-3">
                      <div className="sm:col-span-6">
                        <label className="block text-[11px] font-medium text-gray-600 mb-1">
                          Item Name
                        </label>
                        <input
                          type="text"
                          value={item.name}
                          onChange={(e) =>
                            updateItem(item.id, "name", e.target.value)
                          }
                          className="w-full px-3 py-1.5 bg-white border border-gray-200 rounded-lg text-xs text-gray-800 focus:outline-none focus:ring-1 focus:ring-[#009845]"
                          placeholder="Item Name"
                        />
                      </div>

                      <div className="sm:col-span-3">
                        <label className="block text-[11px] font-medium text-gray-600 mb-1">
                          QTY
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
                        />
                      </div>

                      <div className="sm:col-span-3">
                        <label className="block text-[11px] font-medium text-gray-600 mb-1">
                          Rate (PKR)
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
                    Adjustment (PKR):
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
            </div>
          </div>

          {/* Right Column: Live Quotation Document & Actions */}
          <div className="lg:col-span-6 space-y-6">
            {/* The Document Card */}
            <div className="bg-white rounded-2xl border border-gray-100 p-8 shadow-xs space-y-6">
              {/* Document Header */}
              <div className="flex items-center justify-between">
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
                  <span className="text-xs font-semibold text-gray-400">
                    #Qt-2024-005
                  </span>
                </div>
              </div>

              <div className="border-t border-gray-100 pt-6">
                <div className="flex justify-between items-start gap-4">
                  {/* To Block */}
                  <div>
                    <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">
                      To,
                    </p>
                    <h4 className="text-base font-bold text-gray-900">
                      {customerName || "Customer Name"}
                    </h4>
                    <p className="text-xs text-gray-600 mt-1">{phone}</p>
                    <p className="text-xs text-gray-500 mt-0.5">{location}</p>
                  </div>

                  {/* Metadata Block */}
                  <div className="text-right space-y-1 text-xs">
                    <p className="text-gray-500">
                      <span className="font-semibold text-gray-700 mr-2">
                        Date:
                      </span>
                      {date}
                    </p>
                    <p className="text-gray-500">
                      <span className="font-semibold text-gray-700 mr-2">
                        Valid Till:
                      </span>
                      {validTill}
                    </p>
                    <p className="text-gray-500">
                      <span className="font-semibold text-gray-700 mr-2">
                        From:
                      </span>
                      {companyName}
                    </p>
                  </div>
                </div>
              </div>

              {/* Items Table Card */}
              <div className="bg-[#F9FAFB] rounded-xl p-4 space-y-3">
                <div className="grid grid-cols-12 text-[11px] font-bold text-gray-500 border-b border-gray-200/80 pb-2">
                  <div className="col-span-6">Items</div>
                  <div className="col-span-2 text-center">QTY</div>
                  <div className="col-span-2 text-right">Rate ( PKR )</div>
                  <div className="col-span-2 text-right">Amount ( PKR )</div>
                </div>

                <div className="space-y-2 py-1">
                  {items.map((item, idx) => (
                    <div
                      key={item.id}
                      className="grid grid-cols-12 text-xs text-gray-800 items-center"
                    >
                      <div className="col-span-6 font-medium truncate pr-2">
                        {idx + 1}. {item.name}
                      </div>
                      <div className="col-span-2 text-center text-gray-600">
                        {item.qty}
                      </div>
                      <div className="col-span-2 text-right text-gray-600">
                        {formatNumber(item.rate)}
                      </div>
                      <div className="col-span-2 text-right font-semibold text-gray-900">
                        {formatNumber(item.qty * item.rate)}
                      </div>
                    </div>
                  ))}
                </div>

                {/* Subtotals */}
                <div className="border-t border-gray-200/80 pt-3 space-y-1 text-xs">
                  <div className="flex justify-between items-center text-gray-700">
                    <span className="font-bold">Sub total</span>
                    <span className="font-bold">{formatNumber(subTotal)}</span>
                  </div>
                  <div className="flex justify-between items-center text-gray-500">
                    <span>Adjustment</span>
                    <span>{formatNumber(adjustment)}</span>
                  </div>
                </div>

                {/* Green Total Offer Banner */}
                <div className="bg-[#009845] text-white rounded-lg px-4 py-2.5 flex justify-between items-center font-bold text-sm shadow-xs mt-2">
                  <span>Total Offer ( PKR )</span>
                  <span>{formatNumber(totalOffer)}</span>
                </div>
              </div>

              {/* Terms & Conditions */}
              <div className="space-y-2 pt-2 text-xs text-gray-500">
                <h5 className="font-bold text-gray-800">Terms & Conditions</h5>
                <ul className="list-disc pl-4 space-y-1">
                  <li>This is an estimated offer and valid for the mentioned date only.</li>
                  <li>Final price may vary after physical inspection.</li>
                </ul>
                <p className="font-semibold text-gray-800 pt-2">Thank you</p>
              </div>
            </div>

            {/* Quotation Actions Panel */}
            <div className="bg-white rounded-2xl border border-gray-100 p-6 shadow-xs space-y-4">
              <h4 className="text-sm font-bold text-gray-900">
                Quotation Actions
              </h4>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <button
                  type="button"
                  onClick={() => showToast("Opening WhatsApp share link...")}
                  className="w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-[#009845] hover:bg-[#00823b] text-white rounded-xl text-xs font-bold shadow-xs transition-colors"
                >
                  <Image
                    src="/icons/whatsapp.svg"
                    alt="WhatsApp"
                    width={18}
                    height={18}
                    className="object-contain"
                  />
                  <span>Send to what&apos;sapp</span>
                </button>

                <button
                  type="button"
                  onClick={() => showToast("Email quotation sent successfully!")}
                  className="w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-[#0070F3] hover:bg-[#0060df] text-white rounded-xl text-xs font-bold shadow-xs transition-colors"
                >
                  <Mail className="w-4 h-4" />
                  <span>Send Via Email</span>
                </button>

                <button
                  type="button"
                  onClick={() => showToast("Downloading PDF quotation...")}
                  className="w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 rounded-xl text-xs font-bold transition-colors"
                >
                  <Download className="w-4 h-4 text-gray-500" />
                  <span>Download pdf</span>
                </button>

                <button
                  type="button"
                  onClick={() => showToast("Converted quotation to invoice!")}
                  className="w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 rounded-xl text-xs font-bold transition-colors"
                >
                  <FileText className="w-4 h-4 text-gray-500" />
                  <span>Convert to Invoice</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
