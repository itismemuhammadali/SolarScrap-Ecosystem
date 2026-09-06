import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

const AUTH_COOKIE = "solar_scrap_auth";

// Routes that can be accessed without authentication
const PUBLIC_PATHS = [
  "/",
  "/verify-email",
  "/verify-otp",
  "/reset-password",
];

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Allow static files, Next.js assets, and favicon
  if (
    pathname.startsWith("/_next") ||
    pathname.startsWith("/images") ||
    pathname.startsWith("/favicon.ico") ||
    pathname.startsWith("/api")
  ) {
    return NextResponse.next();
  }

  const token = request.cookies.get(AUTH_COOKIE)?.value;
  const isPublicPath = PUBLIC_PATHS.includes(pathname);

  // If user is logged in and visits public auth pages, redirect to dashboard
  if (token && isPublicPath) {
    return NextResponse.redirect(new URL("/dashboard", request.url));
  }

  // If user is not logged in and visits protected pages, redirect to sign-in
  if (!token && !isPublicPath) {
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
