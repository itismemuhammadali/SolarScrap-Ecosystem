"use client";

import React, { useState } from "react";
import Image from "next/image";
import { X, Download, FileText } from "lucide-react";

export interface QuotationModalData {
  quotationId?: string;
  customerName?: string;
  phone?: string;
  location?: string;
  company?: string;
  date?: string;
  validTill?: string;
  fromCompany?: string;
  items?: Array<{
    name: string;
    qty: number | string;
    rate: number;
    amount: number;
  }>;
  subTotal?: number;
  adjustment?: number;
  totalOffer?: number;
  status?: string;
}

interface QuotationModalProps {
  isOpen: boolean;
  onClose: () => void;
  data: QuotationModalData | null;
  onConvertToInvoice?: () => void;
}

export default function QuotationModal({
  isOpen,
  onClose,
  data,
  onConvertToInvoice,
}: QuotationModalProps) {
  const [isInvoice, setIsInvoice] = useState(false);

  if (!isOpen || !data) return null;

  const formatNumber = (num: number) =>
    num.toLocaleString("en-PK", { maximumFractionDigits: 0 });

  const defaultItems = [
    {
      name: "Longi 550W Solar Panel (Used)",
      qty: 20,
      rate: 12000,
      amount: 240000,
    },
  ];

  const items = data.items && data.items.length > 0 ? data.items : defaultItems;
  const subTotal = data.subTotal ?? 456880;
  const adjustment = data.adjustment ?? 0;
  const totalOffer = data.totalOffer ?? (subTotal - adjustment);

  const handlePrintPdf = () => {
    const originalTitle = document.title;
    const cleanCustomer = (data?.customerName || "Customer").trim().replace(/[^a-zA-Z0-9_-]/g, "_");
    const docPrefix = isInvoice ? "Invoice" : "Quotation";
    const refId = isInvoice
      ? (data?.quotationId?.replace(/QT|Qt/i, "INV") || "INV-001")
      : (data?.quotationId?.replace("#", "") || "QT-001");
    document.title = `Solar_Scrap_${docPrefix}_${cleanCustomer}_${refId}`;
    window.print();
    setTimeout(() => {
      document.title = originalTitle;
    }, 1500);
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4">
      {/* Super White Outer Modal Container with 3 Distinct Light-Gray Cards */}
      <div
        id="printable-quotation"
        className="bg-white rounded-3xl max-w-[500px] w-full p-3 sm:p-4 shadow-2xl relative border border-gray-100 flex flex-col gap-2.5 animate-scale-up select-none"
      >
        {/* Floating Close Button */}
        <button
          type="button"
          onClick={onClose}
          className="no-print absolute -top-3 -right-3 sm:-top-2 sm:-right-2 w-8 h-8 rounded-full bg-white text-gray-500 hover:text-gray-800 shadow-md border border-gray-200 flex items-center justify-center transition-all cursor-pointer z-20 hover:scale-105"
          aria-label="Close"
        >
          <X className="w-4 h-4" />
        </button>

        {/* ===================== BOX 1: HEADER & RECIPIENT METADATA ===================== */}
        <div className="print-card bg-[#F4F6F8] rounded-2xl p-4 sm:p-5 border border-gray-200/50">
          {/* Logo & Heading */}
          <div className="flex items-start justify-between gap-4">
            <div className="flex items-center">
              <Image
                src="/images/solar-scrap-img.png"
                alt="Solar Scrap"
                width={120}
                height={55}
                className="w-[110px] sm:w-[120px] h-auto object-contain"
                priority
              />
            </div>

            <div className="text-right">
              {isInvoice ? (
                <div>
                  <div className="flex items-center justify-end gap-1.5 mb-1">
                    <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-[#E6F9ED] text-[#009845] border border-[#009845]/40 uppercase tracking-wider">
                      Paid / Issued
                    </span>
                  </div>
                  <h2 className="text-lg sm:text-xl font-black text-gray-900 tracking-tight leading-tight">
                    Commercial Invoice
                  </h2>
                  <p className="text-[11px] font-mono text-gray-500 mt-0.5">
                    {data.quotationId?.replace(/QT|Qt/i, "INV") || "#INV-2024-005"}
                  </p>
                </div>
              ) : (
                <div>
                  <h2 className="text-lg sm:text-xl font-black text-gray-900 tracking-tight leading-tight">
                    Quotation
                  </h2>
                  <p className="text-[11px] font-mono text-gray-500 mt-0.5">
                    {data.quotationId || "#Qt-2024-005"}
                  </p>
                </div>
              )}
            </div>
          </div>

          <div className="border-t border-gray-200/70 my-3" />

          {/* Details Row */}
          <div className="flex justify-between items-start gap-3 text-xs">
            <div>
              <p className="text-xs font-bold text-gray-900">To,</p>
              <p className="text-xs font-bold text-gray-900 mt-0.5">
                {data.customerName || "Raza Ahmed"}
              </p>
              <p className="text-[11px] text-gray-600 mt-0.5">
                {data.phone || "+92 300 1234567"}
              </p>
              <p className="text-[11px] text-gray-600">
                {data.location || "Rawalpindi, Bahria Town"}
              </p>
            </div>

            <div className="space-y-1 text-right text-[11px]">
              <p className="flex justify-end gap-2">
                <span className="font-bold text-gray-900">
                  {isInvoice ? "Invoice Date:" : "Date:"}
                </span>
                <span className="text-gray-700 font-medium">{data.date || "03 Dec 2024"}</span>
              </p>
              <p className="flex justify-end gap-2">
                <span className="font-bold text-gray-900">
                  {isInvoice ? "Due Date:" : "Valid Till:"}
                </span>
                <span className="text-gray-700 font-medium">
                  {isInvoice ? "Upon Receipt / Settled" : (data.validTill || "10 Dec 2024")}
                </span>
              </p>
              <p className="flex justify-end gap-2">
                <span className="font-bold text-gray-900">From:</span>
                <span className="text-gray-700 font-medium">{data.fromCompany || "Solar Scrap Official"}</span>
              </p>
            </div>
          </div>
        </div>

        {/* ===================== BOX 2: ITEMS TABLE, TOTALS & TERMS ===================== */}
        <div className="print-card bg-[#F4F6F8] rounded-2xl p-4 sm:p-5 border border-gray-200/50 space-y-2.5">
          {/* Table Headers */}
          <div className="grid grid-cols-12 text-[11px] font-bold text-gray-800 pb-1.5 border-b border-gray-200/70">
            <div className="col-span-6">Items</div>
            <div className="col-span-2 text-center">QTY</div>
            <div className="col-span-2 text-center">Rate ( PKR )</div>
            <div className="col-span-2 text-right">Amount ( PKR )</div>
          </div>

          {/* Item Rows */}
          <div className="space-y-1.5 text-xs text-gray-800">
            {items.map((item, idx) => (
              <div key={idx} className="grid grid-cols-12 items-center text-[11px] pb-1.5 border-b border-gray-200/60">
                <div className="col-span-6 text-gray-700 truncate pr-1">
                  {idx + 1}.{item.name}
                </div>
                <div className="col-span-2 text-center text-gray-700">
                  {item.qty}
                </div>
                <div className="col-span-2 text-center text-gray-700">
                  {formatNumber(item.rate)}
                </div>
                <div className="col-span-2 text-right font-bold text-gray-900">
                  {formatNumber(item.amount)}
                </div>
              </div>
            ))}
          </div>

          {/* Subtotal & Adjustment */}
          <div className="pt-1 space-y-1 text-xs">
            <div className="flex justify-between items-center text-gray-900 font-bold text-[11px]">
              <span>Sub total</span>
              <span>{formatNumber(subTotal)}</span>
            </div>
            <div className="flex justify-between items-center text-gray-900 font-bold text-[11px]">
              <span>Adjustment</span>
              <span>{adjustment === 0 ? "00" : formatNumber(adjustment)}</span>
            </div>
          </div>

          {/* Solid Green Total Offer / Total Amount Bar */}
          <div className="print-highlight bg-[#009845] text-white rounded-xl px-4 py-2 flex justify-between items-center font-bold text-xs shadow-xs mt-1">
            <span>{isInvoice ? "Total Amount ( PKR )" : "Total Offer ( PKR )"}</span>
            <span>{formatNumber(totalOffer)}</span>
          </div>

          <div className="border-t border-gray-200/70 pt-2" />

          {/* Terms & Conditions */}
          <div className="space-y-0.5 text-[11px] text-gray-600">
            <p className="font-bold text-gray-900">Terms &amp; Conditions</p>
            {isInvoice ? (
              <>
                <p className="text-[10px] text-gray-500">
                  • Official commercial invoice for inspected solar scrap &amp; equipment.
                </p>
                <p className="text-[10px] text-gray-500">
                  • Certified transaction and equipment handover.
                </p>
              </>
            ) : (
              <>
                <p className="text-[10px] text-gray-500">
                  • This is an estimated offer and valid for the mentioned date only.
                </p>
                <p className="text-[10px] text-gray-500">
                  • Final price may vary after physical inspection
                </p>
              </>
            )}
            <p className="text-xs font-bold text-gray-900 pt-1">Thank you</p>
          </div>
        </div>

        {/* ===================== BOX 3: QUOTATION / INVOICE ACTIONS ===================== */}
        <div className="no-print bg-[#F4F6F8] rounded-2xl p-4 border border-gray-200/50 space-y-2.5">
          <p className="text-xs font-bold text-gray-900">
            {isInvoice ? "Invoice Actions" : "Quotation Actions"}
          </p>
          <div className="grid grid-cols-2 gap-3">
            <button
              type="button"
              onClick={handlePrintPdf}
              className="flex items-center justify-center gap-2 py-2 px-3 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200/90 rounded-xl text-xs font-semibold transition-colors shadow-2xs cursor-pointer"
            >
              <Download className="w-3.5 h-3.5 text-gray-600" />
              <span>{isInvoice ? "Download Invoice PDF" : "Download pdf"}</span>
            </button>

            <button
              type="button"
              onClick={() => {
                const nextState = !isInvoice;
                setIsInvoice(nextState);
                if (nextState && onConvertToInvoice) {
                  onConvertToInvoice();
                }
              }}
              className={`flex items-center justify-center gap-2 py-2 px-3 rounded-xl text-xs font-semibold transition-colors shadow-2xs cursor-pointer ${
                isInvoice
                  ? "bg-[#E6F9ED] text-[#009845] border border-[#009845]/40 hover:bg-[#d5f5e0]"
                  : "bg-white hover:bg-gray-50 text-gray-700 border border-gray-200/90"
              }`}
            >
              <FileText className="w-3.5 h-3.5 text-gray-600" />
              <span>{isInvoice ? "Switch to Quotation" : "Convert to Invoice"}</span>
            </button>
          </div>
        </div>

      </div>
    </div>
  );
}
