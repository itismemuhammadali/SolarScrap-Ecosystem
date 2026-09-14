import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Solar Scrap'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'B2B Solar Scrap Recycling Marketplace'**
  String get tagline;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @selectRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Role'**
  String get selectRoleTitle;

  /// No description provided for @selectRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you looking to buy or sell solar scrap?'**
  String get selectRoleSubtitle;

  /// No description provided for @sellerRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'I Want to Sell'**
  String get sellerRoleTitle;

  /// No description provided for @sellerRoleDesc.
  ///
  /// In en, this message translates to:
  /// **'Post your solar equipment, panels, batteries & scrap for buyers to bid on.'**
  String get sellerRoleDesc;

  /// No description provided for @buyerRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'I Want to Buy'**
  String get buyerRoleTitle;

  /// No description provided for @buyerRoleDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse auctions, place bids and purchase solar scrap at competitive prices.'**
  String get buyerRoleDesc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your account'**
  String get signInToContinue;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @orSignInWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orSignInWith;

  /// No description provided for @googleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get googleSignIn;

  /// No description provided for @appleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get appleSignIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNameHint;

  /// No description provided for @companyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyNameLabel;

  /// No description provided for @companyNameHint.
  ///
  /// In en, this message translates to:
  /// **'ABC Solar Recyclers'**
  String get companyNameHint;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'0300 1234567'**
  String get phoneHint;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'Karachi'**
  String get cityHint;

  /// No description provided for @termsAgreement.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to our Terms of Service and Privacy Policy'**
  String get termsAgreement;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get otpVerificationTitle;

  /// No description provided for @otpVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit verification code to {contact}'**
  String otpVerificationSubtitle(String contact);

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendCodeIn(int seconds);

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didNotReceiveCode;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive password reset instructions'**
  String get resetPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get newPasswordHint;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccess;

  /// No description provided for @sellerDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Seller Dashboard'**
  String get sellerDashboardTitle;

  /// No description provided for @activeListings.
  ///
  /// In en, this message translates to:
  /// **'Active Listings'**
  String get activeListings;

  /// No description provided for @pendingOffers.
  ///
  /// In en, this message translates to:
  /// **'Pending Offers'**
  String get pendingOffers;

  /// No description provided for @completedDeals.
  ///
  /// In en, this message translates to:
  /// **'Completed Deals'**
  String get completedDeals;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @createNewListing.
  ///
  /// In en, this message translates to:
  /// **'Create New Listing'**
  String get createNewListing;

  /// No description provided for @myListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get myListings;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @categoryPanels.
  ///
  /// In en, this message translates to:
  /// **'Solar Panels'**
  String get categoryPanels;

  /// No description provided for @categoryInverters.
  ///
  /// In en, this message translates to:
  /// **'Inverters'**
  String get categoryInverters;

  /// No description provided for @categoryBatteries.
  ///
  /// In en, this message translates to:
  /// **'Batteries'**
  String get categoryBatteries;

  /// No description provided for @categoryCables.
  ///
  /// In en, this message translates to:
  /// **'Cables & Wiring'**
  String get categoryCables;

  /// No description provided for @categoryStructure.
  ///
  /// In en, this message translates to:
  /// **'Mounting Structure'**
  String get categoryStructure;

  /// No description provided for @categoryOthers.
  ///
  /// In en, this message translates to:
  /// **'Other Equipment'**
  String get categoryOthers;

  /// No description provided for @listingTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Listing Title'**
  String get listingTitleLabel;

  /// No description provided for @listingTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500W Monocrystalline Panels (Lot of 50)'**
  String get listingTitleHint;

  /// No description provided for @listingCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get listingCategoryLabel;

  /// No description provided for @listingConditionLabel.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get listingConditionLabel;

  /// No description provided for @listingQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get listingQuantityLabel;

  /// No description provided for @listingWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Weight (kg)'**
  String get listingWeightLabel;

  /// No description provided for @listingDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get listingDescriptionLabel;

  /// No description provided for @listingDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the scrap, damages, wear and tear, history...'**
  String get listingDescriptionHint;

  /// No description provided for @uploadPhotos.
  ///
  /// In en, this message translates to:
  /// **'Upload Photos'**
  String get uploadPhotos;

  /// No description provided for @uploadPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Add clear photos of the items, labels, and damage areas'**
  String get uploadPhotosHint;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @previewListing.
  ///
  /// In en, this message translates to:
  /// **'Preview Listing'**
  String get previewListing;

  /// No description provided for @submitListing.
  ///
  /// In en, this message translates to:
  /// **'Submit Listing'**
  String get submitListing;

  /// No description provided for @listingSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Listing Submitted!'**
  String get listingSubmittedTitle;

  /// No description provided for @listingSubmittedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your listing is being reviewed and will be live shortly.'**
  String get listingSubmittedDesc;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get backToDashboard;

  /// No description provided for @equipmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Equipment Details'**
  String get equipmentDetails;

  /// No description provided for @panelType.
  ///
  /// In en, this message translates to:
  /// **'Panel Type'**
  String get panelType;

  /// No description provided for @monocrystalline.
  ///
  /// In en, this message translates to:
  /// **'Monocrystalline'**
  String get monocrystalline;

  /// No description provided for @polycrystalline.
  ///
  /// In en, this message translates to:
  /// **'Polycrystalline'**
  String get polycrystalline;

  /// No description provided for @thinFilm.
  ///
  /// In en, this message translates to:
  /// **'Thin Film'**
  String get thinFilm;

  /// No description provided for @wattagePerPanel.
  ///
  /// In en, this message translates to:
  /// **'Wattage per Panel (W)'**
  String get wattagePerPanel;

  /// No description provided for @inverterType.
  ///
  /// In en, this message translates to:
  /// **'Inverter Type'**
  String get inverterType;

  /// No description provided for @stringInverter.
  ///
  /// In en, this message translates to:
  /// **'String Inverter'**
  String get stringInverter;

  /// No description provided for @centralInverter.
  ///
  /// In en, this message translates to:
  /// **'Central Inverter'**
  String get centralInverter;

  /// No description provided for @microInverter.
  ///
  /// In en, this message translates to:
  /// **'Micro Inverter'**
  String get microInverter;

  /// No description provided for @capacityKva.
  ///
  /// In en, this message translates to:
  /// **'Capacity (kVA / kW)'**
  String get capacityKva;

  /// No description provided for @batteryType.
  ///
  /// In en, this message translates to:
  /// **'Battery Type'**
  String get batteryType;

  /// No description provided for @lithiumIon.
  ///
  /// In en, this message translates to:
  /// **'Lithium-Ion'**
  String get lithiumIon;

  /// No description provided for @leadAcid.
  ///
  /// In en, this message translates to:
  /// **'Lead Acid'**
  String get leadAcid;

  /// No description provided for @tubular.
  ///
  /// In en, this message translates to:
  /// **'Tubular'**
  String get tubular;

  /// No description provided for @cableMetal.
  ///
  /// In en, this message translates to:
  /// **'Cable Metal'**
  String get cableMetal;

  /// No description provided for @copper.
  ///
  /// In en, this message translates to:
  /// **'Copper'**
  String get copper;

  /// No description provided for @aluminum.
  ///
  /// In en, this message translates to:
  /// **'Aluminum'**
  String get aluminum;

  /// No description provided for @pickupLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocationTitle;

  /// No description provided for @pickupAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address / Warehouse Location'**
  String get pickupAddressLabel;

  /// No description provided for @pickupCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get pickupCityLabel;

  /// No description provided for @pickupDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Pickup Date'**
  String get pickupDateLabel;

  /// No description provided for @contactPersonLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPersonLabel;

  /// No description provided for @contactPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone'**
  String get contactPhoneLabel;

  /// No description provided for @statusTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Status Tracking'**
  String get statusTrackingTitle;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get statusUnderReview;

  /// No description provided for @statusPublished.
  ///
  /// In en, this message translates to:
  /// **'Published / Live'**
  String get statusPublished;

  /// No description provided for @statusOffersReceived.
  ///
  /// In en, this message translates to:
  /// **'Offers Received'**
  String get statusOffersReceived;

  /// No description provided for @statusPickupScheduled.
  ///
  /// In en, this message translates to:
  /// **'Pickup Scheduled'**
  String get statusPickupScheduled;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @priceOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'Price Offers'**
  String get priceOffersTitle;

  /// No description provided for @offerAmount.
  ///
  /// In en, this message translates to:
  /// **'Offered Amount'**
  String get offerAmount;

  /// No description provided for @offeredBy.
  ///
  /// In en, this message translates to:
  /// **'Offered by {buyerName}'**
  String offeredBy(String buyerName);

  /// No description provided for @acceptOffer.
  ///
  /// In en, this message translates to:
  /// **'Accept Offer'**
  String get acceptOffer;

  /// No description provided for @rejectOffer.
  ///
  /// In en, this message translates to:
  /// **'Reject Offer'**
  String get rejectOffer;

  /// No description provided for @offerAccepted.
  ///
  /// In en, this message translates to:
  /// **'Offer accepted'**
  String get offerAccepted;

  /// No description provided for @offerRejected.
  ///
  /// In en, this message translates to:
  /// **'Offer Rejected'**
  String get offerRejected;

  /// No description provided for @buyerDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get buyerDashboardTitle;

  /// No description provided for @searchAuctionsHint.
  ///
  /// In en, this message translates to:
  /// **'Search solar panels, inverters, scrap...'**
  String get searchAuctionsHint;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @liveAuctions.
  ///
  /// In en, this message translates to:
  /// **'Live Auctions'**
  String get liveAuctions;

  /// No description provided for @endingSoon.
  ///
  /// In en, this message translates to:
  /// **'Ending Soon'**
  String get endingSoon;

  /// No description provided for @highestBids.
  ///
  /// In en, this message translates to:
  /// **'Highest Bids'**
  String get highestBids;

  /// No description provided for @savedAuctions.
  ///
  /// In en, this message translates to:
  /// **'Saved Auctions'**
  String get savedAuctions;

  /// No description provided for @myBids.
  ///
  /// In en, this message translates to:
  /// **'My Bids'**
  String get myBids;

  /// No description provided for @noAuctionsFound.
  ///
  /// In en, this message translates to:
  /// **'No auctions found'**
  String get noAuctionsFound;

  /// No description provided for @noSavedAuctions.
  ///
  /// In en, this message translates to:
  /// **'No saved auctions yet'**
  String get noSavedAuctions;

  /// No description provided for @noBidsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t placed any bids yet'**
  String get noBidsYet;

  /// No description provided for @auctionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Auction Details'**
  String get auctionDetailsTitle;

  /// No description provided for @currentBid.
  ///
  /// In en, this message translates to:
  /// **'Current Bid'**
  String get currentBid;

  /// No description provided for @startingBid.
  ///
  /// In en, this message translates to:
  /// **'Starting Bid'**
  String get startingBid;

  /// No description provided for @minimumIncrement.
  ///
  /// In en, this message translates to:
  /// **'Minimum Increment'**
  String get minimumIncrement;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time Left'**
  String get timeLeft;

  /// No description provided for @auctionEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends on'**
  String get auctionEnds;

  /// No description provided for @sellerInfo.
  ///
  /// In en, this message translates to:
  /// **'Seller Information'**
  String get sellerInfo;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @specifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// No description provided for @bidHistory.
  ///
  /// In en, this message translates to:
  /// **'Bid History'**
  String get bidHistory;

  /// No description provided for @placeBid.
  ///
  /// In en, this message translates to:
  /// **'Place Bid'**
  String get placeBid;

  /// No description provided for @enterBidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Bid Amount'**
  String get enterBidAmount;

  /// No description provided for @bidMustBeHigher.
  ///
  /// In en, this message translates to:
  /// **'Bid must be at least {amount}'**
  String bidMustBeHigher(String amount);

  /// No description provided for @confirmBidTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your Bid'**
  String get confirmBidTitle;

  /// No description provided for @confirmBidPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to place a bid of {amount}?'**
  String confirmBidPrompt(String amount);

  /// No description provided for @bidPlacedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your bid of {amount} has been placed successfully!'**
  String bidPlacedSuccess(String amount);

  /// No description provided for @youAreHighestBidder.
  ///
  /// In en, this message translates to:
  /// **'You are currently the highest bidder!'**
  String get youAreHighestBidder;

  /// No description provided for @youHaveBeenOutbid.
  ///
  /// In en, this message translates to:
  /// **'You have been outbid on this listing.'**
  String get youHaveBeenOutbid;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @securitySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySection;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'Support & About'**
  String get supportSection;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English (Default)'**
  String get languageEnglish;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'اردو (Urdu)'**
  String get languageUrdu;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {lang}'**
  String languageChanged(String lang);

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @listingUpdates.
  ///
  /// In en, this message translates to:
  /// **'Listing Updates'**
  String get listingUpdates;

  /// No description provided for @priceOffersNotification.
  ///
  /// In en, this message translates to:
  /// **'Price Offers & Bids'**
  String get priceOffersNotification;

  /// No description provided for @productUpdates.
  ///
  /// In en, this message translates to:
  /// **'Product Updates'**
  String get productUpdates;

  /// No description provided for @newAuctions.
  ///
  /// In en, this message translates to:
  /// **'New Auctions'**
  String get newAuctions;

  /// No description provided for @bidUpdates.
  ///
  /// In en, this message translates to:
  /// **'Bid Updates'**
  String get bidUpdates;

  /// No description provided for @closingSoonAlerts.
  ///
  /// In en, this message translates to:
  /// **'Closing Soon Alerts'**
  String get closingSoonAlerts;

  /// No description provided for @winningNotifications.
  ///
  /// In en, this message translates to:
  /// **'Winning Notifications'**
  String get winningNotifications;

  /// No description provided for @twoFA.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication (2FA)'**
  String get twoFA;

  /// No description provided for @twoFADesc.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security to your account'**
  String get twoFADesc;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @unverified.
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get unverified;

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPasswordLabel;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.'**
  String get deleteAccountConfirm;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Solar Scrap'**
  String get aboutUs;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Solar Scrap v1.0.0'**
  String get version;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Solar Scrap Platform. All rights reserved.'**
  String get copyright;

  /// No description provided for @sellerSignUp.
  ///
  /// In en, this message translates to:
  /// **'Seller Sign Up'**
  String get sellerSignUp;

  /// No description provided for @sellerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Seller?'**
  String get sellerQuestion;

  /// No description provided for @buyerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Buyer?'**
  String get buyerQuestion;

  /// No description provided for @step1Of3Credentials.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 3 · Credentials'**
  String get step1Of3Credentials;

  /// No description provided for @orContinueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'OR Continue with Email'**
  String get orContinueWithEmail;

  /// No description provided for @emailAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Email Address *'**
  String get emailAddressRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password *'**
  String get passwordRequired;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password *'**
  String get confirmPasswordRequired;

  /// No description provided for @createSecurePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a secure password'**
  String get createSecurePasswordHint;

  /// No description provided for @pwdRuleMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get pwdRuleMinLength;

  /// No description provided for @pwdRuleUpperLower.
  ///
  /// In en, this message translates to:
  /// **'Uppercase and lowercase letters'**
  String get pwdRuleUpperLower;

  /// No description provided for @pwdRuleNumberSymbol.
  ///
  /// In en, this message translates to:
  /// **'At least one number or symbol'**
  String get pwdRuleNumberSymbol;

  /// No description provided for @pwdRuleMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get pwdRuleMatch;

  /// No description provided for @agreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeToThe;

  /// No description provided for @andAcknowledgeThe.
  ///
  /// In en, this message translates to:
  /// **' and acknowledge the '**
  String get andAcknowledgeThe;

  /// No description provided for @buyerNotificationCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about new scrap auctions and market prices (Optional)'**
  String get buyerNotificationCheckbox;

  /// No description provided for @sellerNotificationCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about quotations and offers on your solar listings (Optional)'**
  String get sellerNotificationCheckbox;

  /// No description provided for @continueToDetails.
  ///
  /// In en, this message translates to:
  /// **'Continue to Details'**
  String get continueToDetails;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyYourEmail;

  /// No description provided for @weSentVerificationLinkTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification link to\n'**
  String get weSentVerificationLinkTo;

  /// No description provided for @tapLinkToVerify.
  ///
  /// In en, this message translates to:
  /// **'.\nPlease tap the link in your inbox to verify your address.'**
  String get tapLinkToVerify;

  /// No description provided for @iHaveVerifiedLink.
  ///
  /// In en, this message translates to:
  /// **'I Have Verified Link'**
  String get iHaveVerifiedLink;

  /// No description provided for @emailNotVerifiedYet.
  ///
  /// In en, this message translates to:
  /// **'Email not verified yet. Please check your inbox or spam.'**
  String get emailNotVerifiedYet;

  /// No description provided for @resendLink.
  ///
  /// In en, this message translates to:
  /// **'Resend Link'**
  String get resendLink;

  /// No description provided for @skipDevMode.
  ///
  /// In en, this message translates to:
  /// **'Skip (Dev Mode)'**
  String get skipDevMode;

  /// No description provided for @verificationLinkResent.
  ///
  /// In en, this message translates to:
  /// **'Verification link re-sent!'**
  String get verificationLinkResent;

  /// No description provided for @passwordRequirementsError.
  ///
  /// In en, this message translates to:
  /// **'Please meet all password security requirements.'**
  String get passwordRequirementsError;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @acceptTermsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms & Conditions and Privacy Policy.'**
  String get acceptTermsError;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get enterValidEmail;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address.'**
  String get enterEmail;

  /// No description provided for @businessAndLocation.
  ///
  /// In en, this message translates to:
  /// **'Business & Location'**
  String get businessAndLocation;

  /// No description provided for @step2Of3BusinessDetails.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 3 · Business Details'**
  String get step2Of3BusinessDetails;

  /// No description provided for @uploadProfileLogo.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile / Logo (Optional)'**
  String get uploadProfileLogo;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @contactPersonRequired.
  ///
  /// In en, this message translates to:
  /// **'Contact Person / Full Name *'**
  String get contactPersonRequired;

  /// No description provided for @companyYardNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Company / Yard Name *'**
  String get companyYardNameRequired;

  /// No description provided for @businessTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Business Type *'**
  String get businessTypeRequired;

  /// No description provided for @selectBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Select business type'**
  String get selectBusinessType;

  /// No description provided for @businessTypeScrapDealer.
  ///
  /// In en, this message translates to:
  /// **'Scrap Dealer'**
  String get businessTypeScrapDealer;

  /// No description provided for @businessTypeRecycler.
  ///
  /// In en, this message translates to:
  /// **'Recycler'**
  String get businessTypeRecycler;

  /// No description provided for @businessTypeTraderBroker.
  ///
  /// In en, this message translates to:
  /// **'Trader / Broker'**
  String get businessTypeTraderBroker;

  /// No description provided for @businessTypeSolarEpc.
  ///
  /// In en, this message translates to:
  /// **'Solar EPC Contractor'**
  String get businessTypeSolarEpc;

  /// No description provided for @businessTypeManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get businessTypeManufacturer;

  /// No description provided for @businessTypeOtherBusiness.
  ///
  /// In en, this message translates to:
  /// **'Other Business'**
  String get businessTypeOtherBusiness;

  /// No description provided for @businessTypeSolarPlantOwner.
  ///
  /// In en, this message translates to:
  /// **'Solar Plant Owner'**
  String get businessTypeSolarPlantOwner;

  /// No description provided for @businessTypeCommercialIndustrial.
  ///
  /// In en, this message translates to:
  /// **'Commercial / Industrial Facility'**
  String get businessTypeCommercialIndustrial;

  /// No description provided for @businessTypeResidentHomeowner.
  ///
  /// In en, this message translates to:
  /// **'Resident / Homeowner'**
  String get businessTypeResidentHomeowner;

  /// No description provided for @businessTypeOtherFacility.
  ///
  /// In en, this message translates to:
  /// **'Other Facility'**
  String get businessTypeOtherFacility;

  /// No description provided for @businessTypeEpcContractor.
  ///
  /// In en, this message translates to:
  /// **'EPC Contractor'**
  String get businessTypeEpcContractor;

  /// No description provided for @businessTypeScrapDealerBroker.
  ///
  /// In en, this message translates to:
  /// **'Scrap Dealer / Broker'**
  String get businessTypeScrapDealerBroker;

  /// No description provided for @gstNtnOptional.
  ///
  /// In en, this message translates to:
  /// **'GST / NTN Number (Optional)'**
  String get gstNtnOptional;

  /// No description provided for @businessLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Business / Warehouse Location *'**
  String get businessLocationRequired;

  /// No description provided for @pinOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pin on Map'**
  String get pinOnMap;

  /// No description provided for @streetAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Street Address *'**
  String get streetAddressRequired;

  /// No description provided for @cityRequired.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get cityRequired;

  /// No description provided for @areaDistrictLabel.
  ///
  /// In en, this message translates to:
  /// **'Area / District'**
  String get areaDistrictLabel;

  /// No description provided for @continueToMobileVerification.
  ///
  /// In en, this message translates to:
  /// **'Continue to Mobile Verification'**
  String get continueToMobileVerification;

  /// No description provided for @enterNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterNameError;

  /// No description provided for @enterCompanyNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter your company or business name'**
  String get enterCompanyNameError;

  /// No description provided for @enterStreetAddressError.
  ///
  /// In en, this message translates to:
  /// **'Please enter street address'**
  String get enterStreetAddressError;

  /// No description provided for @enterCityError.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get enterCityError;

  /// No description provided for @mobileVerification.
  ///
  /// In en, this message translates to:
  /// **'Mobile Verification'**
  String get mobileVerification;

  /// No description provided for @step3Of3MobileVerification.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 3 · Mobile Verification (2FA)'**
  String get step3Of3MobileVerification;

  /// No description provided for @verifyMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify Mobile Number'**
  String get verifyMobileNumber;

  /// No description provided for @protectAccount2FADesc.
  ///
  /// In en, this message translates to:
  /// **'Protect your scrap trades and account with two-factor mobile authentication (2FA).'**
  String get protectAccount2FADesc;

  /// No description provided for @mobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumberLabel;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @enter6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-Digit Code'**
  String get enter6DigitCode;

  /// No description provided for @didntGetCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code?'**
  String get didntGetCode;

  /// No description provided for @resendNow.
  ///
  /// In en, this message translates to:
  /// **'Resend Now'**
  String get resendNow;

  /// No description provided for @verifyAndCompleteRegistration.
  ///
  /// In en, this message translates to:
  /// **'Verify & Complete Registration'**
  String get verifyAndCompleteRegistration;

  /// No description provided for @enterValidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile number.'**
  String get enterValidMobileNumber;

  /// No description provided for @enterCompleteOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit OTP code.'**
  String get enterCompleteOtpCode;

  /// No description provided for @invalidOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Please enter the correct code or 000000.'**
  String get invalidOtpCode;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Try again.'**
  String get registrationFailed;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to {phone}'**
  String codeSentTo(String phone);

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @enterEmailOrPhoneReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone to receive a reset OTP'**
  String get enterEmailOrPhoneReset;

  /// No description provided for @emailOrPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone'**
  String get emailOrPhoneLabel;

  /// No description provided for @emailOrPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com or 0300 1234567'**
  String get emailOrPhoneHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @passwordResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Reset!'**
  String get passwordResetTitle;

  /// No description provided for @passwordResetSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated successfully.'**
  String get passwordResetSuccessDesc;

  /// No description provided for @accountUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Account Under Review'**
  String get accountUnderReview;

  /// No description provided for @accountApproved.
  ///
  /// In en, this message translates to:
  /// **'Account Approved!'**
  String get accountApproved;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// No description provided for @checkStatus.
  ///
  /// In en, this message translates to:
  /// **'Check Status'**
  String get checkStatus;

  /// No description provided for @pleaseEnterEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email or phone'**
  String get pleaseEnterEmailOrPhone;

  /// No description provided for @verifyOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtpTitle;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @enterOtpSentToPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your mobile number\nending in {phone}'**
  String enterOtpSentToPhone(String phone);

  /// No description provided for @resendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in 00:{seconds}'**
  String resendInSeconds(String seconds);

  /// No description provided for @verifyAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify Account'**
  String get verifyAccount;

  /// No description provided for @pleaseEnterAll6Digits.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 6 digits'**
  String get pleaseEnterAll6Digits;

  /// No description provided for @didntReceiveCodeCheckSpam.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? Check your spam folder or try resending.'**
  String get didntReceiveCodeCheckSpam;

  /// No description provided for @accountVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'🎉 Account Verified! Admin has approved your account.'**
  String get accountVerifiedSuccess;

  /// No description provided for @accountVerifiedBuyerSuccess.
  ///
  /// In en, this message translates to:
  /// **'🎉 Account Verified! Admin has approved your buyer account.'**
  String get accountVerifiedBuyerSuccess;

  /// No description provided for @statusPendingApprovalDesc.
  ///
  /// In en, this message translates to:
  /// **'Status: Pending Admin Approval. Please approve from the web portal.'**
  String get statusPendingApprovalDesc;

  /// No description provided for @buyerAccountApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Buyer Account Approved!'**
  String get buyerAccountApprovedTitle;

  /// No description provided for @sellerAccountApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Approved & Active!'**
  String get sellerAccountApprovedTitle;

  /// No description provided for @accountRequestSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Request Submitted'**
  String get accountRequestSubmittedTitle;

  /// No description provided for @buyerApprovedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your dealer registration has been verified and approved by the admin team. You can now browse auctions and place bids.'**
  String get buyerApprovedDesc;

  /// No description provided for @sellerApprovedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your seller profile has been verified and approved by the Solar Scrap Admin team. You now have full access to create listings and manage sales.'**
  String get sellerApprovedDesc;

  /// No description provided for @accountPendingReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Your registration request has been submitted for admin review. Once verified and approved by the admin team, your account will unlock automatically.'**
  String get accountPendingReviewDesc;

  /// No description provided for @statusApprovedVerified.
  ///
  /// In en, this message translates to:
  /// **'Status: Approved & Verified'**
  String get statusApprovedVerified;

  /// No description provided for @statusPendingAdminApproval.
  ///
  /// In en, this message translates to:
  /// **'Status: Pending Admin Approval'**
  String get statusPendingAdminApproval;

  /// No description provided for @verifiedBuyerAccountAt.
  ///
  /// In en, this message translates to:
  /// **'Verified Buyer Account · {location}'**
  String verifiedBuyerAccountAt(String location);

  /// No description provided for @pendingVerificationAt.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification · {location}'**
  String pendingVerificationAt(String location);

  /// No description provided for @verifiedSellerAccountAt.
  ///
  /// In en, this message translates to:
  /// **'Verified Seller Account · {location}'**
  String verifiedSellerAccountAt(String location);

  /// No description provided for @checkApprovalStatus.
  ///
  /// In en, this message translates to:
  /// **'Check Approval Status'**
  String get checkApprovalStatus;

  /// No description provided for @monitoringAdminApprovalDesc.
  ///
  /// In en, this message translates to:
  /// **'App is actively monitoring for admin approval. Once approved on the web portal, access unlocks automatically.'**
  String get monitoringAdminApprovalDesc;

  /// No description provided for @switchAccountReturnSignIn.
  ///
  /// In en, this message translates to:
  /// **'Switch Account / Return to Sign In'**
  String get switchAccountReturnSignIn;

  /// No description provided for @createFirstListing.
  ///
  /// In en, this message translates to:
  /// **'Create First Listing'**
  String get createFirstListing;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @auctionsTab.
  ///
  /// In en, this message translates to:
  /// **'Auctions'**
  String get auctionsTab;

  /// No description provided for @myBidsTab.
  ///
  /// In en, this message translates to:
  /// **'My Bids'**
  String get myBidsTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @listingTab.
  ///
  /// In en, this message translates to:
  /// **'Listing'**
  String get listingTab;

  /// No description provided for @alertsTab.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsTab;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get goodMorning;

  /// No description provided for @searchAuctionsEquipmentHint.
  ///
  /// In en, this message translates to:
  /// **'Search auctions, equipment...'**
  String get searchAuctionsEquipmentHint;

  /// No description provided for @searchBidsHint.
  ///
  /// In en, this message translates to:
  /// **'Search bids'**
  String get searchBidsHint;

  /// No description provided for @searchListingsHint.
  ///
  /// In en, this message translates to:
  /// **'Search listings...'**
  String get searchListingsHint;

  /// No description provided for @activeBids.
  ///
  /// In en, this message translates to:
  /// **'Active Bids'**
  String get activeBids;

  /// No description provided for @wonAuctions.
  ///
  /// In en, this message translates to:
  /// **'Won Auctions'**
  String get wonAuctions;

  /// No description provided for @totalBids.
  ///
  /// In en, this message translates to:
  /// **'Total Bids'**
  String get totalBids;

  /// No description provided for @latestAuctions.
  ///
  /// In en, this message translates to:
  /// **'Latest Auctions'**
  String get latestAuctions;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @featuredAuction.
  ///
  /// In en, this message translates to:
  /// **'Featured Auction'**
  String get featuredAuction;

  /// No description provided for @exploreAuctions.
  ///
  /// In en, this message translates to:
  /// **'Explore Auctions'**
  String get exploreAuctions;

  /// No description provided for @viewAuction.
  ///
  /// In en, this message translates to:
  /// **'View Auction'**
  String get viewAuction;

  /// No description provided for @bidNow.
  ///
  /// In en, this message translates to:
  /// **'Bid Now'**
  String get bidNow;

  /// No description provided for @priceDemand.
  ///
  /// In en, this message translates to:
  /// **'Price Demand'**
  String get priceDemand;

  /// No description provided for @verifiedBuyer.
  ///
  /// In en, this message translates to:
  /// **'Verified Buyer'**
  String get verifiedBuyer;

  /// No description provided for @verifiedSeller.
  ///
  /// In en, this message translates to:
  /// **'Verified Seller'**
  String get verifiedSeller;

  /// No description provided for @scrapDealerBuyer.
  ///
  /// In en, this message translates to:
  /// **'Scrap Dealer / Buyer'**
  String get scrapDealerBuyer;

  /// No description provided for @solarEquipmentSeller.
  ///
  /// In en, this message translates to:
  /// **'Solar Equipment Seller'**
  String get solarEquipmentSeller;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @readyToSell.
  ///
  /// In en, this message translates to:
  /// **'Ready to Sell?'**
  String get readyToSell;

  /// No description provided for @readyToSellDesc.
  ///
  /// In en, this message translates to:
  /// **'Post your solar scrap and get competitive offers'**
  String get readyToSellDesc;

  /// No description provided for @sellSolarScrap.
  ///
  /// In en, this message translates to:
  /// **'Sell Solar Scrap'**
  String get sellSolarScrap;

  /// No description provided for @totalListings.
  ///
  /// In en, this message translates to:
  /// **'Total Listings'**
  String get totalListings;

  /// No description provided for @alertsAndNotifications.
  ///
  /// In en, this message translates to:
  /// **'Alerts & Notifications'**
  String get alertsAndNotifications;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @noActiveAuctionsFound.
  ///
  /// In en, this message translates to:
  /// **'No active auctions found in this category'**
  String get noActiveAuctionsFound;

  /// No description provided for @noBidsFoundUnderStatus.
  ///
  /// In en, this message translates to:
  /// **'No bids found under {status}'**
  String noBidsFoundUnderStatus(String status);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActive;

  /// No description provided for @filterWinning.
  ///
  /// In en, this message translates to:
  /// **'Winning'**
  String get filterWinning;

  /// No description provided for @filterClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get filterClosed;

  /// No description provided for @filterOutbid.
  ///
  /// In en, this message translates to:
  /// **'Outbid'**
  String get filterOutbid;

  /// No description provided for @filterSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get filterSold;

  /// No description provided for @filterDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get filterDraft;

  /// No description provided for @marketplaceHeroTag.
  ///
  /// In en, this message translates to:
  /// **'SolarScrap Marketplace'**
  String get marketplaceHeroTag;

  /// No description provided for @verifiedAuctionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified Solar Scrap Auctions'**
  String get verifiedAuctionsTitle;

  /// No description provided for @exploreAuctionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore solar panels, inverters & batteries across Pakistan.'**
  String get exploreAuctionsSubtitle;

  /// No description provided for @noMatchingAuctionsFound.
  ///
  /// In en, this message translates to:
  /// **'No matching auctions found on marketplace'**
  String get noMatchingAuctionsFound;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @filterLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get filterLatest;

  /// No description provided for @filterLowestPrice.
  ///
  /// In en, this message translates to:
  /// **'Lowest Price'**
  String get filterLowestPrice;

  /// No description provided for @filterHighestPrice.
  ///
  /// In en, this message translates to:
  /// **'Highest Price'**
  String get filterHighestPrice;

  /// No description provided for @categoryTransformers.
  ///
  /// In en, this message translates to:
  /// **'Transformers'**
  String get categoryTransformers;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out of your account?'**
  String get signOutConfirmation;

  /// No description provided for @recentListings.
  ///
  /// In en, this message translates to:
  /// **'Recent Listings'**
  String get recentListings;

  /// No description provided for @noListingsYet.
  ///
  /// In en, this message translates to:
  /// **'No listings yet'**
  String get noListingsYet;

  /// No description provided for @tapSellSolarScrapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Sell Solar Scrap\" above to add your first listing!'**
  String get tapSellSolarScrapToAdd;

  /// No description provided for @filterSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get filterSubmitted;

  /// No description provided for @filterUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get filterUnderReview;

  /// No description provided for @filterPriceOffered.
  ///
  /// In en, this message translates to:
  /// **'Price Offered'**
  String get filterPriceOffered;

  /// No description provided for @askingPrice.
  ///
  /// In en, this message translates to:
  /// **'Asking price'**
  String get askingPrice;

  /// No description provided for @noMatchingListings.
  ///
  /// In en, this message translates to:
  /// **'No matching listings'**
  String get noMatchingListings;

  /// No description provided for @noListingsCreatedYet.
  ///
  /// In en, this message translates to:
  /// **'No listings created yet'**
  String get noListingsCreatedYet;

  /// No description provided for @tryChangingSearchFilter.
  ///
  /// In en, this message translates to:
  /// **'Try changing the search keyword or filter'**
  String get tryChangingSearchFilter;

  /// No description provided for @tapPlusToCreateListing.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to create your first listing'**
  String get tapPlusToCreateListing;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @listingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get listingsTitle;

  /// No description provided for @dealsTitle.
  ///
  /// In en, this message translates to:
  /// **'Deals'**
  String get dealsTitle;

  /// No description provided for @earningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earningsTitle;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @companyInformation.
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get companyInformation;

  /// No description provided for @companyLabel.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get companyLabel;

  /// No description provided for @gstLabel.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get gstLabel;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @buyerRoleFallback.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyerRoleFallback;

  /// No description provided for @sellerRoleFallback.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get sellerRoleFallback;

  /// No description provided for @statusWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get statusWon;

  /// No description provided for @statusLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get statusLost;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @newListingTitle.
  ///
  /// In en, this message translates to:
  /// **'New Listing'**
  String get newListingTitle;

  /// No description provided for @equipmentCategory.
  ///
  /// In en, this message translates to:
  /// **'Equipment Category'**
  String get equipmentCategory;

  /// No description provided for @whatTypeOfEquipment.
  ///
  /// In en, this message translates to:
  /// **'What type of equipment are you selling?'**
  String get whatTypeOfEquipment;

  /// No description provided for @completeSolarSystem.
  ///
  /// In en, this message translates to:
  /// **'Complete Solar System'**
  String get completeSolarSystem;

  /// No description provided for @stepXOfY.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepXOfY(int current, int total);

  /// No description provided for @uploadImages.
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get uploadImages;

  /// No description provided for @addUpTo10Photos.
  ///
  /// In en, this message translates to:
  /// **'Add up to 10 photos'**
  String get addUpTo10Photos;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @listingDetailsStepImages.
  ///
  /// In en, this message translates to:
  /// **'Listing Details · Step {current} of {total} (Images)'**
  String listingDetailsStepImages(int current, int total);

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String failedToPickImage(String error);

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed. Please check your connection and try again.'**
  String get imageUploadFailed;

  /// No description provided for @listingDetailsStepLocation.
  ///
  /// In en, this message translates to:
  /// **'Listing Details · Step {current} of {total} (Location)'**
  String listingDetailsStepLocation(int current, int total);

  /// No description provided for @areaLocalityOptional.
  ///
  /// In en, this message translates to:
  /// **'Area / Locality (optional)'**
  String get areaLocalityOptional;

  /// No description provided for @areaHint.
  ///
  /// In en, this message translates to:
  /// **'DHA Phase 7, Karachi'**
  String get areaHint;

  /// No description provided for @completeAddress.
  ///
  /// In en, this message translates to:
  /// **'Complete Address'**
  String get completeAddress;

  /// No description provided for @completeAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Street, building, area details...'**
  String get completeAddressHint;

  /// No description provided for @listingDetailsStepContact.
  ///
  /// In en, this message translates to:
  /// **'Listing Details · Step {current} of {total} (Contact)'**
  String listingDetailsStepContact(int current, int total);

  /// No description provided for @prefilledFromProfile.
  ///
  /// In en, this message translates to:
  /// **'Pre-filled from your profile. Edit if needed.'**
  String get prefilledFromProfile;

  /// No description provided for @listingPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Listing Preview'**
  String get listingPreviewTitle;

  /// No description provided for @listingDetailsStepPreview.
  ///
  /// In en, this message translates to:
  /// **'Listing Details · Step {current} of {total} (Preview)'**
  String listingDetailsStepPreview(int current, int total);

  /// No description provided for @previewBadge.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewBadge;

  /// No description provided for @imagesCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Images ({count})'**
  String imagesCountLabel(int count);

  /// No description provided for @noPhotosUploaded.
  ///
  /// In en, this message translates to:
  /// **'No photos uploaded'**
  String get noPhotosUploaded;

  /// No description provided for @locationAndContact.
  ///
  /// In en, this message translates to:
  /// **'Location & Contact'**
  String get locationAndContact;

  /// No description provided for @startOver.
  ///
  /// In en, this message translates to:
  /// **'Start Over'**
  String get startOver;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @failedToSubmitListing.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit listing. Please try again.'**
  String get failedToSubmitListing;

  /// No description provided for @numberOfPanels.
  ///
  /// In en, this message translates to:
  /// **'Number of Panels'**
  String get numberOfPanels;

  /// No description provided for @wattsPerPanel.
  ///
  /// In en, this message translates to:
  /// **'Watts per Panel'**
  String get wattsPerPanel;

  /// No description provided for @wattsPerPanelUnit.
  ///
  /// In en, this message translates to:
  /// **'Watts per Panel (W)'**
  String get wattsPerPanelUnit;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @brandHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Brand name'**
  String get brandHint;

  /// No description provided for @ratedPower.
  ///
  /// In en, this message translates to:
  /// **'Rated Power'**
  String get ratedPower;

  /// No description provided for @cableType.
  ///
  /// In en, this message translates to:
  /// **'Cable Type'**
  String get cableType;

  /// No description provided for @conductor.
  ///
  /// In en, this message translates to:
  /// **'Conductor'**
  String get conductor;

  /// No description provided for @insulation.
  ///
  /// In en, this message translates to:
  /// **'Insulation'**
  String get insulation;

  /// No description provided for @cableSize.
  ///
  /// In en, this message translates to:
  /// **'Cable Size'**
  String get cableSize;

  /// No description provided for @structureType.
  ///
  /// In en, this message translates to:
  /// **'Structure Type'**
  String get structureType;

  /// No description provided for @metal.
  ///
  /// In en, this message translates to:
  /// **'Metal'**
  String get metal;

  /// No description provided for @panels.
  ///
  /// In en, this message translates to:
  /// **'Panels'**
  String get panels;

  /// No description provided for @inverter.
  ///
  /// In en, this message translates to:
  /// **'Inverter'**
  String get inverter;

  /// No description provided for @structure.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get structure;

  /// No description provided for @listingSubmittedReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Listing Submitted for Review'**
  String get listingSubmittedReviewTitle;

  /// No description provided for @listingSubmittedReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Your listing has been submitted for admin approval. It will go live on the marketplace once accepted.'**
  String get listingSubmittedReviewDesc;

  /// No description provided for @listingIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Listing ID'**
  String get listingIdLabel;

  /// No description provided for @pendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApproval;

  /// No description provided for @listingDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Listing Details'**
  String get listingDetailsTitle;

  /// No description provided for @equipmentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Equipment Details'**
  String get equipmentDetailsTitle;

  /// No description provided for @pickupCity.
  ///
  /// In en, this message translates to:
  /// **'Pickup City'**
  String get pickupCity;

  /// No description provided for @pickupArea.
  ///
  /// In en, this message translates to:
  /// **'Pickup Area'**
  String get pickupArea;

  /// No description provided for @contactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPerson;

  /// No description provided for @trackStatus.
  ///
  /// In en, this message translates to:
  /// **'Track Status'**
  String get trackStatus;

  /// No description provided for @lakhUnit.
  ///
  /// In en, this message translates to:
  /// **'Lakh'**
  String get lakhUnit;

  /// No description provided for @currentlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currently: '**
  String get currentlyLabel;

  /// No description provided for @bidsReceived.
  ///
  /// In en, this message translates to:
  /// **'Bids Received'**
  String get bidsReceived;

  /// No description provided for @totalBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} Total'**
  String totalBadge(int count);

  /// No description provided for @noBidsPlacedYet.
  ///
  /// In en, this message translates to:
  /// **'No bids placed yet'**
  String get noBidsPlacedYet;

  /// No description provided for @bidsWillAppearRealtime.
  ///
  /// In en, this message translates to:
  /// **'Bids from buyers will appear here in real-time.'**
  String get bidsWillAppearRealtime;

  /// No description provided for @reviewOffer.
  ///
  /// In en, this message translates to:
  /// **'Review Offer'**
  String get reviewOffer;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// No description provided for @statusDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get statusDeclined;

  /// No description provided for @statusPendingOffer.
  ///
  /// In en, this message translates to:
  /// **'Pending Offer'**
  String get statusPendingOffer;

  /// No description provided for @activeOnMarket.
  ///
  /// In en, this message translates to:
  /// **'Active on Market'**
  String get activeOnMarket;

  /// No description provided for @negotiationReview.
  ///
  /// In en, this message translates to:
  /// **'Negotiation / Review'**
  String get negotiationReview;

  /// No description provided for @dealClosed.
  ///
  /// In en, this message translates to:
  /// **'Deal Closed'**
  String get dealClosed;

  /// No description provided for @acceptingBidsFromBuyers.
  ///
  /// In en, this message translates to:
  /// **'Accepting bids from buyers'**
  String get acceptingBidsFromBuyers;

  /// No description provided for @awaitingBuyerBids.
  ///
  /// In en, this message translates to:
  /// **'Awaiting buyer bids'**
  String get awaitingBuyerBids;

  /// No description provided for @actionRequired.
  ///
  /// In en, this message translates to:
  /// **'Action Required'**
  String get actionRequired;

  /// No description provided for @pendingAgreement.
  ///
  /// In en, this message translates to:
  /// **'Pending agreement'**
  String get pendingAgreement;

  /// No description provided for @bidsReceivedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} bid(s) received'**
  String bidsReceivedCount(int count);

  /// No description provided for @reviewingOffersCount.
  ///
  /// In en, this message translates to:
  /// **'Reviewing {count} offer(s)'**
  String reviewingOffersCount(int count);

  /// No description provided for @awaitingBuyerOffers.
  ///
  /// In en, this message translates to:
  /// **'Awaiting buyer offers'**
  String get awaitingBuyerOffers;

  /// No description provided for @panelCondition.
  ///
  /// In en, this message translates to:
  /// **'Panel Condition'**
  String get panelCondition;

  /// No description provided for @conditionScrap.
  ///
  /// In en, this message translates to:
  /// **'Scrap'**
  String get conditionScrap;

  /// No description provided for @conditionBulletHit.
  ///
  /// In en, this message translates to:
  /// **'Bullet Hit'**
  String get conditionBulletHit;

  /// No description provided for @conditionShatterGlass.
  ///
  /// In en, this message translates to:
  /// **'Shatter lass'**
  String get conditionShatterGlass;

  /// No description provided for @conditionGood.
  ///
  /// In en, this message translates to:
  /// **'Good Conditions'**
  String get conditionGood;

  /// No description provided for @conditionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get conditionOther;

  /// No description provided for @conditionWorking.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get conditionWorking;

  /// No description provided for @conditionNonWorking.
  ///
  /// In en, this message translates to:
  /// **'Non working'**
  String get conditionNonWorking;

  /// No description provided for @inverterTypeHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get inverterTypeHybrid;

  /// No description provided for @inverterTypeOnGrid.
  ///
  /// In en, this message translates to:
  /// **'On Grid'**
  String get inverterTypeOnGrid;

  /// No description provided for @batteryTypeLithium.
  ///
  /// In en, this message translates to:
  /// **'Lithium'**
  String get batteryTypeLithium;

  /// No description provided for @cableTypeAC.
  ///
  /// In en, this message translates to:
  /// **'AC'**
  String get cableTypeAC;

  /// No description provided for @cableTypeDC.
  ///
  /// In en, this message translates to:
  /// **'DC'**
  String get cableTypeDC;

  /// No description provided for @insulationPVC.
  ///
  /// In en, this message translates to:
  /// **'PVC'**
  String get insulationPVC;

  /// No description provided for @insulationXLPE.
  ///
  /// In en, this message translates to:
  /// **'XLPE'**
  String get insulationXLPE;

  /// No description provided for @structureElevated.
  ///
  /// In en, this message translates to:
  /// **'Elevated'**
  String get structureElevated;

  /// No description provided for @structureRooftop.
  ///
  /// In en, this message translates to:
  /// **'Rooftop'**
  String get structureRooftop;

  /// No description provided for @structureGround.
  ///
  /// In en, this message translates to:
  /// **'Ground Mounted'**
  String get structureGround;

  /// No description provided for @metalGI.
  ///
  /// In en, this message translates to:
  /// **'GI'**
  String get metalGI;

  /// No description provided for @completeSystemPanelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete System: Panels'**
  String get completeSystemPanelsTitle;

  /// No description provided for @completeSystemInvertersTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete System: Inverter'**
  String get completeSystemInvertersTitle;

  /// No description provided for @completeSystemBatteriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete System: Batteries'**
  String get completeSystemBatteriesTitle;

  /// No description provided for @completeSystemStructureTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete System: Structure'**
  String get completeSystemStructureTitle;

  /// No description provided for @completeSystemCablesTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete System: Cables'**
  String get completeSystemCablesTitle;

  /// No description provided for @completeSystemBannerPanels.
  ///
  /// In en, this message translates to:
  /// **'Complete System · Solar Panels'**
  String get completeSystemBannerPanels;

  /// No description provided for @completeSystemBannerInverter.
  ///
  /// In en, this message translates to:
  /// **'Complete System · Inverter'**
  String get completeSystemBannerInverter;

  /// No description provided for @completeSystemBannerBatteries.
  ///
  /// In en, this message translates to:
  /// **'Complete System · Batteries'**
  String get completeSystemBannerBatteries;

  /// No description provided for @completeSystemBannerStructure.
  ///
  /// In en, this message translates to:
  /// **'Complete System · Structure'**
  String get completeSystemBannerStructure;

  /// No description provided for @completeSystemBannerCables.
  ///
  /// In en, this message translates to:
  /// **'Complete System · Cables'**
  String get completeSystemBannerCables;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @noPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone'**
  String get noPhone;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @stepXOfYWithDetail.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total} ({detail})'**
  String stepXOfYWithDetail(int current, int total, String detail);

  /// No description provided for @batteryTypeLeadAcid.
  ///
  /// In en, this message translates to:
  /// **'Lead Acid'**
  String get batteryTypeLeadAcid;

  /// No description provided for @batteryTypeTabular.
  ///
  /// In en, this message translates to:
  /// **'Tabular'**
  String get batteryTypeTabular;

  /// No description provided for @numberOfBatteries.
  ///
  /// In en, this message translates to:
  /// **'Number of Batteries'**
  String get numberOfBatteries;

  /// No description provided for @batteryCountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Battery count'**
  String get batteryCountHint;

  /// No description provided for @batteryCapacityKw.
  ///
  /// In en, this message translates to:
  /// **'Battery Capacity (kW)'**
  String get batteryCapacityKw;

  /// No description provided for @batteryCapacityAmp.
  ///
  /// In en, this message translates to:
  /// **'Battery Capacity (Amp)'**
  String get batteryCapacityAmp;

  /// No description provided for @manufacturerBrand.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer / Brand'**
  String get manufacturerBrand;

  /// No description provided for @purchaseYear.
  ///
  /// In en, this message translates to:
  /// **'Purchase Year'**
  String get purchaseYear;

  /// No description provided for @noOfYearUsed.
  ///
  /// In en, this message translates to:
  /// **'No. of year used'**
  String get noOfYearUsed;

  /// No description provided for @batteryConditions.
  ///
  /// In en, this message translates to:
  /// **'Battery Conditions'**
  String get batteryConditions;

  /// No description provided for @conductorCopper.
  ///
  /// In en, this message translates to:
  /// **'Copper'**
  String get conductorCopper;

  /// No description provided for @conductorAL.
  ///
  /// In en, this message translates to:
  /// **'AL'**
  String get conductorAL;

  /// No description provided for @insulationRubber.
  ///
  /// In en, this message translates to:
  /// **'Rubber'**
  String get insulationRubber;

  /// No description provided for @insulationThermoplastic.
  ///
  /// In en, this message translates to:
  /// **'Thermoplastic'**
  String get insulationThermoplastic;

  /// No description provided for @commentsOptional.
  ///
  /// In en, this message translates to:
  /// **'Comments (optional)'**
  String get commentsOptional;

  /// No description provided for @commentsHint.
  ///
  /// In en, this message translates to:
  /// **'Describe in details ......'**
  String get commentsHint;

  /// No description provided for @structureNonElevated.
  ///
  /// In en, this message translates to:
  /// **'Non Elevated'**
  String get structureNonElevated;

  /// No description provided for @structureMetal.
  ///
  /// In en, this message translates to:
  /// **'Structure Metal'**
  String get structureMetal;

  /// No description provided for @metalAL.
  ///
  /// In en, this message translates to:
  /// **'AL'**
  String get metalAL;

  /// No description provided for @metalGL.
  ///
  /// In en, this message translates to:
  /// **'GL'**
  String get metalGL;

  /// No description provided for @metalHotDip.
  ///
  /// In en, this message translates to:
  /// **'Hot dip'**
  String get metalHotDip;

  /// No description provided for @othersComponentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Others Components'**
  String get othersComponentsTitle;

  /// No description provided for @totalPriceDemand.
  ///
  /// In en, this message translates to:
  /// **'Total Price Demand'**
  String get totalPriceDemand;

  /// No description provided for @stepFinalDetails.
  ///
  /// In en, this message translates to:
  /// **'Final Details'**
  String get stepFinalDetails;

  /// No description provided for @stepDetailPanels.
  ///
  /// In en, this message translates to:
  /// **'Panels'**
  String get stepDetailPanels;

  /// No description provided for @stepDetailInverters.
  ///
  /// In en, this message translates to:
  /// **'Inverters'**
  String get stepDetailInverters;

  /// No description provided for @stepDetailBatteries.
  ///
  /// In en, this message translates to:
  /// **'Batteries'**
  String get stepDetailBatteries;

  /// No description provided for @stepDetailCables.
  ///
  /// In en, this message translates to:
  /// **'Cables'**
  String get stepDetailCables;

  /// No description provided for @stepDetailStructure.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get stepDetailStructure;

  /// No description provided for @structureDetails.
  ///
  /// In en, this message translates to:
  /// **'Structure Details'**
  String get structureDetails;

  /// No description provided for @othersCommentsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g communications devices, switch gears ...'**
  String get othersCommentsHint;

  /// No description provided for @cableSizeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g 12 meter'**
  String get cableSizeHint;

  /// No description provided for @batteryYearsUsedHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1 year'**
  String get batteryYearsUsedHint;

  /// No description provided for @purchaseYearHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2019'**
  String get purchaseYearHint;

  /// No description provided for @batteryCapacityKwHint.
  ///
  /// In en, this message translates to:
  /// **'e.g 5 kw'**
  String get batteryCapacityKwHint;

  /// No description provided for @batteryCapacityAmpHint.
  ///
  /// In en, this message translates to:
  /// **'e.g 200 amp'**
  String get batteryCapacityAmpHint;

  /// No description provided for @cableConductor.
  ///
  /// In en, this message translates to:
  /// **'Cable Conductor'**
  String get cableConductor;

  /// No description provided for @insulationType.
  ///
  /// In en, this message translates to:
  /// **'Insulation Type'**
  String get insulationType;

  /// No description provided for @detailsTab.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTab;

  /// No description provided for @specsTab.
  ///
  /// In en, this message translates to:
  /// **'Specs'**
  String get specsTab;

  /// No description provided for @timelineTab.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineTab;

  /// No description provided for @sellerContactDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'SELLER / CONTACT DETAILS'**
  String get sellerContactDetailsTitle;

  /// No description provided for @placeYourBid.
  ///
  /// In en, this message translates to:
  /// **'Place Your Bid'**
  String get placeYourBid;

  /// No description provided for @startingPrice.
  ///
  /// In en, this message translates to:
  /// **'Starting Price'**
  String get startingPrice;

  /// No description provided for @currentHighestBid.
  ///
  /// In en, this message translates to:
  /// **'Current Highest Bid'**
  String get currentHighestBid;

  /// No description provided for @minimumBid.
  ///
  /// In en, this message translates to:
  /// **'Minimum Bid'**
  String get minimumBid;

  /// No description provided for @yourBidAmountPkr.
  ///
  /// In en, this message translates to:
  /// **'Your Bid Amount (PKR)'**
  String get yourBidAmountPkr;

  /// No description provided for @reviewBidBeforeSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Please review your bid before submitting.'**
  String get reviewBidBeforeSubmitting;

  /// No description provided for @yourBid.
  ///
  /// In en, this message translates to:
  /// **'Your Bid'**
  String get yourBid;

  /// No description provided for @submitBid.
  ///
  /// In en, this message translates to:
  /// **'Submit Bid'**
  String get submitBid;

  /// No description provided for @failedToPlaceBid.
  ///
  /// In en, this message translates to:
  /// **'Failed to place bid. Please try again.'**
  String get failedToPlaceBid;

  /// No description provided for @bidSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Bid Submitted!'**
  String get bidSubmittedTitle;

  /// No description provided for @bidSubmittedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your bid is now live. You\'ll be notified if you win.'**
  String get bidSubmittedSubtitle;

  /// No description provided for @goToMyBids.
  ///
  /// In en, this message translates to:
  /// **'Go To My Bids'**
  String get goToMyBids;

  /// No description provided for @bidDetails.
  ///
  /// In en, this message translates to:
  /// **'Bid Details'**
  String get bidDetails;

  /// No description provided for @myBidAmount.
  ///
  /// In en, this message translates to:
  /// **'My Bid Amount'**
  String get myBidAmount;

  /// No description provided for @bidDate.
  ///
  /// In en, this message translates to:
  /// **'Bid Date'**
  String get bidDate;

  /// No description provided for @currentHighest.
  ///
  /// In en, this message translates to:
  /// **'Current Highest'**
  String get currentHighest;

  /// No description provided for @equipmentSpecifications.
  ///
  /// In en, this message translates to:
  /// **'Equipment Specifications'**
  String get equipmentSpecifications;

  /// No description provided for @sellerContactInformation.
  ///
  /// In en, this message translates to:
  /// **'Seller Contact Information'**
  String get sellerContactInformation;

  /// No description provided for @viewFullAuctionListing.
  ///
  /// In en, this message translates to:
  /// **'View Full Auction Listing'**
  String get viewFullAuctionListing;

  /// No description provided for @bidAcceptedBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Bid Was Accepted!'**
  String get bidAcceptedBannerTitle;

  /// No description provided for @bidAcceptedBannerDesc.
  ///
  /// In en, this message translates to:
  /// **'The seller accepted your offer. They will coordinate payment and equipment pickup.'**
  String get bidAcceptedBannerDesc;

  /// No description provided for @searchSavedAuctionsHint.
  ///
  /// In en, this message translates to:
  /// **'Search saved auctions...'**
  String get searchSavedAuctionsHint;

  /// No description provided for @tapHeartToSaveAuctions.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on any auction to save it for quick access.'**
  String get tapHeartToSaveAuctions;

  /// No description provided for @placeBidOnAuction.
  ///
  /// In en, this message translates to:
  /// **'Place Bid on {title}'**
  String placeBidOnAuction(String title);

  /// No description provided for @currentDemand.
  ///
  /// In en, this message translates to:
  /// **'Current Demand: {price}'**
  String currentDemand(String price);

  /// No description provided for @minimumBidIs.
  ///
  /// In en, this message translates to:
  /// **'Minimum bid is {amount}'**
  String minimumBidIs(String amount);

  /// No description provided for @auctionLabel.
  ///
  /// In en, this message translates to:
  /// **'Auction'**
  String get auctionLabel;

  /// No description provided for @referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get referenceNumber;

  /// No description provided for @auctionIdPrefix.
  ///
  /// In en, this message translates to:
  /// **'Auction ID: {id}'**
  String auctionIdPrefix(String id);

  /// No description provided for @bidWinningBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re currently winning!'**
  String get bidWinningBannerTitle;

  /// No description provided for @bidWinningBannerDesc.
  ///
  /// In en, this message translates to:
  /// **'Your bid is currently the highest. You will be notified when the auction closes.'**
  String get bidWinningBannerDesc;

  /// No description provided for @bidActiveBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Bid Submitted & Active'**
  String get bidActiveBannerTitle;

  /// No description provided for @bidActiveBannerDesc.
  ///
  /// In en, this message translates to:
  /// **'Your offer has been sent to the seller. You will be notified when they review or accept.'**
  String get bidActiveBannerDesc;

  /// No description provided for @bidOutbidBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'You Have Been Outbid'**
  String get bidOutbidBannerTitle;

  /// No description provided for @bidOutbidBannerDesc.
  ///
  /// In en, this message translates to:
  /// **'Another buyer submitted a higher offer. Return to the auction to increase your bid.'**
  String get bidOutbidBannerDesc;

  /// No description provided for @timelineStepBidSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Bid Submitted'**
  String get timelineStepBidSubmitted;

  /// No description provided for @timelineStepUnderSellerReview.
  ///
  /// In en, this message translates to:
  /// **'Under Seller Review'**
  String get timelineStepUnderSellerReview;

  /// No description provided for @timelineStepBidAccepted.
  ///
  /// In en, this message translates to:
  /// **'Bid Accepted by Seller'**
  String get timelineStepBidAccepted;

  /// No description provided for @timelineStepDealFinalized.
  ///
  /// In en, this message translates to:
  /// **'Deal Finalized'**
  String get timelineStepDealFinalized;

  /// No description provided for @timelineStepAuctionRunning.
  ///
  /// In en, this message translates to:
  /// **'Auction Running'**
  String get timelineStepAuctionRunning;

  /// No description provided for @timelineStepOfferDeclined.
  ///
  /// In en, this message translates to:
  /// **'Offer Declined / Closed'**
  String get timelineStepOfferDeclined;

  /// No description provided for @timelineStepAuctionClosed.
  ///
  /// In en, this message translates to:
  /// **'Auction Closed'**
  String get timelineStepAuctionClosed;

  /// No description provided for @timelineStepHighestBidder.
  ///
  /// In en, this message translates to:
  /// **'Highest Bidder'**
  String get timelineStepHighestBidder;

  /// No description provided for @timelineStepSellerDecision.
  ///
  /// In en, this message translates to:
  /// **'Seller Decision'**
  String get timelineStepSellerDecision;

  /// No description provided for @loadingAuctionDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading full auction details...'**
  String get loadingAuctionDetails;

  /// No description provided for @featuredBadge.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featuredBadge;

  /// No description provided for @priceOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Price Offer'**
  String get priceOfferTitle;

  /// No description provided for @acceptOfferPrompt.
  ///
  /// In en, this message translates to:
  /// **'Accept this offer?'**
  String get acceptOfferPrompt;

  /// No description provided for @acceptOfferDesc.
  ///
  /// In en, this message translates to:
  /// **'You are accepting {price} for {title}. This action cannot be undone.'**
  String acceptOfferDesc(String price, String title);

  /// No description provided for @acceptOfferCloseDealDesc.
  ///
  /// In en, this message translates to:
  /// **'You are accepting {price} for {title}. This action will close the deal.'**
  String acceptOfferCloseDealDesc(String price, String title);

  /// No description provided for @confirmAccept.
  ///
  /// In en, this message translates to:
  /// **'Confirm Accept'**
  String get confirmAccept;

  /// No description provided for @offerAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Offer accepted successfully! Deal is closed.'**
  String get offerAcceptedSuccess;

  /// No description provided for @failedToAcceptOffer.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept offer. Please try again.'**
  String get failedToAcceptOffer;

  /// No description provided for @rejectOfferPrompt.
  ///
  /// In en, this message translates to:
  /// **'Reject this offer?'**
  String get rejectOfferPrompt;

  /// No description provided for @rejectOfferDesc.
  ///
  /// In en, this message translates to:
  /// **'The buyer will be notified that their bid of {price} was declined.'**
  String rejectOfferDesc(String price);

  /// No description provided for @confirmReject.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reject'**
  String get confirmReject;

  /// No description provided for @offerRejectedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Offer rejected.'**
  String get offerRejectedSnackbar;

  /// No description provided for @failedToRejectOffer.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject offer.'**
  String get failedToRejectOffer;

  /// No description provided for @refPrefix.
  ///
  /// In en, this message translates to:
  /// **'Ref: {ref}'**
  String refPrefix(String ref);

  /// No description provided for @offeredPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Offered Price'**
  String get offeredPriceLabel;

  /// No description provided for @yourAskingPrefix.
  ///
  /// In en, this message translates to:
  /// **'Your asking: {price}'**
  String yourAskingPrefix(String price);

  /// No description provided for @bidDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bid placed by {buyer} on {date}. Confirming accept will close this deal and notify the buyer immediately.'**
  String bidDetailsSubtitle(String buyer, String date);

  /// No description provided for @buyerOfferedDesc.
  ///
  /// In en, this message translates to:
  /// **'A buyer has offered {price} for this equipment. Review the terms and select your decision below.'**
  String buyerOfferedDesc(String price);

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Photo'**
  String get changeProfilePhoto;

  /// No description provided for @takePhotoCamera.
  ///
  /// In en, this message translates to:
  /// **'Take Photo (Camera)'**
  String get takePhotoCamera;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully!'**
  String get profilePhotoUpdated;

  /// No description provided for @failedToUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload photo. Please check backend connection.'**
  String get failedToUploadPhoto;

  /// No description provided for @errorSelectingImage.
  ///
  /// In en, this message translates to:
  /// **'Error selecting image: {error}'**
  String errorSelectingImage(String error);

  /// No description provided for @fullNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Full Name cannot be empty'**
  String get fullNameEmpty;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccess;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile. Ensure backend is running.'**
  String get failedToUpdateProfile;

  /// No description provided for @tapPhotoToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap photo to change'**
  String get tapPhotoToChange;

  /// No description provided for @fullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your Full Name'**
  String get fullNamePlaceholder;

  /// No description provided for @companyNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Company Name Pvt. Ltd.'**
  String get companyNamePlaceholder;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressLabel;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @areaStreetAddress.
  ///
  /// In en, this message translates to:
  /// **'Area / Street Address'**
  String get areaStreetAddress;

  /// No description provided for @areaStreetHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. SITE Area, Gulberg'**
  String get areaStreetHint;

  /// No description provided for @cityHintBuyer.
  ///
  /// In en, this message translates to:
  /// **'e.g. Karachi, Lahore, Islamabad'**
  String get cityHintBuyer;

  /// No description provided for @phoneHintBuyer.
  ///
  /// In en, this message translates to:
  /// **'e.g. +92 300 1234567'**
  String get phoneHintBuyer;

  /// No description provided for @enterFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullNameHint;

  /// No description provided for @couldNotPickPhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not pick photo: {error}'**
  String couldNotPickPhoto(String error);

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @passwordDifferenceNotice.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from previously used passwords.'**
  String get passwordDifferenceNotice;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @reenterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get reenterNewPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @enterCurrentPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get enterCurrentPasswordPrompt;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 6 characters long'**
  String get passwordMinLength;

  /// No description provided for @failedToUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to update password. Please check your current password.'**
  String get failedToUpdatePassword;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All Read'**
  String get markAllRead;

  /// No description provided for @allNotificationsMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get allNotificationsMarkedRead;

  /// No description provided for @todaySection.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todaySection;

  /// No description provided for @earlierSection.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get earlierSection;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'We will notify you about your bids and new auctions.'**
  String get noNotificationsDesc;

  /// No description provided for @detailsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{topic} details coming soon!'**
  String detailsComingSoon(String topic);

  /// No description provided for @onboardingSellerTitle1.
  ///
  /// In en, this message translates to:
  /// **'List Your Solar Scrap'**
  String get onboardingSellerTitle1;

  /// No description provided for @onboardingSellerDesc1.
  ///
  /// In en, this message translates to:
  /// **'Sell solar panels, batteries, inverters,\ntransformers and more — reach thousands of\nverified buyers nationwide.'**
  String get onboardingSellerDesc1;

  /// No description provided for @onboardingSellerTitle2.
  ///
  /// In en, this message translates to:
  /// **'Get Best Market Value'**
  String get onboardingSellerTitle2;

  /// No description provided for @onboardingSellerDesc2.
  ///
  /// In en, this message translates to:
  /// **'Connect with verified buyers through a\ntransparent auction process. Every listing gets\ncompetitive offers.'**
  String get onboardingSellerDesc2;

  /// No description provided for @onboardingSellerTitle3.
  ///
  /// In en, this message translates to:
  /// **'Get Instant Alerts'**
  String get onboardingSellerTitle3;

  /// No description provided for @onboardingSellerDesc3.
  ///
  /// In en, this message translates to:
  /// **'When a room opens, you get a limited-time\nchance to claim it.'**
  String get onboardingSellerDesc3;

  /// No description provided for @onboardingBuyerTitle1.
  ///
  /// In en, this message translates to:
  /// **'Buy Quality Solar Scrap'**
  String get onboardingBuyerTitle1;

  /// No description provided for @onboardingBuyerDesc1.
  ///
  /// In en, this message translates to:
  /// **'Buy quality solar scrap through a trusted\nmarketplace built for verified dealers.'**
  String get onboardingBuyerDesc1;

  /// No description provided for @onboardingBuyerTitle2.
  ///
  /// In en, this message translates to:
  /// **'Discover Live Auctions'**
  String get onboardingBuyerTitle2;

  /// No description provided for @onboardingBuyerDesc2.
  ///
  /// In en, this message translates to:
  /// **'Browse active auctions for solar panels,\nbatteries, inverters, transformers, and more.'**
  String get onboardingBuyerDesc2;

  /// No description provided for @onboardingBuyerTitle3.
  ///
  /// In en, this message translates to:
  /// **'Bid Smart, Win More'**
  String get onboardingBuyerTitle3;

  /// No description provided for @onboardingBuyerDesc3.
  ///
  /// In en, this message translates to:
  /// **'Place competitive bids, track your auctions, and\nsecure the best solar scrap deals.'**
  String get onboardingBuyerDesc3;

  /// No description provided for @helpTopicAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Account & Login'**
  String get helpTopicAccountLogin;

  /// No description provided for @helpTopicSellingScrap.
  ///
  /// In en, this message translates to:
  /// **'Selling Solar Scrap'**
  String get helpTopicSellingScrap;

  /// No description provided for @helpTopicPickupOrders.
  ///
  /// In en, this message translates to:
  /// **'Pickup & Orders'**
  String get helpTopicPickupOrders;

  /// No description provided for @helpTopicPrivacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get helpTopicPrivacySecurity;

  /// No description provided for @helpTopicReportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get helpTopicReportProblem;

  /// No description provided for @helpTopicFaqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get helpTopicFaqs;

  /// No description provided for @privacyPolicyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: August 5, 2026'**
  String get privacyPolicyLastUpdated;

  /// No description provided for @privacyPolicyInfoCollectTitle.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacyPolicyInfoCollectTitle;

  /// No description provided for @privacyPolicyInfoCollectDesc.
  ///
  /// In en, this message translates to:
  /// **'We Collect Your Name, Email, Phone Number, Pickup Address, Company Details (If Applicable), And Order Information. We May Also Collect Device, Location, And Usage Data To Improve The App.'**
  String get privacyPolicyInfoCollectDesc;

  /// No description provided for @privacyPolicyHowUseTitle.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get privacyPolicyHowUseTitle;

  /// No description provided for @privacyPolicyHowUseDesc.
  ///
  /// In en, this message translates to:
  /// **'Your Information Is Used To Create Your Account, Process Scrap Purchases, Schedule Pickups, Provide Customer Support, Send Important Notifications, And Improve Our Services.'**
  String get privacyPolicyHowUseDesc;

  /// No description provided for @privacyPolicyDataSharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get privacyPolicyDataSharingTitle;

  /// No description provided for @privacyPolicyDataSharingDesc.
  ///
  /// In en, this message translates to:
  /// **'We Do Not Sell Your Personal Information. We Only Share Necessary Data With Trusted Service Providers Such As Payment Processors, Logistics Partners, And Authorities When Legally Required.'**
  String get privacyPolicyDataSharingDesc;

  /// No description provided for @privacyPolicyLocationAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get privacyPolicyLocationAccessTitle;

  /// No description provided for @privacyPolicyLocationAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'With Your Permission, We Use Your Location To Schedule Pickups, Improve Collection Accuracy, And Provide Location-Based Services. You Can Disable Location Access Anytime In Your Device Settings.'**
  String get privacyPolicyLocationAccessDesc;

  /// No description provided for @faqsSection.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqsSection;

  /// No description provided for @faq1Title.
  ///
  /// In en, this message translates to:
  /// **'1. How Do I Sell My Solar Scrap?'**
  String get faq1Title;

  /// No description provided for @faq1Desc.
  ///
  /// In en, this message translates to:
  /// **'Simply Create An Account, Add Your Scrap Details, Submit A Pickup Request, And Our Team Will Review And Arrange Collection.'**
  String get faq1Desc;

  /// No description provided for @faq2Title.
  ///
  /// In en, this message translates to:
  /// **'2. What Types Of Scrap Do You Accept?'**
  String get faq2Title;

  /// No description provided for @faq2Desc.
  ///
  /// In en, this message translates to:
  /// **'We Accept Various Types Of Solar-Related Scrap, Including Solar Panels, Inverters, Cables, Aluminum Frames, Batteries (Where Applicable), And Other Recyclable Components.'**
  String get faq2Desc;

  /// No description provided for @faq3Title.
  ///
  /// In en, this message translates to:
  /// **'3. How Will I Know The Value Of My Scrap?'**
  String get faq3Title;

  /// No description provided for @faq3Desc.
  ///
  /// In en, this message translates to:
  /// **'Our Team Evaluates Your Scrap Based On Its Type, Quantity, Condition, And Current Market Value Before Confirming The Purchase Price.'**
  String get faq3Desc;

  /// No description provided for @faq4Title.
  ///
  /// In en, this message translates to:
  /// **'4. How Do I Schedule A Pickup?'**
  String get faq4Title;

  /// No description provided for @faq4Desc.
  ///
  /// In en, this message translates to:
  /// **'After Submitting Your Scrap Details, You Can Choose A Preferred Pickup Location And Time. We\'ll Contact You To Confirm The Schedule.'**
  String get faq4Desc;

  /// No description provided for @faq5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Is My Personal Information Secure?'**
  String get faq5Title;

  /// No description provided for @faq5Desc.
  ///
  /// In en, this message translates to:
  /// **'Yes. We Use Industry-Standard Security Measures To Protect Your Personal Information And Never Sell Your Data To Third Parties.'**
  String get faq5Desc;

  /// No description provided for @contactUsSection.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUsSection;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
