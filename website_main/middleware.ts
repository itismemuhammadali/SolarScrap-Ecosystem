import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

const AUTH_COOKIE = "solar_scrap_auth";

// Routes that are authentication-only pages (redirect logged in users to /dashboard)
const AUTH_PAGES = [
  "/",
  "/verify-email",
  "/verify-otp",
  "/reset-password",
];

// Public landing / lead capture pages accessible to everyone (authenticated or guest)
const PUBLIC_LANDING_PAGES = [
  "/facebook-lead",
  "/meta-lead",
];

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Allow static files, Next.js assets, and favicon
  if (
    pathname.startsWith("/_next") ||
    pathname.startsWith("/images") ||
    pathname.startsWith("/icons") ||
    pathname.startsWith("/favicon.ico") ||
    pathname.startsWith("/api")
  ) {
    return NextResponse.next();
  }

  const token = request.cookies.get(AUTH_COOKIE)?.value;
  const isAuthPage = AUTH_PAGES.includes(pathname);
  const isLandingPage = PUBLIC_LANDING_PAGES.includes(pathname);

  // If user is logged in and visits sign-in/auth pages, redirect to dashboard
  if (token && isAuthPage) {
    return NextResponse.redirect(new URL("/dashboard", request.url));
  }

  // If user is not logged in and visits protected pages, redirect to sign-in
  if (!token && !isAuthPage && !isLandingPage) {
    const loginUrl = new URL("/", request.url);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - images (public images)
     */
    "/((?!_next/static|_next/image|images|favicon.ico).*)",
  ],
};
