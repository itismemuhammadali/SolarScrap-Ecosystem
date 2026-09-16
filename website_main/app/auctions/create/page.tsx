"use client";

import { useState, useRef, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createAdminAuction, createAdminListing, uploadListingImageFile } from "@/lib/admin-api";
import { getSession, getAvatarUrl } from "@/lib/auth";
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
  CheckCircle,
  Plus,
  Trash2,
  Sliders,
  Layers,
  Zap,
  Battery,
  Cable,
  Building,
} from "lucide-react";
import Sidebar from "@/components/Sidebar";

// Category Definitions matching App & Website Figma
const categories = [
  {
    id: "Solar Panels",
    label: "Solar Panels",
    image: "/images/solar-panel.jpg",
    fit: "cover",
  },
  {
    id: "Batteries",
    label: "Batteries",
    image: "/images/battery.jpg",
    fit: "contain",
  },
  {
    id: "Inverters",
    label: "Inverters",
    image: "/images/inverter.png",
    fit: "contain",
  },
  {
    id: "Cables",
    label: "Cables",
    image: "/images/cables.jpg",
    fit: "cover",
  },
  {
    id: "Structure",
    label: "Structure",
    image: "/images/structure.png",
    fit: "cover",
  },
  {
    id: "Complete Solar System",
    label: "Complete Solar System",
    image: "/images/complete-solar-system.jpg",
    fit: "cover",
  },
];

const panelConditions = [
  "Scrap",
  "Bullet Hit",
  "Shatter glass",
  "Good Conditions",
  "Other",
];

const inverterConditions = ["Working", "Non working"];
const batteryConditions = ["Working", "Non working", "Good Conditions", "Scrap"];

export interface AuctionLotItem {
  id: string;
  category: string;
  title: string;
  qty: string;
  condition: string;
  priceDemand: number;
  specs: Record<string, any>;
  images: string[];
  icon: string;
}

export default function CreateAuctionPage() {
  const router = useRouter();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [topSearch, setTopSearch] = useState("");
  const [toast, setToast] = useState<string | null>(null);

  // Selected Category
  const [selectedCategory, setSelectedCategory] = useState("Solar Panels");
  const [adminName, setAdminName] = useState("Admin");
  const [adminPhotoUrl, setAdminPhotoUrl] = useState<string | null>(null);

  useEffect(() => {
    const session = getSession();
    if (session?.user) {
      if (session.user.display_name) setAdminName(session.user.display_name);
      else if (session.user.email) setAdminName(session.user.email.split("@")[0]);
      if (session.user.profile_photo_url) setAdminPhotoUrl(session.user.profile_photo_url);
    }
  }, []);

  // Common Contact & Location Fields
  const [contactInfo, setContactInfo] = useState({
    fullName: "Abdul Rehman",
    phoneNumber: "+92 301 2345678",
    email: "abdul@suntech.com",
    city: "Karachi",
    locality: "DHA Phase 7, Karachi",
    completeAddress: "DHA Phase 7, Sector B, Plot 42, Karachi",
    priceDemand: "Rs 45,000,000",
  });

  useEffect(() => {
    if (typeof window !== "undefined") {
      const sp = new URLSearchParams(window.location.search);
      const cat = sp.get("category");
      const seller = sp.get("seller");
      const city = sp.get("city");
      const basePrice = sp.get("basePrice");
      const title = sp.get("title");

      if (cat) {
        const found = categories.find(
          (c) => c.id.toLowerCase() === cat.toLowerCase()
        );
        if (found) setSelectedCategory(found.id);
      }
      if (seller || city || basePrice) {
        setContactInfo((prev) => ({
          ...prev,
          fullName: seller || prev.fullName,
          city: city || prev.city,
          priceDemand: basePrice
            ? `Rs ${Number(basePrice).toLocaleString("en-PK")}`
            : prev.priceDemand,
        }));
      }
      if (title) {
        setSolarPanels((prev) => ({ ...prev, brand: title }));
      }
    }
  }, []);

  // Category Specific State - Matching Seller App
  // 1. Solar Panels
  const [solarPanels, setSolarPanels] = useState({
    panelsCount: "200",
    wattsPerPanel: "400",
    condition: "Scrap",
    brand: "Waaree Energies",
    purchaseYear: "2019",
  });

  // 2. Inverters
  const [inverters, setInverters] = useState({
    type: "Hybrid", // 'Hybrid' | 'On-Grid'
    ratedPower: "10 kW",
    brand: "Huawei Sun2000",
    condition: "Working",
  });

  // 3. Batteries
  const [batteries, setBatteries] = useState({
    type: "Lithium", // 'Lithium' | 'Lead-Acid'
    count: "16",
    capacity: "100Ah",
    brand: "Narada LiFePO4",
    purchaseYear: "2021",
    yearsUsed: "2",
    condition: "Good Conditions",
  });

  // 4. Cables
  const [cables, setCables] = useState({
    type: "DC", // 'AC' | 'DC'
    conductor: "Copper", // 'Copper' | 'Aluminium'
    insulation: "XLPE", // 'PVC' | 'XLPE' | 'Rubber'
    size: "6mm / 250 meters",
    comments: "High-grade UV-resistant DC solar cables",
  });

  // 5. Structure
  const [structure, setStructure] = useState({
    type: "Elevated", // 'Elevated' | 'Roof Mount' | 'Ground'
    metal: "AL", // 'AL' | 'GI'
    comments: "L2/L3 Elevated Aluminum channel frames",
  });

  // 6. Complete Solar System (Consolidated Details)
  const [completeSystem, setCompleteSystem] = useState({
    systemCapacity: "15 kW",
    comments: "Complete grid-tied 15kW rooftop solar system including all inverters, panels, and structure.",
  });

  // Uploaded Photos State & Item Interface
  interface UploadedImageItem {
    id: string;
    previewUrl: string;
    serverUrl?: string;
    isUploading?: boolean;
    error?: string;
  }

  const [uploadedImages, setUploadedImages] = useState<UploadedImageItem[]>([]);
  const [combinedItems, setCombinedItems] = useState<AuctionLotItem[]>([]);

  const showToast = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 3500);
  };

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;

    const fileList = Array.from(files);
    const newItems: UploadedImageItem[] = fileList.map((file) => ({
      id: `${Date.now()}-${Math.random().toString(36).substring(2, 9)}`,
      previewUrl: URL.createObjectURL(file),
      isUploading: true,
    }));

    setUploadedImages((prev) => [...prev, ...newItems].slice(0, 10));
    showToast(`Uploading ${newItems.length} photo(s)...`);

    if (fileInputRef.current) {
      fileInputRef.current.value = "";
    }

    // Upload each file to backend storage
    for (let i = 0; i < fileList.length; i++) {
      const file = fileList[i];
      const item = newItems[i];
      try {
        const serverUrl = await uploadListingImageFile(file);
        setUploadedImages((prev) =>
          prev.map((img) =>
            img.id === item.id
              ? { ...img, serverUrl, isUploading: false }
              : img
          )
        );
      } catch (err: any) {
        console.error("Listing image upload failed:", err);
        setUploadedImages((prev) =>
          prev.map((img) =>
            img.id === item.id
              ? { ...img, isUploading: false, error: err.message || "Failed" }
              : img
          )
        );
        showToast(`Failed to upload ${file.name}`);
      }
    }
  };

  const handleRemoveImage = (index: number) => {
    setUploadedImages((prev) => {
      const target = prev[index];
      if (target?.previewUrl?.startsWith("blob:")) {
        try {
          URL.revokeObjectURL(target.previewUrl);
        } catch (_) {}
      }
      return prev.filter((_, i) => i !== index);
    });
    showToast("Photo removed.");
  };

  const [isSubmitting, setIsSubmitting] = useState(false);

  const resetFormDetails = () => {
    uploadedImages.forEach((img) => {
      if (img.previewUrl?.startsWith("blob:")) {
        try {
          URL.revokeObjectURL(img.previewUrl);
        } catch (_) {}
      }
    });
    setUploadedImages([]);
    setSolarPanels({
      panelsCount: "",
      wattsPerPanel: "",
      condition: "Scrap",
      brand: "",
      purchaseYear: "",
    });
    setInverters({
      type: "Hybrid",
      ratedPower: "",
      brand: "",
      condition: "Working",
    });
    setBatteries({
      type: "Lithium",
      count: "",
      capacity: "",
      brand: "",
      purchaseYear: "",
      yearsUsed: "",
      condition: "Working",
    });
    setCables({
      type: "DC",
      conductor: "Copper",
      insulation: "XLPE",
      size: "",
      comments: "",
    });
    setStructure({
      type: "Elevated",
      metal: "AL",
      comments: "",
    });
    setCompleteSystem({
      systemCapacity: "",
      comments: "",
    });
    setContactInfo((prev) => ({
      ...prev,
      priceDemand: "",
    }));
  };

  const handleClearListing = () => {
    setContactInfo({
      fullName: "",
      phoneNumber: "",
      email: "",
      city: "",
      locality: "",
      completeAddress: "",
      priceDemand: "",
    });
    resetFormDetails();
    showToast("Form details cleared.");
  };

  const buildCurrentLotItem = (): AuctionLotItem => {
    const rawPrice = Number(contactInfo.priceDemand.replace(/[^0-9]/g, "")) || 0;
    const catIcons: Record<string, string> = {
      "Solar Panels": "☀️",
      "Inverters": "⚡",
      "Batteries": "🔋",
      "Cables": "⚡",
      "Structure": "☀️",
      "Complete Solar System": "⚡",
    };

    let specsObj: Record<string, any> = {};
    let qtyStr = "1 Lot";
    let conditionStr = "Good";

    if (selectedCategory === "Solar Panels") {
      specsObj = {
        panels_count: solarPanels.panelsCount,
        watts_per_panel: solarPanels.wattsPerPanel,
        condition: solarPanels.condition,
        brand: solarPanels.brand,
        purchase_year: solarPanels.purchaseYear,
      };
      qtyStr = `${solarPanels.panelsCount || "200"} Panels`;
      conditionStr = solarPanels.condition;
    } else if (selectedCategory === "Inverters") {
      specsObj = {
        inverter_type: inverters.type,
        rated_power: inverters.ratedPower,
        inverter_brand: inverters.brand,
        condition: inverters.condition,
      };
      qtyStr = `${inverters.ratedPower || "1 Unit"}`;
      conditionStr = inverters.condition;
    } else if (selectedCategory === "Batteries") {
      specsObj = {
        battery_count: batteries.count,
        brand: batteries.brand,
        capacity: batteries.capacity,
        battery_type: batteries.type,
        purchase_year: batteries.purchaseYear,
        years_used: batteries.yearsUsed,
        condition: batteries.condition,
      };
      qtyStr = `${batteries.count || "16"} Units`;
      conditionStr = batteries.condition;
    } else if (selectedCategory === "Cables") {
      specsObj = {
        cable_type: cables.type,
        conductor: cables.conductor,
        insulation: cables.insulation,
        size: cables.size,
        comments: cables.comments,
      };
      qtyStr = cables.size || "1 Lot";
      conditionStr = "Good";
    } else if (selectedCategory === "Structure") {
      specsObj = {
        structure_type: structure.type,
        metal: structure.metal,
        comments: structure.comments,
      };
      qtyStr = structure.type || "1 Lot";
      conditionStr = "Good";
    } else {
      specsObj = {
        system_capacity: completeSystem.systemCapacity,
        comments: completeSystem.comments,
      };
      qtyStr = completeSystem.systemCapacity || "1 System";
      conditionStr = "Good";
    }

    const uploadedServerUrls = uploadedImages
      .map((img) => img.serverUrl)
      .filter((url): url is string => Boolean(url));

    const defaultImages: Record<string, string> = {
      "Solar Panels": "assets/images/solar-panel.jpg",
      "Inverters": "assets/images/inverter.png",
      "Batteries": "assets/images/battery.jpg",
      "Cables": "assets/images/cables.jpg",
      "Structure": "assets/images/structure.png",
      "Complete Solar System": "assets/images/complete-solar-system.jpg",
    };

    const finalImages =
      uploadedServerUrls.length > 0
        ? uploadedServerUrls
        : [defaultImages[selectedCategory] || "assets/images/buyer-solar.jpg"];

    return {
      id: `lot-${Date.now()}-${Math.floor(Math.random() * 1000)}`,
      category: selectedCategory,
      title: getPreviewTitle(),
      qty: qtyStr,
      condition: conditionStr,
      priceDemand: rawPrice,
      specs: specsObj,
      images: finalImages,
      icon: catIcons[selectedCategory] || "☀️",
    };
  };

  const handleAddAnotherItem = () => {
    if (uploadedImages.some((img) => img.isUploading)) {
      showToast("Please wait for images to finish uploading.");
      return;
    }

    const currentLot = buildCurrentLotItem();
    setCombinedItems((prev) => [...prev, currentLot]);
    resetFormDetails();
    showToast(
      `Added Lot #${combinedItems.length + 1} (${currentLot.title}) to this combined auction! Select category and configure details for the next item.`
    );

    if (typeof window !== "undefined") {
      window.scrollTo({ top: 120, behavior: "smooth" });
    }
  };

  const handleRemoveCombinedLot = (lotId: string) => {
    setCombinedItems((prev) => prev.filter((it) => it.id !== lotId));
    showToast("Lot removed from combined auction.");
  };

  const handleSubmitAuction = async () => {
    if (uploadedImages.some((img) => img.isUploading)) {
      showToast("Please wait for images to finish uploading.");
      return;
    }

    setIsSubmitting(true);
    try {
      const hasActiveForm = Boolean(
        solarPanels.panelsCount ||
          inverters.ratedPower ||
          batteries.count ||
          cables.size ||
          structure.comments ||
          completeSystem.systemCapacity ||
          contactInfo.priceDemand
      );

      let allLots: AuctionLotItem[] = [...combinedItems];
      if (hasActiveForm || combinedItems.length === 0) {
        const currentLot = buildCurrentLotItem();
        allLots.push(currentLot);
      }

      if (allLots.length === 0) {
        showToast("Please add at least one item/lot to this auction.");
        setIsSubmitting(false);
        return;
      }

      const totalDemand =
        allLots.reduce((acc, it) => acc + (it.priceDemand || 0), 0) || 500000;
      const allImages = Array.from(new Set(allLots.flatMap((it) => it.images)));
      const uniqueCats = Array.from(new Set(allLots.map((it) => it.category)));
      const isCombined = allLots.length > 1;

      const combinedTitle = isCombined
        ? `Combined Solar Auction (${allLots.length} Lots: ${uniqueCats.join(", ")})`
        : allLots[0].title;

      const combinedQty = isCombined
        ? `${allLots.length} Lots (${allLots.map((it) => it.qty).join(" + ")})`
        : allLots[0].qty;

      const combinedIcons = allLots.map((it) => it.icon).join(" ");

      let createdListingId = `auc-${Date.now()}`;
      let createdAuctionCode = `AUC-${createdListingId.slice(0, 6).toUpperCase()}`;
      try {
        const createdRes = await createAdminAuction({
          title: combinedTitle,
          category: isCombined ? "Complete Solar System" : allLots[0].category,
          price_demand: totalDemand,
          starting_price: totalDemand,
          starting_bid: totalDemand,
          reserve_price: totalDemand,
          duration: "3 Days",
          ends_in: "3d 00h",
          specs: {
            is_combined: isCombined,
            total_lots: allLots.length,
            lots: allLots,
          },
          image_urls: allImages,
          pickup_city: contactInfo.city || "Karachi",
          pickup_area: contactInfo.locality || "Industrial Area",
          pickup_address:
            contactInfo.completeAddress ||
            `${contactInfo.locality || "Industrial Area"}, ${contactInfo.city || "Karachi"}`,
          contact_name: contactInfo.fullName || "Solar Scrap Admin",
          contact_phone: contactInfo.phoneNumber || "+92 300 1234567",
          contact_email: contactInfo.email || "admin@solarscrap.com",
        });
        if (createdRes?.id) {
          createdListingId = createdRes.id;
        }
        if (createdRes?.auction_id) {
          createdAuctionCode = createdRes.auction_id;
        }
      } catch (apiErr) {
        console.error("Failed to post auction to backend API, falling back:", apiErr);
        try {
          const fallbackRes = await createAdminListing({
            title: combinedTitle,
            is_auction: true,
            status: "auction",
            post_status: "Auction",
            starting_price: totalDemand,
            starting_bid: totalDemand,
            duration: "3 Days",
            ends_in: "3d 00h",
            category: isCombined ? "Complete Solar System" : allLots[0].category,
            price_demand: totalDemand,
            specs: {
              is_combined: isCombined,
              total_lots: allLots.length,
              lots: allLots,
            },
            image_urls: allImages,
            pickup_city: contactInfo.city || "Karachi",
            pickup_area: contactInfo.locality || "Industrial Area",
            pickup_address:
              contactInfo.completeAddress ||
              `${contactInfo.locality || "Industrial Area"}, ${contactInfo.city || "Karachi"}`,
            contact_name: contactInfo.fullName || "Solar Scrap Admin",
            contact_phone: contactInfo.phoneNumber || "+92 300 1234567",
            contact_email: contactInfo.email || "admin@solarscrap.com",
          });
          if (fallbackRes?.id) {
            createdListingId = fallbackRes.id;
            createdAuctionCode = `AUC-${fallbackRes.id.slice(0, 6).toUpperCase()}`;
          }
        } catch (fErr) {
          console.error("Fallback creation also failed:", fErr);
        }
      }

      const newAuction = {
        id: createdListingId,
        auctionId: createdAuctionCode,
        title: combinedTitle,

        icon: isCombined ? "📦" : allLots[0].icon,
        category: (isCombined ? "Complete System" : allLots[0].category) as any,
        categoryColor: isCombined
          ? "bg-purple-50 text-purple-700 border-purple-200"
          : allLots[0].category === "Solar Panels"
          ? "bg-blue-50 text-blue-700 border-blue-200"
          : allLots[0].category === "Inverters"
          ? "bg-amber-50 text-amber-700 border-amber-200"
          : allLots[0].category === "Batteries"
          ? "bg-emerald-50 text-emerald-700 border-emerald-200"
          : "bg-purple-50 text-purple-700 border-purple-200",
        qty: combinedQty,
        sellerName: contactInfo.fullName || "Solar Scrap Admin",
        sellerCompany: contactInfo.locality || "EPC Trading Co.",
        sellerCity: contactInfo.city || "Karachi",
        startingPrice: totalDemand,
        priceDemand: Math.round(totalDemand * 1.15),
        startingBid: totalDemand,
        currentHighBid: 0,
        highestBidderName: "No Bids Yet",
        highestBidderCompany: "Awaiting Verified Dealers",
        highestBidderCity: "-",
        totalBids: 0,
        status: "Active" as const,
        createdAt: "Today, Just now",
        endsIn: "3d 00h",
        endDate: "10 Mar 2026",
        reservePrice: totalDemand,
        images: allImages,
        items: allLots,
      };

      try {
        const stored = localStorage.getItem("solar_scrap_auctions");
        let list = [];
        if (stored) {
          list = JSON.parse(stored);
        }
        const updated = [newAuction, ...list];
        localStorage.setItem("solar_scrap_auctions", JSON.stringify(updated));
      } catch (err) {
        console.error("Failed to save new auction to storage", err);
      }

      showToast(
        isCombined
          ? `Combined Auction with ${allLots.length} items created & published live!`
          : "Auction listing created & published live to marketplace!"
      );
      setTimeout(() => {
        router.push("/auctions");
      }, 1200);
    } catch (err) {
      console.error("Error submitting auction:", err);
      showToast("An error occurred while saving the auction.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const currentCategoryObj =
    categories.find((c) => c.id === selectedCategory) || categories[0];

  // Derive dynamic preview values based on selected category
  const getPreviewTitle = () => {
    switch (selectedCategory) {
      case "Solar Panels":
        return `${solarPanels.panelsCount || "200"}x Solar Panels ${
          solarPanels.wattsPerPanel ? `${solarPanels.wattsPerPanel}W` : ""
        }`;
      case "Inverters":
        return `${inverters.ratedPower || "10 kW"} ${inverters.type} Inverter (${
          inverters.brand || "Solar Inverter"
        })`;
      case "Batteries":
        return `${batteries.count || "16"}x ${batteries.type} Batteries ${
          batteries.capacity ? `(${batteries.capacity})` : ""
        }`;
      case "Cables":
        return `${cables.size || "Standard"} ${cables.type} Cables (${
          cables.conductor
        })`;
      case "Structure":
        return `${structure.type} Mounting Structure (${structure.metal})`;
      case "Complete Solar System":
        return `Complete Solar System · ${completeSystem.systemCapacity || "15 kW"} (${
          solarPanels.panelsCount || "200"
        }x Panels)`;
      default:
        return `${selectedCategory} Listing`;
    }
  };

  const getPreviewSubtitle = () => {
    switch (selectedCategory) {
      case "Solar Panels":
        return `Solar Panels · ${solarPanels.condition}`;
      case "Inverters":
        return `Inverters · ${inverters.type} · ${inverters.condition}`;
      case "Batteries":
        return `Batteries · ${batteries.type} · ${batteries.condition}`;
      case "Cables":
        return `Cables · ${cables.type} / ${cables.conductor}`;
      case "Structure":
        return `Structure · ${structure.type} / ${structure.metal}`;
      case "Complete Solar System":
        return `Complete Solar System · ${inverters.type} · All Components Included`;
      default:
        return selectedCategory;
    }
  };

  const getPreviewSpecs = () => {
    switch (selectedCategory) {
      case "Solar Panels":
        return [
          { label: "Equipment", value: `${solarPanels.panelsCount} Panels, ${solarPanels.wattsPerPanel}W each` },
          { label: "Manufacturer", value: solarPanels.brand },
          { label: "Condition", value: solarPanels.condition },
          { label: "Purchase Year", value: solarPanels.purchaseYear },
          { label: "Estimated Weight", value: `~${parseInt(solarPanels.panelsCount || "0") * 12} kg` },
        ];
      case "Inverters":
        return [
          { label: "Inverter Type", value: inverters.type },
          { label: "Rated Power", value: inverters.ratedPower },
          { label: "Brand", value: inverters.brand },
          { label: "Condition", value: inverters.condition },
        ];
      case "Batteries":
        return [
          { label: "Battery Chemistry", value: batteries.type },
          { label: "Quantity", value: `${batteries.count} Units` },
          { label: "Rated Capacity", value: batteries.capacity },
          { label: "Brand", value: batteries.brand },
          { label: "Years Used", value: `${batteries.yearsUsed} Years (Bought ${batteries.purchaseYear})` },
          { label: "Condition", value: batteries.condition },
        ];
      case "Cables":
        return [
          { label: "Cable Type", value: `${cables.type} Solar Cables` },
          { label: "Conductor Material", value: cables.conductor },
          { label: "Insulation", value: cables.insulation },
          { label: "Size / Length", value: cables.size },
          { label: "Notes", value: cables.comments },
        ];
      case "Structure":
        return [
          { label: "Mounting Type", value: `${structure.type} Mounting` },
          { label: "Frame Metal", value: structure.metal === "AL" ? "Aluminum (AL)" : "Galvanized Iron (GI)" },
          { label: "Specifications", value: structure.comments },
        ];
      case "Complete Solar System":
        return [
          { label: "System Capacity", value: completeSystem.systemCapacity },
          { label: "Solar Panels", value: `${solarPanels.panelsCount}x ${solarPanels.wattsPerPanel}W (${solarPanels.condition})` },
          { label: "Inverter", value: `${inverters.ratedPower} ${inverters.type} (${inverters.brand})` },
          ...(inverters.type.toLowerCase() === "hybrid"
            ? [{ label: "Battery Bank", value: `${batteries.count}x ${batteries.capacity} ${batteries.type}` }]
            : []),
          { label: "Cables & Wiring", value: `${cables.conductor} ${cables.type} (${cables.size})` },
          { label: "Mounting Structure", value: `${structure.type} (${structure.metal})` },
        ];
      default:
        return [];
    }
  };

  return (
    <div className="flex h-screen bg-[#F5F6FA] overflow-hidden">
      {/* Toast Notification */}
      {toast && (
        <div className="fixed top-6 right-6 z-50 bg-[#009845] text-white px-5 py-3 rounded-xl shadow-lg flex items-center gap-2 text-sm font-semibold animate-fade-in">
          <CheckCircle className="w-5 h-5" />
          <span>{toast}</span>
        </div>
      )}

      {/* Hidden File Input for Image Uploads */}
      <input
        type="file"
        ref={fileInputRef}
        onChange={handleImageUpload}
        multiple
        accept="image/*"
        className="hidden"
      />

      {/* Unified Sidebar Navigation */}
      <Sidebar
        activeItem="Auctions"
        mobileMenuOpen={mobileMenuOpen}
        setMobileMenuOpen={setMobileMenuOpen}
      />

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0 h-screen overflow-hidden">
        {/* Top Header */}
        <header className="h-[76px] bg-white border-b border-[#EAECF0] flex items-center justify-between px-6 lg:px-8 shrink-0">
          <div className="flex items-center gap-4 flex-1">
            <button
              onClick={() => setMobileMenuOpen(true)}
              className="lg:hidden p-2 text-gray-500 hover:text-gray-700 rounded-lg hover:bg-gray-100"
              aria-label="Toggle Sidebar"
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
                className="w-full pl-10 pr-4 py-2 bg-[#F9FAFB] border border-[#EAECF0] rounded-xl text-xs sm:text-sm text-[#0F172A] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
              />
            </div>
          </div>

          <div className="flex items-center gap-5">
            <button className="relative p-2 text-gray-400 hover:text-gray-600 rounded-full hover:bg-gray-50">
              <Bell className="w-5 h-5" />
              <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white"></span>
            </button>
            <div className="flex items-center gap-3 pl-3 border-l border-gray-100">
              <span className="text-xs sm:text-sm font-semibold text-[#0F172A] hidden sm:inline-block">
                {adminName}
              </span>
              <div className="w-9 h-9 rounded-full overflow-hidden ring-1 ring-gray-200 relative bg-emerald-700 flex items-center justify-center text-white font-bold text-sm select-none">
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

        {/* Page Content */}
        <main className="flex-1 overflow-y-auto p-6 lg:p-8 bg-[#F5F6FA]">
          <div className="max-w-6xl mx-auto space-y-7 pb-12">
            {/* Title Header */}
            <div>
              <h1 className="text-2xl font-bold text-[#0F172A] tracking-tight">
                Create Auction
              </h1>
              <p className="text-xs sm:text-sm text-gray-500 mt-1">
                Select the Equipment and configure auction parameters. Add multiple equipment items to sell them together in one combined auction.
              </p>
            </div>

            {/* Combined Auction Tray - displays all added lots in this auction */}
            {combinedItems.length > 0 && (
              <div className="bg-gradient-to-r from-emerald-50 via-teal-50 to-emerald-50 rounded-2xl border-2 border-[#009845]/40 p-4 sm:p-5 shadow-sm space-y-3 animate-fadeIn">
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pb-2.5 border-b border-emerald-200/60">
                  <div className="flex items-center gap-2.5">
                    <div className="w-8 h-8 rounded-xl bg-[#009845] text-white flex items-center justify-center font-bold text-sm shadow-xs">
                      <Layers className="w-4 h-4" />
                    </div>
                    <div>
                      <h3 className="text-sm sm:text-base font-bold text-gray-900 flex items-center gap-2">
                        <span>Combined Auction ({combinedItems.length} {combinedItems.length === 1 ? "Lot" : "Lots"} Added)</span>
                        <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-[#009845] text-white shadow-2xs">
                          Single Combined Auction
                        </span>
                      </h3>
                      <p className="text-[11px] text-gray-600">
                        All items added here will be bundled and listed together in ONE combined auction.
                      </p>
                    </div>
                  </div>
                  <div className="text-left sm:text-right pl-10 sm:pl-0">
                    <span className="text-[10px] font-semibold text-gray-500 uppercase tracking-wider block">Combined Demand</span>
                    <span className="text-sm sm:text-base font-extrabold text-[#009845]">
                      Rs {combinedItems.reduce((acc, it) => acc + (it.priceDemand || 0), 0).toLocaleString()}
                    </span>
                  </div>
                </div>

                {/* List of Added Lots */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-2.5">
                  {combinedItems.map((lot, idx) => (
                    <div
                      key={lot.id}
                      className="bg-white rounded-xl p-3 border border-emerald-100 shadow-2xs flex items-start justify-between gap-2 hover:border-[#009845]/40 transition-all"
                    >
                      <div className="flex items-start gap-2.5 min-w-0">
                        <span className="text-xl shrink-0 mt-0.5">{lot.icon}</span>
                        <div className="min-w-0">
                          <div className="flex items-center gap-1.5">
                            <span className="text-[10px] font-bold text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded">
                              Lot #{idx + 1}
                            </span>
                            <span className="text-[10px] text-gray-400 font-medium">
                              {lot.category}
                            </span>
                          </div>
                          <p className="font-bold text-xs text-gray-900 truncate mt-0.5" title={lot.title}>
                            {lot.title}
                          </p>
                          <p className="text-[11px] text-gray-500">
                            {lot.qty} • {lot.condition}
                          </p>
                          {lot.priceDemand > 0 && (
                            <p className="text-xs font-semibold text-[#009845] mt-1">
                              Rs {lot.priceDemand.toLocaleString()}
                            </p>
                          )}
                        </div>
                      </div>
                      <button
                        type="button"
                        onClick={() => handleRemoveCombinedLot(lot.id)}
                        className="p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors cursor-pointer shrink-0"
                        title="Remove lot from combined auction"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  ))}
                </div>

                <div className="p-2.5 bg-white/80 rounded-xl border border-emerald-200/50 flex flex-col sm:flex-row sm:items-center justify-between gap-1.5 text-xs text-gray-700">
                  <span className="flex items-center gap-1.5 font-medium text-emerald-800">
                    <span className="w-2 h-2 rounded-full bg-[#009845] animate-pulse" />
                    Currently configuring Lot #{combinedItems.length + 1} below:
                  </span>
                  <span className="text-[11px] text-gray-500">
                    Fill out equipment details below, then click &ldquo;Add Another Item to this Auction&rdquo; or &ldquo;Publish Combined Auction&rdquo;.
                  </span>
                </div>
              </div>
            )}

            {/* Equipment Category Selection Cards - Matching Mobile App Categories */}
            <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3.5 sm:gap-4">
              {categories.map((cat) => {
                const isSelected = selectedCategory === cat.id;
                return (
                  <button
                    key={cat.id}
                    type="button"
                    onClick={() => setSelectedCategory(cat.id)}
                    className={`relative p-3.5 sm:p-4 rounded-2xl border transition-all duration-200 flex flex-col items-center justify-between min-h-[146px] cursor-pointer text-center ${
                      isSelected
                        ? "border-[#009845] bg-[#E6F9ED] ring-1 ring-[#009845] shadow-xs"
                        : "border-[#EAECF0] bg-white hover:border-gray-300 hover:shadow-xs"
                    }`}
                  >
                    {/* Category Image */}
                    <div className="relative w-20 h-20 sm:w-24 sm:h-24 rounded-2xl overflow-hidden flex items-center justify-center my-auto">
                      <Image
                        src={cat.image}
                        alt={cat.label}
                        fill
                        className={
                          cat.fit === "contain"
                            ? "object-contain p-1"
                            : "object-cover"
                        }
                      />
                    </div>

                    {/* Category Label & Indicator */}
                    <div className="flex flex-col items-center w-full mt-1">
                      <span
                        className={`text-xs sm:text-[13px] font-bold text-center leading-tight ${
                          isSelected ? "text-[#009845]" : "text-[#0F172A]"
                        }`}
                      >
                        {cat.label}
                      </span>
                      {isSelected ? (
                        <span className="w-1.5 h-1.5 rounded-full bg-[#009845] mt-1.5" />
                      ) : (
                        <span className="w-1.5 h-1.5 mt-1.5 opacity-0" />
                      )}
                    </div>
                  </button>
                );
              })}
            </div>

            {/* ==================== ACTIVE EQUIPMENT DETAILS FORM ==================== */}
            <div className="bg-white rounded-2xl border border-[#EAECF0] p-6 sm:p-8 shadow-xs space-y-6">
              <div className="flex items-center justify-between pb-4 border-b border-gray-100">
                <div className="flex items-center gap-2.5">
                  <div className="relative w-7 h-7 rounded-md overflow-hidden shrink-0">
                    <Image
                      src={currentCategoryObj.image}
                      alt={selectedCategory}
                      fill
                      className="object-contain"
                    />
                  </div>
                  <div>
                    <h3 className="text-base font-bold text-[#0F172A]">
                      {selectedCategory} Specifications:
                    </h3>
                    <p className="text-xs text-gray-500">
                      Configure accurate equipment parameters from the seller app workflow.
                    </p>
                  </div>
                </div>
              </div>

              {/* ----------------- 1. SOLAR PANELS SPECIFIC FIELDS ----------------- */}
              {selectedCategory === "Solar Panels" && (
                <div className="space-y-5">
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Number of Panels
                      </label>
                      <input
                        type="text"
                        value={solarPanels.panelsCount}
                        onChange={(e) =>
                          setSolarPanels({
                            ...solarPanels,
                            panelsCount: e.target.value,
                          })
                        }
                        placeholder="e.g. 200"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Watts per Panel (W)
                      </label>
                      <input
                        type="text"
                        value={solarPanels.wattsPerPanel}
                        onChange={(e) =>
                          setSolarPanels({
                            ...solarPanels,
                            wattsPerPanel: e.target.value,
                          })
                        }
                        placeholder="e.g. 400"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Brand / Manufacturer
                      </label>
                      <input
                        type="text"
                        value={solarPanels.brand}
                        onChange={(e) =>
                          setSolarPanels({
                            ...solarPanels,
                            brand: e.target.value,
                          })
                        }
                        placeholder="e.g. Longi, Jinko, Canadian Solar"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>
                  </div>

                  {/* Panel Condition Chips */}
                  <div className="space-y-2">
                    <label className="block text-xs font-semibold text-[#344054]">
                      Panel Condition
                    </label>
                    <div className="flex flex-wrap gap-2.5">
                      {panelConditions.map((c) => {
                        const isSelected = solarPanels.condition === c;
                        return (
                          <button
                            key={c}
                            type="button"
                            onClick={() =>
                              setSolarPanels({ ...solarPanels, condition: c })
                            }
                            className={`px-5 py-2 rounded-xl text-xs font-semibold border transition-all cursor-pointer ${
                              isSelected
                                ? "border-[#009845] bg-[#E6F9ED] text-[#009845] ring-1 ring-[#009845]"
                                : "border-[#D0D5DD] bg-white text-[#344054] hover:border-gray-400 hover:bg-gray-50/50"
                            }`}
                          >
                            {c}
                          </button>
                        );
                      })}
                    </div>
                  </div>
                </div>
              )}

              {/* ----------------- 2. INVERTERS SPECIFIC FIELDS ----------------- */}
              {selectedCategory === "Inverters" && (
                <div className="space-y-5">
                  {/* Options Partition Card with Vertical Divider */}
                  <div className="bg-[#F8F9FA] rounded-2xl p-5 border border-[#EAECF0] shadow-xs">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8 items-start">
                      {/* Inverter Type (Hybrid vs On-Grid) */}
                      <div>
                        <div className="flex items-center justify-between mb-2">
                          <label className="text-xs font-bold text-[#1D2939] uppercase tracking-wider">
                            Inverter Type
                          </label>
                          <span className="text-[11px] font-medium text-gray-400">
                            Select Category
                          </span>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                          {["Hybrid", "On-Grid"].map((type) => {
                            const isSelected = inverters.type === type;
                            return (
                              <button
                                key={type}
                                type="button"
                                onClick={() =>
                                  setInverters({ ...inverters, type })
                                }
                                className={`py-3 px-4 rounded-xl text-xs font-bold border transition-all cursor-pointer shadow-xs ${
                                  isSelected
                                    ? "border-[#009845] bg-[#E6F9ED] text-[#009845] ring-2 ring-[#009845]/30"
                                    : "border-[#D0D5DD] bg-white text-[#344054] hover:border-gray-400 hover:bg-gray-50"
                                }`}
                              >
                                {type}
                              </button>
                            );
                          })}
                        </div>
                      </div>

                      {/* Inverter Condition with Vertical Line Separator */}
                      <div className="relative pt-4 md:pt-0 md:pl-8 border-t md:border-t-0 md:border-l border-gray-200">
                        <div className="flex items-center justify-between mb-2">
                          <label className="text-xs font-bold text-[#1D2939] uppercase tracking-wider">
                            Inverter Condition
                          </label>
                          <span className="text-[11px] font-medium text-gray-400">
                            Physical State
                          </span>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                          {inverterConditions.map((cond) => {
                            const isSelected = inverters.condition === cond;
                            return (
                              <button
                                key={cond}
                                type="button"
                                onClick={() =>
                                  setInverters({ ...inverters, condition: cond })
                                }
                                className={`py-3 px-4 rounded-xl text-xs font-bold border transition-all cursor-pointer shadow-xs ${
                                  isSelected
                                    ? "border-[#009845] bg-[#E6F9ED] text-[#009845] ring-2 ring-[#009845]/30"
                                    : "border-[#D0D5DD] bg-white text-[#344054] hover:border-gray-400 hover:bg-gray-50"
                                }`}
                              >
                                {cond}
                              </button>
                            );
                          })}
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Rated Power (e.g. 5kW, 10kW)
                      </label>
                      <input
                        type="text"
                        value={inverters.ratedPower}
                        onChange={(e) =>
                          setInverters({
                            ...inverters,
                            ratedPower: e.target.value,
                          })
                        }
                        placeholder="e.g. 10 kW"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Inverter Brand / Model
                      </label>
                      <input
                        type="text"
                        value={inverters.brand}
                        onChange={(e) =>
                          setInverters({ ...inverters, brand: e.target.value })
                        }
                        placeholder="e.g. Huawei, Growatt, Inverex"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* ----------------- 3. BATTERIES SPECIFIC FIELDS ----------------- */}
              {selectedCategory === "Batteries" && (
                <div className="space-y-5">
                  {/* Options Partition Card with Vertical Divider */}
                  <div className="bg-[#F8F9FA] rounded-2xl p-5 border border-[#EAECF0] shadow-xs">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8 items-start">
                      {/* Battery Chemistry Type */}
                      <div>
                        <div className="flex items-center justify-between mb-2">
                          <label className="text-xs font-bold text-[#1D2939] uppercase tracking-wider">
                            Battery Chemistry Type
                          </label>
                          <span className="text-[11px] font-medium text-gray-400">
                            Select Chemistry
                          </span>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                          {["Lithium", "Lead-Acid"].map((type) => {
                            const isSelected = batteries.type === type;
                            return (
                              <button
                                key={type}
                                type="button"
                                onClick={() =>
                                  setBatteries({ ...batteries, type })
                                }
                                className={`py-3 px-4 rounded-xl text-xs font-bold border transition-all cursor-pointer shadow-xs ${
                                  isSelected
                                    ? "border-[#009845] bg-[#E6F9ED] text-[#009845] ring-2 ring-[#009845]/30"
                                    : "border-[#D0D5DD] bg-white text-[#344054] hover:border-gray-400 hover:bg-gray-50"
                                }`}
                              >
                                {type}
                              </button>
                            );
                          })}
                        </div>
                      </div>

                      {/* Battery Condition with Vertical Line Separator */}
                      <div className="relative pt-4 md:pt-0 md:pl-8 border-t md:border-t-0 md:border-l border-gray-200">
                        <div className="flex items-center justify-between mb-2">
                          <label className="text-xs font-bold text-[#1D2939] uppercase tracking-wider">
                            Battery Condition
                          </label>
                          <span className="text-[11px] font-medium text-gray-400">
                            Physical State
                          </span>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                          {["Working", "Non working"].map((cond) => {
                            const isSelected = batteries.condition === cond;
                            return (
                              <button
                                key={cond}
                                type="button"
                                onClick={() =>
                                  setBatteries({ ...batteries, condition: cond })
                                }
                                className={`py-3 px-4 rounded-xl text-xs font-bold border transition-all cursor-pointer shadow-xs ${
                                  isSelected
                                    ? "border-[#009845] bg-[#E6F9ED] text-[#009845] ring-2 ring-[#009845]/30"
                                    : "border-[#D0D5DD] bg-white text-[#344054] hover:border-gray-400 hover:bg-gray-50"
                                }`}
                              >
                                {cond}
                              </button>
                            );
                          })}
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-4 gap-5">
                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Quantity / Units
                      </label>
                      <input
                        type="text"
                        value={batteries.count}
                        onChange={(e) =>
                          setBatteries({ ...batteries, count: e.target.value })
                        }
                        placeholder="e.g. 16"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Capacity (Ah / kWh)
                      </label>
                      <input
                        type="text"
                        value={batteries.capacity}
                        onChange={(e) =>
                          setBatteries({
                            ...batteries,
                            capacity: e.target.value,
                          })
                        }
                        placeholder="e.g. 100Ah or 5kWh"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Brand / Manufacturer
                      </label>
                      <input
                        type="text"
                        value={batteries.brand}
                        onChange={(e) =>
                          setBatteries({ ...batteries, brand: e.target.value })
                        }
                        placeholder="e.g. Narada, Pylontech"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Purchase Year / Age
                      </label>
                      <input
                        type="text"
                        value={batteries.purchaseYear}
                        onChange={(e) =>
                          setBatteries({
                            ...batteries,
                            purchaseYear: e.target.value,
                          })
                        }
                        placeholder="e.g. 2021"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* ----------------- 4. CABLES SPECIFIC FIELDS ----------------- */}
              {selectedCategory === "Cables" && (
                <div className="space-y-5">
                  {/* Options Partition Card with Vertical Divider */}
                  <div className="bg-[#F8F9FA] rounded-2xl p-5 border border-[#EAECF0] shadow-xs">
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 md:gap-6 items-start">
                      {/* Cable Type */}
                      <div>
                        <div className="flex items-center justify-between mb-2">
                          <label className="text-xs font-bold text-[#1D2939] uppercase tracking-wider">
                            Cable Current Type
                          </label>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                          {["AC", "DC"].map((type) => {
                            const isSelected = cables.type === type;
                            return (
                              <button
                                key={type}
                                type="button"
                                onClick={() => setCables({ ...cables, type })}
                                className={`py-3 px-4 rounded-xl text-xs font-bold border transition-all cursor-pointer shadow-xs ${
                                  isSelected
                                    ? "border-[#009845] bg-[#E6F9ED] text-[#009845] ring-2 ring-[#009845]/30"
                                    : "border-[#D0D5DD] bg-white text-[#344054] hover:border-gray-400 hover:bg-gray-50"
                                }`}
                              >
                                {type}
                              </button>
                            );
                          })}
                        </div>
                      </div>

                      {/* Conductor Material with Vertical Line Separator */}
                      <div className="relative pt-4 md:pt-0 md:pl-6 border-t md:border-t-0 md:border-l border-gray-200">
                        <div className="flex items-center justify-between mb-2">
                          <label className="text-xs font-bold text-[#1D2939] uppercase tracking-wider">
                            Conductor Material
                          </label>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                          {["Copper", "Aluminium"].map((mat) => {
                            const isSelected = cables.conductor === mat;
                            return (
                              <button
                                key={mat}
                                type="button"
                                onClick={() =>
                                  setCables({ ...cables, conductor: mat })
                                }
                                className={`py-3 px-4 rounded-xl text-xs font-bold border transition-all cursor-pointer shadow-xs ${
                                  isSelected
                                    ? "border-[#009845] bg-[#E6F9ED] text-[#009845] ring-2 ring-[#009845]/30"
                                    : "border-[#D0D5DD] bg-white text-[#344054] hover:border-gray-400 hover:bg-gray-50"
                                }`}
                              >
                                {mat}
                              </button>
                            );
                          })}
                        </div>
                      </div>

                      {/* Insulation Type with Vertical Line Separator */}
                      <div className="relative pt-4 md:pt-0 md:pl-6 border-t md:border-t-0 md:border-l border-gray-200">
                        <div className="flex items-center justify-between mb-2">
                          <label className="text-xs font-bold text-[#1D2939] uppercase tracking-wider">
                            Insulation Type
                          </label>
                        </div>
                        <select
                          value={cables.insulation}
                          onChange={(e) =>
                            setCables({ ...cables, insulation: e.target.value })
                          }
                          className="w-full py-3 px-3.5 bg-white border border-[#D0D5DD] rounded-xl text-xs font-semibold text-[#101828] focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all shadow-xs"
                        >
                          <option value="PVC">PVC Insulation</option>
                          <option value="XLPE">XLPE Insulation</option>
                          <option value="Rubber">Rubber Insulation</option>
                        </select>
                      </div>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Cable Size / Cross-Section &amp; Length
                      </label>
                      <input
                        type="text"
                        value={cables.size}
                        onChange={(e) =>
                          setCables({ ...cables, size: e.target.value })
                        }
                        placeholder="e.g. 4mm, 6mm, 100 meters"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                        Cable Details / Comments
                      </label>
                      <input
                        type="text"
                        value={cables.comments}
                        onChange={(e) =>
                          setCables({ ...cables, comments: e.target.value })
                        }
                        placeholder="e.g. Single core / Double core flexible"
                        className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* ----------------- 5. STRUCTURE SPECIFIC FIELDS ----------------- */}
              {selectedCategory === "Structure" && (
                <div className="space-y-5">
                  {/* Options Partition Card with Vertical Divider */}
                  <div className="bg-[#F8F9FA] rounded-2xl p-5 border border-[#EAECF0] shadow-xs">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8 items-start">
                      {/* Structure Type */}
                      <div>
                        <div className="flex items-center justify-between mb-2">
                          <label className="text-xs font-bold text-[#1D2939] uppercase tracking-wider">
                            Mounting Structure Type
                          </label>
                          <span className="text-[11px] font-medium text-gray-400">
                            Select Type
                          </span>
                        </div>
                        <div className="grid grid-cols-3 gap-3">
                          {["Elevated", "Roof Mount", "Ground"].map((type) => {
                            const isSelected = structure.type === type;
                            return (
                              <button
                                key={type}
                                type="button"
                                onClick={() =>
                                  setStructure({ ...structure, type })
                                }
                                className={`py-3 px-3 rounded-xl text-xs font-bold border transition-all cursor-pointer shadow-xs ${
                                  isSelected
                                    ? "border-[#009845] bg-[#E6F9ED] text-[#009845] ring-2 ring-[#009845]/30"
                                    : "border-[#D0D5DD] bg-white text-[#344054] hover:border-gray-400 hover:bg-gray-50"
                                }`}
                              >
                                {type}
                              </button>
                            );
                          })}
                        </div>
                      </div>

                      {/* Frame Metal with Vertical Line Separator */}
                      <div className="relative pt-4 md:pt-0 md:pl-8 border-t md:border-t-0 md:border-l border-gray-200">
                        <div className="flex items-center justify-between mb-2">
                          <label className="text-xs font-bold text-[#1D2939] uppercase tracking-wider">
                            Frame Metal / Material
                          </label>
                          <span className="text-[11px] font-medium text-gray-400">
                            Material
                          </span>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                          {[
                            { id: "AL", label: "Aluminum (AL)" },
                            { id: "GI", label: "Galvanized Iron (GI)" },
                          ].map((m) => {
                            const isSelected = structure.metal === m.id;
                            return (
                              <button
                                key={m.id}
                                type="button"
                                onClick={() =>
                                  setStructure({ ...structure, metal: m.id })
                                }
                                className={`py-3 px-4 rounded-xl text-xs font-bold border transition-all cursor-pointer shadow-xs ${
                                  isSelected
                                    ? "border-[#009845] bg-[#E6F9ED] text-[#009845] ring-2 ring-[#009845]/30"
                                    : "border-[#D0D5DD] bg-white text-[#344054] hover:border-gray-400 hover:bg-gray-50"
                                }`}
                              >
                                {m.label}
                              </button>
                            );
                          })}
                        </div>
                      </div>
                    </div>
                  </div>

                  <div>
                    <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                      Structure Specifications &amp; Condition Details
                    </label>
                    <input
                      type="text"
                      value={structure.comments}
                      onChange={(e) =>
                        setStructure({
                          ...structure,
                          comments: e.target.value,
                        })
                      }
                      placeholder="e.g. L2/L3 Elevated channels with high-grade stainless clamps"
                      className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                    />
                  </div>
                </div>
              )}

              {/* ----------------- 6. COMPLETE SOLAR SYSTEM CONSOLIDATED FIELDS ----------------- */}
              {selectedCategory === "Complete Solar System" && (
                <div className="space-y-6">
                  <div className="p-4 bg-emerald-50/60 border border-emerald-200 rounded-xl text-xs text-emerald-900 leading-relaxed">
                    <span className="font-bold">Complete Solar System Mode:</span> Enter the components included in this entire setup (Solar Panels, Inverter, Batteries, Cables, and Structure). All components will be bundled in this auction.
                  </div>

                  {/* Component 1: Solar Panels in System */}
                  <div className="p-4 bg-gray-50/70 rounded-xl border border-gray-200/80 space-y-4">
                    <div className="flex items-center gap-2 text-xs font-bold text-gray-800">
                      <Zap className="w-4 h-4 text-[#009845]" />
                      <span>1. Solar Panels Component</span>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                      <div>
                        <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                          Panels Count
                        </label>
                        <input
                          type="text"
                          value={solarPanels.panelsCount}
                          onChange={(e) =>
                            setSolarPanels({ ...solarPanels, panelsCount: e.target.value })
                          }
                          className="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-xs"
                          placeholder="200"
                        />
                      </div>
                      <div>
                        <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                          Watts per Panel (W)
                        </label>
                        <input
                          type="text"
                          value={solarPanels.wattsPerPanel}
                          onChange={(e) =>
                            setSolarPanels({ ...solarPanels, wattsPerPanel: e.target.value })
                          }
                          className="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-xs"
                          placeholder="400W"
                        />
                      </div>
                      <div>
                        <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                          Panel Condition
                        </label>
                        <select
                          value={solarPanels.condition}
                          onChange={(e) =>
                            setSolarPanels({ ...solarPanels, condition: e.target.value })
                          }
                          className="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-xs"
                        >
                          {panelConditions.map((c) => (
                            <option key={c} value={c}>
                              {c}
                            </option>
                          ))}
                        </select>
                      </div>
                    </div>
                  </div>

                  {/* Component 2: Inverter in System */}
                  <div className="p-4 bg-gray-50/70 rounded-xl border border-gray-200/80 space-y-4">
                    <div className="flex items-center gap-2 text-xs font-bold text-gray-800">
                      <Layers className="w-4 h-4 text-[#009845]" />
                      <span>2. Inverter Component</span>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                      <div>
                        <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                          Inverter Type
                        </label>
                        <div className="flex gap-2">
                          {["Hybrid", "On-Grid"].map((type) => (
                            <button
                              key={type}
                              type="button"
                              onClick={() => setInverters({ ...inverters, type })}
                              className={`flex-1 py-1.5 px-3 rounded-lg text-xs font-semibold border ${
                                inverters.type === type
                                  ? "bg-[#009845] text-white border-[#009845]"
                                  : "bg-white text-gray-700 border-gray-300"
                              }`}
                            >
                              {type}
                            </button>
                          ))}
                        </div>
                      </div>
                      <div>
                        <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                          Rated Power
                        </label>
                        <input
                          type="text"
                          value={inverters.ratedPower}
                          onChange={(e) =>
                            setInverters({ ...inverters, ratedPower: e.target.value })
                          }
                          className="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-xs"
                          placeholder="15 kW"
                        />
                      </div>
                      <div>
                        <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                          Inverter Brand
                        </label>
                        <input
                          type="text"
                          value={inverters.brand}
                          onChange={(e) =>
                            setInverters({ ...inverters, brand: e.target.value })
                          }
                          className="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-xs"
                          placeholder="Huawei / Sungrow"
                        />
                      </div>
                    </div>
                  </div>

                  {/* Component 3: Batteries in System (if Hybrid) */}
                  {inverters.type.toLowerCase() === "hybrid" && (
                    <div className="p-4 bg-gray-50/70 rounded-xl border border-gray-200/80 space-y-4">
                      <div className="flex items-center gap-2 text-xs font-bold text-gray-800">
                        <Battery className="w-4 h-4 text-[#009845]" />
                        <span>3. Battery Bank (Hybrid System)</span>
                      </div>
                      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                          <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                            Battery Chemistry
                          </label>
                          <div className="flex gap-2">
                            {["Lithium", "Lead-Acid"].map((bType) => (
                              <button
                                key={bType}
                                type="button"
                                onClick={() => setBatteries({ ...batteries, type: bType })}
                                className={`flex-1 py-1.5 px-3 rounded-lg text-xs font-semibold border ${
                                  batteries.type === bType
                                    ? "bg-[#009845] text-white border-[#009845]"
                                    : "bg-white text-gray-700 border-gray-300"
                                }`}
                              >
                                {bType}
                              </button>
                            ))}
                          </div>
                        </div>
                        <div>
                          <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                            Units &amp; Capacity
                          </label>
                          <input
                            type="text"
                            value={`${batteries.count} units · ${batteries.capacity}`}
                            onChange={(e) => {
                              const val = e.target.value;
                              setBatteries({ ...batteries, capacity: val });
                            }}
                            className="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-xs"
                            placeholder="16 units · 100Ah"
                          />
                        </div>
                        <div>
                          <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                            Battery Brand
                          </label>
                          <input
                            type="text"
                            value={batteries.brand}
                            onChange={(e) =>
                              setBatteries({ ...batteries, brand: e.target.value })
                            }
                            className="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-xs"
                            placeholder="Narada / Pylontech"
                          />
                        </div>
                      </div>
                    </div>
                  )}

                  {/* Component 4: Cables & Structure */}
                  <div className="p-4 bg-gray-50/70 rounded-xl border border-gray-200/80 space-y-4">
                    <div className="flex items-center gap-2 text-xs font-bold text-gray-800">
                      <Building className="w-4 h-4 text-[#009845]" />
                      <span>4. Cables &amp; Mounting Structure Included</span>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                          Cables Material &amp; Specs
                        </label>
                        <input
                          type="text"
                          value={`${cables.conductor} ${cables.type} (${cables.size})`}
                          onChange={(e) =>
                            setCables({ ...cables, size: e.target.value })
                          }
                          className="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-xs"
                          placeholder="Copper DC / AC solar wiring included"
                        />
                      </div>
                      <div>
                        <label className="block text-[11px] font-semibold text-gray-600 mb-1">
                          Mounting Structure Type &amp; Material
                        </label>
                        <input
                          type="text"
                          value={`${structure.type} mounting (${structure.metal})`}
                          onChange={(e) =>
                            setStructure({ ...structure, comments: e.target.value })
                          }
                          className="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-xs"
                          placeholder="Elevated Aluminum structure"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* ----------------- COMMON LOCATION, CONTACT & PRICE ----------------- */}
              <div className="pt-4 border-t border-gray-100 space-y-5">
                <h4 className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                  Contact &amp; Auction Location
                </h4>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
                  <div>
                    <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                      Full Name
                    </label>
                    <input
                      type="text"
                      value={contactInfo.fullName}
                      onChange={(e) =>
                        setContactInfo({
                          ...contactInfo,
                          fullName: e.target.value,
                        })
                      }
                      placeholder="Seller Name"
                      className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                      Phone Number
                    </label>
                    <input
                      type="text"
                      value={contactInfo.phoneNumber}
                      onChange={(e) =>
                        setContactInfo({
                          ...contactInfo,
                          phoneNumber: e.target.value,
                        })
                      }
                      placeholder="+92 301 2345678"
                      className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                      Email address
                    </label>
                    <input
                      type="email"
                      value={contactInfo.email}
                      onChange={(e) =>
                        setContactInfo({
                          ...contactInfo,
                          email: e.target.value,
                        })
                      }
                      placeholder="seller@domain.com"
                      className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                      City
                    </label>
                    <input
                      type="text"
                      value={contactInfo.city}
                      onChange={(e) =>
                        setContactInfo({ ...contactInfo, city: e.target.value })
                      }
                      placeholder="Karachi"
                      className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                      Area / Locality
                    </label>
                    <input
                      type="text"
                      value={contactInfo.locality}
                      onChange={(e) =>
                        setContactInfo({
                          ...contactInfo,
                          locality: e.target.value,
                        })
                      }
                      placeholder="DHA Phase 7, Karachi"
                      className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                      Total Price Demand (PKR)
                    </label>
                    <input
                      type="text"
                      value={contactInfo.priceDemand}
                      onChange={(e) =>
                        setContactInfo({
                          ...contactInfo,
                          priceDemand: e.target.value,
                        })
                      }
                      placeholder="Rs 45,000,000"
                      className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] font-semibold text-[#009845] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-semibold text-[#344054] mb-1.5">
                    Complete Address &amp; Pickup Notes
                  </label>
                  <input
                    type="text"
                    value={contactInfo.completeAddress}
                    onChange={(e) =>
                      setContactInfo({
                        ...contactInfo,
                        completeAddress: e.target.value,
                      })
                    }
                    placeholder="Plot / Warehouse address, accessibility for crane/trucks..."
                    className="w-full px-3.5 py-2.5 bg-white border border-[#D0D5DD] rounded-xl text-xs sm:text-sm text-[#101828] placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#009845]/20 focus:border-[#009845] transition-all"
                  />
                </div>
              </div>

              {/* ----------------- FUNCTIONAL IMAGE UPLOAD SLOTS ----------------- */}
              <div className="space-y-3 pt-2">
                <div className="flex items-center justify-between">
                  <div>
                    <label className="block text-xs font-semibold text-[#344054]">
                      Add Images ({uploadedImages.length} uploaded):
                    </label>
                    <p className="text-[11px] text-gray-500">
                      Upload actual equipment photos from your device (Max 10 images)
                    </p>
                  </div>
                  {uploadedImages.length > 0 && (
                    <button
                      type="button"
                      onClick={() => setUploadedImages([])}
                      className="text-xs text-red-500 hover:text-red-600 font-semibold"
                    >
                      Remove All
                    </button>
                  )}
                </div>

                <div className="grid grid-cols-2 sm:grid-cols-5 gap-3">
                  {/* Uploaded Images with Status and Delete Action */}
                  {uploadedImages.map((imgItem, idx) => (
                    <div
                      key={imgItem.id || idx}
                      className="aspect-4/3 rounded-2xl relative overflow-hidden group border border-gray-200 shadow-xs bg-slate-100"
                    >
                      <Image
                        src={imgItem.previewUrl}
                        alt={`Equipment image ${idx + 1}`}
                        fill
                        unoptimized
                        className="object-cover"
                      />
                      {imgItem.isUploading && (
                        <div className="absolute inset-0 bg-black/50 backdrop-blur-xs flex flex-col items-center justify-center gap-1.5 z-10">
                          <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                          <span className="text-[10px] text-white font-medium">Uploading...</span>
                        </div>
                      )}
                      {imgItem.error && (
                        <div className="absolute inset-0 bg-red-600/70 backdrop-blur-xs flex items-center justify-center p-1 z-10">
                          <span className="text-[10px] text-white font-bold text-center">Upload Failed</span>
                        </div>
                      )}
                      {!imgItem.isUploading && !imgItem.error && (
                        <span className="absolute top-1.5 left-1.5 w-5 h-5 rounded-full bg-emerald-500 text-white flex items-center justify-center shadow-md z-10">
                          <Check className="w-3 h-3 stroke-[3]" />
                        </span>
                      )}
                      <button
                        type="button"
                        onClick={(e) => {
                          e.stopPropagation();
                          handleRemoveImage(idx);
                        }}
                        className="absolute top-1.5 right-1.5 w-6 h-6 rounded-full bg-black/60 hover:bg-red-500 text-white flex items-center justify-center transition-colors cursor-pointer shadow-md z-10"
                        title="Delete photo"
                      >
                        <X className="w-3.5 h-3.5" />
                      </button>
                      <span className="absolute bottom-1 left-2 text-[10px] bg-black/60 text-white px-1.5 py-0.5 rounded font-medium z-10">
                        #{idx + 1}
                      </span>
                    </div>
                  ))}


                  {/* Empty Add Photo Trigger Slots */}
                  {Array.from({
                    length: Math.max(1, 5 - uploadedImages.length),
                  }).map((_, idx) => (
                    <div
                      key={idx}
                      onClick={() => fileInputRef.current?.click()}
                      className="aspect-4/3 border-2 border-dashed border-[#D0D5DD] rounded-2xl flex flex-col items-center justify-center gap-1.5 p-3 hover:border-[#009845] hover:bg-emerald-50/20 transition-all cursor-pointer bg-[#FAFAFA] group"
                    >
                      <div className="w-8 h-8 rounded-full bg-gray-100 group-hover:bg-emerald-100 flex items-center justify-center transition-colors">
                        <Camera className="w-4 h-4 text-gray-500 group-hover:text-[#009845]" />
                      </div>
                      <span className="text-[11px] font-bold text-gray-500 group-hover:text-[#009845]">
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
                  className="px-4 py-2 text-xs font-bold text-[#009845] hover:text-[#008230] rounded-lg transition-colors cursor-pointer"
                >
                  Clear Form
                </button>
              </div>
            </div>

            {/* ==================== LIVE LISTING PREVIEW CARD ==================== */}
            <div className="space-y-3">
              <span className="inline-block px-3 py-1 bg-[#E0F2FE] text-[#0284C7] rounded-full text-xs font-bold">
                Live Preview
              </span>

              <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 bg-white rounded-2xl border border-[#EAECF0] p-6 sm:p-8 shadow-xs">
                {/* Left Preview Details */}
                <div className="lg:col-span-7 space-y-4">
                  <div>
                    <h3 className="text-xl font-bold text-[#0F172A]">
                      {getPreviewTitle()}
                    </h3>
                    <p className="text-xs text-gray-500 mt-0.5">
                      {getPreviewSubtitle()}
                    </p>
                  </div>

                  <div className="border border-gray-100 rounded-xl overflow-hidden divide-y divide-gray-100 text-xs">
                    {getPreviewSpecs().map((spec, i) => (
                      <div
                        key={i}
                        className={`flex justify-between py-2.5 px-4 ${
                          i % 2 === 0 ? "bg-gray-50/50" : ""
                        }`}
                      >
                        <span className="text-gray-500">{spec.label}</span>
                        <span className="font-semibold text-gray-800">
                          {spec.value}
                        </span>
                      </div>
                    ))}
                    <div className="flex justify-between py-2.5 px-4 bg-emerald-50/40">
                      <span className="font-bold text-emerald-800">
                        Price Demand
                      </span>
                      <span className="font-bold text-[#009845]">
                        {contactInfo.priceDemand || "Rs 0"}
                      </span>
                    </div>
                  </div>
                </div>

                {/* Right Preview Images & Contact */}
                <div className="lg:col-span-5 space-y-4">
                  <div>
                    <h4 className="text-xs font-bold text-gray-700 mb-2">
                      Images ({uploadedImages.length > 0 ? uploadedImages.length : 1})
                    </h4>
                    <div className="grid grid-cols-5 gap-2">
                      {uploadedImages.length > 0 ? (
                        uploadedImages.slice(0, 5).map((imgItem, i) => (
                          <div
                            key={imgItem.id || i}
                            className="aspect-square bg-slate-100 rounded-lg overflow-hidden relative"
                          >
                            <Image
                              src={imgItem.previewUrl}
                              alt="Upload photo preview"
                              fill
                              unoptimized
                              className="object-cover"
                            />
                          </div>
                        ))
                      ) : (

                        <div className="aspect-square bg-slate-100 rounded-lg overflow-hidden relative col-span-2">
                          <Image
                            src={currentCategoryObj.image}
                            alt="Default item photo"
                            fill
                            className={
                              currentCategoryObj.fit === "contain"
                                ? "object-contain p-2"
                                : "object-cover"
                            }
                          />
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="bg-gray-50/80 rounded-xl p-3.5 space-y-2 text-xs border border-gray-100">
                    <h4 className="font-bold text-gray-800">
                      Location &amp; Seller
                    </h4>
                    <div className="flex items-center gap-2 text-gray-600">
                      <MapPin className="w-3.5 h-3.5 text-[#009845] shrink-0" />
                      <span>
                        {contactInfo.locality || contactInfo.city || "Karachi, Pakistan"}
                      </span>
                    </div>
                    <div className="flex items-center gap-2 text-gray-600">
                      <Phone className="w-3.5 h-3.5 text-[#009845] shrink-0" />
                      <span>
                        {contactInfo.fullName} ({contactInfo.phoneNumber})
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Bottom Action Buttons */}
            <div className="flex flex-col sm:flex-row items-center justify-end gap-3 pt-6 border-t border-[#EAECF0]">
              <Link
                href="/auctions"
                className="w-full sm:w-auto px-6 py-3 border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-xl text-xs font-bold transition-colors text-center cursor-pointer"
              >
                Cancel
              </Link>

              <button
                type="button"
                disabled={isSubmitting}
                onClick={handleAddAnotherItem}
                className="w-full sm:w-auto px-6 py-3 border-2 border-[#009845] text-[#009845] hover:bg-[#E6F9ED] active:bg-[#d0f4dc] rounded-xl text-xs font-bold transition-all cursor-pointer flex items-center justify-center gap-2 shadow-2xs disabled:opacity-50"
                title="Add this item as a lot to the combined auction and add another equipment"
              >
                <Plus className="w-4 h-4 text-[#009845]" />
                <span>Save &amp; Add Another Item to this Auction</span>
              </button>

              <button
                type="button"
                disabled={isSubmitting}
                onClick={handleSubmitAuction}
                className="w-full sm:w-auto px-8 py-3 bg-[#009845] hover:bg-[#008230] text-white rounded-xl text-xs font-bold shadow-2xs transition-colors cursor-pointer flex items-center justify-center gap-2 disabled:opacity-50"
              >
                <span>
                  {isSubmitting
                    ? "Submitting..."
                    : combinedItems.length > 0
                    ? `Publish Combined Auction (${combinedItems.length + 1} Lots)`
                    : "Submit Listing"}
                </span>
              </button>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
