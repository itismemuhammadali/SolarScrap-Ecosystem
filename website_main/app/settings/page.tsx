"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import {
  Search,
  Bell,
  Sun,
  Menu,
  X,
  User,
  Key,
  Globe,
  Shield,
  Eye,
  EyeOff,
  FileText,
  Check,
  Smartphone,
  Laptop,
  LogOut,
  Save,
  CheckCircle2,
  Lock,
  Mail,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";
import { getSession, saveSession, getAvatarUrl } from "@/lib/auth";
import {
  updateUserProfile,
  changeUserPassword,
  getUserPreferences,
  updateUserPreferences,
  getUserSessions,
  revokeUserSession,
  revokeAllOtherSessions,
  toggleTwoFactorAuth,
} from "@/lib/admin-api";

export default function SettingsPage() {
  const [activeTab, setActiveTab] = useState<
    | "profile"
    | "password"
    | "notifications"
    | "sessions"
    | "security"
    | "privacy"
    | "terms"
  >("profile");

  const [topSearch, setTopSearch] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  // Profile Form state
  const [fullName, setFullName] = useState("Super Admin");
  const [email, setEmail] = useState("admin@solarscrap.pk");
  const [phone, setPhone] = useState("+92 300 0000000");
  const [role, setRole] = useState("Super Admin");
  const [profilePhotoUrl, setProfilePhotoUrl] = useState<string | null>(null);
  const [isSavingProfile, setIsSavingProfile] = useState(false);

  // Password Form state
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [showCurrent, setShowCurrent] = useState(false);
  const [showNew, setShowNew] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [isSavingPassword, setIsSavingPassword] = useState(false);

  // Notifications Preferences toggles
  const [emailUserApprovals, setEmailUserApprovals] = useState(true);
  const [emailNewBids, setEmailNewBids] = useState(true);
  const [emailFacebookLeads, setEmailFacebookLeads] = useState(true);
  const [pushNotifications, setPushNotifications] = useState(false);
  const [pushDealUpdates, setPushDealUpdates] = useState(false);
  const [smsFacebookLeads, setSmsFacebookLeads] = useState(false);

  // Sessions state
  const [sessions, setSessions] = useState<any[]>([
    {
      id: "curr_default",
      device: "Current Web Browser",
      location: "Karachi, PK",
      time: "Active now",
      isCurrent: true,
    },
  ]);

  // Login Security toggles
  const [twoFactorAuth, setTwoFactorAuth] = useState(false);
  const [loginAlerts, setLoginAlerts] = useState(true);
  const [trustedDevicesOnly, setTrustedDevicesOnly] = useState(false);

  // Toast feedback
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3500);
  };

  useEffect(() => {
    const session = getSession();
    if (session?.user) {
      if (session.user.display_name) setFullName(session.user.display_name);
      if (session.user.email) setEmail(session.user.email);
      if (session.user.phone_number) setPhone(session.user.phone_number);
      if (session.user.role) setRole(session.user.role.toUpperCase());
      if (session.user.profile_photo_url) setProfilePhotoUrl(session.user.profile_photo_url);
    }

    // Load persisted preferences from backend
    getUserPreferences().then((prefs) => {
      if (prefs) {
        if (typeof prefs.email_user_approvals === "boolean") setEmailUserApprovals(prefs.email_user_approvals);
        if (typeof prefs.email_new_bids === "boolean") setEmailNewBids(prefs.email_new_bids);
        if (typeof prefs.email_facebook_leads === "boolean") setEmailFacebookLeads(prefs.email_facebook_leads);
        if (typeof prefs.push_notifications === "boolean") setPushNotifications(prefs.push_notifications);
        if (typeof prefs.push_deal_updates === "boolean") setPushDealUpdates(prefs.push_deal_updates);
        if (typeof prefs.sms_facebook_leads === "boolean") setSmsFacebookLeads(prefs.sms_facebook_leads);
        if (typeof prefs.login_alerts === "boolean") setLoginAlerts(prefs.login_alerts);
        if (typeof prefs.trusted_devices_only === "boolean") setTrustedDevicesOnly(prefs.trusted_devices_only);
        if (typeof prefs.two_factor_enabled === "boolean") setTwoFactorAuth(prefs.two_factor_enabled);
      }
    });

    // Load active sessions from backend
    getUserSessions().then((sessList) => {
      if (sessList && sessList.length > 0) {
        setSessions(sessList);
      }
    });
  }, []);

  const handleSaveProfile = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      setIsSavingProfile(true);
      await updateUserProfile({
        display_name: fullName,
        phone_number: phone,
      });

      const session = getSession();
      if (session) {
        saveSession(session.token, {
          ...session.user,
          display_name: fullName,
          phone_number: phone,
        });
      }
      showToast("Profile settings saved successfully!");
    } catch (err: any) {
      showToast(err.message || "Failed to save profile.");
    } finally {
      setIsSavingProfile(false);
    }
  };

  const handleSavePassword = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!currentPassword) {
      showToast("Please enter your current password.");
      return;
    }
    if (newPassword !== confirmPassword) {
      showToast("Passwords do not match!");
      return;
    }
    if (newPassword.length < 6) {
      showToast("Password must be at least 6 characters!");
      return;
    }
    try {
      setIsSavingPassword(true);
      await changeUserPassword(currentPassword, newPassword);
      setCurrentPassword("");
      setNewPassword("");
      setConfirmPassword("");
      showToast("Password updated successfully!");
    } catch (err: any) {
      showToast(err.message || "Failed to update password.");
    } finally {
      setIsSavingPassword(false);
    }
  };

  const handleTogglePref = async (
    key: string,
    currentVal: boolean,
    setter: (val: boolean) => void,
    label: string
  ) => {
    const newVal = !currentVal;
    setter(newVal);
    try {
      await updateUserPreferences({ [key]: newVal });
      showToast(`${label} ${newVal ? "enabled" : "disabled"}`);
    } catch (e) {
      setter(currentVal);
      showToast(`Failed to update ${label}`);
    }
  };

  const handleToggle2FA = async () => {
    const newVal = !twoFactorAuth;
    setTwoFactorAuth(newVal);
    try {
      await toggleTwoFactorAuth(newVal);
      await updateUserPreferences({ two_factor_enabled: newVal });
      showToast(`Two-Factor Authentication ${newVal ? "enabled" : "disabled"}`);
    } catch (e) {
      setTwoFactorAuth(!newVal);
      showToast("Failed to update Two-Factor Authentication");
    }
  };

  const handleRevokeSession = async (sess: any) => {
    try {
      await revokeUserSession(sess.id);
      setSessions((prev) => prev.filter((s) => s.id !== sess.id));
      showToast(`Revoked session: ${sess.device}`);
    } catch (e) {
      showToast("Failed to revoke session");
    }
  };

  const handleRevokeAllOtherSessions = async () => {
    try {
      await revokeAllOtherSessions();
      setSessions((prev) => prev.filter((s) => s.isCurrent || s.is_current));
      showToast("All other sessions revoked successfully!");
    } catch (e) {
      showToast("Failed to revoke sessions");
    }
  };

  const navItems = [
    { name: "Dashboard", icon: "/icons/dashboard.svg", href: "/dashboard" },
    { name: "Sellers / EPC", icon: "/icons/seller.svg", href: "/sellers" },
    { name: "Scrap Dealers", icon: "/icons/scrap-dealer.svg", href: "/scrap-dealers" },
    { name: "Seller Posts", icon: "/icons/seller-post.svg", href: "/seller-posts" },
    { name: "Auctions", icon: "/icons/auction.svg", href: "/auctions" },
    { name: "Bids", icon: "/icons/bids.svg", href: "/bids" },
    { name: "Facebook Leads", icon: "/icons/facebook-leads.svg", href: "/facebook-leads" },
    { name: "Quotation history", icon: "/icons/quotation-history.svg", href: "/quotation-history" },
    { name: "My Inventory", icon: "/icons/inventory.svg", href: "/my-inventory" },
    { name: "Notifications", icon: "/icons/notifications.svg", href: "/notifications" },
    { name: "Settings", icon: "/icons/setting.svg", href: "/settings" },
  ];

  const settingsMenuItems = [
    { id: "profile", label: "Edit Profile", icon: User },
    { id: "password", label: "Change Password", icon: Key },
    { id: "notifications", label: "Notification Preferences", icon: Bell },
    { id: "sessions", label: "Session Management", icon: Globe },
    { id: "security", label: "Login Security", icon: Shield },
    { id: "privacy", label: "Privacy & Data", icon: Eye },
    { id: "terms", label: "Terms of Service", icon: FileText },
  ] as const;

  return (
    <div className="flex h-screen w-full bg-[#F5F6FA] overflow-hidden">
      {/* ===================== UNIFIED SIDEBAR ===================== */}
      <Sidebar
        activeItem="Settings"
        mobileMenuOpen={mobileMenuOpen}
        setMobileMenuOpen={setMobileMenuOpen}
      />

      {/* ===================== MAIN CONTENT AREA ===================== */}
      <div className="flex-1 bg-[#F5F6FA] flex flex-col min-w-0 h-screen overflow-hidden">
        
        {/* Top Navbar */}
        <header className="sticky top-0 z-20 bg-white border-b border-gray-200/80 px-5 sm:px-8 py-3.5 flex items-center justify-between gap-4">
            <div className="relative flex-1 max-w-[420px]">
              <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                value={topSearch}
                onChange={(e) => setTopSearch(e.target.value)}
                placeholder="Search users, posts, auctions, bids..."
                className="w-full pl-10 pr-4 py-2 text-xs sm:text-sm bg-gray-50/70 border border-gray-200/80 rounded-xl outline-none focus:bg-white focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all text-gray-800 placeholder:text-gray-400"
              />
            </div>

            <div className="flex items-center gap-4 sm:gap-6">
              <Link
                href="/notifications"
                className="relative p-2 text-gray-500 hover:text-gray-800 hover:bg-gray-100 rounded-full transition-colors"
                aria-label="Notifications"
              >
                <Bell className="w-4.5 h-4.5" />
                <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white" />
              </Link>

              <div className="flex items-center gap-3 pl-2 sm:border-l border-gray-200">
                <span className="hidden sm:inline-block text-xs font-semibold text-gray-800">
                  {fullName}
                </span>
                <div className="relative w-8.5 h-8.5 sm:w-9 sm:h-9 rounded-full overflow-hidden ring-2 ring-gray-100 shadow-sm bg-emerald-700 flex items-center justify-center text-white font-bold text-sm select-none">
                  {profilePhotoUrl ? (
                    /* eslint-disable-next-line @next/next/no-img-element */
                    <img
                      src={getAvatarUrl(profilePhotoUrl)!}
                      alt={fullName}
                      className="w-full h-full object-cover"
                    />
                  ) : (
                    <span>{fullName ? fullName.charAt(0).toUpperCase() : "A"}</span>
                  )}
                </div>
              </div>
            </div>
          </header>

          {/* Main Body */}
          <main className="flex-1 p-5 sm:p-7 md:p-8 space-y-6 overflow-y-auto">
            
            {/* Header Title */}
            <div>
              <h1 className="text-xl sm:text-2xl font-bold text-gray-900 tracking-tight">
                Settings
              </h1>
              <p className="text-xs text-gray-500 mt-0.5">
                Manage your account and platform preferences.
              </p>
            </div>

            {/* 2-Column Settings Layout */}
            <div className="flex flex-col md:flex-row gap-5 items-start">
              
              {/* Settings Nav Menu (Left Column) */}
              <div className="w-full md:w-64 bg-white rounded-2xl border border-gray-200/80 p-2 shadow-2xs space-y-0.5 shrink-0">
                {settingsMenuItems.map((item) => {
                  const isActive = activeTab === item.id;
                  const Icon = item.icon;
                  return (
                    <button
                      key={item.id}
                      type="button"
                      onClick={() => setActiveTab(item.id)}
                      className={`w-full flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold transition-all duration-150 text-left cursor-pointer ${
                        isActive
                          ? "bg-emerald-50 text-[#009845]"
                          : "text-gray-500 hover:text-gray-900 hover:bg-gray-50"
                      }`}
                    >
                      <Icon
                        className={`w-4 h-4 shrink-0 ${
                          isActive ? "text-[#009845]" : "text-gray-400"
                        }`}
                      />
                      <span className="truncate">{item.label}</span>
                    </button>
                  );
                })}
              </div>

              {/* Settings Tab Content (Right Column) */}
              <div className="flex-1 w-full bg-white rounded-2xl border border-gray-200/80 p-6 sm:p-7 shadow-2xs">
                
                {/* ===================== TAB 1: EDIT PROFILE ===================== */}
                {activeTab === "profile" && (
                  <div>
                    <h2 className="text-base font-bold text-gray-900 pb-4 border-b border-gray-100">
                      Edit Profile
                    </h2>

                    {/* Avatar Block */}
                    <div className="flex items-center gap-4 py-5">
                      <div className="w-14 h-14 rounded-2xl bg-[#009845] text-white flex items-center justify-center font-black text-xl shadow-xs shrink-0 overflow-hidden ring-1 ring-gray-200">
                        {profilePhotoUrl ? (
                          /* eslint-disable-next-line @next/next/no-img-element */
                          <img
                            src={getAvatarUrl(profilePhotoUrl)!}
                            alt={fullName}
                            className="w-full h-full object-cover"
                          />
                        ) : (
                          fullName.charAt(0).toUpperCase() || "A"
                        )}
                      </div>
                      <div>
                        <h3 className="text-sm font-bold text-gray-900">{fullName}</h3>
                        <p className="text-xs text-gray-500 font-mono">{email}</p>
                        <button
                          type="button"
                          onClick={() => showToast("Photo upload feature ready.")}
                          className="text-[11px] font-bold text-[#009845] hover:underline mt-1 cursor-pointer"
                        >
                          Change photo
                        </button>
                      </div>
                    </div>

                    {/* Form Grid */}
                    <form onSubmit={handleSaveProfile} className="space-y-4 pt-2">
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                          <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                            Full Name
                          </label>
                          <input
                            type="text"
                            value={fullName}
                            onChange={(e) => setFullName(e.target.value)}
                            required
                            className="w-full px-3.5 py-2.5 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-1 focus:ring-[#009845]/20 text-gray-900 font-medium"
                          />
                        </div>

                        <div>
                          <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                            Email Address
                          </label>
                          <input
                            type="email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                            className="w-full px-3.5 py-2.5 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-1 focus:ring-[#009845]/20 text-gray-900 font-medium font-mono"
                          />
                        </div>

                        <div>
                          <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                            Phone Number
                          </label>
                          <input
                            type="text"
                            value={phone}
                            onChange={(e) => setPhone(e.target.value)}
                            className="w-full px-3.5 py-2.5 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-1 focus:ring-[#009845]/20 text-gray-900 font-medium font-mono"
                          />
                        </div>

                        <div>
                          <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                            Role
                          </label>
                          <input
                            type="text"
                            value={role}
                            disabled
                            className="w-full px-3.5 py-2.5 text-xs bg-gray-50 border border-gray-200 rounded-xl text-gray-600 font-medium"
                          />
                        </div>
                      </div>

                      <div className="pt-3">
                        <button
                          type="submit"
                          disabled={isSavingProfile}
                          className="px-6 py-2.5 bg-[#009845] hover:bg-[#008230] text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer disabled:opacity-50"
                        >
                          {isSavingProfile ? "Saving..." : "Save Changes"}
                        </button>
                      </div>
                    </form>
                  </div>
                )}

                {/* ===================== TAB 2: CHANGE PASSWORD ===================== */}
                {activeTab === "password" && (
                  <div>
                    <h2 className="text-base font-bold text-gray-900 mb-5">
                      Change Password
                    </h2>

                    <form onSubmit={handleSavePassword} className="space-y-4">
                      {/* Row 1: Current Password & New Password (2 Columns) */}
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                          <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                            Current Password
                          </label>
                          <div className="relative">
                            <input
                              type={showCurrent ? "text" : "password"}
                              value={currentPassword}
                              onChange={(e) => setCurrentPassword(e.target.value)}
                              placeholder="••••••••"
                              className="w-full px-3.5 py-2.5 pr-10 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-1 focus:ring-[#009845]/20 text-gray-900"
                            />
                            <button
                              type="button"
                              onClick={() => setShowCurrent(!showCurrent)}
                              className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 cursor-pointer"
                            >
                              {showCurrent ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                            </button>
                          </div>
                        </div>

                        <div>
                          <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                            New Password
                          </label>
                          <div className="relative">
                            <input
                              type={showNew ? "text" : "password"}
                              value={newPassword}
                              onChange={(e) => setNewPassword(e.target.value)}
                              placeholder="••••••••"
                              className="w-full px-3.5 py-2.5 pr-10 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-1 focus:ring-[#009845]/20 text-gray-900"
                            />
                            <button
                              type="button"
                              onClick={() => setShowNew(!showNew)}
                              className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 cursor-pointer"
                            >
                              {showNew ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                            </button>
                          </div>
                        </div>
                      </div>

                      {/* Row 2: Confirm New Password (Left column only) */}
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                          <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                            Confirm New Password
                          </label>
                          <div className="relative">
                            <input
                              type={showConfirm ? "text" : "password"}
                              value={confirmPassword}
                              onChange={(e) => setConfirmPassword(e.target.value)}
                              placeholder="••••••••"
                              className="w-full px-3.5 py-2.5 pr-10 text-xs bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-1 focus:ring-[#009845]/20 text-gray-900"
                            />
                            <button
                              type="button"
                              onClick={() => setShowConfirm(!showConfirm)}
                              className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 cursor-pointer"
                            >
                              {showConfirm ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                            </button>
                          </div>
                        </div>
                      </div>

                      {/* Row 3: Update Password Button */}
                      <div className="pt-2">
                        <button
                          type="submit"
                          disabled={isSavingPassword}
                          className="px-6 py-2.5 bg-[#009845] hover:bg-[#008230] text-white text-xs font-semibold rounded-xl shadow-xs transition-colors cursor-pointer disabled:opacity-50"
                        >
                          {isSavingPassword ? "Updating..." : "Update Password"}
                        </button>
                      </div>
                    </form>
                  </div>
                )}

                {/* ===================== TAB 3: NOTIFICATION PREFERENCES ===================== */}
                {activeTab === "notifications" && (
                  <div>
                    <h2 className="text-base font-bold text-gray-900 mb-6">
                      Notification Preferences
                    </h2>

                    <div className="space-y-6">
                      {/* Row 1: Email — New User Approvals */}
                      <div className="flex items-center justify-between gap-4">
                        <div className="flex items-start gap-3.5">
                          <Mail className="w-4 h-4 text-gray-500 shrink-0 mt-0.5" />
                          <div>
                            <p className="text-xs font-bold text-gray-900 leading-tight">
                              Email — New User Approvals
                            </p>
                            <p className="text-[11px] text-gray-400 mt-0.5">
                              Get notified when a new seller or dealer registers
                            </p>
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() =>
                            handleTogglePref(
                              "email_user_approvals",
                              emailUserApprovals,
                              setEmailUserApprovals,
                              "User approval emails"
                            )
                          }
                          className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out outline-none ${
                            emailUserApprovals ? "bg-[#009845]" : "bg-gray-200"
                          }`}
                        >
                          <span
                            className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-md ring-0 transition duration-200 ease-in-out ${
                              emailUserApprovals ? "translate-x-5" : "translate-x-0"
                            }`}
                          />
                        </button>
                      </div>

                      {/* Row 2: Email — New Bids */}
                      <div className="flex items-center justify-between gap-4">
                        <div className="flex items-start gap-3.5">
                          <Mail className="w-4 h-4 text-gray-500 shrink-0 mt-0.5" />
                          <div>
                            <p className="text-xs font-bold text-gray-900 leading-tight">
                              Email — New Bids
                            </p>
                            <p className="text-[11px] text-gray-400 mt-0.5">
                              Get notified when a bid is placed on any auction
                            </p>
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() =>
                            handleTogglePref(
                              "email_new_bids",
                              emailNewBids,
                              setEmailNewBids,
                              "Bid alert emails"
                            )
                          }
                          className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out outline-none ${
                            emailNewBids ? "bg-[#009845]" : "bg-gray-200"
                          }`}
                        >
                          <span
                            className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-md ring-0 transition duration-200 ease-in-out ${
                              emailNewBids ? "translate-x-5" : "translate-x-0"
                            }`}
                          />
                        </button>
                      </div>

                      {/* Row 3: Email — Facebook Leads */}
                      <div className="flex items-center justify-between gap-4">
                        <div className="flex items-start gap-3.5">
                          <Mail className="w-4 h-4 text-gray-500 shrink-0 mt-0.5" />
                          <div>
                            <p className="text-xs font-bold text-gray-900 leading-tight">
                              Email — Facebook Leads
                            </p>
                            <p className="text-[11px] text-gray-400 mt-0.5">
                              Get notified when a new lead arrives from Facebook
                            </p>
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() =>
                            handleTogglePref(
                              "email_facebook_leads",
                              emailFacebookLeads,
                              setEmailFacebookLeads,
                              "Facebook lead emails"
                            )
                          }
                          className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out outline-none ${
                            emailFacebookLeads ? "bg-[#009845]" : "bg-gray-200"
                          }`}
                        >
                          <span
                            className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-md ring-0 transition duration-200 ease-in-out ${
                              emailFacebookLeads ? "translate-x-5" : "translate-x-0"
                            }`}
                          />
                        </button>
                      </div>

                      {/* Row 4: Push Notifications */}
                      <div className="flex items-center justify-between gap-4">
                        <div className="flex items-start gap-3.5">
                          <Bell className="w-4 h-4 text-gray-500 shrink-0 mt-0.5" />
                          <div>
                            <p className="text-xs font-bold text-gray-900 leading-tight">
                              Push Notifications
                            </p>
                            <p className="text-[11px] text-gray-400 mt-0.5">
                              Browser push alerts for real-time activity
                            </p>
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() =>
                            handleTogglePref(
                              "push_notifications",
                              pushNotifications,
                              setPushNotifications,
                              "Push notifications"
                            )
                          }
                          className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out outline-none ${
                            pushNotifications ? "bg-[#009845]" : "bg-gray-200"
                          }`}
                        >
                          <span
                            className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-md ring-0 transition duration-200 ease-in-out ${
                              pushNotifications ? "translate-x-5" : "translate-x-0"
                            }`}
                          />
                        </button>
                      </div>

                      {/* Row 5: Push — Deal Updates */}
                      <div className="flex items-center justify-between gap-4">
                        <div className="flex items-start gap-3.5">
                          <Bell className="w-4 h-4 text-gray-500 shrink-0 mt-0.5" />
                          <div>
                            <p className="text-xs font-bold text-gray-900 leading-tight">
                              Push — Deal Updates
                            </p>
                            <p className="text-[11px] text-gray-400 mt-0.5">
                              Browser alerts for deal status changes
                            </p>
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() =>
                            handleTogglePref(
                              "push_deal_updates",
                              pushDealUpdates,
                              setPushDealUpdates,
                              "Deal update push alerts"
                            )
                          }
                          className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out outline-none ${
                            pushDealUpdates ? "bg-[#009845]" : "bg-gray-200"
                          }`}
                        >
                          <span
                            className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-md ring-0 transition duration-200 ease-in-out ${
                              pushDealUpdates ? "translate-x-5" : "translate-x-0"
                            }`}
                          />
                        </button>
                      </div>

                      {/* Row 6: SMS — Facebook Leads */}
                      <div className="flex items-center justify-between gap-4">
                        <div className="flex items-start gap-3.5">
                          <Smartphone className="w-4 h-4 text-gray-500 shrink-0 mt-0.5" />
                          <div>
                            <p className="text-xs font-bold text-gray-900 leading-tight">
                              SMS — Facebook Leads
                            </p>
                            <p className="text-[11px] text-gray-400 mt-0.5">
                              SMS alert when a new Facebook lead is received
                            </p>
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() =>
                            handleTogglePref(
                              "sms_facebook_leads",
                              smsFacebookLeads,
                              setSmsFacebookLeads,
                              "SMS lead alerts"
                            )
                          }
                          className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out outline-none ${
                            smsFacebookLeads ? "bg-[#009845]" : "bg-gray-200"
                          }`}
                        >
                          <span
                            className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-md ring-0 transition duration-200 ease-in-out ${
                              smsFacebookLeads ? "translate-x-5" : "translate-x-0"
                            }`}
                          />
                        </button>
                      </div>
                    </div>
                  </div>
                )}

                {/* ===================== TAB 4: SESSION MANAGEMENT ===================== */}
                {activeTab === "sessions" && (
                  <div>
                    <h2 className="text-base font-bold text-gray-900 mb-5">
                      Session Management
                    </h2>

                    <div className="space-y-3">
                      {sessions.map((sess) => (
                        <div
                          key={sess.id}
                          className="p-3.5 bg-white border border-gray-200/80 rounded-2xl flex items-center justify-between gap-4 transition-all"
                        >
                          <div className="flex items-center gap-3">
                            {/* Dot indicator */}
                            <span
                              className={`w-2 h-2 rounded-full shrink-0 ${
                                sess.isCurrent ? "bg-emerald-500" : "bg-gray-300"
                              }`}
                            />
                            <div>
                              <p className="text-xs font-bold text-gray-900 leading-tight">
                                {sess.device}
                              </p>
                              <p className="text-[11px] text-gray-400 mt-0.5">
                                {sess.location} · {sess.time}
                              </p>
                            </div>
                          </div>

                          {sess.isCurrent || sess.is_current ? (
                            <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-50 text-emerald-700 border border-emerald-200">
                              Current
                            </span>
                          ) : (
                            <button
                              type="button"
                              onClick={() => handleRevokeSession(sess)}
                              className="text-xs font-semibold text-red-600 hover:text-red-700 hover:underline cursor-pointer"
                            >
                              Revoke
                            </button>
                          )}
                        </div>
                      ))}
                    </div>

                    {/* Revoke All Other Sessions Button */}
                    <div className="pt-3">
                      <button
                        type="button"
                        onClick={handleRevokeAllOtherSessions}
                        className="px-4 py-2 border border-red-200 text-red-600 hover:bg-red-50 text-xs font-semibold rounded-xl transition-colors cursor-pointer shadow-2xs"
                      >
                        Revoke All Other Sessions
                      </button>
                    </div>
                  </div>
                )}

                {/* ===================== TAB 5: LOGIN SECURITY ===================== */}
                {activeTab === "security" && (
                  <div>
                    <h2 className="text-base font-bold text-gray-900 mb-6">
                      Login Security
                    </h2>

                    <div className="space-y-6">
                      {/* Row 1: Two-Factor Authentication */}
                      <div className="flex items-center justify-between gap-4">
                        <div>
                          <p className="text-xs font-bold text-gray-900 leading-tight">
                            Two-Factor Authentication
                          </p>
                          <p className="text-[11px] text-gray-400 mt-0.5">
                            Add an extra layer of security to your account
                          </p>
                        </div>
                        <button
                          type="button"
                          onClick={handleToggle2FA}
                          className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out outline-none ${
                            twoFactorAuth ? "bg-[#009845]" : "bg-gray-200"
                          }`}
                        >
                          <span
                            className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-md ring-0 transition duration-200 ease-in-out ${
                              twoFactorAuth ? "translate-x-5" : "translate-x-0"
                            }`}
                          />
                        </button>
                      </div>

                      {/* Row 2: Login Alerts */}
                      <div className="flex items-center justify-between gap-4">
                        <div>
                          <p className="text-xs font-bold text-gray-900 leading-tight">
                            Login Alerts
                          </p>
                          <p className="text-[11px] text-gray-400 mt-0.5">
                            Get notified when someone signs in from a new device
                          </p>
                        </div>
                        <button
                          type="button"
                          onClick={() =>
                            handleTogglePref(
                              "login_alerts",
                              loginAlerts,
                              setLoginAlerts,
                              "Login alerts"
                            )
                          }
                          className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out outline-none ${
                            loginAlerts ? "bg-[#009845]" : "bg-gray-200"
                          }`}
                        >
                          <span
                            className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-md ring-0 transition duration-200 ease-in-out ${
                              loginAlerts ? "translate-x-5" : "translate-x-0"
                            }`}
                          />
                        </button>
                      </div>

                      {/* Row 3: Trusted Devices Only */}
                      <div className="flex items-center justify-between gap-4">
                        <div>
                          <p className="text-xs font-bold text-gray-900 leading-tight">
                            Trusted Devices Only
                          </p>
                          <p className="text-[11px] text-gray-400 mt-0.5">
                            Only allow access from recognized devices
                          </p>
                        </div>
                        <button
                          type="button"
                          onClick={() =>
                            handleTogglePref(
                              "trusted_devices_only",
                              trustedDevicesOnly,
                              setTrustedDevicesOnly,
                              "Trusted devices only"
                            )
                          }
                          className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out outline-none ${
                            trustedDevicesOnly ? "bg-[#009845]" : "bg-gray-200"
                          }`}
                        >
                          <span
                            className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-md ring-0 transition duration-200 ease-in-out ${
                              trustedDevicesOnly ? "translate-x-5" : "translate-x-0"
                            }`}
                          />
                        </button>
                      </div>
                    </div>
                  </div>
                )}

                {/* ===================== TAB 6: PRIVACY & DATA ===================== */}
                {activeTab === "privacy" && (
                  <div>
                    <h2 className="text-base font-bold text-gray-900 mb-2">
                      Privacy &amp; Data
                    </h2>
                    <p className="text-xs text-gray-500 leading-relaxed max-w-2xl">
                      Solar Scrap collects and processes admin data solely for platform management purposes. All data is encrypted and stored securely.
                    </p>
                    <button
                      type="button"
                      onClick={() => showToast("Opening Privacy & Data document...")}
                      className="text-xs font-semibold text-[#009845] hover:underline mt-4 cursor-pointer inline-block"
                    >
                      View full document &rarr;
                    </button>
                  </div>
                )}

                {/* ===================== TAB 7: TERMS OF SERVICE ===================== */}
                {activeTab === "terms" && (
                  <div>
                    <h2 className="text-base font-bold text-gray-900 mb-2">
                      Terms of Service
                    </h2>
                    <p className="text-xs text-gray-500 leading-relaxed max-w-2xl">
                      By using the Solar Scrap Admin Portal, you agree to our terms of service and acceptable use policy.
                    </p>
                    <button
                      type="button"
                      onClick={() => showToast("Opening Terms of Service document...")}
                      className="text-xs font-semibold text-[#009845] hover:underline mt-4 cursor-pointer inline-block"
                    >
                      View full document &rarr;
                    </button>
                  </div>
                )}

              </div>

            </div>

          </main>

        </div>

      {/* ===================== TOAST NOTIFICATION ===================== */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 bg-gray-900 text-white text-xs px-4 py-3 rounded-xl shadow-2xl flex items-center gap-2 z-50 animate-slideUp">
          <Check className="w-4 h-4 text-[#009845]" />
          <span>{toastMessage}</span>
        </div>
      )}

      </div>
  );
}
