import { getSession, clearSession } from "./auth";
import {
  DashboardStatsResponse,
  AdminUserItem,
  AdminLeadItem,
  AdminSellerPostItem,
  UpdateSellerPostRequest,
  AdminNotificationItem,
} from "./types";

const API_BASE =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000/api/v1";

function getAuthHeaders(): HeadersInit {
  const session = getSession();
  const token = session?.token || "admin_token";
  return {
    "Content-Type": "application/json",
    Authorization: `Bearer ${token}`,
  };
}

/**
 * Fetch live dashboard statistics, charts data, and recent activity
 */
export async function getDashboardStats(): Promise<DashboardStatsResponse> {
  const response = await fetch(`${API_BASE}/admin/dashboard-stats`, {
    method: "GET",
    headers: getAuthHeaders(),
    cache: "no-store",
  });

  if (!response.ok) {
    if (response.status === 401) {
      clearSession();
      if (typeof window !== "undefined") {
        window.location.href = "/";
      }
    }
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to fetch dashboard statistics");
  }

  return response.json();
}

/**
 * Fetch users (sellers or dealers) with optional status filter
 */
export async function getAdminUsers(
  role?: "seller" | "buyer",
  status?: string
): Promise<AdminUserItem[]> {
  const params = new URLSearchParams();
  if (role) params.set("role", role);
  if (status && status !== "All") params.set("status", status);

  const url = `${API_BASE}/admin/users?${params.toString()}`;
  const response = await fetch(url, {
    method: "GET",
    headers: getAuthHeaders(),
    cache: "no-store",
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to fetch users");
  }

  return response.json();
}

/**
 * Update user account approval status (Pending / Approved / Rejected)
 */
export async function updateUserStatus(
  userId: string,
  status: "approved" | "rejected" | "pending"
): Promise<{ message: string; user_id: string; status: string }> {
  const response = await fetch(`${API_BASE}/admin/users/${userId}/status`, {
    method: "PATCH",
    headers: getAuthHeaders(),
    body: JSON.stringify({ status }),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to update user status");
  }

  return response.json();
}

/**
 * Fetch all Facebook campaign leads
 */
export async function getAdminLeads(): Promise<AdminLeadItem[]> {
  const response = await fetch(`${API_BASE}/admin/leads`, {
    method: "GET",
    headers: getAuthHeaders(),
    cache: "no-store",
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to fetch leads");
  }

  return response.json();
}

/**
 * Update lead status or add note
 */
export async function updateAdminLead(
  leadId: string,
  data: { status?: string; note?: string }
): Promise<{ message: string }> {
  const response = await fetch(`${API_BASE}/admin/leads/${leadId}`, {
    method: "PATCH",
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to update lead");
  }

  return response.json();
}

/**
 * Simulate or manually create a Meta/Facebook lead
 */
export async function createAdminLead(
  lead: Partial<AdminLeadItem>
): Promise<AdminLeadItem> {
  const response = await fetch(`${API_BASE}/admin/leads`, {
    method: "POST",
    headers: getAuthHeaders(),
    body: JSON.stringify(lead),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to create lead");
  }

  return response.json();
}

/**
 * Populate Firestore with demo records
 */
export async function seedDemoData(): Promise<{ message: string }> {
  const response = await fetch(`${API_BASE}/admin/seed-demo-data`, {
    method: "POST",
    headers: getAuthHeaders(),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to seed demo data");
  }

  return response.json();
}

/**
 * Fetch all seller posts / listings
 */
export async function getAdminSellerPosts(): Promise<AdminSellerPostItem[]> {
  const response = await fetch(`${API_BASE}/admin/posts`, {
    method: "GET",
    headers: getAuthHeaders(),
    cache: "no-store",
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to fetch seller posts");
  }

  return response.json();
}

/**
 * Update seller post status, offered price, or admin notes
 */
export async function updateAdminSellerPost(
  postId: string,
  data: UpdateSellerPostRequest
): Promise<{ message: string; id: string }> {
  const response = await fetch(`${API_BASE}/admin/posts/${postId}`, {
    method: "PATCH",
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to update seller post");
  }

  return response.json();
}

/**
 * Create a new auction listing directly on the marketplace
 */
export async function createAdminListing(data: any): Promise<any> {
  const response = await fetch(`${API_BASE}/listings`, {
    method: "POST",
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to create auction listing");
  }

  return response.json();
}

/**
 * Upload a listing equipment image file to backend storage
 */
export async function uploadListingImageFile(file: File): Promise<string> {
  const formData = new FormData();
  formData.append("file", file);

  const session = getSession();
  const token = session?.token || "admin_token";

  const response = await fetch(`${API_BASE}/storage/upload-listing-image`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
    },
    body: formData,
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to upload listing image");
  }

  const data = await response.json();
  return data.url;
}

/**
 * Fetch all marketplace auctions with live bids and highest bidder details
 */
export async function getAdminAuctions(): Promise<any[]> {
  const response = await fetch(`${API_BASE}/admin/auctions`, {
    method: "GET",
    headers: getAuthHeaders(),
    cache: "no-store",
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to fetch admin auctions");
  }

  return response.json();
}

/**
 * Close an auction directly from the admin portal
 */
export async function closeAdminAuction(
  listingId: string
): Promise<{ message: string; id: string }> {
  const response = await fetch(`${API_BASE}/admin/auctions/${listingId}/close`, {
    method: "POST",
    headers: getAuthHeaders(),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to close auction");
  }

  return response.json();
}

/**
 * Accept a bid as the winner from the admin portal
 */
export async function acceptAdminBid(
  bidId: string
): Promise<{ message: string; bid_id: string }> {
  const response = await fetch(`${API_BASE}/admin/bids/${bidId}/accept`, {
    method: "POST",
    headers: getAuthHeaders(),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to accept bid");
  }

  return response.json();
}

/**
 * Fetch bids across all auctions or filtered by auctionId
 */
export async function getAdminBids(auctionId?: string): Promise<any[]> {
  const url = auctionId
    ? `${API_BASE}/admin/bids?auction_id=${encodeURIComponent(auctionId)}`
    : `${API_BASE}/admin/bids`;

  const response = await fetch(url, {
    method: "GET",
    headers: getAuthHeaders(),
    cache: "no-store",
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to fetch admin bids");
  }

  return response.json();
}

/**
 * Fetch details of a single auction for the bids page summary banner
 */
export async function getAdminAuctionDetail(auctionId: string): Promise<any> {
  const response = await fetch(
    `${API_BASE}/admin/auctions/${encodeURIComponent(auctionId)}`,
    {
      method: "GET",
      headers: getAuthHeaders(),
      cache: "no-store",
    }
  );

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to fetch auction details");
  }

  return response.json();
}

/**
 * Fetch all admin notifications, newest first
 */
export async function getAdminNotifications(): Promise<AdminNotificationItem[]> {
  const response = await fetch(`${API_BASE}/admin/notifications`, {
    method: "GET",
    headers: getAuthHeaders(),
    cache: "no-store",
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to fetch admin notifications");
  }

  return response.json();
}

/**
 * Mark a single admin notification as read
 */
export async function markAdminNotificationRead(id: string): Promise<{ success: boolean; message: string }> {
  const response = await fetch(`${API_BASE}/admin/notifications/${id}/read`, {
    method: "POST",
    headers: getAuthHeaders(),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to mark notification as read");
  }

  return response.json();
}

/**
 * Mark all admin notifications as read
 */
export async function markAllAdminNotificationsRead(): Promise<{ success: boolean; message: string }> {
  const response = await fetch(`${API_BASE}/admin/notifications/read-all`, {
    method: "POST",
    headers: getAuthHeaders(),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to mark all notifications as read");
  }

  return response.json();
}

/**
 * Delete a single admin notification
 */
export async function deleteAdminNotification(id: string): Promise<{ success: boolean; message: string }> {
  const response = await fetch(`${API_BASE}/admin/notifications/${id}`, {
    method: "DELETE",
    headers: getAuthHeaders(),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to delete notification");
  }

  return response.json();
}

/**
 * Submit an incoming Meta / Facebook Ad lead from public landing page (no auth needed)
 */
export async function submitPublicLead(payload: {
  name: string;
  phone: string;
  email?: string;
  city: string;
  area?: string;
  category?: string;
  quantity?: string;
  specs?: string;
  asking_price?: string | number;
  remarks?: string;
  intent?: string;
  source?: string;
}): Promise<{ success: boolean; message: string; lead_id: string; id: string }> {
  const response = await fetch(`${API_BASE}/admin/leads/public`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.detail || "Failed to submit lead");
  }

  return response.json();
}



