export interface NavItem {
  name: string;
  icon: string;
  href: string;
}

export const navItems: NavItem[] = [
  { name: "Dashboard", icon: "/icons/dashboard.svg", href: "/dashboard" },
  { name: "Sellers / EPC", icon: "/icons/seller.svg", href: "/sellers" },
  { name: "Scrap Dealers", icon: "/icons/scrap-dealer.svg", href: "/scrap-dealers" },
  { name: "Seller Posts", icon: "/icons/seller-post.svg", href: "/seller-posts" },
  { name: "Auctions", icon: "/icons/auction.svg", href: "/auctions" },
  { name: "Facebook Leads", icon: "/icons/facebook-leads.svg", href: "/facebook-leads" },
  { name: "Quotation history", icon: "/icons/quotation-history.svg", href: "/quotation-history" },
  { name: "My Inventory", icon: "/icons/inventory.svg", href: "/my-inventory" },
  { name: "Notifications", icon: "/icons/notifications.svg", href: "/notifications" },
  { name: "Settings", icon: "/icons/setting.svg", href: "/settings" },
];
