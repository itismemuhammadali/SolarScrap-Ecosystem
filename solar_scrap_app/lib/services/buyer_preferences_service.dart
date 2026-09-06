class BuyerPreferencesService {
  static final BuyerPreferencesService instance = BuyerPreferencesService._internal();
  BuyerPreferencesService._internal();

  bool newAuctions = true;
  bool bidUpdates = true;
  bool closingSoonAlerts = false;
  bool winningNotifications = true;
  String language = 'English';

  void updateNotificationSettings({
    bool? newAuctionsVal,
    bool? bidUpdatesVal,
    bool? closingSoonAlertsVal,
    bool? winningNotificationsVal,
  }) {
    if (newAuctionsVal != null) newAuctions = newAuctionsVal;
    if (bidUpdatesVal != null) bidUpdates = bidUpdatesVal;
    if (closingSoonAlertsVal != null) closingSoonAlerts = closingSoonAlertsVal;
    if (winningNotificationsVal != null) winningNotifications = winningNotificationsVal;
  }

  void setLanguage(String lang) {
    language = lang;
  }
}
