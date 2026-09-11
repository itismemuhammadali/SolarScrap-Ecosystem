"use client";

import { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { ChevronLeft } from "lucide-react";
import { forgotPassword } from "@/lib/auth";

export default function VerifyEmailPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage("");
    setIsLoading(true);

    try {
      const res = await forgotPassword(email.trim());
      sessionStorage.setItem("reset_email", email.trim());
      sessionStorage.setItem("reset_masked_email", res.masked_email);
      router.push("/verify-otp");
    } catch (err: unknown) {
      if (err instanceof Error) {
        setErrorMessage(err.message);
      } else {
        setErrorMessage("Failed to send reset code. Please try again.");
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <main className="min-h-screen w-full bg-[#E5E7EB] p-2 sm:p-4 md:p-6 lg:p-8 flex items-center justify-center">
      {/* Outer Card Frame with 10px-14px padding */}
      <div className="w-full max-w-[1360px] bg-white rounded-[32px] sm:rounded-[40px] p-2.5 sm:p-3 md:p-3.5 shadow-2xl border border-gray-200/80 flex flex-col md:flex-row relative min-h-[640px] md:min-h-[728px] items-center">
        
        {/* Left Column - Verify Email Scrap Image (Taller full-height image) */}
        <div className="relative w-full md:w-[50%] lg:w-[52%] h-[340px] sm:h-[420px] md:h-[700px] min-h-[300px] rounded-[22px] sm:rounded-[26px] md:rounded-[28px] overflow-hidden shadow-xs shrink-0">
          <Image
            src="/images/verify-email-screen.jpg"
            alt="Industrial Scrap Equipment"
            fill
            priority
            className="object-cover object-center"
            sizes="(max-width: 768px) 100vw, 52vw"
          />
        </div>

        {/* Right Column - Elevated Floating White Verify Form Card */}
        <div className="w-full md:flex-1 h-auto md:h-[680px] bg-white rounded-[24px] sm:rounded-[28px] md:rounded-[30px] shadow-[-10px_0_30px_rgba(0,0,0,0.12),0_10px_30px_rgba(0,0,0,0.06)] border border-gray-100/90 z-10 -mt-6 sm:-mt-8 md:mt-0 md:-ml-[10px] flex flex-col justify-center items-center px-6 py-8 sm:px-10 sm:py-12 md:px-12 lg:px-16 relative">
          <div className="w-full max-w-[430px] flex flex-col">
            
            {/* Solar Scrap Logo */}
            <div className="mb-4 sm:mb-5">
              <Image
                src="/images/solar-scrap-img.png"
                alt="Solar Scrap"
                width={165}
                height={62}
                className="w-[145px] sm:w-[160px] md:w-[170px] h-auto object-contain -ml-0.5"
                priority
              />
            </div>

            {/* Back Button */}
            <div className="mb-3 sm:mb-4">
              <Link
                href="/"
                className="inline-flex items-center justify-center w-9 h-9 rounded-xl bg-gray-100 hover:bg-gray-200/80 text-gray-700 border border-gray-200/80 transition-colors"
                aria-label="Go back to Sign In"
              >
                <ChevronLeft className="w-4.5 h-4.5" />
              </Link>
            </div>

            {/* Title & Subtitle */}
            <h1 className="text-2xl sm:text-3xl md:text-[32px] font-bold text-gray-900 tracking-tight leading-tight">
              Confirm it&apos;s you.
            </h1>
            <p className="text-xs sm:text-sm md:text-[15px] text-gray-500 mt-1.5 mb-6 sm:mb-8 font-normal">
              Please verify your email to continue
            </p>

            {/* Verify Email Form */}
            <form onSubmit={handleSubmit} className="space-y-4 sm:space-y-5">
              {/* Email Address */}
              <div>
                <label
                  htmlFor="email"
                  className="block text-xs sm:text-sm font-semibold text-gray-700 mb-2"
                >
                  Email Address
                </label>
                <input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="mymail@gmail.com"
                  required
                  className="w-full px-4 py-3 sm:py-3.5 text-xs sm:text-sm md:text-base text-gray-900 placeholder:text-gray-400 bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all duration-200"
                />
              </div>

              {/* Error Message */}
              {errorMessage && (
                <div className="p-3 bg-red-50 border border-red-200 text-red-700 text-xs sm:text-sm rounded-xl">
                  {errorMessage}
                </div>
              )}

              {/* Continue Button */}
              <div className="pt-2">
                <button
                  type="submit"
                  disabled={isLoading}
                  className="w-full py-3.5 sm:py-4 px-4 bg-[#009845] hover:bg-[#008230] active:bg-[#006d28] text-white text-sm sm:text-base font-bold rounded-xl shadow-lg shadow-[#009845]/25 hover:shadow-xl transition-all duration-200 flex items-center justify-center disabled:opacity-75 cursor-pointer"
                >
                  {isLoading ? (
                    <span className="inline-block w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                  ) : (
                    "Continue"
                  )}
                </button>
              </div>
            </form>

          </div>
        </div>

      </div>
    </main>
  );
}
