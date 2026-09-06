"use client";

import { Suspense, useState } from "react";
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
  const id = searchParams.get("id") || "1";

  const [toast, setToast] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 3000);
  };

  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="min-h-screen bg-[#F8F9FA] py-8 px-4 sm:px-6 lg:px-8">
      {/* Toast Notification */}
      {toast && (
        <div className="fixed top-6 right-6 z-50 bg-[#009845] text-white px-5 py-3 rounded-xl shadow-lg flex items-center gap-2 text-sm font-semibold">
          <CheckCircle className="w-5 h-5" />
          <span>{toast}</span>
        </div>
      )}

      <div className="max-w-3xl mx-auto space-y-6">
        {/* Navigation / Top Bar */}
        <div className="flex items-center justify-between">
          <Link
            href="/quotation-history"
            className="inline-flex items-center gap-2 px-4 py-2 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-lg text-sm font-semibold shadow-xs transition-colors"
          >
            <ArrowLeft className="w-4 h-4 text-gray-500" />
            <span>Back to History</span>
          </Link>

          <div className="flex items-center gap-2">
            <button
              onClick={handlePrint}
              className="p-2 bg-white hover:bg-gray-50 text-gray-600 border border-gray-200 rounded-lg transition-colors"
              title="Print Quotation"
            >
              <Printer className="w-4 h-4" />
            </button>
            <Link
              href="/quotation-history/create"
              className="inline-flex items-center gap-2 px-4 py-2 bg-[#009845] hover:bg-[#00823b] text-white rounded-lg text-sm font-semibold transition-colors"
            >
              <span>Edit / New</span>
            </Link>
          </div>
        </div>

        {/* Quotation Document Card */}
        <div className="bg-white rounded-2xl border border-gray-200/80 p-8 sm:p-10 shadow-xs space-y-8 print:border-none print:shadow-none">
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
                Quotation
              </h1>
              <span className="text-xs font-bold text-gray-400">
                #Qt-2024-005
              </span>
            </div>
          </div>

          {/* Parties & Dates Info */}
          <div className="flex flex-col sm:flex-row justify-between items-start gap-6">
            <div>
              <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">
                To,
              </p>
              <h2 className="text-lg font-bold text-gray-900">Raza Ahmed</h2>
              <p className="text-xs text-gray-600 mt-1">+92 300 1234567</p>
              <p className="text-xs text-gray-500 mt-0.5">
                Rawalpindi, Bahria Town
              </p>
            </div>

            <div className="text-left sm:text-right space-y-1.5 text-xs">
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
                SolarTec Pvt Ltd
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
              <div className="grid grid-cols-12 text-xs text-gray-800 items-center">
                <div className="col-span-6 font-medium">
                  1. Longi 550W Solar Panel (Used)
                </div>
                <div className="col-span-2 text-center text-gray-600">20</div>
                <div className="col-span-2 text-right text-gray-600">
                  12,000
                </div>
                <div className="col-span-2 text-right font-semibold text-gray-900">
                  240,000
                </div>
              </div>

              <div className="grid grid-cols-12 text-xs text-gray-800 items-center">
                <div className="col-span-6 font-medium">
                  2. GoodWe On-Grid Inverter 10kW
                </div>
                <div className="col-span-2 text-center text-gray-600">1</div>
                <div className="col-span-2 text-right text-gray-600">
                  216,880
                </div>
                <div className="col-span-2 text-right font-semibold text-gray-900">
                  216,880
                </div>
              </div>
            </div>

            {/* Subtotals */}
            <div className="border-t border-gray-200/80 pt-3.5 space-y-1.5 text-xs">
              <div className="flex justify-between items-center text-gray-700">
                <span className="font-bold">Sub total</span>
                <span className="font-bold text-gray-900">456,880</span>
              </div>
              <div className="flex justify-between items-center text-gray-500">
                <span>Adjustment</span>
                <span>00</span>
              </div>
            </div>

            {/* Green Total Offer Banner */}
            <div className="bg-[#009845] text-white rounded-lg px-5 py-3 flex justify-between items-center font-bold text-sm shadow-xs">
              <span>Total Offer ( PKR )</span>
              <span>456,880</span>
            </div>
          </div>

          {/* Terms & Conditions */}
          <div className="space-y-2 pt-2 text-xs text-gray-500">
            <h3 className="font-bold text-gray-800">Terms & Conditions</h3>
            <ul className="list-disc pl-4 space-y-1">
              <li>This is an estimated offer and valid for the mentioned date only.</li>
              <li>Final price may vary after physical inspection.</li>
            </ul>
            <p className="font-bold text-gray-800 pt-3">Thank you</p>
          </div>
        </div>

        {/* Action Buttons Panel */}
        <div className="bg-white rounded-2xl border border-gray-200/80 p-6 shadow-xs print:hidden">
          <h4 className="text-sm font-bold text-gray-900 mb-4">
            Quotation Actions
          </h4>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <button
              onClick={() => showToast("Downloading official quotation PDF...")}
              className="flex items-center justify-center gap-2 py-3 px-4 bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 rounded-xl text-xs font-bold transition-colors"
            >
              <Download className="w-4 h-4 text-gray-500" />
              <span>Download pdf</span>
            </button>

            <button
              onClick={() => showToast("Quotation successfully converted to invoice!")}
              className="flex items-center justify-center gap-2 py-3 px-4 bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200 rounded-xl text-xs font-bold transition-colors"
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

export default function ViewQuotationPage() {
  return (
    <Suspense fallback={<div className="p-8 text-center text-sm text-gray-500">Loading quotation...</div>}>
      <QuotationViewContent />
    </Suspense>
  );
}
