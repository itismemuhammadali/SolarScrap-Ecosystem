"use client";

import { Suspense, useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import {
  ArrowLeft,
  Download,
  FileText,
  CheckCircle,
  Share2,
  Printer,
} from "lucide-react";

function QuotationViewContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const id = searchParams.get("id") || "QT-2026-001";
  const initialClient = searchParams.get("client") || "Hassan Malik";
  const initialPhone = searchParams.get("phone") || "+92 300 1234567";
  const initialCity = searchParams.get("city") || "Karachi, Pakistan";
  const initialCompany = searchParams.get("company") || "Orient Solar Energy";

  const [record, setRecord] = useState<any>(null);
  const [toast, setToast] = useState<string | null>(null);

  useEffect(() => {
    try {
      const stored = localStorage.getItem("solar_scrap_quotations");
      if (stored) {
        const list = JSON.parse(stored);
        const match = list.find((item: any) => item.id === id);
        if (match) {
          setRecord(match);
          return;
        }
      }
    } catch (e) {
      console.error(e);
    }
    // Fallback record
    setRecord({
      id: id,
      quotationNumber: `#${id}`,
      name: initialClient,
      phone: initialPhone,
      city: initialCity,
      company: initialCompany,
      date: "05 Mar 2026",
      validTill: "12 Mar 2026",
      totalAmount: 240000,
      items: [
        {
          id: "1",
          name: "Longi 550W Tier-1 Mono PERC Panel (Used)",
          qty: 20,
          rate: 12000,
        },
      ],
    });
  }, [id, initialClient, initialPhone, initialCity, initialCompany]);

  const showToast = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 3000);
  };

  const handlePrint = () => {
    const originalTitle = document.title;
    const cleanCustomer = (currentRecord.name || "Customer").trim().replace(/[^a-zA-Z0-9_-]/g, "_");
    document.title = `Solar_Scrap_Quotation_${cleanCustomer}_${currentRecord.id || "Invoice"}`;
    window.print();
    setTimeout(() => {
      document.title = originalTitle;
    }, 1500);
  };

  const formatNumber = (num: number) => {
    return new Intl.NumberFormat("en-PK").format(num);
  };

  const currentRecord = record || {
    id: id,
    name: initialClient,
    phone: initialPhone,
    city: initialCity,
    company: initialCompany,
    date: "05 Mar 2026",
    validTill: "12 Mar 2026",
    totalAmount: 240000,
    items: [
      { id: "1", name: "Longi 550W Solar Panel (Used)", qty: 20, rate: 12000 },
    ],
  };

  const itemsList = currentRecord.items && currentRecord.items.length > 0
    ? currentRecord.items
    : [{ id: "1", name: "Longi 550W Tier-1 Solar Panels", qty: 20, rate: 12000 }];

  const subTotal = itemsList.reduce((acc: number, it: any) => acc + it.qty * it.rate, 0);
  const totalOffer = currentRecord.totalAmount || subTotal;

  const handleWhatsApp = () => {
    const cleanPhone = (currentRecord.phone || "").replace(/[^0-9]/g, "");
    const lines = itemsList
      .map(
        (it: any, idx: number) =>
          `${idx + 1}. ${it.name} x ${it.qty} = PKR ${formatNumber(it.qty * it.rate)}`
      )
      .join("\n");
    const text = `*SOLAR SCRAP OFFICIAL QUOTATION / INVOICE*\nQuotation No: ${currentRecord.id}\nTo: ${currentRecord.name}\nDate: ${currentRecord.date}\nValid Till: ${currentRecord.validTill || "7 Days"}\n\n*Line Items:*\n${lines}\n\n*Total Amount:* PKR ${formatNumber(totalOffer)}\n\nThank you for choosing Solar Scrap!`;
    const url = cleanPhone
      ? `https://wa.me/${cleanPhone}?text=${encodeURIComponent(text)}`
      : `https://wa.me/?text=${encodeURIComponent(text)}`;
    window.open(url, "_blank");
  };

  return (
    <div className="min-h-screen bg-[#F5F6FA] py-8 px-4 sm:px-6 lg:px-8">
      {/* Toast Notification */}
      {toast && (
        <div className="no-print fixed top-6 right-6 z-50 bg-[#009845] text-white px-5 py-3 rounded-xl shadow-lg flex items-center gap-2 text-sm font-semibold">
          <CheckCircle className="w-5 h-5" />
          <span>{toast}</span>
        </div>
      )}

      <div className="max-w-3xl mx-auto space-y-6">
        {/* Navigation / Top Bar */}
        <div className="no-print flex items-center justify-between print:hidden">
          <Link
            href="/quotation-history"
            className="inline-flex items-center gap-2 px-4 py-2 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-lg text-sm font-semibold shadow-xs transition-colors cursor-pointer"
          >
            <ArrowLeft className="w-4 h-4 text-gray-500" />
            <span>Back to History</span>
          </Link>

          <div className="flex items-center gap-2">
            <button
              onClick={handlePrint}
              className="p-2 bg-white hover:bg-gray-50 text-gray-600 border border-gray-200 rounded-lg transition-colors cursor-pointer"
              title="Print Quotation"
            >
              <Printer className="w-4 h-4" />
            </button>
            <Link
              href="/quotation-history/create"
              className="inline-flex items-center gap-2 px-4 py-2 bg-[#009845] hover:bg-[#00823b] text-white rounded-lg text-sm font-semibold transition-colors cursor-pointer"
            >
              <span>+ New Quotation</span>
            </Link>
          </div>
        </div>

        {/* Quotation Document Card */}
        <div
          id="printable-quotation"
          className="bg-white rounded-3xl border border-gray-200/80 p-6 sm:p-8 shadow-xs space-y-6 print:border-none print:shadow-none"
        >
          {/* Header */}
          <div className="flex items-center justify-between pb-6 border-b border-gray-100">
            <Image
              src="/images/solar-scrap-img.png"
              alt="Solar Scrap Logo"
              width={140}
              height={72}
              className="w-[130px] sm:w-[140px] h-auto object-contain"
              priority
            />

            <div className="text-right">
              <h1 className="text-2xl font-black text-gray-900 tracking-tight">
                Quotation & Invoice
              </h1>
              <span className="text-xs font-bold text-gray-400">
                #{currentRecord.id}
              </span>
            </div>
          </div>

          {/* Parties & Dates Info */}
          <div className="flex flex-col sm:flex-row justify-between items-start gap-6">
            <div>
              <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">
                To,
              </p>
              <h2 className="text-lg font-bold text-gray-900">{currentRecord.name}</h2>
              <p className="text-xs text-gray-600 mt-1">{currentRecord.phone}</p>
              <p className="text-xs text-gray-500 mt-0.5">
                {currentRecord.city || "Pakistan"}
              </p>
              {currentRecord.company && (
                <p className="text-xs text-gray-400 mt-0.5 font-medium">
                  {currentRecord.company}
                </p>
              )}
            </div>

            <div className="text-left sm:text-right space-y-1.5 text-xs">
              <p className="text-gray-500">
                <span className="font-semibold text-gray-700 mr-2">Date:</span>
                {currentRecord.date || "05 Mar 2026"}
              </p>
              <p className="text-gray-500">
                <span className="font-semibold text-gray-700 mr-2">
                  Valid Till:
                </span>
                {currentRecord.validTill || "12 Mar 2026"}
              </p>
              <p className="text-gray-500">
                <span className="font-semibold text-gray-700 mr-2">From:</span>
                Solar Scrap Official Portal
              </p>
            </div>
          </div>

          {/* Items Table Box */}
          <div className="bg-[#F9FAFB] rounded-xl p-5 space-y-4 border border-gray-100">
            <div className="grid grid-cols-12 text-xs font-bold text-gray-500 border-b border-gray-200/80 pb-2.5">
              <div className="col-span-6">Items</div>
              <div className="col-span-2 text-center">QTY</div>
              <div className="col-span-2 text-right">Rate ( PKR )</div>
              <div className="col-span-2 text-right">Amount ( PKR )</div>
            </div>

            <div className="space-y-3 py-1">
              {itemsList.map((item: any, idx: number) => (
                <div
                  key={item.id || idx}
                  className="grid grid-cols-12 text-xs text-gray-800 items-center"
                >
                  <div className="col-span-6 font-medium">
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
            <div className="border-t border-gray-200/80 pt-3.5 space-y-1.5 text-xs">
              <div className="flex justify-between items-center text-gray-700">
                <span className="font-bold">Sub total</span>
                <span className="font-bold text-gray-900">{formatNumber(subTotal)}</span>
              </div>
              <div className="flex justify-between items-center text-gray-500">
                <span>Adjustment / Discount</span>
                <span>00</span>
              </div>
            </div>

            {/* Green Total Offer Banner */}
            <div className="bg-[#009845] text-white rounded-lg px-5 py-3 flex justify-between items-center font-bold text-sm shadow-xs">
              <span>Total Offer ( PKR )</span>
              <span>{formatNumber(totalOffer)}</span>
            </div>
          </div>

          {/* Terms & Conditions */}
          <div className="space-y-2 pt-2 text-xs text-gray-500">
            <h3 className="font-bold text-gray-800">Terms & Conditions</h3>
            <ul className="list-disc pl-4 space-y-1">
              <li>This is an official valuation offer and valid for the mentioned date only.</li>
              <li>Final price and payment release may vary after on-site physical inspection.</li>
            </ul>
            <p className="font-bold text-gray-800 pt-3">Thank you for working with Solar Scrap.</p>
          </div>
        </div>

        {/* Action Buttons Panel */}
        <div className="bg-white rounded-2xl border border-gray-200/80 p-6 shadow-xs print:hidden space-y-4">
          <h4 className="text-sm font-bold text-gray-900">
            Quotation & Invoice Actions
          </h4>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            <button
              type="button"
              onClick={handlePrint}
              className="flex items-center justify-center gap-2 py-3 px-4 bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 rounded-xl text-xs font-bold transition-colors cursor-pointer"
            >
              <Download className="w-4 h-4 text-gray-500" />
              <span>Download / Print PDF</span>
            </button>

            <button
              type="button"
              onClick={handleWhatsApp}
              className="flex items-center justify-center gap-2 py-3 px-4 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-200 rounded-xl text-xs font-bold transition-colors cursor-pointer"
            >
              <Image
                src="/icons/whatsapp.svg"
                alt="WhatsApp"
                width={18}
                height={18}
                className="object-contain"
              />
              <span>Share via WhatsApp</span>
            </button>

            <button
              type="button"
              onClick={() => showToast("Quotation confirmed as official Paid Invoice!")}
              className="flex items-center justify-center gap-2 py-3 px-4 bg-[#009845] hover:bg-[#00823b] text-white rounded-xl text-xs font-bold shadow-xs transition-colors cursor-pointer"
            >
              <FileText className="w-4 h-4" />
              <span>Mark as Paid Invoice</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default function ViewQuotationPage() {
  return (
    <Suspense fallback={<div className="p-8 text-center text-sm text-gray-500">Loading quotation...</div>}>
      <QuotationViewContent />
    </Suspense>
  );
}
