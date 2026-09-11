export type UserRole = "admin" | "buyer" | "seller";

export interface UserProfile {
  user_id: string;
  email: string;
  role: UserRole;
  display_name?: string | null;
  phone_number?: string | null;
  company_name?: string | null;
  city?: string | null;
  area?: string | null;
  address?: string | null;
  company_type?: string | null;
  gst_number?: string | null;
  profile_photo_url?: string | null;
  created_at?: string | null;
}

export interface LoginResponse {
  access_token: string;
  token_type: string;
  user: UserProfile;
  message: string;
}

export interface ForgotPasswordResponse {
  message: string;
  masked_email: string;
}

export interface VerifyOtpResponse {
  reset_token: string;
  message: string;
}

export interface ResetPasswordResponse {
  message: string;
}

export interface ApiError {
  detail: string;
}

export interface StatCardItem {
  total_sellers: number;
  total_dealers: number;
  pending_approvals: number;
  pending_posts: number;
  active_auctions: number;
  total_bids: number;
  facebook_leads: number;
}

export interface UserGrowthPoint {
  month: string;
  sellers: number;
  dealers: number;
}

export interface UserStatusBreakdown {
  approved: number;
  pending: number;
  rejected: number;
}

export interface BidActivityWeek {
  week: string;
  count: number;
  height_pct: number;
}

export interface CityLeadItem {
  city: string;
  count: number;
  percentage: number;
}

export interface RecentActivityItem {
  id: string;
  title: string;
  time: string;
  type: string;
}

export interface DashboardStatsResponse {
  stats: StatCardItem;
  user_growth: UserGrowthPoint[];
  user_status: UserStatusBreakdown;
  bid_activity: BidActivityWeek[];
  city_leads: CityLeadItem[];
  recent_activities: RecentActivityItem[];
}

export interface AdminUserItem {
  id: string;
  name: string;
  avatar_letter: string;
  company: string;
  email: string;
  phone: string;
  status: "Pending" | "Approved" | "Rejected";
  activity_status: "Active" | "Inactive";
  joined: string;
  role: string;
  city: string;
  area: string;
  profile_photo_url?: string | null;
}

export interface AdminLeadItem {
  id: string;
  lead_id: string;
  name: string;
  phone: string;
  email: string;
  city: string;
  area: string;
  received_date: string;
  status: "New" | "Contacted" | "Follow-up" | "Converted";
  source: string;
  notes: string[];
}

export interface AdminSellerPostItem {
  id: string;
  post_id: string;
  title: string;
  category: string;
  qty: number;
  condition: string;
  status: string;
  price_expected: number;
  offered_price?: number | null;
  submitted_date: string;
  seller_name: string;
  seller_company: string;
  seller_email: string;
  seller_phone: string;
  city: string;
  area: string;
  address: string;
  brand_model: string;
  estimated_weight: string;
  disassembly_state: string;
  images: string[];
  admin_notes?: string | null;
}

export interface UpdateSellerPostRequest {
  status?: string;
  offered_price?: number;
  admin_notes?: string;
}

export interface AdminNotificationItem {
  id: string;
  type: "new_user_registered" | "new_pending_post" | "new_bid" | "auction_created" | string;
  title: string;
  description: string;
  entity_id?: string | null;
  entity_type?: "user" | "listing" | "bid" | null;
  is_read: boolean;
  created_at?: string | null;
}
