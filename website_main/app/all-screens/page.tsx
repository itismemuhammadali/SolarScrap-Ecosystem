"use client";

import Image from "next/image";
import Link from "next/link";
import {
  Sun,
  LayoutDashboard,
  Users,
  Building2,
  FileText,
  Gavel,
  TrendingUp,
  Share2,
  Bell,
  Settings,
  Lock,
  KeyRound,
  ShieldCheck,
  ExternalLink,
  Sparkles,
  Layers,
  ArrowRight,
  CheckCircle2,
} from "lucide-react";

interface ScreenCard {
  title: string;
  category: "Auth Flow" | "Admin Core" | "Marketplace & Bidding" | "Leads & Communication" | "Settings & Security";
  description: string;
  path: string;
  badge: string;
  badgeColor: string;
  icon: any;
  features: string[];
}

const allScreensList: ScreenCard[] = [
  // 1. Auth Flow
  {
    title: "1. Sign In / Login",
    category: "Auth Flow",
    description: "Main authentication entry with Solar Scrap brand logo, email & password fields, password reveal toggle, and forgot password link.",
    path: "/",
    badge: "Auth Entry",
    badgeColor: "bg-emerald-50 text-[#009639] border-emerald-200",
    icon: Lock,
    features: ["Hero Factory Image", "Enlarged Solar Scrap Logo", "Password Eye Toggle", "Forgot Password Link"],
  },
  {
    title: "2. Verify Email",
    category: "Auth Flow",
    description: "Email verification screen for password reset with clean single-column card and scrap AC hero image.",
    path: "/verify-email",
    badge: "Password Recovery",
    badgeColor: "bg-blue-50 text-blue-700 border-blue-200",
    icon: KeyRound,
    features: ["Back to Login Button", "Clean Email Input", "Continue to OTP Action"],
  },
  {
    title: "3. Verify 6-Digit OTP",
    category: "Auth Flow",
    description: "Interactive 6-digit OTP code verification with auto-focus, paste support, backspace handling, and 45s resend timer.",
    path: "/verify-otp",
    badge: "2FA Verification",
    badgeColor: "bg-purple-50 text-purple-700 border-purple-200",
    icon: ShieldCheck,
    features: ["6 Individual OTP Inputs", "Auto-focus Next/Prev", "Paste 6 Digits", "45s Countdown Timer"],
  },
  {
    title: "4. Reset / New Password",
    category: "Auth Flow",
    description: "Create new password with confirmation match validation, eye toggles, and live feedback toast.",
    path: "/reset-password",
    badge: "Password Reset",
    badgeColor: "bg-amber-50 text-amber-700 border-amber-200",
    icon: Lock,
    features: ["New Password", "Confirm Password Match", "Interactive Eye Toggles", "Return to Sign In"],
  },

  // 2. Admin Core
  {
    title: "5. Admin Dashboard",
    category: "Admin Core",
    description: "Complete analytical dashboard with 7 quick metric stat cards, User Growth dual-line SVG chart, User Status donut SVG chart, Bid Activity weekly bar chart, City Leads progress bars, and live activity feed.",
    path: "/dashboard",
    badge: "Analytics & KPI",
    badgeColor: "bg-emerald-50 text-[#009639] border-emerald-200",
    icon: LayoutDashboard,
    features: ["7 Stat KPI Cards", "Dual-line SVG Growth Chart", "Donut Chart Status", "City Progress Bars", "Recent Activity Feed"],
  },
  {
    title: "6. Sellers / EPC Partners",
    category: "Admin Core",
    description: "Manage registered EPC and solar sellers with tab filtering, search, floating action menu, detailed User Profile Modal, and Activate User prompt.",
    path: "/sellers",
    badge: "User Management",
    badgeColor: "bg-indigo-50 text-indigo-700 border-indigo-200",
    icon: Users,
    features: ["Tab Filters (Approved/Pending/Rejected)", "User Details Modal", "Activate User Prompt", "Real-time Search"],
  },
  {
    title: "7. Scrap Dealers",
    category: "Admin Core",
    description: "Verified scrap buyers directory with city location, rating, contact details, floating actions, and interactive user modals.",
    path: "/scrap-dealers",
    badge: "Buyer Directory",
    badgeColor: "bg-teal-50 text-teal-700 border-teal-200",
    icon: Building2,
    features: ["Dealer Accounts Table", "Rating & Location Badges", "Profile Modal", "Action Dropdown Menu"],
  },

  // 3. Marketplace & Bidding
  {
    title: "8. Seller Scrap Posts",
    category: "Marketplace & Bidding",
    description: "Approve, edit, manage and convert scrap posts into auctions with 5 nested popups: Post Details with price banner, Quick Edit Modal, Set Price Valuation Modal, Convert to Auction Modal, and Delete Prompt.",
    path: "/seller-posts",
    badge: "5 Modals Included",
    badgeColor: "bg-amber-50 text-amber-700 border-amber-200",
    icon: FileText,
    features: ["Post Details with Price Banner", "Quick Edit Post Form", "Set Admin Valuation Price", "Convert to Live Auction", "Delete Post Prompt"],
  },
  {
    title: "9. Live Auctions",
    category: "Marketplace & Bidding",
    description: "Manage ongoing and closed auctions with live high bid tracking, Auction Details modal with dual starting/high bid banners, Edit Auction Modal, and Early Close Winner modal.",
    path: "/auctions",
    badge: "Bidding Engine",
    badgeColor: "bg-sky-50 text-sky-700 border-sky-200",
    icon: Gavel,
    features: ["Dual Bid Banners (Starting vs High)", "Photo Gallery Grid", "Winner Detection", "Close Auction Early", "Delete Auction Modal"],
  },
  {
    title: "10. Bid Management",
    category: "Marketplace & Bidding",
    description: "3-Column grid of live dealer bids with Highest/Winner/Lost badges, Auction filter dropdown, and one-click 'Select Winner' confirmation modal.",
    path: "/bids",
    badge: "3-Column Cards Grid",
    badgeColor: "bg-rose-50 text-rose-700 border-rose-200",
    icon: TrendingUp,
    features: ["3-Column Grid Cards", "Auction ID Dropdown Filter", "Select Winner Modal", "Bid Details Popup", "Winner/Lost Highlight Badges"],
  },

  // 4. Leads & Communication
  {
    title: "11. Facebook Leads",
    category: "Leads & Communication",
    description: "Track and follow up incoming Facebook campaign leads with 5 top metric cards, direct Phone/WhatsApp triggers, Update Status radio modal, and internal remarks note modal.",
    path: "/facebook-leads",
    badge: "CRM & Campaign Leads",
    badgeColor: "bg-blue-50 text-blue-700 border-blue-200",
    icon: Share2,
    features: ["5 KPI Stat Metric Cards", "Direct Call & WhatsApp Links", "Update Lead Status Modal", "Internal Notes Modal", "City & Area Filter"],
  },
  {
    title: "12. Notifications Center",
    category: "Leads & Communication",
    description: "Color-coded notification feed matching all designs (Sellers, Bids, Facebook Leads, Posts, Auctions) with green unread dots, Mark All as Read button, and Notification Detail Modal.",
    path: "/notifications",
    badge: "Matched Color Icons",
    badgeColor: "bg-emerald-50 text-emerald-700 border-emerald-200",
    icon: Bell,
    features: ["Color-coded Notification Icons", "Green Unread Indicator Dots", "Mark All as Read", "Notification Detail Popup", "Direct Screen Navigation"],
  },

  // 5. Settings & Security
  {
    title: "13. Platform Settings (7 Working Tabs)",
    category: "Settings & Security",
    description: "2-Column settings layout featuring all 7 tabs: Edit Profile, 2-Column Change Password, Notification Preferences (6 toggles), Session Management (3 device cards + revoke), Login Security (3 toggles), Privacy & Data, and Terms of Service.",
    path: "/settings",
    badge: "All 7 Tabs Live",
    badgeColor: "bg-emerald-50 text-[#009639] border-emerald-200",
    icon: Settings,
    features: ["Edit Profile Avatar & Form", "Change Password 2-Column Grid", "6 Notification Toggle Switches", "3 Session Device Cards + Revoke", "3 Login Security Toggles", "Privacy & Terms of Service"],
  },

  // 6. Quotations & Inventory (New from Figma)
  {
    title: "14. Quotation History",
    category: "Admin Core",
    description: "Table of all quotations with status tabs (All, Approved, Pending, Rejected), search filter, and '+ Create Quotations' action.",
    path: "/quotation-history",
    badge: "New Figma Screen",
    badgeColor: "bg-emerald-50 text-[#009845] border-emerald-200",
    icon: FileText,
    features: ["Status Tabs (Approved/Pending/Rejected)", "Search by Name/Company/Phone", "View Quotation Action", "Create Quotation CTA"],
  },
  {
    title: "15. Create Quotation Builder",
    category: "Admin Core",
    description: "Two-column interactive quotation builder with Personal Details & Item Details on the left, and live Invoice/Quotation Preview on the right.",
    path: "/quotation-history/create",
    badge: "New Figma Screen",
    badgeColor: "bg-emerald-50 text-[#009845] border-emerald-200",
    icon: FileText,
    features: ["Live Calculation Preview", "Add/Remove Dynamic Line Items", "WhatsApp & Email Share", "Download PDF & Convert to Invoice"],
  },
  {
    title: "16. View Quotation Document",
    category: "Admin Core",
    description: "Clean, print-friendly quotation document view matching official Solar Scrap branding with total breakdown and terms.",
    path: "/quotation-history/view",
    badge: "New Figma Screen",
    badgeColor: "bg-blue-50 text-blue-700 border-blue-200",
    icon: FileText,
    features: ["Brand Document Template", "Terms & Conditions", "Print View Support", "Download PDF & Convert to Invoice"],
  },
  {
    title: "17. My Inventory",
    category: "Admin Core",
    description: "Purchased items inventory dashboard with categories (All, Solar, Batteries), quantity counts, purchase dates, and details popup modal.",
    path: "/my-inventory",
    badge: "New Figma Screen",
    badgeColor: "bg-emerald-50 text-[#009845] border-emerald-200",
    icon: Layers,
    features: ["Category Filtering (Solar / Batteries)", "Item Details Modal", "Quantity & Price Badges", "Real-time Search Filter"],
  },
  {
    title: "18. Create Auction Flow (Steps 1 & 2)",
    category: "Marketplace & Bidding",
    description: "Comprehensive equipment auction creation wizard with equipment category selector, condition pills, photo upload slots, live preview card, and multi-equipment support.",
    path: "/auctions/create",
    badge: "New Figma Screen",
    badgeColor: "bg-emerald-50 text-[#009845] border-emerald-200",
    icon: Gavel,
    features: ["6 Equipment Category Cards", "Condition Pills (Scrap, Bullet Hit, etc.)", "Live Listing Card Preview", "Add Multiple Items (Step 2)", "Photo Upload Slots"],
  },
];

export default function AllScreensHub() {
  return (
    <div className="min-h-screen bg-[#111827] text-white p-4 sm:p-6 md:p-10 font-sans">
      <div className="max-w-[1400px] mx-auto space-y-8">
        
        {/* Header Banner */}
        <div className="bg-gradient-to-r from-gray-900 via-gray-800 to-gray-900 border border-white/10 rounded-3xl p-6 sm:p-8 md:p-10 shadow-2xl relative overflow-hidden flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
          <div className="space-y-3 z-10">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#009639]/20 border border-[#009639]/40 text-[#009639] text-xs font-bold uppercase tracking-wider">
              <Sparkles className="w-3.5 h-3.5" />
              <span>Solar Scrap Admin &amp; Seller Portal Complete Suite</span>
            </div>

            <h1 className="text-2xl sm:text-3xl md:text-4xl font-extrabold text-white tracking-tight leading-tight">
              All 13 Platform Screens &amp; Sub-Modals
            </h1>

            <p className="text-gray-400 text-xs sm:text-sm max-w-2xl leading-relaxed">
              Every screen has been meticulously crafted to 100% pixel-perfect accuracy, exact dimensions, matched color icons, and fully interactive modals. Click on any screen below to launch it directly.
            </p>
          </div>

          <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 z-10 shrink-0 w-full md:w-auto">
            <Link
              href="/dashboard"
              className="px-6 py-3 bg-[#009639] hover:bg-[#008230] text-white font-bold text-xs sm:text-sm rounded-xl shadow-lg shadow-[#009639]/30 transition-all flex items-center justify-center gap-2 text-center"
            >
              <span>Launch Dashboard</span>
              <ArrowRight className="w-4 h-4" />
            </Link>

            <Link
              href="/"
              className="px-6 py-3 bg-white/10 hover:bg-white/15 text-white font-bold text-xs sm:text-sm rounded-xl border border-white/10 transition-all flex items-center justify-center gap-2 text-center"
            >
              <span>Sign In Screen</span>
              <Lock className="w-4 h-4" />
            </Link>
          </div>

          {/* Background Decorative Glow */}
          <div className="absolute -right-20 -bottom-20 w-80 h-80 bg-[#009639]/15 rounded-full blur-3xl pointer-events-none" />
        </div>

        {/* Categories Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5 sm:gap-6">
          {allScreensList.map((screen, idx) => {
            const Icon = screen.icon;
            return (
              <div
                key={idx}
                className="bg-gray-900/90 border border-gray-800 rounded-2xl p-5 sm:p-6 hover:border-[#009639]/50 hover:bg-gray-850 transition-all duration-200 shadow-xl flex flex-col justify-between group"
              >
                <div>
                  {/* Top Badge & Category */}
                  <div className="flex items-center justify-between gap-2 pb-3 border-b border-gray-800">
                    <span className="text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                      {screen.category}
                    </span>
                    <span
                      className={`text-[10px] font-bold px-2.5 py-0.5 rounded-full border ${screen.badgeColor}`}
                    >
                      {screen.badge}
                    </span>
                  </div>

                  {/* Title & Icon */}
                  <div className="flex items-center gap-3 mt-4">
                    <div className="w-10 h-10 rounded-xl bg-[#009639]/20 text-[#009639] border border-[#009639]/30 flex items-center justify-center shrink-0 group-hover:scale-105 transition-transform">
                      <Icon className="w-5 h-5" />
                    </div>
                    <h3 className="text-base font-bold text-white group-hover:text-[#009639] transition-colors leading-snug">
                      {screen.title}
                    </h3>
                  </div>

                  {/* Description */}
                  <p className="text-xs text-gray-400 mt-3 leading-relaxed">
                    {screen.description}
                  </p>

                  {/* Feature Tags */}
                  <div className="flex flex-wrap gap-1.5 mt-4">
                    {screen.features.map((feat, fIdx) => (
                      <span
                        key={fIdx}
                        className="text-[10px] bg-gray-800 text-gray-300 px-2 py-0.5 rounded-md border border-gray-700/60"
                      >
                        {feat}
                      </span>
                    ))}
                  </div>
                </div>

                {/* Open Button */}
                <div className="pt-5 mt-5 border-t border-gray-800/80">
                  <Link
                    href={screen.path}
                    className="w-full py-2.5 px-4 bg-gray-800 hover:bg-[#009639] text-gray-200 hover:text-white text-xs font-bold rounded-xl transition-all flex items-center justify-center gap-2 group-hover:shadow-md cursor-pointer"
                  >
                    <span>Open Screen</span>
                    <ExternalLink className="w-3.5 h-3.5" />
                  </Link>
                </div>

              </div>
            );
          })}
        </div>

        {/* Footer */}
        <div className="text-center py-6 border-t border-gray-800 text-xs text-gray-500 flex flex-col sm:flex-row items-center justify-between gap-3">
          <div className="flex items-center gap-2 text-gray-400">
            <Sun className="w-4 h-4 text-[#009639]" />
            <span className="font-bold text-white">Solar Scrap</span>
            <span>— Admin &amp; Seller Portal</span>
          </div>

          <p>© 2026 Solar Scrap. All 13 Screens &amp; Sub-Modals Verified and Live.</p>
        </div>

      </div>
    </div>
  );
}
