"use client";

import { useState, useRef, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { ChevronLeft, Mail } from "lucide-react";
import { verifyOtp, forgotPassword } from "@/lib/auth";

export default function VerifyOtpPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [displayEmail, setDisplayEmail] = useState("Solarscrap.info@gmail.com");
  const [otp, setOtp] = useState<string[]>(["", "", "", "", "", ""]);
  const [timer, setTimer] = useState(45);
  const [canResend, setCanResend] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);

  // Load email from sessionStorage on mount
  useEffect(() => {
    if (typeof window !== "undefined") {
      const storedEmail = sessionStorage.getItem("reset_email");
      const storedMasked = sessionStorage.getItem("reset_masked_email");
      if (storedEmail) {
        setEmail(storedEmail);
        setDisplayEmail(storedMasked || storedEmail);
      }
    }
  }, []);

  // Resend Timer Countdown
  useEffect(() => {
    let interval: NodeJS.Timeout;
    if (timer > 0) {
      interval = setInterval(() => {
        setTimer((prev) => prev - 1);
      }, 1000);
    } else {
      setCanResend(true);
    }
    return () => clearInterval(interval);
  }, [timer]);

  // Handle Input Change
  const handleChange = (index: number, value: string) => {
    // Only accept numeric characters
    if (!/^\d*$/.test(value)) return;
    setErrorMessage("");

    const newOtp = [...otp];
    // If pasted or typed multiple digits
    if (value.length > 1) {
      const pastedDigits = value.slice(0, 6).split("");
      pastedDigits.forEach((digit, i) => {
        if (i < 6) newOtp[i] = digit;
      });
      setOtp(newOtp);
      const nextIndex = Math.min(pastedDigits.length, 5);
      inputRefs.current[nextIndex]?.focus();
      return;
    }

    newOtp[index] = value;
    setOtp(newOtp);

    // Auto-focus next input
    if (value && index < 5) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  // Handle Key Down (Backspace, Arrow keys)
  const handleKeyDown = (index: number, e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Backspace") {
      if (!otp[index] && index > 0) {
        inputRefs.current[index - 1]?.focus();
      }
    } else if (e.key === "ArrowLeft" && index > 0) {
      inputRefs.current[index - 1]?.focus();
    } else if (e.key === "ArrowRight" && index < 5) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  // Handle Paste Event
  const handlePaste = (e: React.ClipboardEvent) => {
    e.preventDefault();
    const pastedData = e.clipboardData.getData("text").replace(/\D/g, "").slice(0, 6);
    if (!pastedData) return;

    const newOtp = [...otp];
    pastedData.split("").forEach((char, idx) => {
      newOtp[idx] = char;
    });
    setOtp(newOtp);

    const targetIndex = Math.min(pastedData.length, 5);
    inputRefs.current[targetIndex]?.focus();
  };

  const handleResend = async () => {
    if (!canResend) return;
    setErrorMessage("");
    const targetEmail = email || "solarscrap.info@gmail.com";
    try {
      await forgotPassword(targetEmail);
      setOtp(["", "", "", "", "", ""]);
      setTimer(45);
      setCanResend(false);
      inputRefs.current[0]?.focus();
    } catch (err: unknown) {
      if (err instanceof Error) {
        setErrorMessage(err.message);
      } else {
        setErrorMessage("Failed to resend code.");
      }
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage("");
    const fullOtp = otp.join("");
    if (fullOtp.length < 6) return;

    const targetEmail = email || "solarscrap.info@gmail.com";
    setIsLoading(true);

    try {
      const res = await verifyOtp(targetEmail, fullOtp);
      sessionStorage.setItem("reset_token", res.reset_token);
      setIsSuccess(true);
      setTimeout(() => {
        router.push("/reset-password");
      }, 700);
    } catch (err: unknown) {
      if (err instanceof Error) {
        setErrorMessage(err.message);
      } else {
        setErrorMessage("Invalid OTP code.");
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <main className="min-h-screen w-full bg-[#E5E7EB] p-2 sm:p-4 md:p-6 lg:p-8 flex items-center justify-center">
      {/* Outer Card Frame with 10px-14px padding */}
      <div className="w-full max-w-[1360px] bg-white rounded-[32px] sm:rounded-[40px] p-2.5 sm:p-3 md:p-3.5 shadow-2xl border border-gray-200/80 flex flex-col md:flex-row relative min-h-[640px] md:min-h-[728px] items-center">
        
        {/* Left Column - Hero OTP Broken Solar Panels Image (Taller full-height image) */}
        <div className="relative w-full md:w-[50%] lg:w-[52%] h-[340px] sm:h-[420px] md:h-[700px] min-h-[300px] rounded-[22px] sm:rounded-[26px] md:rounded-[28px] overflow-hidden shadow-xs shrink-0">
          <Image
            src="/images/otp-screen-img.jpg"
            alt="Solar Panels Facility"
            fill
            priority
            className="object-cover object-center"
            sizes="(max-width: 768px) 100vw, 52vw"
          />
        </div>

        {/* Right Column - Elevated Floating White OTP Form Card */}
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
                href="/verify-email"
                className="inline-flex items-center justify-center w-9 h-9 rounded-xl bg-gray-100 hover:bg-gray-200/80 text-gray-700 border border-gray-200/80 transition-colors"
                aria-label="Go back to Verify Email"
              >
                <ChevronLeft className="w-4.5 h-4.5" />
              </Link>
            </div>

            {/* Form with Card Container */}
            <form onSubmit={handleSubmit} className="space-y-4 sm:space-y-5">
              
              {/* White Bordered Inner Card Container */}
              <div className="bg-white border border-gray-200/90 rounded-2xl p-5 sm:p-6 flex flex-col items-center justify-center text-center shadow-xs">
                {/* Green Circle with Envelope Icon */}
                <div className="w-13 h-13 rounded-full bg-[#009845] flex items-center justify-center text-white mb-3 shadow-md shadow-[#009845]/20">
                  <Mail className="w-6 h-6 text-white" />
                </div>

                {/* Sent To Description */}
                <p className="text-xs sm:text-sm text-gray-500 font-normal">
                  Please enter the code we sent to
                </p>
                <p className="text-sm sm:text-base font-bold text-gray-900 mt-0.5 mb-5">
                  {displayEmail}
                </p>

                {/* 6 Digit Input Boxes */}
                <div 
                  className="grid grid-cols-6 gap-2 sm:gap-2.5 w-full max-w-[320px]"
                  onPaste={handlePaste}
                >
                  {otp.map((digit, idx) => (
                    <input
                      key={idx}
                      ref={(el) => {
                        inputRefs.current[idx] = el;
                      }}
                      type="text"
                      inputMode="numeric"
                      maxLength={1}
                      value={digit}
                      onChange={(e) => handleChange(idx, e.target.value)}
                      onKeyDown={(e) => handleKeyDown(idx, e)}
                      className="w-full h-12 sm:h-13 text-center text-lg sm:text-xl font-bold text-gray-900 bg-white border border-gray-200 rounded-xl outline-none focus:border-[#009845] focus:ring-2 focus:ring-[#009845]/15 transition-all duration-200"
                      autoFocus={idx === 0}
                    />
                  ))}
                </div>
              </div>

              {/* Error Message */}
              {errorMessage && (
                <div className="p-3 bg-red-50 border border-red-200 text-red-700 text-xs sm:text-sm rounded-xl">
                  {errorMessage}
                </div>
              )}

              {/* Continue Green Button */}
              <div>
                <button
                  type="submit"
                  disabled={isLoading || otp.join("").length < 6}
                  className="w-full py-3.5 sm:py-4 px-4 bg-[#009845] hover:bg-[#008230] text-white text-sm sm:text-base font-bold rounded-xl shadow-lg shadow-[#009845]/25 hover:shadow-xl transition-all duration-200 flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer"
                >
                  {isLoading ? (
                    <span className="inline-block w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                  ) : (
                    "Continue"
                  )}
                </button>
              </div>

              {/* Resend Code Section */}
              <div className="flex items-center justify-between text-xs sm:text-sm pt-1 px-1">
                <span className="text-gray-500">
                  Didn&apos;t receive code?
                </span>
                {canResend ? (
                  <button
                    type="button"
                    onClick={handleResend}
                    className="font-semibold text-[#009845] hover:underline cursor-pointer"
                  >
                    Resend OTP
                  </button>
                ) : (
                  <span className="text-gray-400 font-medium">
                    Resend in <span className="text-gray-700 font-semibold">{timer}s</span>
                  </span>
                )}
              </div>

              {/* Success Message Feedback */}
              {isSuccess && (
                <div className="p-3.5 bg-green-50 border border-green-200 text-green-700 text-xs sm:text-sm rounded-xl flex items-center justify-center gap-2">
                  <span>✓ OTP verified successfully! Redirecting...</span>
                </div>
              )}
            </form>

          </div>
        </div>

      </div>
    </main>
  );
}
