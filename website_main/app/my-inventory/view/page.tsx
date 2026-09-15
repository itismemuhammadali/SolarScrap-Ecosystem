"use client";

import { Suspense, useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import {
  ArrowLeft,
  Download,
  FileText,
  Printer,
  CheckCircle,
} from "lucide-react";

function InventoryViewContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const id = searchParams.get("id") || "1";
  const clientName = searchParams.get("client") || "Registered Buyer";
  const clientPhone = searchParams.get("phone") || "+92 300 0000000";
  const clientCity = searchParams.get("city") || "Islamabad, Pakistan";
  const sellerCompany = searchParams.get("company") || "Solar Scrap Verified";

  const [toast, setToast] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 3000);
  };

  const handlePrintPdf = () => {
    const originalTitle = document.title;
    const cleanCustomer = clientName.trim().replace(/[^a-zA-Z0-9_-]/g, "_");
    document.title = `Solar_Scrap_Quotation_${cleanCustomer}_QT-2024-005`;
    window.print();
    setTimeout(() => {
      document.title = originalTitle;
    }, 1500);
  };

  return (
    <div className="min-h-screen bg-[#F5F6FA] py-8 px-4 sm:px-6 lg:px-8 print:p-0 print:m-0 print:bg-white">
      {toast && (
        <div className="no-print fixed top-6 right-6 z-50 bg-[#009845] text-white px-5 py-3 rounded-xl shadow-lg flex items-center gap-2 text-sm font-semibold">
          <CheckCircle className="w-5 h-5" />
          <span>{toast}</span>
        </div>
      )}

      <div className="max-w-3xl mx-auto space-y-6 print:max-w-none print:w-full print:m-0 print:p-0 print:space-y-0">
        {/* Navigation / Top Bar */}
        <div className="no-print flex items-center justify-between print:hidden">
          <Link
            href="/my-inventory"
            className="inline-flex items-center gap-2 px-4 py-2 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-lg text-sm font-semibold shadow-xs transition-colors cursor-pointer"
          >
            <ArrowLeft className="w-4 h-4 text-gray-500" />
            <span>Back to Inventory</span>
          </Link>

          <button
            onClick={handlePrintPdf}
            className="p-2 bg-white hover:bg-gray-50 text-gray-600 border border-gray-200 rounded-lg transition-colors cursor-pointer"
            title="Print Quotation"
          >
            <Printer className="w-4 h-4" />
          </button>
        </div>

        {/* Complete Document Card */}
        <div
          id="printable-quotation"
          className="bg-white rounded-2xl border border-gray-200/80 p-8 sm:p-10 shadow-xs space-y-8 print:border-none print:shadow-none print:p-0 print:m-0 print:w-full print:max-w-none print:gap-4"
        >
          {/* Header */}
          <div className="flex items-center justify-between pb-6 print:pb-4 border-b border-gray-100">
            <Image
              src="/images/solar-scrap-img.png"
              alt="Solar Scrap Logo"
              width={140}
              height={72}
              className="w-[130px] sm:w-[140px] print:w-[145px] h-auto object-contain"
              priority
            />

            <div className="text-right">
              <h1 className="text-2xl print:text-3xl font-black text-gray-900 tracking-tight">
                Quotation
              </h1>
              <span className="text-xs print:text-sm font-bold text-gray-400">
                #Qt-2024-005
              </span>
            </div>
          </div>

          {/* Recipient & Metadata */}
          <div className="flex flex-col sm:flex-row justify-between items-start gap-6 print:gap-8">
            <div>
              <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">
                To,
              </p>
              <h2 className="text-lg print:text-xl font-bold text-gray-900">{clientName}</h2>
              <p className="text-xs print:text-sm text-gray-600 mt-1">{clientPhone}</p>
              <p className="text-xs print:text-sm text-gray-500 mt-0.5">
                {clientCity}
              </p>
            </div>

            <div className="text-left sm:text-right space-y-1.5 text-xs print:text-sm">
              <p className="text-gray-500">
                <span className="font-semibold text-gray-700 mr-2">Date:</span>
                03 Dec 2024
              </p>
              <p className="text-gray-500">
                <span className="font-semibold text-gray-700 mr-2">
                  Valid Till:
                </span>
                10 Dec 2024
              </p>
              <p className="text-gray-500">
                <span className="font-semibold text-gray-700 mr-2">From:</span>
                {sellerCompany}
              </p>
            </div>
          </div>

          {/* Items Table */}
          <div className="print-card bg-[#F9FAFB] rounded-xl p-5 print:p-6 space-y-4 border border-gray-100">
            <div className="grid grid-cols-12 text-xs print:text-sm font-bold text-gray-500 border-b border-gray-200/80 pb-2.5 uppercase tracking-wider">
              <div className="col-span-6">Items &amp; Description</div>
              <div className="col-span-2 text-center">QTY</div>
              <div className="col-span-2 text-right">Rate ( PKR )</div>
              <div className="col-span-2 text-right">Amount ( PKR )</div>
            </div>

            <div className="space-y-3 py-1">
              <div className="grid grid-cols-12 text-xs print:text-sm text-gray-800 items-center print:py-2 border-b border-gray-100 last:border-none">
                <div className="col-span-6 font-medium text-gray-900 truncate print:whitespace-normal print:overflow-visible pr-2">
                  1. Longi 550W Solar Panel (Used)
                </div>
                <div className="col-span-2 text-center text-gray-600 font-medium">20</div>
                <div className="col-span-2 text-right text-gray-600">
                  12,000
                </div>
                <div className="col-span-2 text-right font-bold text-gray-900">
                  240,000
                </div>
              </div>
            </div>

            {/* Subtotals */}
            <div className="border-t border-gray-200/80 pt-3.5 space-y-1.5 text-xs print:text-sm">
              <div className="flex justify-between items-center text-gray-700">
                <span className="font-bold">Sub total</span>
                <span className="font-bold text-gray-900">PKR 456,880</span>
              </div>
              <div className="flex justify-between items-center text-gray-500">
                <span>Adjustment</span>
                <span>PKR 00</span>
              </div>
            </div>

            {/* Green Total Offer Banner */}
            <div className="print-highlight bg-[#009845] text-white rounded-lg px-5 py-3.5 flex justify-between items-center font-extrabold text-sm print:text-base shadow-xs">
              <span className="uppercase tracking-wider">Total Offer ( PKR )</span>
              <span className="font-black">PKR 456,880</span>
            </div>
          </div>

          {/* Terms & Conditions */}
          <div className="space-y-2 pt-2 text-xs print:text-sm text-gray-500">
            <h3 className="font-bold text-gray-800">Terms &amp; Conditions</h3>
            <ul className="list-disc pl-4 space-y-1">
              <li>This is an estimated offer and valid for the mentioned date only.</li>
              <li>Final price may vary after physical inspection.</li>
            </ul>
            <p className="font-bold text-gray-800 pt-2">Thank you for choosing Solar Scrap.</p>
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

        {/* Action Buttons Panel */}
        <div className="bg-white rounded-2xl border border-gray-200/80 p-6 shadow-xs print:hidden">
          <h4 className="text-sm font-bold text-gray-900 mb-4">
            Quotation Actions
          </h4>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <button
              onClick={handlePrintPdf}
              className="flex items-center justify-center gap-2 py-3 px-4 bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 rounded-xl text-xs font-bold transition-colors cursor-pointer"
            >
              <Download className="w-4 h-4 text-gray-500" />
              <span>Download pdf</span>
            </button>

            <button
              onClick={() => showToast("Quotation successfully converted to invoice!")}
              className="flex items-center justify-center gap-2 py-3 px-4 bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 rounded-xl text-xs font-bold transition-colors cursor-pointer"
            >
              <FileText className="w-4 h-4 text-gray-500" />
              <span>Convert to Invoice</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default function InventoryViewPage() {
  return (
    <Suspense fallback={<div className="p-8 text-center text-sm text-gray-500">Loading details...</div>}>
      <InventoryViewContent />
    </Suspense>
  );
}
