import {
  LoginResponse,
  ForgotPasswordResponse,
  VerifyOtpResponse,
  ResetPasswordResponse,
  UserProfile,
} from "./types";

const API_BASE =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000/api/v1";

const AUTH_COOKIE_NAME = "solar_scrap_auth";
const USER_KEY = "solar_scrap_user";
const TOKEN_KEY = "solar_scrap_token";

/**
 * Sign In with email, password, and role.
 */
export async function signIn(
  email: string,
  password: string,
  role: string = "admin"
): Promise<LoginResponse> {
  const response = await fetch(`${API_BASE}/auth/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ email, password, role }),
  });

  const data = await response.json();

  if (!response.ok) {
    const errorMsg =
      data?.detail || "Authentication failed. Please check your credentials.";
    throw new Error(errorMsg);
  }

  return data as LoginResponse;
}

/**
 * Send Forgot Password request to generate OTP.
 */
export async function forgotPassword(
  email: string
): Promise<ForgotPasswordResponse> {
  const response = await fetch(`${API_BASE}/auth/forgot-password`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ email }),
  });

  const data = await response.json();

  if (!response.ok) {
    const errorMsg =
      data?.detail || "Failed to send reset code. Please try again.";
    throw new Error(errorMsg);
  }

  return data as ForgotPasswordResponse;
}

/**
 * Verify 6-digit OTP code and retrieve reset token.
 */
export async function verifyOtp(
  email: string,
  otp: string
): Promise<VerifyOtpResponse> {
  const response = await fetch(`${API_BASE}/auth/verify-otp`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ email, otp }),
  });

  const data = await response.json();

  if (!response.ok) {
    const errorMsg =
      data?.detail || "Invalid or expired OTP code.";
    throw new Error(errorMsg);
  }

  return data as VerifyOtpResponse;
}

/**
 * Reset user password with new password and reset token.
 */
export async function resetPassword(
  email: string,
  resetToken: string,
  newPassword: string
): Promise<ResetPasswordResponse> {
  const response = await fetch(`${API_BASE}/auth/reset-password`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      email,
      reset_token: resetToken,
      new_password: newPassword,
    }),
  });

  const data = await response.json();

  if (!response.ok) {
    const errorMsg =
      data?.detail || "Failed to reset password. Please try again.";
    throw new Error(errorMsg);
  }

  return data as ResetPasswordResponse;
}

/**
 * Persist user session to localStorage and document.cookie.
 */
export function saveSession(token: string, user: UserProfile): void {
  if (typeof window === "undefined") return;

  try {
    localStorage.setItem(TOKEN_KEY, token);
    localStorage.setItem(USER_KEY, JSON.stringify(user));

    // Save auth token in cookie (expires in 7 days)
    const maxAge = 7 * 24 * 60 * 60;
    document.cookie = `${AUTH_COOKIE_NAME}=${encodeURIComponent(
      token
    )}; path=/; max-age=${maxAge}; SameSite=Lax`;
  } catch (e) {
    console.error("Failed to save session:", e);
  }
}

/**
 * Read current session from localStorage.
 */
export function getSession(): { token: string; user: UserProfile } | null {
  if (typeof window === "undefined") return null;

  try {
    const token = localStorage.getItem(TOKEN_KEY);
    const userStr = localStorage.getItem(USER_KEY);
    if (!token || !userStr) return null;

    const user = JSON.parse(userStr) as UserProfile;
    return { token, user };
  } catch {
    return null;
  }
}

/**
 * Clear session and auth cookie.
 */
export function clearSession(): void {
  if (typeof window === "undefined") return;

  try {
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem(USER_KEY);
    document.cookie = `${AUTH_COOKIE_NAME}=; path=/; max-age=0; SameSite=Lax`;
  } catch (e) {
    console.error("Failed to clear session:", e);
  }
}

/**
 * Check whether user is authenticated.
 */
export function isAuthenticated(): boolean {
  return getSession() !== null;
}

/**
 * Resolves avatar URL to an absolute URL if needed.
 */
export function getAvatarUrl(url?: string | null): string | null {
  if (!url) return null;
  if (url.startsWith("http://") || url.startsWith("https://") || url.startsWith("data:")) {
    return url;
  }
  const baseUrl = process.env.NEXT_PUBLIC_BACKEND_URL || "http://localhost:8000";
  return `${baseUrl}${url.startsWith("/") ? "" : "/"}${url}`;
}
