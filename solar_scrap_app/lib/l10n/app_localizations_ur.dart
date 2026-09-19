// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'سولر اسکریپ';

  @override
  String get tagline => 'بی ٹو بی سولر اسکریپ ری سائیکلنگ مارکیٹ';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get confirm => 'تصدیق کریں';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get saveChanges => 'تبدیلیاں محفوظ کریں';

  @override
  String get delete => 'حذف کریں';

  @override
  String get edit => 'ترمیم کریں';

  @override
  String get next => 'اگلا';

  @override
  String get back => 'پیچھے';

  @override
  String get done => 'مکمل';

  @override
  String get submit => 'جمع کرائیں';

  @override
  String get continueButton => 'جاری رکھیں';

  @override
  String get close => 'بند کریں';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get yes => 'ہاں';

  @override
  String get no => 'نہیں';

  @override
  String get search => 'تلاش کریں';

  @override
  String get filter => 'فلٹر';

  @override
  String get apply => 'لاگو کریں';

  @override
  String get reset => 'دوبارہ ترتیب دیں';

  @override
  String get loading => 'لوڈ ہو رہا ہے...';

  @override
  String get pleaseWait => 'براہ کرم انتظار فرمائیں...';

  @override
  String get errorOccurred => 'کوئی خرابی پیش آگئی';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get success => 'کامیاب';

  @override
  String get viewAll => 'سب دیکھیں';

  @override
  String get seeMore => 'مزید دیکھیں';

  @override
  String get requiredField => 'یہ خانہ ضروری ہے';

  @override
  String get selectRoleTitle => 'اپنا کردار منتخب کریں';

  @override
  String get selectRoleSubtitle =>
      'کیا آپ سولر اسکریپ خریدنا چاہتے ہیں یا بیچنا؟';

  @override
  String get sellerRoleTitle => 'میں بیچنا چاہتا ہوں';

  @override
  String get sellerRoleDesc =>
      'اپنے سولر آلات، پینلز، بیٹریاں اور اسکریپ خریداروں کی بولی کے لیے پوسٹ کریں۔';

  @override
  String get buyerRoleTitle => 'میں خریدنا چاہتا ہوں';

  @override
  String get buyerRoleDesc =>
      'نیلامیوں میں حصہ لیں، بولی لگائیں اور مسابقتی قیمتوں پر سولر اسکریپ خریدیں۔';

  @override
  String get getStarted => 'شروع کریں';

  @override
  String get welcomeBack => 'خوش آمدید،';

  @override
  String get signInToContinue =>
      'جاری رکھنے کے لیے اپنے اکاؤنٹ میں لاگ ان کریں';

  @override
  String get emailLabel => 'ای میل ایڈریس';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'پاس ورڈ';

  @override
  String get passwordHint => 'اپنا پاس ورڈ درج کریں';

  @override
  String get confirmPasswordLabel => 'پاس ورڈ کی تصدیق کریں';

  @override
  String get confirmPasswordHint => 'پاس ورڈ دوبارہ درج کریں';

  @override
  String get forgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get signIn => 'لاگ ان کریں';

  @override
  String get signUp => 'رجسٹر کریں';

  @override
  String get dontHaveAccount => 'کیا آپ کا اکاؤنٹ نہیں ہے؟';

  @override
  String get alreadyHaveAccount => 'پہلے سے اکاؤنٹ موجود ہے؟';

  @override
  String get orSignInWith => 'یا اس کے ساتھ جاری رکھیں';

  @override
  String get googleSignIn => 'گوگل کے ساتھ جاری رکھیں';

  @override
  String get appleSignIn => 'ایپل کے ساتھ جاری رکھیں';

  @override
  String get createAccount => 'اکاؤنٹ بنائیں';

  @override
  String get fullNameLabel => 'پورا نام';

  @override
  String get fullNameHint => 'محمد احمد';

  @override
  String get companyNameLabel => 'کمپنی کا نام';

  @override
  String get companyNameHint => 'اے بی سی سولر ری سائیکلرز';

  @override
  String get phoneLabel => 'فون نمبر';

  @override
  String get phoneHint => '0300 1234567';

  @override
  String get cityLabel => 'شہر';

  @override
  String get cityHint => 'کراچی';

  @override
  String get termsAgreement =>
      'رجسٹر کر کے آپ ہماری سروس کی شرائط اور پرائیویسی پالیسی سے اتفاق کرتے ہیں';

  @override
  String get otpVerificationTitle => 'تصدیقی کوڈ';

  @override
  String otpVerificationSubtitle(String contact) {
    return 'ہم نے $contact پر 6 ہندسوں کا تصدیقی کوڈ بھیجا ہے';
  }

  @override
  String get verify => 'تصدیق کریں';

  @override
  String get resendCode => 'کوڈ دوبارہ بھیجیں';

  @override
  String resendCodeIn(int seconds) {
    return '$seconds سیکنڈ میں کوڈ دوبارہ بھیجیں';
  }

  @override
  String get didNotReceiveCode => 'کیا آپ کو کوڈ موصول نہیں ہوا؟';

  @override
  String get resetPasswordTitle => 'پاس ورڈ دوبارہ ترتیب دیں';

  @override
  String get resetPasswordSubtitle =>
      'پاس ورڈ کی ہدایات حاصل کرنے کے لیے اپنا ای میل درج کریں';

  @override
  String get sendResetLink => 'ری سیٹ لنک بھیجیں';

  @override
  String get newPasswordLabel => 'نیا پاس ورڈ';

  @override
  String get newPasswordHint => 'نیا پاس ورڈ درج کریں';

  @override
  String get passwordChangedSuccess => 'پاس ورڈ کامیابی سے تبدیل ہو گیا';

  @override
  String get sellerDashboardTitle => 'سیلر ڈیش بورڈ';

  @override
  String get activeListings => 'فعال لسٹنگز';

  @override
  String get pendingOffers => 'زیر التواء آفرز';

  @override
  String get completedDeals => 'مکمل شدہ سودے';

  @override
  String get totalRevenue => 'کل آمدنی';

  @override
  String get createNewListing => 'نئی لسٹنگ بنائیں';

  @override
  String get myListings => 'میری لسٹنگز';

  @override
  String get recentActivity => 'حالیہ سرگرمی';

  @override
  String get categoryPanels => 'سولر پینلز';

  @override
  String get categoryInverters => 'انورٹرز';

  @override
  String get categoryBatteries => 'بیٹریاں';

  @override
  String get categoryCables => 'کیبلز اور وائرنگ';

  @override
  String get categoryStructure => 'ماؤنٹنگ اسٹرکچر';

  @override
  String get categoryOthers => 'دیگر آلات';

  @override
  String get listingTitleLabel => 'لسٹنگ کا عنوان';

  @override
  String get listingTitleHint => 'مثلاً: 500 واٹ مونوکرسٹلائن پینلز (50 عدد)';

  @override
  String get listingCategoryLabel => 'زمرہ';

  @override
  String get listingConditionLabel => 'حالت';

  @override
  String get listingQuantityLabel => 'مقدار';

  @override
  String get listingWeightLabel => 'تخمینی وزن (کلوگرام)';

  @override
  String get listingDescriptionLabel => 'تفصیل';

  @override
  String get listingDescriptionHint =>
      'اسکریپ کی تفصیل، نقصانات، یا تاریخ درج کریں...';

  @override
  String get uploadPhotos => 'تصاویر اپ لوڈ کریں';

  @override
  String get uploadPhotosHint =>
      'آلات، لیبلز اور نقائص کی واضح تصاویر شامل کریں';

  @override
  String get takePhoto => 'تصویر کھینچیں';

  @override
  String get chooseFromGallery => 'گیلری سے منتخب کریں';

  @override
  String get previewListing => 'لسٹنگ کا پیش نظارہ';

  @override
  String get submitListing => 'لسٹنگ جمع کروائیں';

  @override
  String get listingSubmittedTitle => 'لسٹنگ جمع ہو گئی!';

  @override
  String get listingSubmittedDesc =>
      'آپ کی لسٹنگ کا جائزہ لیا جا رہا ہے اور جلد فعال ہو جائے گی۔';

  @override
  String get backToDashboard => 'ڈیش بورڈ پر واپس جائیں';

  @override
  String get equipmentDetails => 'آلات کی تفصیلات';

  @override
  String get panelType => 'پینل کی قسم';

  @override
  String get monocrystalline => 'مونوکرسٹلائن';

  @override
  String get polycrystalline => 'پولی کرسٹلائن';

  @override
  String get thinFilm => 'تھن فلم';

  @override
  String get wattagePerPanel => 'فی پینل واٹ (W)';

  @override
  String get inverterType => 'انورٹر کی قسم';

  @override
  String get stringInverter => 'اسٹرنگ انورٹر';

  @override
  String get centralInverter => 'سینٹرل انورٹر';

  @override
  String get microInverter => 'مائیکرو انورٹر';

  @override
  String get capacityKva => 'گنجائش (kVA / kW)';

  @override
  String get batteryType => 'بیٹری کی قسم';

  @override
  String get lithiumIon => 'لیتھیم آئن';

  @override
  String get leadAcid => 'لیڈ ایسڈ';

  @override
  String get tubular => 'ٹیوبلر';

  @override
  String get cableMetal => 'کیبل دھات';

  @override
  String get copper => 'تانبا (کاپر)';

  @override
  String get aluminum => 'ایلومینیم';

  @override
  String get pickupLocationTitle => 'پک اپ کا مقام';

  @override
  String get pickupAddressLabel => 'پتہ / گودام کا مقام';

  @override
  String get pickupCityLabel => 'شہر';

  @override
  String get pickupDateLabel => 'پک اپ کی تاریخ';

  @override
  String get contactPersonLabel => 'رابطہ کار';

  @override
  String get contactPhoneLabel => 'رابطہ فون نمبر';

  @override
  String get statusTrackingTitle => 'حیثیت کی ٹریکنگ';

  @override
  String get statusDraft => 'ڈرافٹ';

  @override
  String get statusUnderReview => 'زیرِ جائزہ';

  @override
  String get statusPublished => 'شائع شدہ / لائیو';

  @override
  String get statusOffersReceived => 'آفرز موصول ہوئیں';

  @override
  String get statusPickupScheduled => 'پک اپ کا وقت طے ہو گیا';

  @override
  String get statusCompleted => 'مکمل شدہ';

  @override
  String get statusCancelled => 'منسوخ شدہ';

  @override
  String get priceOffersTitle => 'قیمت کی آفرز';

  @override
  String get offerAmount => 'پیش کردہ قیمت';

  @override
  String offeredBy(String buyerName) {
    return '$buyerName کی طرف سے پیش کردہ';
  }

  @override
  String get acceptOffer => 'آفر قبول کریں';

  @override
  String get rejectOffer => 'آفر مسترد کریں';

  @override
  String get offerAccepted => 'پیشکش قبول کر لی گئی';

  @override
  String get offerRejected => 'آفر مسترد کر دی گئی';

  @override
  String get buyerDashboardTitle => 'مارکیٹ';

  @override
  String get searchAuctionsHint => 'سولر پینلز، انورٹرز، اسکریپ تلاش کریں...';

  @override
  String get allCategories => 'تمام زمرے';

  @override
  String get liveAuctions => 'لائیو نیلامی';

  @override
  String get endingSoon => 'جلد ختم ہونے والی';

  @override
  String get highestBids => 'سب سے زیادہ بولیاں';

  @override
  String get savedAuctions => 'محفوظ شدہ نیلامیاں';

  @override
  String get myBids => 'میری بولیاں';

  @override
  String get noAuctionsFound => 'کوئی نیلامی نہیں ملی';

  @override
  String get noSavedAuctions => 'ابھی تک کوئی محفوظ شدہ نیلامی نہیں ہے';

  @override
  String get noBidsYet => 'آپ نے ابھی تک کوئی بولی نہیں لگائی';

  @override
  String get auctionDetailsTitle => 'نیلامی کی تفصیلات';

  @override
  String get currentBid => 'موجودہ بولی';

  @override
  String get startingBid => 'ابتدائی بولی';

  @override
  String get minimumIncrement => 'کم از کم اضافہ';

  @override
  String get timeLeft => 'باقی وقت';

  @override
  String get auctionEnds => 'اختتام';

  @override
  String get sellerInfo => 'بیچنے والے کی معلومات';

  @override
  String get location => 'مقام';

  @override
  String get specifications => 'خصوصیات';

  @override
  String get bidHistory => 'بولی کی تاریخ';

  @override
  String get placeBid => 'بولی لگائیں';

  @override
  String get enterBidAmount => 'بولی کی رقم درج کریں';

  @override
  String bidMustBeHigher(String amount) {
    return 'بولی کم از کم $amount ہونی چاہیے';
  }

  @override
  String get confirmBidTitle => 'اپنی بولی کی تصدیق کریں';

  @override
  String confirmBidPrompt(String amount) {
    return 'کیا آپ واقعی $amount کی بولی لگانا چاہتے ہیں؟';
  }

  @override
  String bidPlacedSuccess(String amount) {
    return 'آپ کی $amount کی بولی کامیابی سے لگ گئی!';
  }

  @override
  String get youAreHighestBidder => 'آپ اس وقت سب سے زیادہ بولی دینے والے ہیں!';

  @override
  String get youHaveBeenOutbid => 'اس لسٹنگ پر آپ سے زیادہ بولی لگ چکی ہے۔';

  @override
  String get settingsTitle => 'سیٹنگز';

  @override
  String get preferencesSection => 'ترجیحات';

  @override
  String get accountSection => 'اکاؤنٹ';

  @override
  String get securitySection => 'سیکیورٹی';

  @override
  String get supportSection => 'سپورٹ اور معلومات';

  @override
  String get languageLabel => 'زبان';

  @override
  String get selectLanguage => 'زبان منتخب کریں';

  @override
  String get languageEnglish => 'English (انگریزی)';

  @override
  String get languageUrdu => 'اردو (Urdu)';

  @override
  String languageChanged(String lang) {
    return 'زبان $lang میں تبدیل کر دی گئی';
  }

  @override
  String get notificationsTitle => 'اطلاعات (نوٹیفیکیشنز)';

  @override
  String get pushNotifications => 'پش نوٹیفیکیشنز';

  @override
  String get listingUpdates => 'لسٹنگ اپ ڈیٹس';

  @override
  String get priceOffersNotification => 'قیمت کی پیشکشیں اور بولیاں';

  @override
  String get productUpdates => 'پروڈکٹ اپ ڈیٹس';

  @override
  String get newAuctions => 'نئی نیلامیاں';

  @override
  String get bidUpdates => 'بولی کی اپ ڈیٹس';

  @override
  String get closingSoonAlerts => 'جلد ختم ہونے کے الرٹس';

  @override
  String get winningNotifications => 'جیتنے کی اطلاعات';

  @override
  String get twoFA => 'دو مرحلہ جاتی تصدیق (2FA)';

  @override
  String get twoFADesc =>
      'اپنے اکاؤنٹ کی حفاظت کے لیے اضافی سیکیورٹی شامل کریں';

  @override
  String get verified => 'تصدیق شدہ';

  @override
  String get unverified => 'غیر تصدیق شدہ';

  @override
  String get verifyNow => 'ابھی تصدیق کریں';

  @override
  String get changePassword => 'پاس ورڈ تبدیل کریں';

  @override
  String get currentPasswordLabel => 'موجودہ پاس ورڈ';

  @override
  String get editProfile => 'پروفائل میں ترمیم کریں';

  @override
  String get deleteAccount => 'اکاؤنٹ حذف کریں';

  @override
  String get deleteAccountConfirm =>
      'کیا آپ واقعی اپنا اکاؤنٹ حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں ہو سکتا اور آپ کا سارا ڈیٹا ہمیشہ کے لیے ختم ہو جائے گا۔';

  @override
  String get logout => 'لاگ آؤٹ';

  @override
  String get logoutConfirm => 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟';

  @override
  String get privacyPolicy => 'رازداری کی پالیسی (پرائیویسی پالیسی)';

  @override
  String get termsConditions => 'شرائط و ضوابط';

  @override
  String get helpCenter => 'ہیلپ سینٹر';

  @override
  String get contactSupport => 'سپورٹ سے رابطہ کریں';

  @override
  String get faq => 'اکثر پوچھے جانے والے سوالات';

  @override
  String get aboutUs => 'سولر اسکریپ کے بارے میں';

  @override
  String get version => 'سولر اسکریپ ورژن 1.0.0';

  @override
  String get copyright => '© 2026 سولر اسکریپ پلیٹ فارم۔ جملہ حقوق محفوظ ہیں۔';

  @override
  String get sellerSignUp => 'سیلر سائن اپ';

  @override
  String get sellerQuestion => 'بیچنے والے ہیں؟';

  @override
  String get buyerQuestion => 'خریدار ہیں؟';

  @override
  String get step1Of3Credentials => 'مرحلہ 1 از 3 · اسناد';

  @override
  String get orContinueWithEmail => 'یا ای میل سے جاری رکھیں';

  @override
  String get emailAddressRequired => 'ای میل ایڈریس *';

  @override
  String get passwordRequired => 'پاس ورڈ *';

  @override
  String get confirmPasswordRequired => 'پاس ورڈ کی تصدیق کریں *';

  @override
  String get createSecurePasswordHint => 'ایک محفوظ پاس ورڈ بنائیں';

  @override
  String get pwdRuleMinLength => 'کم از کم 8 حروف';

  @override
  String get pwdRuleUpperLower => 'بڑے اور چھوٹے حروف';

  @override
  String get pwdRuleNumberSymbol => 'کم از کم ایک نمبر یا علامت';

  @override
  String get pwdRuleMatch => 'پاس ورڈ مماثل ہیں';

  @override
  String get agreeToThe => 'میں متفق ہوں ';

  @override
  String get andAcknowledgeThe => ' اور تسلیم کرتا ہوں ';

  @override
  String get buyerNotificationCheckbox =>
      'نئی نیلامیوں اور مارکیٹ قیمتوں کے نوٹیفکیشن موصول کریں (اختیاری)';

  @override
  String get sellerNotificationCheckbox =>
      'اپنی لسٹنگز پر تجاویز اور آفرز کے نوٹیفکیشن موصول کریں (اختیاری)';

  @override
  String get continueToDetails => 'تفصیلات کی طرف بڑھیں';

  @override
  String get verifyYourEmail => 'اپنا ای میل تصدیق کریں';

  @override
  String get weSentVerificationLinkTo => 'ہم نے تصدیقی لنک بھیجا ہے\n';

  @override
  String get tapLinkToVerify =>
      '.\nبراہ کرم پتہ تصدیق کرنے کے لیے اپنے ان باکس میں لنک پر ٹیپ کریں۔';

  @override
  String get iHaveVerifiedLink => 'میں نے لنک تصدیق کر لیا ہے';

  @override
  String get emailNotVerifiedYet =>
      'ای میل کی ابھی تصدیق نہیں ہوئی۔ براہ کرم اپنا ان باکس یا اسپیم چیک کریں۔';

  @override
  String get resendLink => 'لنک دوبارہ بھیجیں';

  @override
  String get skipDevMode => 'چھوڑیں (ڈیو موڈ)';

  @override
  String get verificationLinkResent => 'تصدیقی لنک دوبارہ بھیج دیا گیا!';

  @override
  String get passwordRequirementsError =>
      'براہ کرم پاس ورڈ کی تمام حفاظتی شرائط پوری کریں۔';

  @override
  String get passwordsDoNotMatch => 'نئے پاس ورڈ مماثل نہیں ہیں';

  @override
  String get acceptTermsError =>
      'براہ کرم شرائط و ضوابط اور رازداری کی پالیسی قبول کریں۔';

  @override
  String get enterValidEmail => 'براہ کرم ایک درست ای میل درج کریں۔';

  @override
  String get enterEmail => 'براہ کرم اپنا ای میل درج کریں۔';

  @override
  String get businessAndLocation => 'کاروبار اور مقام';

  @override
  String get step2Of3BusinessDetails => 'مرحلہ 2 از 3 · کاروباری تفصیلات';

  @override
  String get uploadProfileLogo => 'پروفائل / لوگو اپ لوڈ کریں (اختیاری)';

  @override
  String get changePhoto => 'تصویر تبدیل کریں';

  @override
  String get contactPersonRequired => 'رابطہ کار / پورا نام *';

  @override
  String get companyYardNameRequired => 'کمپنی / یارڈ کا نام *';

  @override
  String get businessTypeRequired => 'کاروبار کی قسم *';

  @override
  String get selectBusinessType => 'کاروبار کی قسم منتخب کریں';

  @override
  String get businessTypeScrapDealer => 'اسکریپ ڈیلر';

  @override
  String get businessTypeRecycler => 'ری سائیکلر';

  @override
  String get businessTypeTraderBroker => 'تاجر / بروکر';

  @override
  String get businessTypeSolarEpc => 'سولر ای پی سی ٹھیکیدار';

  @override
  String get businessTypeManufacturer => 'مینوفیکچرر';

  @override
  String get businessTypeOtherBusiness => 'دیگر کاروبار';

  @override
  String get businessTypeSolarPlantOwner => 'سولر پلانٹ کا مالک';

  @override
  String get businessTypeCommercialIndustrial => 'تجارتی / صنعتی سہولت';

  @override
  String get businessTypeResidentHomeowner => 'رہائشی / گھر کا مالک';

  @override
  String get businessTypeOtherFacility => 'دیگر سہولت';

  @override
  String get businessTypeEpcContractor => 'ای پی سی ٹھیکیدار';

  @override
  String get businessTypeScrapDealerBroker => 'اسکریپ ڈیلر / بروکر';

  @override
  String get gstNtnOptional => 'جی ایس ٹی / این ٹی این نمبر (اختیاری)';

  @override
  String get businessLocationRequired => 'کاروبار / گودام کا مقام *';

  @override
  String get pinOnMap => 'نقشے پر نشان لگائیں';

  @override
  String get streetAddressRequired => 'گلی کا پتہ *';

  @override
  String get cityRequired => 'شہر *';

  @override
  String get areaDistrictLabel => 'علاقہ / ضلع';

  @override
  String get continueToMobileVerification => 'موبائل تصدیق کی طرف بڑھیں';

  @override
  String get enterNameError => 'اپنا نام درج کریں';

  @override
  String get enterCompanyNameError => 'اپنی کمپنی یا کاروبار کا نام درج کریں';

  @override
  String get enterStreetAddressError => 'براہ کرم گلی کا پتہ درج کریں';

  @override
  String get enterCityError => 'شہر درج کریں';

  @override
  String get mobileVerification => 'موبائل کی تصدیق';

  @override
  String get step3Of3MobileVerification => 'مرحلہ 3 از 3 · موبائل تصدیق (2FA)';

  @override
  String get verifyMobileNumber => 'موبائل نمبر کی تصدیق کریں';

  @override
  String get protectAccount2FADesc =>
      'اپنے اسکریپ کے سودوں اور اکاؤنٹ کو ٹو فیکٹر تصدیق (2FA) سے محفوظ بنائیں۔';

  @override
  String get mobileNumberLabel => 'موبائل نمبر';

  @override
  String get sendCode => 'کوڈ بھیجیں';

  @override
  String get resend => 'دوبارہ بھیجیں';

  @override
  String get enter6DigitCode => '6 ہندسوں کا کوڈ درج کریں';

  @override
  String get didntGetCode => 'کوڈ نہیں ملا؟';

  @override
  String get resendNow => 'ابھی دوبارہ بھیجیں';

  @override
  String get verifyAndCompleteRegistration =>
      'تصدیق کریں اور رجسٹریشن مکمل کریں';

  @override
  String get enterValidMobileNumber =>
      'براہ کرم ایک درست موبائل نمبر درج کریں۔';

  @override
  String get enterCompleteOtpCode =>
      'براہ کرم پورا 6 ہندسوں کا او ٹی پی کوڈ درج کریں۔';

  @override
  String get invalidOtpCode => 'غلط کوڈ۔ براہ کرم درست کوڈ یا 000000 درج کریں۔';

  @override
  String get registrationFailed => 'رجسٹریشن ناکام ہوگئی۔ دوبارہ کوشش کریں۔';

  @override
  String codeSentTo(String phone) {
    return '$phone پر تصدیقی کوڈ بھیج دیا گیا';
  }

  @override
  String get forgotPasswordTitle => 'پاس ورڈ بھول گئے';

  @override
  String get enterEmailOrPhoneReset =>
      'ری سیٹ او ٹی پی حاصل کرنے کے لیے اپنا ای میل یا فون درج کریں';

  @override
  String get emailOrPhoneLabel => 'ای میل یا فون';

  @override
  String get emailOrPhoneHint => 'name@example.com یا 0300 1234567';

  @override
  String get sendOtp => 'او ٹی پی بھیجیں';

  @override
  String get backToLogin => 'لاگ ان پر واپس جائیں';

  @override
  String get passwordResetTitle => 'پاس ورڈ ری سیٹ ہو گیا!';

  @override
  String get passwordResetSuccessDesc =>
      'آپ کا پاس ورڈ کامیابی سے اپ ڈیٹ ہو گیا ہے۔';

  @override
  String get accountUnderReview => 'اکاؤنٹ زیر جائزہ ہے';

  @override
  String get accountApproved => 'اکاؤنٹ منظور ہو گیا!';

  @override
  String get goToDashboard => 'ڈیش بورڈ پر جائیں';

  @override
  String get checkStatus => 'حیثیت چیک کریں';

  @override
  String get pleaseEnterEmailOrPhone => 'براہ کرم اپنا ای میل یا فون درج کریں';

  @override
  String get verifyOtpTitle => 'او ٹی پی کی تصدیق کریں';

  @override
  String get verificationCode => 'تصدیقی کوڈ';

  @override
  String enterOtpSentToPhone(String phone) {
    return 'اپنے موبائل نمبر پر بھیجا گیا 6 ہندسوں کا کوڈ درج کریں\nجس کے آخر میں $phone ہے';
  }

  @override
  String resendInSeconds(String seconds) {
    return 'دوبارہ بھیجیں 00:$seconds میں';
  }

  @override
  String get verifyAccount => 'اکاؤنٹ کی تصدیق کریں';

  @override
  String get pleaseEnterAll6Digits => 'براہ کرم تمام 6 ہندسے درج کریں';

  @override
  String get didntReceiveCodeCheckSpam =>
      'کیا کوڈ موصول نہیں ہوا؟ اپنا اسپیم فولڈر چیک کریں یا دوبارہ کوشش کریں۔';

  @override
  String get accountVerifiedSuccess =>
      '🎉 اکاؤنٹ کی تصدیق ہو گئی! ایڈمن نے آپ کا اکاؤنٹ منظور کر لیا ہے۔';

  @override
  String get accountVerifiedBuyerSuccess =>
      '🎉 اکاؤنٹ کی تصدیق ہو گئی! ایڈمن نے آپ کا خریدار اکاؤنٹ منظور کر لیا ہے۔';

  @override
  String get statusPendingApprovalDesc =>
      'اسٹیٹس: ایڈمن کی منظوری کا انتظار ہے۔ براہ کرم ویب پورٹل سے منظور کریں۔';

  @override
  String get buyerAccountApprovedTitle => 'خریدار اکاؤنٹ منظور ہو گیا!';

  @override
  String get sellerAccountApprovedTitle => 'اکاؤنٹ منظور اور فعال ہے!';

  @override
  String get accountRequestSubmittedTitle => 'اکاؤنٹ کی درخواست جمع کر دی گئی';

  @override
  String get buyerApprovedDesc =>
      'آپ کے ڈیلر رجسٹریشن کی تصدیق اور ایڈمن ٹیم کی جانب سے منظوری ہو گئی ہے۔ اب آپ نیلامی دیکھ سکتے ہیں اور بولیاں لگا سکتے ہیں۔';

  @override
  String get sellerApprovedDesc =>
      'آپ کی سیلر پروفائل کی تصدیق اور سولر اسکریپ ایڈمن ٹیم نے منظوری دے دی ہے۔ اب آپ کو لسٹنگ بنانے اور فروخت کا مکمل انتظام کرنے کی رسائی حاصل ہے۔';

  @override
  String get accountPendingReviewDesc =>
      'آپ کی رجسٹریشن کی درخواست ایڈمن کے جائزے کے لیے جمع کر دی گئی ہے۔ ایڈمن ٹیم سے تصدیق اور منظوری کے بعد آپ کا اکاؤنٹ خود بخود کھل جائے گا۔';

  @override
  String get statusApprovedVerified => 'اسٹیٹس: منظور شدہ اور تصدیق شدہ';

  @override
  String get statusPendingAdminApproval => 'اسٹیٹس: ایڈمن کی منظوری کا انتظار';

  @override
  String verifiedBuyerAccountAt(String location) {
    return 'تصدیق شدہ خریدار اکاؤنٹ · $location';
  }

  @override
  String pendingVerificationAt(String location) {
    return 'زیر التواء تصدیق · $location';
  }

  @override
  String verifiedSellerAccountAt(String location) {
    return 'تصدیق شدہ سیلر اکاؤنٹ · $location';
  }

  @override
  String get checkApprovalStatus => 'منظوری کی حیثیت چیک کریں';

  @override
  String get monitoringAdminApprovalDesc =>
      'ایپ فعال طور پر ایڈمن کی منظوری پر نظر رکھے ہوئے ہے۔ ویب پورٹل پر منظوری ملتے ہی رسائی خود بخود کھل جائے گی۔';

  @override
  String get switchAccountReturnSignIn =>
      'اکاؤنٹ تبدیل کریں / دوبارہ لاگ ان کریں';

  @override
  String get createFirstListing => 'پہلی لسٹنگ بنائیں';

  @override
  String get homeTab => 'ہوم';

  @override
  String get auctionsTab => 'نیلامیاں';

  @override
  String get myBidsTab => 'میری بولیاں';

  @override
  String get profileTab => 'پروفائل';

  @override
  String get listingTab => 'لسٹنگ';

  @override
  String get alertsTab => 'الرٹس';

  @override
  String get goodMorning => 'صبح بخیر،';

  @override
  String get searchAuctionsEquipmentHint => 'نیلامی اور آلات تلاش کریں...';

  @override
  String get searchBidsHint => 'بولیاں تلاش کریں';

  @override
  String get searchListingsHint => 'لسٹنگز تلاش کریں...';

  @override
  String get activeBids => 'فعال بولیاں';

  @override
  String get wonAuctions => 'جیتی گئی نیلامیاں';

  @override
  String get totalBids => 'کل بولیاں';

  @override
  String get latestAuctions => 'تازہ ترین نیلامیاں';

  @override
  String get seeAll => 'سب دیکھیں';

  @override
  String get featuredAuction => 'نمایاں نیلامی';

  @override
  String get exploreAuctions => 'نیلامیاں دیکھیں';

  @override
  String get viewAuction => 'نیلامی دیکھیں';

  @override
  String get bidNow => 'ابھی بولی لگائیں';

  @override
  String get priceDemand => 'طلب کردہ قیمت';

  @override
  String get verifiedBuyer => 'تصدیق شدہ خریدار';

  @override
  String get verifiedSeller => 'تصدیق شدہ سیلر';

  @override
  String get scrapDealerBuyer => 'اسکریپ ڈیلر / خریدار';

  @override
  String get solarEquipmentSeller => 'سولر آلات کا سیلر';

  @override
  String get contactInformation => 'رابطے کی معلومات';

  @override
  String get notificationSettings => 'نوٹیفکیشن کی ترتیبات';

  @override
  String get readyToSell => 'کیا آپ فروخت کے لیے تیار ہیں؟';

  @override
  String get readyToSellDesc =>
      'اپنا سولر اسکریپ پوسٹ کریں اور بہترین پیشکشیں حاصل کریں';

  @override
  String get sellSolarScrap => 'سولر اسکریپ فروخت کریں';

  @override
  String get totalListings => 'کل لسٹنگز';

  @override
  String get alertsAndNotifications => 'الرٹس اور نوٹیفیکیشنز';

  @override
  String get markAllAsRead => 'تمام کو پڑھا ہوا نشان زد کریں';

  @override
  String get noActiveAuctionsFound =>
      'اس کیٹیگری میں کوئی فعال نیلامی نہیں ملی';

  @override
  String noBidsFoundUnderStatus(String status) {
    return '$status کے تحت کوئی بولی نہیں ملی';
  }

  @override
  String get filterAll => 'تمام';

  @override
  String get filterActive => 'فعال';

  @override
  String get filterWinning => 'جیتنے والی';

  @override
  String get filterClosed => 'بند';

  @override
  String get filterOutbid => 'آؤٹ بڈ';

  @override
  String get filterSold => 'فروخت شدہ';

  @override
  String get filterDraft => 'ڈرافٹ';

  @override
  String get marketplaceHeroTag => 'سولر اسکریپ مارکیٹ پلیس';

  @override
  String get verifiedAuctionsTitle => 'تصدیق شدہ سولر اسکریپ نیلامی';

  @override
  String get exploreAuctionsSubtitle =>
      'پورے پاکستان میں سولر پینلز، انورٹرز اور بیٹریاں دریافت کریں۔';

  @override
  String get noMatchingAuctionsFound =>
      'مارکیٹ پلیس پر کوئی مماثل نیلامی نہیں ملی';

  @override
  String get refresh => 'ریفریش کریں';

  @override
  String get filterLatest => 'تازہ ترین';

  @override
  String get filterLowestPrice => 'کم ترین قیمت';

  @override
  String get filterHighestPrice => 'زیادہ ترین قیمت';

  @override
  String get categoryTransformers => 'ٹرانسفارمرز';

  @override
  String get notProvided => 'فراہم نہیں کیا گیا';

  @override
  String get notSet => 'متعین نہیں';

  @override
  String get signOut => 'سائن آؤٹ کریں';

  @override
  String get signOutConfirmation =>
      'کیا آپ واقعی اپنے اکاؤنٹ سے سائن آؤٹ کرنا چاہتے ہیں؟';

  @override
  String get recentListings => 'حالیہ لسٹنگز';

  @override
  String get noListingsYet => 'ابھی تک کوئی لسٹنگ نہیں ہے';

  @override
  String get tapSellSolarScrapToAdd =>
      'اپنی پہلی لسٹنگ شامل کرنے کے لیے اوپر \"سولر اسکریپ بیچیں\" پر ٹیپ کریں!';

  @override
  String get filterSubmitted => 'جمع شدہ';

  @override
  String get filterUnderReview => 'زیر جائزہ';

  @override
  String get filterPriceOffered => 'پیش کردہ قیمت';

  @override
  String get askingPrice => 'طلب کردہ قیمت';

  @override
  String get noMatchingListings => 'کوئی مماثل لسٹنگ نہیں ملی';

  @override
  String get noListingsCreatedYet => 'ابھی تک کوئی لسٹنگ نہیں بنائی گئی';

  @override
  String get tryChangingSearchFilter =>
      'تلاش کا لفظ یا فلٹر تبدیل کرنے کی کوشش کریں';

  @override
  String get tapPlusToCreateListing =>
      'اپنی پہلی لسٹنگ بنانے کے لیے نیچے + بٹن پر ٹیپ کریں';

  @override
  String get noNotificationsYet => 'ابھی تک کوئی نوٹیفکیشن نہیں ہے';

  @override
  String get listingsTitle => 'لسٹنگز';

  @override
  String get dealsTitle => 'ڈیلز';

  @override
  String get earningsTitle => 'آمدنی';

  @override
  String get personalInformation => 'ذاتی معلومات';

  @override
  String get companyInformation => 'کمپنی کی معلومات';

  @override
  String get companyLabel => 'کمپنی';

  @override
  String get gstLabel => 'جی ایس ٹی';

  @override
  String get typeLabel => 'قسم';

  @override
  String get buyerRoleFallback => 'خریدار';

  @override
  String get sellerRoleFallback => 'فروخت کنندہ';

  @override
  String get statusWon => 'جیت گیا';

  @override
  String get statusLost => 'ہار گیا';

  @override
  String get statusPending => 'زیر التواء';

  @override
  String get newListingTitle => 'نئی لسٹنگ';

  @override
  String get equipmentCategory => 'سامان کا زمرہ';

  @override
  String get whatTypeOfEquipment => 'آپ کس قسم کا سامان فروخت کر رہے ہیں؟';

  @override
  String get completeSolarSystem => 'مکمل سولر سسٹم';

  @override
  String stepXOfY(int current, int total) {
    return 'مرحلہ $current از $total';
  }

  @override
  String get uploadImages => 'تصاویر اپ لوڈ کریں';

  @override
  String get addUpTo10Photos => '10 تک تصاویر شامل کریں';

  @override
  String get addPhoto => 'تصویر شامل کریں';

  @override
  String get camera => 'کیمرہ';

  @override
  String get gallery => 'گیلری';

  @override
  String listingDetailsStepImages(int current, int total) {
    return 'لسٹنگ کی تفصیلات · مرحلہ $current از $total (تصاویر)';
  }

  @override
  String failedToPickImage(String error) {
    return 'تصویر منتخب کرنے میں ناکامی: $error';
  }

  @override
  String get imageUploadFailed =>
      'تصویر اپ لوڈ ناکام ہو گئی۔ براہ کرم اپنا انٹرنیٹ چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String listingDetailsStepLocation(int current, int total) {
    return 'لسٹنگ کی تفصیلات · مرحلہ $current از $total (مقام)';
  }

  @override
  String get areaLocalityOptional => 'علاقہ / لوکلٹی (اختیاری)';

  @override
  String get areaHint => 'ڈی ایچ اے فیز 7، کراچی';

  @override
  String get completeAddress => 'مکمل پتہ';

  @override
  String get completeAddressHint => 'گلی، عمارت، علاقے کی تفصیلات...';

  @override
  String listingDetailsStepContact(int current, int total) {
    return 'لسٹنگ کی تفصیلات · مرحلہ $current از $total (رابطہ)';
  }

  @override
  String get prefilledFromProfile =>
      'آپ کے پروفائل سے پہلے سے بھرا ہوا۔ ضرورت ہو تو ترمیم کریں۔';

  @override
  String get listingPreviewTitle => 'لسٹنگ کا پیش نظارہ';

  @override
  String listingDetailsStepPreview(int current, int total) {
    return 'لسٹنگ کی تفصیلات · مرحلہ $current از $total (پیش نظارہ)';
  }

  @override
  String get previewBadge => 'پیش نظارہ';

  @override
  String imagesCountLabel(int count) {
    return 'تصاویر ($count)';
  }

  @override
  String get noPhotosUploaded => 'کوئی تصویر اپ لوڈ نہیں ہوئی';

  @override
  String get locationAndContact => 'مقام اور رابطہ';

  @override
  String get startOver => 'دوبارہ شروع کریں';

  @override
  String get editButton => 'ترمیم';

  @override
  String get failedToSubmitListing =>
      'لسٹنگ جمع کروانے میں ناکامی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get numberOfPanels => 'پینلز کی تعداد';

  @override
  String get wattsPerPanel => 'واٹ فی پینل';

  @override
  String get wattsPerPanelUnit => 'واٹ فی پینل (W)';

  @override
  String get capacity => 'صلاحیت';

  @override
  String get brand => 'برانڈ';

  @override
  String get brandHint => 'برانڈ کا نام درج کریں';

  @override
  String get ratedPower => 'شرح شدہ طاقت (پاور)';

  @override
  String get cableType => 'کیبل کی قسم';

  @override
  String get conductor => 'کنڈکٹر';

  @override
  String get insulation => 'انسولیشن';

  @override
  String get cableSize => 'کیبل کا سائز';

  @override
  String get structureType => 'سٹرکچر کی قسم';

  @override
  String get metal => 'دھات';

  @override
  String get panels => 'پینلز';

  @override
  String get inverter => 'انورٹر';

  @override
  String get structure => 'سٹرکچر';

  @override
  String get listingSubmittedReviewTitle =>
      'لسٹنگ جائزے کے لیے جمع کرا دی گئی ہے';

  @override
  String get listingSubmittedReviewDesc =>
      'آپ کی لسٹنگ ایڈمن کی منظوری کے لیے جمع کر دی گئی ہے۔ منظور ہونے کے بعد یہ مارکیٹ پلیس پر لائیو ہو جائے گی۔';

  @override
  String get listingIdLabel => 'لسٹنگ آئی ڈی';

  @override
  String get pendingApproval => 'منظوری زیر التواء';

  @override
  String get listingDetailsTitle => 'لسٹنگ کی تفصیلات';

  @override
  String get equipmentDetailsTitle => 'سامان کی تفصیلات';

  @override
  String get pickupCity => 'پک اپ کا شہر';

  @override
  String get pickupArea => 'پک اپ کا علاقہ';

  @override
  String get contactPerson => 'رابطہ کار';

  @override
  String get trackStatus => 'حیثیت ٹریک کریں';

  @override
  String get lakhUnit => 'لاکھ';

  @override
  String get currentlyLabel => 'فی الحال: ';

  @override
  String get bidsReceived => 'موصول شدہ بولیاں';

  @override
  String totalBadge(int count) {
    return '$count کل';
  }

  @override
  String get noBidsPlacedYet => 'ابھی تک کوئی بولی نہیں لگی';

  @override
  String get bidsWillAppearRealtime =>
      'خریداروں کی بولیاں یہاں ریئل ٹائم میں ظاہر ہوں گی۔';

  @override
  String get reviewOffer => 'پیشکش کا جائزہ لیں';

  @override
  String get statusAccepted => 'قبول شدہ';

  @override
  String get statusDeclined => 'مسترد شدہ';

  @override
  String get statusPendingOffer => 'زیر التواء پیشکش';

  @override
  String get activeOnMarket => 'مارکیٹ پر فعال';

  @override
  String get negotiationReview => 'مذاکرات / جائزہ';

  @override
  String get dealClosed => 'ڈیل مکمل';

  @override
  String get acceptingBidsFromBuyers => 'خریداروں سے بولیاں قبول کر رہے ہیں';

  @override
  String get awaitingBuyerBids => 'خریداروں کی بولیوں کا انتظار ہے';

  @override
  String get actionRequired => 'کارروائی درکار ہے';

  @override
  String get pendingAgreement => 'معاہدہ زیر التواء ہے';

  @override
  String bidsReceivedCount(int count) {
    return '$count بولی(اں) موصول ہوئیں';
  }

  @override
  String reviewingOffersCount(int count) {
    return '$count پیشکش(وں) کا جائزہ لیا جا رہا ہے';
  }

  @override
  String get awaitingBuyerOffers => 'خریداروں کی پیشکشوں کا انتظار ہے';

  @override
  String get panelCondition => 'پینل کی حالت';

  @override
  String get conditionScrap => 'سکریپ';

  @override
  String get conditionBulletHit => 'بلٹ ہٹ';

  @override
  String get conditionShatterGlass => 'ٹوٹا ہوا شیشہ';

  @override
  String get conditionGood => 'اچھی حالت';

  @override
  String get conditionOther => 'دیگر';

  @override
  String get conditionWorking => 'چلتا ہوا (ورکنگ)';

  @override
  String get conditionNonWorking => 'خراب (نان ورکنگ)';

  @override
  String get inverterTypeHybrid => 'ہائبرڈ';

  @override
  String get inverterTypeOnGrid => 'آن گرڈ';

  @override
  String get batteryTypeLithium => 'لیتھیم';

  @override
  String get cableTypeAC => 'اے سی';

  @override
  String get cableTypeDC => 'ڈی سی';

  @override
  String get insulationPVC => 'پی وی سی';

  @override
  String get insulationXLPE => 'ایکس ایل پی ای';

  @override
  String get structureElevated => 'بلند (ایلیویٹڈ)';

  @override
  String get structureRooftop => 'چھت پر (روف ٹاپ)';

  @override
  String get structureGround => 'زمین پر (گراؤنڈ)';

  @override
  String get metalGI => 'جی آئی';

  @override
  String get completeSystemPanelsTitle => 'مکمل سسٹم: پینلز';

  @override
  String get completeSystemInvertersTitle => 'مکمل سسٹم: انورٹر';

  @override
  String get completeSystemBatteriesTitle => 'مکمل سسٹم: بیٹریاں';

  @override
  String get completeSystemStructureTitle => 'مکمل سسٹم: سٹرکچر';

  @override
  String get completeSystemCablesTitle => 'مکمل سسٹم: کیبلز';

  @override
  String get completeSystemBannerPanels => 'مکمل سسٹم · سولر پینلز';

  @override
  String get completeSystemBannerInverter => 'مکمل سسٹم · انورٹر';

  @override
  String get completeSystemBannerBatteries => 'مکمل سسٹم · بیٹریاں';

  @override
  String get completeSystemBannerStructure => 'مکمل سسٹم · سٹرکچر';

  @override
  String get completeSystemBannerCables => 'مکمل سسٹم · کیبلز';

  @override
  String get notSpecified => 'وضاحت نہیں کی گئی';

  @override
  String get noPhone => 'کوئی فون نہیں';

  @override
  String get statusLabel => 'حیثیت';

  @override
  String get addressLabel => 'پتہ';

  @override
  String stepXOfYWithDetail(int current, int total, String detail) {
    return 'مرحلہ $current از $total ($detail)';
  }

  @override
  String get batteryTypeLeadAcid => 'لیڈ ایسڈ';

  @override
  String get batteryTypeTabular => 'ٹیبلر';

  @override
  String get numberOfBatteries => 'بیٹریوں کی تعداد';

  @override
  String get batteryCountHint => 'بیٹریوں کی تعداد درج کریں';

  @override
  String get batteryCapacityKw => 'بیٹری کی گنجائش (کلو واٹ)';

  @override
  String get batteryCapacityAmp => 'بیٹری کی گنجائش (ایمپیئر)';

  @override
  String get manufacturerBrand => 'کارخانہ دار / برانڈ';

  @override
  String get purchaseYear => 'خریداری کا سال';

  @override
  String get noOfYearUsed => 'استعمال شدہ سال';

  @override
  String get batteryConditions => 'بیٹری کی حالت';

  @override
  String get conductorCopper => 'تانبا (کاپر)';

  @override
  String get conductorAL => 'ایلومینیم (AL)';

  @override
  String get insulationRubber => 'ربڑ';

  @override
  String get insulationThermoplastic => 'تھرموپلاسٹک';

  @override
  String get commentsOptional => 'تبصرے (اختیاری)';

  @override
  String get commentsHint => 'تفصیل سے بیان کریں ......';

  @override
  String get structureNonElevated => 'نان ایلیویٹڈ';

  @override
  String get structureMetal => 'سٹرکچر میٹل';

  @override
  String get metalAL => 'ایلومینیم (AL)';

  @override
  String get metalGL => 'جی ایل (GL)';

  @override
  String get metalHotDip => 'ہاٹ ڈِپ';

  @override
  String get othersComponentsTitle => 'دیگر اجزاء';

  @override
  String get totalPriceDemand => 'کل طلب کردہ قیمت';

  @override
  String get stepFinalDetails => 'آخری تفصیلات';

  @override
  String get stepDetailPanels => 'پینلز';

  @override
  String get stepDetailInverters => 'انورٹرز';

  @override
  String get stepDetailBatteries => 'بیٹریاں';

  @override
  String get stepDetailCables => 'کیبلز';

  @override
  String get stepDetailStructure => 'سٹرکچر';

  @override
  String get structureDetails => 'سٹرکچر کی تفصیلات';

  @override
  String get othersCommentsHint =>
      'مثال کے طور پر مواصلاتی آلات، سوئچ گیئرز وغیرہ...';

  @override
  String get cableSizeHint => 'مثال کے طور پر 12 میٹر';

  @override
  String get batteryYearsUsedHint => 'مثال کے طور پر 1 سال';

  @override
  String get purchaseYearHint => 'مثال کے طور پر 2019';

  @override
  String get batteryCapacityKwHint => 'مثال کے طور پر 5 کلو واٹ';

  @override
  String get batteryCapacityAmpHint => 'مثال کے طور پر 200 ایمپیئر';

  @override
  String get cableConductor => 'کیبل کنڈکٹر';

  @override
  String get insulationType => 'انسولیشن کی قسم';

  @override
  String get detailsTab => 'تفصیلات';

  @override
  String get specsTab => 'خصوصیات';

  @override
  String get timelineTab => 'ٹائم لائن';

  @override
  String get sellerContactDetailsTitle => 'فروخت کنندہ کی تفصیلات';

  @override
  String get placeYourBid => 'اپنی بولی لگائیں';

  @override
  String get startingPrice => 'ابتدائی قیمت';

  @override
  String get currentHighestBid => 'موجودہ سب سے زیادہ بولی';

  @override
  String get minimumBid => 'کم از کم بولی';

  @override
  String get yourBidAmountPkr => 'آپ کی بولی کی رقم (روپے)';

  @override
  String get reviewBidBeforeSubmitting =>
      'براہ کرم جمع کرانے سے پہلے اپنی بولی کا جائزہ لیں۔';

  @override
  String get yourBid => 'آپ کی بولی';

  @override
  String get submitBid => 'بولی جمع کروائیں';

  @override
  String get failedToPlaceBid =>
      'بولی لگانے میں ناکامی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get bidSubmittedTitle => 'بولی جمع ہو گئی!';

  @override
  String get bidSubmittedSubtitle =>
      'آپ کی بولی اب لائیو ہے۔ جیتنے پر آپ کو مطلع کیا جائے گا۔';

  @override
  String get goToMyBids => 'میری بولیوں پر جائیں';

  @override
  String get bidDetails => 'بولی کی تفصیلات';

  @override
  String get myBidAmount => 'میری بولی کی رقم';

  @override
  String get bidDate => 'بولی کی تاریخ';

  @override
  String get currentHighest => 'موجودہ سب سے زیادہ';

  @override
  String get equipmentSpecifications => 'سامان کی خصوصیات';

  @override
  String get sellerContactInformation => 'فروخت کنندہ کی معلومات';

  @override
  String get viewFullAuctionListing => 'مکمل نیلامی لسٹنگ دیکھیں';

  @override
  String get bidAcceptedBannerTitle => 'آپ کی بولی قبول کر لی گئی!';

  @override
  String get bidAcceptedBannerDesc =>
      'فروخت کنندہ نے آپ کی پیشکش قبول کر لی ہے۔ وہ ادائیگی اور سامان اٹھانے کے لیے رابطہ کریں گے۔';

  @override
  String get searchSavedAuctionsHint => 'محفوظ شدہ نیلامیاں تلاش کریں...';

  @override
  String get tapHeartToSaveAuctions =>
      'فوری رسائی کے لیے کسی بھی نیلامی پر دل کے نشان کو دبائیں۔';

  @override
  String placeBidOnAuction(String title) {
    return '$title پر بولی لگائیں';
  }

  @override
  String currentDemand(String price) {
    return 'موجودہ طلب: $price';
  }

  @override
  String minimumBidIs(String amount) {
    return 'کم از کم بولی $amount ہے';
  }

  @override
  String get auctionLabel => 'نیلامی';

  @override
  String get referenceNumber => 'حوالہ نمبر';

  @override
  String auctionIdPrefix(String id) {
    return 'نیلامی آئی ڈی: $id';
  }

  @override
  String get bidWinningBannerTitle => 'آپ فی الوقت جیت رہے ہیں!';

  @override
  String get bidWinningBannerDesc =>
      'آپ کی بولی اس وقت سب سے زیادہ ہے۔ نیلامی بند ہونے پر آپ کو مطلع کیا جائے گا۔';

  @override
  String get bidActiveBannerTitle => 'بولی جمع اور فعال ہے';

  @override
  String get bidActiveBannerDesc =>
      'آپ کی پیشکش بیچنے والے کو بھیج دی گئی ہے۔ جب وہ جائزہ لیں گے یا قبول کریں گے تو آپ کو مطلع کیا جائے گا۔';

  @override
  String get bidOutbidBannerTitle => 'کسی اور نے آپ سے زیادہ بولی لگائی ہے';

  @override
  String get bidOutbidBannerDesc =>
      'ایک اور خریدار نے زیادہ پیشکش جمع کرائی ہے۔ اپنی بولی بڑھانے کے لیے نیلامی پر واپس جائیں۔';

  @override
  String get timelineStepBidSubmitted => 'بولی جمع کرائی گئی';

  @override
  String get timelineStepUnderSellerReview => 'بیچنے والے کے زیر جائزہ';

  @override
  String get timelineStepBidAccepted => 'بیچنے والے نے بولی قبول کر لی';

  @override
  String get timelineStepDealFinalized => 'ڈیل مکمل ہو گئی';

  @override
  String get timelineStepAuctionRunning => 'نیلامی جاری ہے';

  @override
  String get timelineStepOfferDeclined => 'پیشکش مسترد / بند کر دی گئی';

  @override
  String get timelineStepAuctionClosed => 'نیلامی بند ہو گئی';

  @override
  String get timelineStepHighestBidder => 'سب سے زیادہ بولی دہندہ';

  @override
  String get timelineStepSellerDecision => 'بیچنے والے کا فیصلہ';

  @override
  String get loadingAuctionDetails =>
      'نیلامی کی مکمل تفصیلات لوڈ ہو رہی ہیں...';

  @override
  String get featuredBadge => 'نمایاں';

  @override
  String get priceOfferTitle => 'قیمت کی پیشکش';

  @override
  String get acceptOfferPrompt => 'کیا یہ پیشکش قبول کریں؟';

  @override
  String acceptOfferDesc(String price, String title) {
    return 'آپ $title کے لیے $price قبول کر رہے ہیں۔ اس عمل کو واپس نہیں کیا جا سکتا۔';
  }

  @override
  String acceptOfferCloseDealDesc(String price, String title) {
    return 'آپ $title کے لیے $price قبول کر رہے ہیں۔ یہ عمل ڈیل کو بند کر دے گا۔';
  }

  @override
  String get confirmAccept => 'قبولیت کی تصدیق کریں';

  @override
  String get offerAcceptedSuccess =>
      'پیشکش کامیابی سے قبول ہو گئی! ڈیل مکمل ہو گئی۔';

  @override
  String get failedToAcceptOffer =>
      'پیشکش قبول کرنے میں ناکامی۔ دوبارہ کوشش کریں۔';

  @override
  String get rejectOfferPrompt => 'کیا یہ پیشکش مسترد کریں؟';

  @override
  String rejectOfferDesc(String price) {
    return 'خریدار کو مطلع کیا جائے گا کہ ان کی $price کی بولی مسترد کر دی گئی ہے۔';
  }

  @override
  String get confirmReject => 'مسترد کرنے کی تصدیق کریں';

  @override
  String get offerRejectedSnackbar => 'پیشکش مسترد کر دی گئی۔';

  @override
  String get failedToRejectOffer => 'پیشکش مسترد کرنے میں ناکامی۔';

  @override
  String refPrefix(String ref) {
    return 'حوالہ: $ref';
  }

  @override
  String get offeredPriceLabel => 'پیشکش کردہ قیمت';

  @override
  String yourAskingPrefix(String price) {
    return 'آپ کی طلب: $price';
  }

  @override
  String bidDetailsSubtitle(String buyer, String date) {
    return 'بولی $buyer نے $date کو لگائی۔ قبول کرنے کی تصدیق سے یہ ڈیل بند ہو جائے گی اور خریدار کو فوری مطلع کیا جائے گا۔';
  }

  @override
  String buyerOfferedDesc(String price) {
    return 'ایک خریدار نے اس سامان کے لیے $price کی پیشکش کی ہے۔ شرائط کا جائزہ لیں اور نیچے اپنا فیصلہ منتخب کریں۔';
  }

  @override
  String get changeProfilePhoto => 'پروفائل تصویر تبدیل کریں';

  @override
  String get takePhotoCamera => 'تصویر لیں (کیمرہ)';

  @override
  String get profilePhotoUpdated => 'پروفائل تصویر کامیابی سے اپ ڈیٹ ہو گئی!';

  @override
  String get failedToUploadPhoto =>
      'تصویر اپ لوڈ کرنے میں ناکامی۔ براہ کرم بیک اینڈ کنکشن چیک کریں۔';

  @override
  String errorSelectingImage(String error) {
    return 'تصویر منتخب کرنے میں خرابی: $error';
  }

  @override
  String get fullNameEmpty => 'پورا نام خالی نہیں ہو سکتا';

  @override
  String get profileUpdatedSuccess => 'پروفائل کامیابی سے اپ ڈیٹ ہو گئی!';

  @override
  String get failedToUpdateProfile =>
      'پروفائل اپ ڈیٹ کرنے میں ناکامی۔ یقینی بنائیں کہ بیک اینڈ چل رہا ہے۔';

  @override
  String get tapPhotoToChange => 'تصویر تبدیل کرنے کے لیے ٹیپ کریں';

  @override
  String get fullNamePlaceholder => 'آپ کا پورا نام';

  @override
  String get companyNamePlaceholder => 'کمپنی کا نام پرائیویٹ لمیٹڈ';

  @override
  String get emailAddressLabel => 'ای میل ایڈریس';

  @override
  String get pleaseEnterFullName => 'براہ کرم اپنا پورا نام درج کریں';

  @override
  String get areaStreetAddress => 'علاقہ / گلی کا پتہ';

  @override
  String get areaStreetHint => 'مثلاً سائٹ ایریا، گلبرگ';

  @override
  String get cityHintBuyer => 'مثلاً کراچی، لاہور، اسلام آباد';

  @override
  String get phoneHintBuyer => 'مثلاً +92 300 1234567';

  @override
  String get enterFullNameHint => 'اپنا پورا نام درج کریں';

  @override
  String couldNotPickPhoto(String error) {
    return 'تصویر منتخب نہیں ہو سکی: $error';
  }

  @override
  String get createNewPassword => 'نیا پاس ورڈ بنائیں';

  @override
  String get passwordDifferenceNotice =>
      'آپ کا نیا پاس ورڈ پہلے استعمال شدہ پاس ورڈز سے مختلف ہونا چاہیے۔';

  @override
  String get enterCurrentPassword => 'موجودہ پاس ورڈ درج کریں';

  @override
  String get reenterNewPassword => 'نیا پاس ورڈ دوبارہ درج کریں';

  @override
  String get updatePassword => 'پاس ورڈ اپ ڈیٹ کریں';

  @override
  String get enterCurrentPasswordPrompt =>
      'براہ کرم اپنا موجودہ پاس ورڈ درج کریں';

  @override
  String get passwordMinLength =>
      'نیا پاس ورڈ کم از کم 6 حروف پر مشتمل ہونا چاہیے';

  @override
  String get failedToUpdatePassword =>
      'پاس ورڈ اپ ڈیٹ کرنے میں ناکامی۔ براہ کرم اپنا موجودہ پاس ورڈ چیک کریں۔';

  @override
  String get markAllRead => 'سب پڑھے گئے نشان زد کریں';

  @override
  String get allNotificationsMarkedRead =>
      'تمام اطلاعات کو پڑھا ہوا نشان زد کر دیا گیا ہے';

  @override
  String get todaySection => 'آج';

  @override
  String get earlierSection => 'پہلے';

  @override
  String get noNotificationsDesc =>
      'ہم آپ کو آپ کی بولیوں اور نئی نیلامیوں کے بارے میں مطلع کریں گے۔';

  @override
  String detailsComingSoon(String topic) {
    return '$topic کی تفصیلات جلد آرہی ہیں!';
  }

  @override
  String get onboardingSellerTitle1 => 'اپنا سولر اسکریپ لسٹ کریں';

  @override
  String get onboardingSellerDesc1 =>
      'سولر پینلز، بیٹریاں، انورٹرز، ٹرانسفارمرز اور مزید فروخت کریں — ملک بھر میں ہزاروں تصدیق شدہ خریداروں تک رسائی حاصل کریں۔';

  @override
  String get onboardingSellerTitle2 => 'بہترین مارکیٹ ریٹ حاصل کریں';

  @override
  String get onboardingSellerDesc2 =>
      'شفاف نیلامی کے عمل کے ذریعے تصدیق شدہ خریداروں سے رابطہ کریں۔ ہر لسٹنگ کو مسابقتی پیشکشیں ملتی ہیں۔';

  @override
  String get onboardingSellerTitle3 => 'فوری الرٹس حاصل کریں';

  @override
  String get onboardingSellerDesc3 =>
      'جب نیلامی شروع ہوتی ہے تو آپ کو اس میں حصہ لینے کا موقع ملتا ہے۔';

  @override
  String get onboardingBuyerTitle1 => 'معیاری سولر اسکریپ خریدیں';

  @override
  String get onboardingBuyerDesc1 =>
      'تصدیق شدہ ڈیلرز کے لیے بنائے گئے قابل اعتماد پلیٹ فارم کے ذریعے معیاری سولر اسکریپ خریدیں۔';

  @override
  String get onboardingBuyerTitle2 => 'براہ راست نیلامیاں دریافت کریں';

  @override
  String get onboardingBuyerDesc2 =>
      'سولر پینلز، بیٹریوں، انورٹرز، ٹرانسفارمرز وغیرہ کے لیے فعال نیلامیوں کو براؤز کریں۔';

  @override
  String get onboardingBuyerTitle3 => 'ہوشمندی سے بولی لگائیں، مزید جیتیں';

  @override
  String get onboardingBuyerDesc3 =>
      'مسابقتی بولیاں لگائیں، اپنی نیلامیوں کو ٹریک کریں اور سولر اسکریپ کے بہترین سودے حاصل کریں۔';

  @override
  String get helpTopicAccountLogin => 'اکاؤنٹ اور لاگ ان';

  @override
  String get helpTopicSellingScrap => 'سولر اسکریپ فروخت کرنا';

  @override
  String get helpTopicPickupOrders => 'پک اپ اور آرڈرز';

  @override
  String get helpTopicPrivacySecurity => 'رازداری اور سیکیورٹی';

  @override
  String get helpTopicReportProblem => 'مسئلے کی اطلاع دیں';

  @override
  String get helpTopicFaqs => 'عمومی سوالات';

  @override
  String get privacyPolicyLastUpdated => 'آخری تجدید: 5 اگست 2026';

  @override
  String get privacyPolicyInfoCollectTitle => 'معلومات جو ہم جمع کرتے ہیں';

  @override
  String get privacyPolicyInfoCollectDesc =>
      'ہم آپ کا نام، ای میل، فون نمبر، پک اپ پتہ، کمپنی کی تفصیلات (اگر قابل اطلاق ہو)، اور آرڈر کی معلومات جمع کرتے ہیں۔ ہم ایپ کو بہتر بنانے کے لیے ڈیوائس، مقام اور استعمال کا ڈیٹا بھی جمع کر سکتے ہیں۔';

  @override
  String get privacyPolicyHowUseTitle =>
      'ہم آپ کی معلومات کیسے استعمال کرتے ہیں';

  @override
  String get privacyPolicyHowUseDesc =>
      'آپ کی معلومات آپ کا اکاؤنٹ بنانے، اسکریپ کی خریداریوں کو پروسیس کرنے، پک اپ کا شیڈول بنانے، کسٹمر سپورٹ فراہم کرنے، اہم اطلاعات بھیجنے، اور ہماری خدمات کو بہتر بنانے کے لیے استعمال ہوتی ہے۔';

  @override
  String get privacyPolicyDataSharingTitle => 'ڈیٹا کا اشتراک';

  @override
  String get privacyPolicyDataSharingDesc =>
      'ہم آپ کی ذاتی معلومات فروخت نہیں کرتے ہیں۔ ہم صرف قابل اعتماد سروس فراہم کنندگان جیسے پیمنٹ پروسیسرز، لاجسٹکس پارٹنرز، اور قانونی طور پر مطلوب ہونے پر حکام کے ساتھ ضروری ڈیٹا کا اشتراک کرتے ہیں۔';

  @override
  String get privacyPolicyLocationAccessTitle => 'مقام تک رسائی';

  @override
  String get privacyPolicyLocationAccessDesc =>
      'آپ کی اجازت سے، ہم پک اپ کا شیڈول بنانے، وصولی کی درستگی کو بہتر بنانے، اور مقام پر مبنی خدمات فراہم کرنے کے لیے آپ کے مقام کا استعمال کرتے ہیں۔ آپ اپنی ڈیوائس کی ترتیبات میں کسی بھی وقت لوکیشن تک رسائی بند کر سکتے ہیں۔';

  @override
  String get faqsSection => 'عمومی سوالات';

  @override
  String get faq1Title => '1. میں اپنا سولر اسکریپ کیسے بیچوں؟';

  @override
  String get faq1Desc =>
      'بس ایک اکاؤنٹ بنائیں، اپنے اسکریپ کی تفصیلات درج کریں، پک اپ کی درخواست جمع کروائیں، اور ہماری ٹیم جائزہ لے کر وصولی کا بندوبست کرے گی۔';

  @override
  String get faq2Title => '2. آپ کس قسم کا اسکریپ قبول کرتے ہیں؟';

  @override
  String get faq2Desc =>
      'ہم شمسی توانائی سے متعلق مختلف قسم کے اسکریپ قبول کرتے ہیں، بشمول سولر پینلز، انورٹرز، کیبلز، ایلومینیم فریم، بیٹریاں (جہاں قابل اطلاق ہو)، اور دیگر ری سائیکل کرنے کے قابل اجزاء۔';

  @override
  String get faq3Title => '3. مجھے اپنے اسکریپ کی قیمت کا کیسے پتہ چلے گا؟';

  @override
  String get faq3Desc =>
      'ہماری ٹیم خریداری کی قیمت کی تصدیق کرنے سے پہلے آپ کے اسکریپ کی قسم، مقدار، حالت اور موجودہ مارکیٹ ریٹ کی بنیاد پر جائزہ لیتی ہے۔';

  @override
  String get faq4Title => '4. میں پک اپ کا شیڈول کیسے بناؤں؟';

  @override
  String get faq4Desc =>
      'اپنے اسکریپ کی تفصیلات جمع کرانے کے بعد، آپ اپنی پسند کا پک اپ مقام اور وقت منتخب کر سکتے ہیں۔ ہم شیڈول کی تصدیق کے لیے آپ سے رابطہ کریں گے۔';

  @override
  String get faq5Title => '5. کیا میری ذاتی معلومات محفوظ ہیں؟';

  @override
  String get faq5Desc =>
      'جی ہاں۔ ہم آپ کی ذاتی معلومات کی حفاظت کے لیے انڈسٹری کے معیاری سیکیورٹی اقدامات استعمال کرتے ہیں اور آپ کا ڈیٹا کبھی تیسرے فریق کو فروخت نہیں کرتے۔';

  @override
  String get contactUsSection => 'ہم سے رابطہ کریں';
}
