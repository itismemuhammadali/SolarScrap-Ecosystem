// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Solar Scrap';

  @override
  String get tagline => 'B2B Solar Scrap Recycling Marketplace';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get submit => 'Submit';

  @override
  String get continueButton => 'Continue';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get loading => 'Loading...';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get success => 'Success';

  @override
  String get viewAll => 'View All';

  @override
  String get seeMore => 'See More';

  @override
  String get requiredField => 'This field is required';

  @override
  String get selectRoleTitle => 'Choose Your Role';

  @override
  String get selectRoleSubtitle =>
      'Are you looking to buy or sell solar scrap?';

  @override
  String get sellerRoleTitle => 'I Want to Sell';

  @override
  String get sellerRoleDesc =>
      'Post your solar equipment, panels, batteries & scrap for buyers to bid on.';

  @override
  String get buyerRoleTitle => 'I Want to Buy';

  @override
  String get buyerRoleDesc =>
      'Browse auctions, place bids and purchase solar scrap at competitive prices.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get welcomeBack => 'Welcome back,';

  @override
  String get signInToContinue => 'Sign in to continue to your account';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get orSignInWith => 'Or continue with';

  @override
  String get googleSignIn => 'Continue with Google';

  @override
  String get appleSignIn => 'Continue with Apple';

  @override
  String get createAccount => 'Create Account';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'John Doe';

  @override
  String get companyNameLabel => 'Company Name';

  @override
  String get companyNameHint => 'ABC Solar Recyclers';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneHint => '0300 1234567';

  @override
  String get cityLabel => 'City';

  @override
  String get cityHint => 'Karachi';

  @override
  String get termsAgreement =>
      'By signing up, you agree to our Terms of Service and Privacy Policy';

  @override
  String get otpVerificationTitle => 'Verification Code';

  @override
  String otpVerificationSubtitle(String contact) {
    return 'We sent a 6-digit verification code to $contact';
  }

  @override
  String get verify => 'Verify';

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendCodeIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get didNotReceiveCode => 'Didn\'t receive the code?';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email address to receive password reset instructions';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get newPasswordHint => 'Enter new password';

  @override
  String get passwordChangedSuccess => 'Password changed successfully';

  @override
  String get sellerDashboardTitle => 'Seller Dashboard';

  @override
  String get activeListings => 'Active Listings';

  @override
  String get pendingOffers => 'Pending Offers';

  @override
  String get completedDeals => 'Completed Deals';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get createNewListing => 'Create New Listing';

  @override
  String get myListings => 'My Listings';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get categoryPanels => 'Solar Panels';

  @override
  String get categoryInverters => 'Inverters';

  @override
  String get categoryBatteries => 'Batteries';

  @override
  String get categoryCables => 'Cables & Wiring';

  @override
  String get categoryStructure => 'Mounting Structure';

  @override
  String get categoryOthers => 'Other Equipment';

  @override
  String get listingTitleLabel => 'Listing Title';

  @override
  String get listingTitleHint => 'e.g. 500W Monocrystalline Panels (Lot of 50)';

  @override
  String get listingCategoryLabel => 'Category';

  @override
  String get listingConditionLabel => 'Condition';

  @override
  String get listingQuantityLabel => 'Quantity';

  @override
  String get listingWeightLabel => 'Estimated Weight (kg)';

  @override
  String get listingDescriptionLabel => 'Description';

  @override
  String get listingDescriptionHint =>
      'Describe the scrap, damages, wear and tear, history...';

  @override
  String get uploadPhotos => 'Upload Photos';

  @override
  String get uploadPhotosHint =>
      'Add clear photos of the items, labels, and damage areas';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get previewListing => 'Preview Listing';

  @override
  String get submitListing => 'Submit Listing';

  @override
  String get listingSubmittedTitle => 'Listing Submitted!';

  @override
  String get listingSubmittedDesc =>
      'Your listing is being reviewed and will be live shortly.';

  @override
  String get backToDashboard => 'Back to Dashboard';

  @override
  String get equipmentDetails => 'Equipment Details';

  @override
  String get panelType => 'Panel Type';

  @override
  String get monocrystalline => 'Monocrystalline';

  @override
  String get polycrystalline => 'Polycrystalline';

  @override
  String get thinFilm => 'Thin Film';

  @override
  String get wattagePerPanel => 'Wattage per Panel (W)';

  @override
  String get inverterType => 'Inverter Type';

  @override
  String get stringInverter => 'String Inverter';

  @override
  String get centralInverter => 'Central Inverter';

  @override
  String get microInverter => 'Micro Inverter';

  @override
  String get capacityKva => 'Capacity (kVA / kW)';

  @override
  String get batteryType => 'Battery Type';

  @override
  String get lithiumIon => 'Lithium-Ion';

  @override
  String get leadAcid => 'Lead Acid';

  @override
  String get tubular => 'Tubular';

  @override
  String get cableMetal => 'Cable Metal';

  @override
  String get copper => 'Copper';

  @override
  String get aluminum => 'Aluminum';

  @override
  String get pickupLocationTitle => 'Pickup Location';

  @override
  String get pickupAddressLabel => 'Address / Warehouse Location';

  @override
  String get pickupCityLabel => 'City';

  @override
  String get pickupDateLabel => 'Preferred Pickup Date';

  @override
  String get contactPersonLabel => 'Contact Person';

  @override
  String get contactPhoneLabel => 'Contact Phone';

  @override
  String get statusTrackingTitle => 'Status Tracking';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusUnderReview => 'Under Review';

  @override
  String get statusPublished => 'Published / Live';

  @override
  String get statusOffersReceived => 'Offers Received';

  @override
  String get statusPickupScheduled => 'Pickup Scheduled';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get priceOffersTitle => 'Price Offers';

  @override
  String get offerAmount => 'Offered Amount';

  @override
  String offeredBy(String buyerName) {
    return 'Offered by $buyerName';
  }

  @override
  String get acceptOffer => 'Accept Offer';

  @override
  String get rejectOffer => 'Reject Offer';

  @override
  String get offerAccepted => 'Offer accepted';

  @override
  String get offerRejected => 'Offer Rejected';

  @override
  String get buyerDashboardTitle => 'Marketplace';

  @override
  String get searchAuctionsHint => 'Search solar panels, inverters, scrap...';

  @override
  String get allCategories => 'All Categories';

  @override
  String get liveAuctions => 'Live Auctions';

  @override
  String get endingSoon => 'Ending Soon';

  @override
  String get highestBids => 'Highest Bids';

  @override
  String get savedAuctions => 'Saved Auctions';

  @override
  String get myBids => 'My Bids';

  @override
  String get noAuctionsFound => 'No auctions found';

  @override
  String get noSavedAuctions => 'No saved auctions yet';

  @override
  String get noBidsYet => 'You haven\'t placed any bids yet';

  @override
  String get auctionDetailsTitle => 'Auction Details';

  @override
  String get currentBid => 'Current Bid';

  @override
  String get startingBid => 'Starting Bid';

  @override
  String get minimumIncrement => 'Minimum Increment';

  @override
  String get timeLeft => 'Time Left';

  @override
  String get auctionEnds => 'Ends on';

  @override
  String get sellerInfo => 'Seller Information';

  @override
  String get location => 'Location';

  @override
  String get specifications => 'Specifications';

  @override
  String get bidHistory => 'Bid History';

  @override
  String get placeBid => 'Place Bid';

  @override
  String get enterBidAmount => 'Enter Bid Amount';

  @override
  String bidMustBeHigher(String amount) {
    return 'Bid must be at least $amount';
  }

  @override
  String get confirmBidTitle => 'Confirm Your Bid';

  @override
  String confirmBidPrompt(String amount) {
    return 'Are you sure you want to place a bid of $amount?';
  }

  @override
  String bidPlacedSuccess(String amount) {
    return 'Your bid of $amount has been placed successfully!';
  }

  @override
  String get youAreHighestBidder => 'You are currently the highest bidder!';

  @override
  String get youHaveBeenOutbid => 'You have been outbid on this listing.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get accountSection => 'Account';

  @override
  String get securitySection => 'Security';

  @override
  String get supportSection => 'Support & About';

  @override
  String get languageLabel => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageEnglish => 'English (Default)';

  @override
  String get languageUrdu => 'اردو (Urdu)';

  @override
  String languageChanged(String lang) {
    return 'Language changed to $lang';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get listingUpdates => 'Listing Updates';

  @override
  String get priceOffersNotification => 'Price Offers & Bids';

  @override
  String get productUpdates => 'Product Updates';

  @override
  String get newAuctions => 'New Auctions';

  @override
  String get bidUpdates => 'Bid Updates';

  @override
  String get closingSoonAlerts => 'Closing Soon Alerts';

  @override
  String get winningNotifications => 'Winning Notifications';

  @override
  String get twoFA => 'Two-Factor Authentication (2FA)';

  @override
  String get twoFADesc => 'Add an extra layer of security to your account';

  @override
  String get verified => 'Verified';

  @override
  String get unverified => 'Unverified';

  @override
  String get verifyNow => 'Verify Now';

  @override
  String get changePassword => 'Change Password';

  @override
  String get currentPasswordLabel => 'Current Password';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirm =>
      'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get faq => 'Frequently Asked Questions';

  @override
  String get aboutUs => 'About Solar Scrap';

  @override
  String get version => 'Solar Scrap v1.0.0';

  @override
  String get copyright => '© 2026 Solar Scrap Platform. All rights reserved.';

  @override
  String get sellerSignUp => 'Seller Sign Up';

  @override
  String get sellerQuestion => 'Seller?';

  @override
  String get buyerQuestion => 'Buyer?';

  @override
  String get step1Of3Credentials => 'Step 1 of 3 · Credentials';

  @override
  String get orContinueWithEmail => 'OR Continue with Email';

  @override
  String get emailAddressRequired => 'Email Address *';

  @override
  String get passwordRequired => 'Password *';

  @override
  String get confirmPasswordRequired => 'Confirm Password *';

  @override
  String get createSecurePasswordHint => 'Create a secure password';

  @override
  String get pwdRuleMinLength => 'At least 8 characters';

  @override
  String get pwdRuleUpperLower => 'Uppercase and lowercase letters';

  @override
  String get pwdRuleNumberSymbol => 'At least one number or symbol';

  @override
  String get pwdRuleMatch => 'Passwords match';

  @override
  String get agreeToThe => 'I agree to the ';

  @override
  String get andAcknowledgeThe => ' and acknowledge the ';

  @override
  String get buyerNotificationCheckbox =>
      'Receive notifications about new scrap auctions and market prices (Optional)';

  @override
  String get sellerNotificationCheckbox =>
      'Receive notifications about quotations and offers on your solar listings (Optional)';

  @override
  String get continueToDetails => 'Continue to Details';

  @override
  String get verifyYourEmail => 'Verify Your Email';

  @override
  String get weSentVerificationLinkTo => 'We sent a verification link to\n';

  @override
  String get tapLinkToVerify =>
      '.\nPlease tap the link in your inbox to verify your address.';

  @override
  String get iHaveVerifiedLink => 'I Have Verified Link';

  @override
  String get emailNotVerifiedYet =>
      'Email not verified yet. Please check your inbox or spam.';

  @override
  String get resendLink => 'Resend Link';

  @override
  String get skipDevMode => 'Skip (Dev Mode)';

  @override
  String get verificationLinkResent => 'Verification link re-sent!';

  @override
  String get passwordRequirementsError =>
      'Please meet all password security requirements.';

  @override
  String get passwordsDoNotMatch => 'New passwords do not match';

  @override
  String get acceptTermsError =>
      'Please accept the Terms & Conditions and Privacy Policy.';

  @override
  String get enterValidEmail => 'Please enter a valid email address.';

  @override
  String get enterEmail => 'Please enter your email address.';

  @override
  String get businessAndLocation => 'Business & Location';

  @override
  String get step2Of3BusinessDetails => 'Step 2 of 3 · Business Details';

  @override
  String get uploadProfileLogo => 'Upload Profile / Logo (Optional)';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get contactPersonRequired => 'Contact Person / Full Name *';

  @override
  String get companyYardNameRequired => 'Company / Yard Name *';

  @override
  String get businessTypeRequired => 'Business Type *';

  @override
  String get selectBusinessType => 'Select business type';

  @override
  String get businessTypeScrapDealer => 'Scrap Dealer';

  @override
  String get businessTypeRecycler => 'Recycler';

  @override
  String get businessTypeTraderBroker => 'Trader / Broker';

  @override
  String get businessTypeSolarEpc => 'Solar EPC Contractor';

  @override
  String get businessTypeManufacturer => 'Manufacturer';

  @override
  String get businessTypeOtherBusiness => 'Other Business';

  @override
  String get businessTypeSolarPlantOwner => 'Solar Plant Owner';

  @override
  String get businessTypeCommercialIndustrial =>
      'Commercial / Industrial Facility';

  @override
  String get businessTypeResidentHomeowner => 'Resident / Homeowner';

  @override
  String get businessTypeOtherFacility => 'Other Facility';

  @override
  String get businessTypeEpcContractor => 'EPC Contractor';

  @override
  String get businessTypeScrapDealerBroker => 'Scrap Dealer / Broker';

  @override
  String get gstNtnOptional => 'GST / NTN Number (Optional)';

  @override
  String get businessLocationRequired => 'Business / Warehouse Location *';

  @override
  String get pinOnMap => 'Pin on Map';

  @override
  String get streetAddressRequired => 'Street Address *';

  @override
  String get cityRequired => 'City *';

  @override
  String get areaDistrictLabel => 'Area / District';

  @override
  String get continueToMobileVerification => 'Continue to Mobile Verification';

  @override
  String get enterNameError => 'Enter your name';

  @override
  String get enterCompanyNameError => 'Enter your company or business name';

  @override
  String get enterStreetAddressError => 'Please enter street address';

  @override
  String get enterCityError => 'Enter city';

  @override
  String get mobileVerification => 'Mobile Verification';

  @override
  String get step3Of3MobileVerification =>
      'Step 3 of 3 · Mobile Verification (2FA)';

  @override
  String get verifyMobileNumber => 'Verify Mobile Number';

  @override
  String get protectAccount2FADesc =>
      'Protect your scrap trades and account with two-factor mobile authentication (2FA).';

  @override
  String get mobileNumberLabel => 'Mobile Number';

  @override
  String get sendCode => 'Send Code';

  @override
  String get resend => 'Resend';

  @override
  String get enter6DigitCode => 'Enter 6-Digit Code';

  @override
  String get didntGetCode => 'Didn\'t get the code?';

  @override
  String get resendNow => 'Resend Now';

  @override
  String get verifyAndCompleteRegistration => 'Verify & Complete Registration';

  @override
  String get enterValidMobileNumber => 'Please enter a valid mobile number.';

  @override
  String get enterCompleteOtpCode =>
      'Please enter the complete 6-digit OTP code.';

  @override
  String get invalidOtpCode =>
      'Invalid code. Please enter the correct code or 000000.';

  @override
  String get registrationFailed => 'Registration failed. Try again.';

  @override
  String codeSentTo(String phone) {
    return 'Verification code sent to $phone';
  }

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get enterEmailOrPhoneReset =>
      'Enter your email or phone to receive a reset OTP';

  @override
  String get emailOrPhoneLabel => 'Email or Phone';

  @override
  String get emailOrPhoneHint => 'name@example.com or 0300 1234567';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get passwordResetTitle => 'Password Reset!';

  @override
  String get passwordResetSuccessDesc =>
      'Your password has been updated successfully.';

  @override
  String get accountUnderReview => 'Account Under Review';

  @override
  String get accountApproved => 'Account Approved!';

  @override
  String get goToDashboard => 'Go to Dashboard';

  @override
  String get checkStatus => 'Check Status';

  @override
  String get pleaseEnterEmailOrPhone => 'Please enter your email or phone';

  @override
  String get verifyOtpTitle => 'Verify OTP';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String enterOtpSentToPhone(String phone) {
    return 'Enter the 6-digit code sent to your mobile number\nending in $phone';
  }

  @override
  String resendInSeconds(String seconds) {
    return 'Resend in 00:$seconds';
  }

  @override
  String get verifyAccount => 'Verify Account';

  @override
  String get pleaseEnterAll6Digits => 'Please enter all 6 digits';

  @override
  String get didntReceiveCodeCheckSpam =>
      'Didn\'t receive the code? Check your spam folder or try resending.';

  @override
  String get accountVerifiedSuccess =>
      '🎉 Account Verified! Admin has approved your account.';

  @override
  String get accountVerifiedBuyerSuccess =>
      '🎉 Account Verified! Admin has approved your buyer account.';

  @override
  String get statusPendingApprovalDesc =>
      'Status: Pending Admin Approval. Please approve from the web portal.';

  @override
  String get buyerAccountApprovedTitle => 'Buyer Account Approved!';

  @override
  String get sellerAccountApprovedTitle => 'Account Approved & Active!';

  @override
  String get accountRequestSubmittedTitle => 'Account Request Submitted';

  @override
  String get buyerApprovedDesc =>
      'Your dealer registration has been verified and approved by the admin team. You can now browse auctions and place bids.';

  @override
  String get sellerApprovedDesc =>
      'Your seller profile has been verified and approved by the Solar Scrap Admin team. You now have full access to create listings and manage sales.';

  @override
  String get accountPendingReviewDesc =>
      'Your registration request has been submitted for admin review. Once verified and approved by the admin team, your account will unlock automatically.';

  @override
  String get statusApprovedVerified => 'Status: Approved & Verified';

  @override
  String get statusPendingAdminApproval => 'Status: Pending Admin Approval';

  @override
  String verifiedBuyerAccountAt(String location) {
    return 'Verified Buyer Account · $location';
  }

  @override
  String pendingVerificationAt(String location) {
    return 'Pending Verification · $location';
  }

  @override
  String verifiedSellerAccountAt(String location) {
    return 'Verified Seller Account · $location';
  }

  @override
  String get checkApprovalStatus => 'Check Approval Status';

  @override
  String get monitoringAdminApprovalDesc =>
      'App is actively monitoring for admin approval. Once approved on the web portal, access unlocks automatically.';

  @override
  String get switchAccountReturnSignIn => 'Switch Account / Return to Sign In';

  @override
  String get createFirstListing => 'Create First Listing';

  @override
  String get homeTab => 'Home';

  @override
  String get auctionsTab => 'Auctions';

  @override
  String get myBidsTab => 'My Bids';

  @override
  String get profileTab => 'Profile';

  @override
  String get listingTab => 'Listing';

  @override
  String get alertsTab => 'Alerts';

  @override
  String get goodMorning => 'Good morning,';

  @override
  String get searchAuctionsEquipmentHint => 'Search auctions, equipment...';

  @override
  String get searchBidsHint => 'Search bids';

  @override
  String get searchListingsHint => 'Search listings...';

  @override
  String get activeBids => 'Active Bids';

  @override
  String get wonAuctions => 'Won Auctions';

  @override
  String get totalBids => 'Total Bids';

  @override
  String get latestAuctions => 'Latest Auctions';

  @override
  String get seeAll => 'See All';

  @override
  String get featuredAuction => 'Featured Auction';

  @override
  String get exploreAuctions => 'Explore Auctions';

  @override
  String get viewAuction => 'View Auction';

  @override
  String get bidNow => 'Bid Now';

  @override
  String get priceDemand => 'Price Demand';

  @override
  String get verifiedBuyer => 'Verified Buyer';

  @override
  String get verifiedSeller => 'Verified Seller';

  @override
  String get scrapDealerBuyer => 'Scrap Dealer / Buyer';

  @override
  String get solarEquipmentSeller => 'Solar Equipment Seller';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get readyToSell => 'Ready to Sell?';

  @override
  String get readyToSellDesc =>
      'Post your solar scrap and get competitive offers';

  @override
  String get sellSolarScrap => 'Sell Solar Scrap';

  @override
  String get totalListings => 'Total Listings';

  @override
  String get alertsAndNotifications => 'Alerts & Notifications';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get noActiveAuctionsFound =>
      'No active auctions found in this category';

  @override
  String noBidsFoundUnderStatus(String status) {
    return 'No bids found under $status';
  }

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterWinning => 'Winning';

  @override
  String get filterClosed => 'Closed';

  @override
  String get filterOutbid => 'Outbid';

  @override
  String get filterSold => 'Sold';

  @override
  String get filterDraft => 'Draft';

  @override
  String get marketplaceHeroTag => 'SolarScrap Marketplace';

  @override
  String get verifiedAuctionsTitle => 'Verified Solar Scrap Auctions';

  @override
  String get exploreAuctionsSubtitle =>
      'Explore solar panels, inverters & batteries across Pakistan.';

  @override
  String get noMatchingAuctionsFound =>
      'No matching auctions found on marketplace';

  @override
  String get refresh => 'Refresh';

  @override
  String get filterLatest => 'Latest';

  @override
  String get filterLowestPrice => 'Lowest Price';

  @override
  String get filterHighestPrice => 'Highest Price';

  @override
  String get categoryTransformers => 'Transformers';

  @override
  String get notProvided => 'Not provided';

  @override
  String get notSet => 'Not set';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirmation =>
      'Are you sure you want to sign out of your account?';

  @override
  String get recentListings => 'Recent Listings';

  @override
  String get noListingsYet => 'No listings yet';

  @override
  String get tapSellSolarScrapToAdd =>
      'Tap \"Sell Solar Scrap\" above to add your first listing!';

  @override
  String get filterSubmitted => 'Submitted';

  @override
  String get filterUnderReview => 'Under Review';

  @override
  String get filterPriceOffered => 'Price Offered';

  @override
  String get askingPrice => 'Asking price';

  @override
  String get noMatchingListings => 'No matching listings';

  @override
  String get noListingsCreatedYet => 'No listings created yet';

  @override
  String get tryChangingSearchFilter =>
      'Try changing the search keyword or filter';

  @override
  String get tapPlusToCreateListing =>
      'Tap the + button below to create your first listing';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get listingsTitle => 'Listings';

  @override
  String get dealsTitle => 'Deals';

  @override
  String get earningsTitle => 'Earnings';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get companyInformation => 'Company Information';

  @override
  String get companyLabel => 'Company';

  @override
  String get gstLabel => 'GST';

  @override
  String get typeLabel => 'Type';

  @override
  String get buyerRoleFallback => 'Buyer';

  @override
  String get sellerRoleFallback => 'Seller';

  @override
  String get statusWon => 'Won';

  @override
  String get statusLost => 'Lost';

  @override
  String get statusPending => 'Pending';

  @override
  String get newListingTitle => 'New Listing';

  @override
  String get equipmentCategory => 'Equipment Category';

  @override
  String get whatTypeOfEquipment => 'What type of equipment are you selling?';

  @override
  String get completeSolarSystem => 'Complete Solar System';

  @override
  String stepXOfY(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get uploadImages => 'Upload Images';

  @override
  String get addUpTo10Photos => 'Add up to 10 photos';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String listingDetailsStepImages(int current, int total) {
    return 'Listing Details · Step $current of $total (Images)';
  }

  @override
  String failedToPickImage(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String get imageUploadFailed =>
      'Image upload failed. Please check your connection and try again.';

  @override
  String listingDetailsStepLocation(int current, int total) {
    return 'Listing Details · Step $current of $total (Location)';
  }

  @override
  String get areaLocalityOptional => 'Area / Locality (optional)';

  @override
  String get areaHint => 'DHA Phase 7, Karachi';

  @override
  String get completeAddress => 'Complete Address';

  @override
  String get completeAddressHint => 'Street, building, area details...';

  @override
  String listingDetailsStepContact(int current, int total) {
    return 'Listing Details · Step $current of $total (Contact)';
  }

  @override
  String get prefilledFromProfile =>
      'Pre-filled from your profile. Edit if needed.';

  @override
  String get listingPreviewTitle => 'Listing Preview';

  @override
  String listingDetailsStepPreview(int current, int total) {
    return 'Listing Details · Step $current of $total (Preview)';
  }

  @override
  String get previewBadge => 'Preview';

  @override
  String imagesCountLabel(int count) {
    return 'Images ($count)';
  }

  @override
  String get noPhotosUploaded => 'No photos uploaded';

  @override
  String get locationAndContact => 'Location & Contact';

  @override
  String get startOver => 'Start Over';

  @override
  String get editButton => 'Edit';

  @override
  String get failedToSubmitListing =>
      'Failed to submit listing. Please try again.';

  @override
  String get numberOfPanels => 'Number of Panels';

  @override
  String get wattsPerPanel => 'Watts per Panel';

  @override
  String get wattsPerPanelUnit => 'Watts per Panel (W)';

  @override
  String get capacity => 'Capacity';

  @override
  String get brand => 'Brand';

  @override
  String get brandHint => 'Enter Brand name';

  @override
  String get ratedPower => 'Rated Power';

  @override
  String get cableType => 'Cable Type';

  @override
  String get conductor => 'Conductor';

  @override
  String get insulation => 'Insulation';

  @override
  String get cableSize => 'Cable Size';

  @override
  String get structureType => 'Structure Type';

  @override
  String get metal => 'Metal';

  @override
  String get panels => 'Panels';

  @override
  String get inverter => 'Inverter';

  @override
  String get structure => 'Structure';

  @override
  String get listingSubmittedReviewTitle => 'Listing Submitted for Review';

  @override
  String get listingSubmittedReviewDesc =>
      'Your listing has been submitted for admin approval. It will go live on the marketplace once accepted.';

  @override
  String get listingIdLabel => 'Listing ID';

  @override
  String get pendingApproval => 'Pending Approval';

  @override
  String get listingDetailsTitle => 'Listing Details';

  @override
  String get equipmentDetailsTitle => 'Equipment Details';

  @override
  String get pickupCity => 'Pickup City';

  @override
  String get pickupArea => 'Pickup Area';

  @override
  String get contactPerson => 'Contact Person';

  @override
  String get trackStatus => 'Track Status';

  @override
  String get lakhUnit => 'Lakh';

  @override
  String get currentlyLabel => 'Currently: ';

  @override
  String get bidsReceived => 'Bids Received';

  @override
  String totalBadge(int count) {
    return '$count Total';
  }

  @override
  String get noBidsPlacedYet => 'No bids placed yet';

  @override
  String get bidsWillAppearRealtime =>
      'Bids from buyers will appear here in real-time.';

  @override
  String get reviewOffer => 'Review Offer';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusDeclined => 'Declined';

  @override
  String get statusPendingOffer => 'Pending Offer';

  @override
  String get activeOnMarket => 'Active on Market';

  @override
  String get negotiationReview => 'Negotiation / Review';

  @override
  String get dealClosed => 'Deal Closed';

  @override
  String get acceptingBidsFromBuyers => 'Accepting bids from buyers';

  @override
  String get awaitingBuyerBids => 'Awaiting buyer bids';

  @override
  String get actionRequired => 'Action Required';

  @override
  String get pendingAgreement => 'Pending agreement';

  @override
  String bidsReceivedCount(int count) {
    return '$count bid(s) received';
  }

  @override
  String reviewingOffersCount(int count) {
    return 'Reviewing $count offer(s)';
  }

  @override
  String get awaitingBuyerOffers => 'Awaiting buyer offers';

  @override
  String get panelCondition => 'Panel Condition';

  @override
  String get conditionScrap => 'Scrap';

  @override
  String get conditionBulletHit => 'Bullet Hit';

  @override
  String get conditionShatterGlass => 'Shatter Glass';

  @override
  String get conditionGood => 'Good Condition';

  @override
  String get conditionOther => 'Other';

  @override
  String get conditionWorking => 'Working';

  @override
  String get conditionNonWorking => 'Non working';

  @override
  String get inverterTypeHybrid => 'Hybrid';

  @override
  String get inverterTypeOnGrid => 'On Grid';

  @override
  String get batteryTypeLithium => 'Lithium';

  @override
  String get cableTypeAC => 'AC';

  @override
  String get cableTypeDC => 'DC';

  @override
  String get insulationPVC => 'PVC';

  @override
  String get insulationXLPE => 'XLPE';

  @override
  String get structureElevated => 'Elevated';

  @override
  String get structureRooftop => 'Rooftop';

  @override
  String get structureGround => 'Ground Mounted';

  @override
  String get metalGI => 'GI';

  @override
  String get completeSystemPanelsTitle => 'Complete System: Panels';

  @override
  String get completeSystemInvertersTitle => 'Complete System: Inverter';

  @override
  String get completeSystemBatteriesTitle => 'Complete System: Batteries';

  @override
  String get completeSystemStructureTitle => 'Complete System: Structure';

  @override
  String get completeSystemCablesTitle => 'Complete System: Cables';

  @override
  String get completeSystemBannerPanels => 'Complete System · Solar Panels';

  @override
  String get completeSystemBannerInverter => 'Complete System · Inverter';

  @override
  String get completeSystemBannerBatteries => 'Complete System · Batteries';

  @override
  String get completeSystemBannerStructure => 'Complete System · Structure';

  @override
  String get completeSystemBannerCables => 'Complete System · Cables';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get noPhone => 'No phone';

  @override
  String get statusLabel => 'Status';

  @override
  String get addressLabel => 'Address';

  @override
  String stepXOfYWithDetail(int current, int total, String detail) {
    return 'Step $current of $total ($detail)';
  }

  @override
  String get batteryTypeLeadAcid => 'Lead Acid';

  @override
  String get batteryTypeTabular => 'Tabular';

  @override
  String get numberOfBatteries => 'Number of Batteries';

  @override
  String get batteryCountHint => 'Enter Battery count';

  @override
  String get batteryCapacityKw => 'Battery Capacity (kW)';

  @override
  String get batteryCapacityAmp => 'Battery Capacity (Amp)';

  @override
  String get manufacturerBrand => 'Manufacturer / Brand';

  @override
  String get purchaseYear => 'Purchase Year';

  @override
  String get noOfYearUsed => 'No. of year used';

  @override
  String get batteryConditions => 'Battery Conditions';

  @override
  String get conductorCopper => 'Copper';

  @override
  String get conductorAL => 'AL';

  @override
  String get insulationRubber => 'Rubber';

  @override
  String get insulationThermoplastic => 'Thermoplastic';

  @override
  String get commentsOptional => 'Comments (optional)';

  @override
  String get commentsHint => 'Describe in details ......';

  @override
  String get structureNonElevated => 'Non Elevated';

  @override
  String get structureMetal => 'Structure Metal';

  @override
  String get metalAL => 'AL';

  @override
  String get metalGL => 'GL';

  @override
  String get metalHotDip => 'Hot dip';

  @override
  String get othersComponentsTitle => 'Others Components';

  @override
  String get totalPriceDemand => 'Total Price Demand';

  @override
  String get stepFinalDetails => 'Final Details';

  @override
  String get stepDetailPanels => 'Panels';

  @override
  String get stepDetailInverters => 'Inverters';

  @override
  String get stepDetailBatteries => 'Batteries';

  @override
  String get stepDetailCables => 'Cables';

  @override
  String get stepDetailStructure => 'Structure';

  @override
  String get structureDetails => 'Structure Details';

  @override
  String get othersCommentsHint =>
      'e.g communications devices, switch gears ...';

  @override
  String get cableSizeHint => 'e.g 12 meter';

  @override
  String get batteryYearsUsedHint => 'e.g. 1 year';

  @override
  String get purchaseYearHint => 'e.g. 2019';

  @override
  String get batteryCapacityKwHint => 'e.g 5 kw';

  @override
  String get batteryCapacityAmpHint => 'e.g 200 amp';

  @override
  String get cableConductor => 'Cable Conductor';

  @override
  String get insulationType => 'Insulation Type';

  @override
  String get detailsTab => 'Details';

  @override
  String get specsTab => 'Specs';

  @override
  String get timelineTab => 'Timeline';

  @override
  String get sellerContactDetailsTitle => 'SELLER DETAILS';

  @override
  String get placeYourBid => 'Place Your Bid';

  @override
  String get startingPrice => 'Starting Price';

  @override
  String get currentHighestBid => 'Current Highest Bid';

  @override
  String get minimumBid => 'Minimum Bid';

  @override
  String get yourBidAmountPkr => 'Your Bid Amount (PKR)';

  @override
  String get reviewBidBeforeSubmitting =>
      'Please review your bid before submitting.';

  @override
  String get yourBid => 'Your Bid';

  @override
  String get submitBid => 'Submit Bid';

  @override
  String get failedToPlaceBid => 'Failed to place bid. Please try again.';

  @override
  String get bidSubmittedTitle => 'Bid Submitted!';

  @override
  String get bidSubmittedSubtitle =>
      'Your bid is now live. You\'ll be notified if you win.';

  @override
  String get goToMyBids => 'Go To My Bids';

  @override
  String get bidDetails => 'Bid Details';

  @override
  String get myBidAmount => 'My Bid Amount';

  @override
  String get bidDate => 'Bid Date';

  @override
  String get currentHighest => 'Current Highest';

  @override
  String get equipmentSpecifications => 'Equipment Specifications';

  @override
  String get sellerContactInformation => 'Seller Information';

  @override
  String get viewFullAuctionListing => 'View Full Auction Listing';

  @override
  String get bidAcceptedBannerTitle => 'Your Bid Was Accepted!';

  @override
  String get bidAcceptedBannerDesc =>
      'The seller accepted your offer. They will coordinate payment and equipment pickup.';

  @override
  String get searchSavedAuctionsHint => 'Search saved auctions...';

  @override
  String get tapHeartToSaveAuctions =>
      'Tap the heart icon on any auction to save it for quick access.';

  @override
  String placeBidOnAuction(String title) {
    return 'Place Bid on $title';
  }

  @override
  String currentDemand(String price) {
    return 'Current Demand: $price';
  }

  @override
  String minimumBidIs(String amount) {
    return 'Minimum bid is $amount';
  }

  @override
  String get auctionLabel => 'Auction';

  @override
  String get referenceNumber => 'Reference Number';

  @override
  String auctionIdPrefix(String id) {
    return 'Auction ID: $id';
  }

  @override
  String get bidWinningBannerTitle => 'You\'re currently winning!';

  @override
  String get bidWinningBannerDesc =>
      'Your bid is currently the highest. You will be notified when the auction closes.';

  @override
  String get bidActiveBannerTitle => 'Bid Submitted & Active';

  @override
  String get bidActiveBannerDesc =>
      'Your offer has been sent to the seller. You will be notified when they review or accept.';

  @override
  String get bidOutbidBannerTitle => 'You Have Been Outbid';

  @override
  String get bidOutbidBannerDesc =>
      'Another buyer submitted a higher offer. Return to the auction to increase your bid.';

  @override
  String get timelineStepBidSubmitted => 'Bid Submitted';

  @override
  String get timelineStepUnderSellerReview => 'Under Seller Review';

  @override
  String get timelineStepBidAccepted => 'Bid Accepted by Seller';

  @override
  String get timelineStepDealFinalized => 'Deal Finalized';

  @override
  String get timelineStepAuctionRunning => 'Auction Running';

  @override
  String get timelineStepOfferDeclined => 'Offer Declined / Closed';

  @override
  String get timelineStepAuctionClosed => 'Auction Closed';

  @override
  String get timelineStepHighestBidder => 'Highest Bidder';

  @override
  String get timelineStepSellerDecision => 'Seller Decision';

  @override
  String get loadingAuctionDetails => 'Loading full auction details...';

  @override
  String get featuredBadge => 'Featured';

  @override
  String get priceOfferTitle => 'Price Offer';

  @override
  String get acceptOfferPrompt => 'Accept this offer?';

  @override
  String acceptOfferDesc(String price, String title) {
    return 'You are accepting $price for $title. This action cannot be undone.';
  }

  @override
  String acceptOfferCloseDealDesc(String price, String title) {
    return 'You are accepting $price for $title. This action will close the deal.';
  }

  @override
  String get confirmAccept => 'Confirm Accept';

  @override
  String get offerAcceptedSuccess =>
      'Offer accepted successfully! Deal is closed.';

  @override
  String get failedToAcceptOffer => 'Failed to accept offer. Please try again.';

  @override
  String get rejectOfferPrompt => 'Reject this offer?';

  @override
  String rejectOfferDesc(String price) {
    return 'The buyer will be notified that their bid of $price was declined.';
  }

  @override
  String get confirmReject => 'Confirm Reject';

  @override
  String get offerRejectedSnackbar => 'Offer rejected.';

  @override
  String get failedToRejectOffer => 'Failed to reject offer.';

  @override
  String refPrefix(String ref) {
    return 'Ref: $ref';
  }

  @override
  String get offeredPriceLabel => 'Offered Price';

  @override
  String yourAskingPrefix(String price) {
    return 'Your asking: $price';
  }

  @override
  String bidDetailsSubtitle(String buyer, String date) {
    return 'Bid placed by $buyer on $date. Confirming accept will close this deal and notify the buyer immediately.';
  }

  @override
  String buyerOfferedDesc(String price) {
    return 'A buyer has offered $price for this equipment. Review the terms and select your decision below.';
  }

  @override
  String get changeProfilePhoto => 'Change Profile Photo';

  @override
  String get takePhotoCamera => 'Take Photo (Camera)';

  @override
  String get profilePhotoUpdated => 'Profile photo updated successfully!';

  @override
  String get failedToUploadPhoto =>
      'Failed to upload photo. Please check backend connection.';

  @override
  String errorSelectingImage(String error) {
    return 'Error selecting image: $error';
  }

  @override
  String get fullNameEmpty => 'Full Name cannot be empty';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully!';

  @override
  String get failedToUpdateProfile =>
      'Failed to update profile. Ensure backend is running.';

  @override
  String get tapPhotoToChange => 'Tap photo to change';

  @override
  String get fullNamePlaceholder => 'Your Full Name';

  @override
  String get companyNamePlaceholder => 'Company Name Pvt. Ltd.';

  @override
  String get emailAddressLabel => 'Email address';

  @override
  String get pleaseEnterFullName => 'Please enter your full name';

  @override
  String get areaStreetAddress => 'Area / Street Address';

  @override
  String get areaStreetHint => 'e.g. SITE Area, Gulberg';

  @override
  String get cityHintBuyer => 'e.g. Karachi, Lahore, Islamabad';

  @override
  String get phoneHintBuyer => 'e.g. +92 300 1234567';

  @override
  String get enterFullNameHint => 'Enter your full name';

  @override
  String couldNotPickPhoto(String error) {
    return 'Could not pick photo: $error';
  }

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get passwordDifferenceNotice =>
      'Your new password must be different from previously used passwords.';

  @override
  String get enterCurrentPassword => 'Enter current password';

  @override
  String get reenterNewPassword => 'Re-enter new password';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get enterCurrentPasswordPrompt => 'Please enter your current password';

  @override
  String get passwordMinLength =>
      'New password must be at least 6 characters long';

  @override
  String get failedToUpdatePassword =>
      'Failed to update password. Please check your current password.';

  @override
  String get markAllRead => 'Mark All Read';

  @override
  String get allNotificationsMarkedRead => 'All notifications marked as read';

  @override
  String get todaySection => 'Today';

  @override
  String get earlierSection => 'Earlier';

  @override
  String get noNotificationsDesc =>
      'We will notify you about your bids and new auctions.';

  @override
  String detailsComingSoon(String topic) {
    return '$topic details coming soon!';
  }

  @override
  String get onboardingSellerTitle1 => 'List Your Solar Scrap';

  @override
  String get onboardingSellerDesc1 =>
      'Sell solar panels, batteries, inverters,\ntransformers and more — reach thousands of\nverified buyers nationwide.';

  @override
  String get onboardingSellerTitle2 => 'Get Best Market Value';

  @override
  String get onboardingSellerDesc2 =>
      'Connect with verified buyers through a\ntransparent auction process. Every listing gets\ncompetitive offers.';

  @override
  String get onboardingSellerTitle3 => 'Get Instant Alerts';

  @override
  String get onboardingSellerDesc3 =>
      'When a room opens, you get a limited-time\nchance to claim it.';

  @override
  String get onboardingBuyerTitle1 => 'Buy Quality Solar Scrap';

  @override
  String get onboardingBuyerDesc1 =>
      'Buy quality solar scrap through a trusted\nmarketplace built for verified dealers.';

  @override
  String get onboardingBuyerTitle2 => 'Discover Live Auctions';

  @override
  String get onboardingBuyerDesc2 =>
      'Browse active auctions for solar panels,\nbatteries, inverters, transformers, and more.';

  @override
  String get onboardingBuyerTitle3 => 'Bid Smart, Win More';

  @override
  String get onboardingBuyerDesc3 =>
      'Place competitive bids, track your auctions, and\nsecure the best solar scrap deals.';

  @override
  String get helpTopicAccountLogin => 'Account & Login';

  @override
  String get helpTopicSellingScrap => 'Selling Solar Scrap';

  @override
  String get helpTopicPickupOrders => 'Pickup & Orders';

  @override
  String get helpTopicPrivacySecurity => 'Privacy & Security';

  @override
  String get helpTopicReportProblem => 'Report a Problem';

  @override
  String get helpTopicFaqs => 'FAQs';

  @override
  String get privacyPolicyLastUpdated => 'Last Updated: August 5, 2026';

  @override
  String get privacyPolicyInfoCollectTitle => 'Information We Collect';

  @override
  String get privacyPolicyInfoCollectDesc =>
      'We Collect Your Name, Email, Phone Number, Pickup Address, Company Details (If Applicable), And Order Information. We May Also Collect Device, Location, And Usage Data To Improve The App.';

  @override
  String get privacyPolicyHowUseTitle => 'How We Use Your Information';

  @override
  String get privacyPolicyHowUseDesc =>
      'Your Information Is Used To Create Your Account, Process Scrap Purchases, Schedule Pickups, Provide Customer Support, Send Important Notifications, And Improve Our Services.';

  @override
  String get privacyPolicyDataSharingTitle => 'Data Sharing';

  @override
  String get privacyPolicyDataSharingDesc =>
      'We Do Not Sell Your Personal Information. We Only Share Necessary Data With Trusted Service Providers Such As Payment Processors, Logistics Partners, And Authorities When Legally Required.';

  @override
  String get privacyPolicyLocationAccessTitle => 'Location Access';

  @override
  String get privacyPolicyLocationAccessDesc =>
      'With Your Permission, We Use Your Location To Schedule Pickups, Improve Collection Accuracy, And Provide Location-Based Services. You Can Disable Location Access Anytime In Your Device Settings.';

  @override
  String get faqsSection => 'FAQs';

  @override
  String get faq1Title => '1. How Do I Sell My Solar Scrap?';

  @override
  String get faq1Desc =>
      'Simply Create An Account, Add Your Scrap Details, Submit A Pickup Request, And Our Team Will Review And Arrange Collection.';

  @override
  String get faq2Title => '2. What Types Of Scrap Do You Accept?';

  @override
  String get faq2Desc =>
      'We Accept Various Types Of Solar-Related Scrap, Including Solar Panels, Inverters, Cables, Aluminum Frames, Batteries (Where Applicable), And Other Recyclable Components.';

  @override
  String get faq3Title => '3. How Will I Know The Value Of My Scrap?';

  @override
  String get faq3Desc =>
      'Our Team Evaluates Your Scrap Based On Its Type, Quantity, Condition, And Current Market Value Before Confirming The Purchase Price.';

  @override
  String get faq4Title => '4. How Do I Schedule A Pickup?';

  @override
  String get faq4Desc =>
      'After Submitting Your Scrap Details, You Can Choose A Preferred Pickup Location And Time. We\'ll Contact You To Confirm The Schedule.';

  @override
  String get faq5Title => '5. Is My Personal Information Secure?';

  @override
  String get faq5Desc =>
      'Yes. We Use Industry-Standard Security Measures To Protect Your Personal Information And Never Sell Your Data To Third Parties.';

  @override
  String get contactUsSection => 'Contact Us';
}
