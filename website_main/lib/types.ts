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
