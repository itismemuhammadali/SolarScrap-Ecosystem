class SellerStats {
  final int listingsCount;
  final int dealsCount;
  final String totalEarnings;

  SellerStats({
    this.listingsCount = 0,
    this.dealsCount = 0,
    this.totalEarnings = 'Rs. 0',
  });

  factory SellerStats.fromJson(Map<String, dynamic> json) {
    return SellerStats(
      listingsCount: json['listings_count'] ?? 0,
      dealsCount: json['deals_count'] ?? 0,
      totalEarnings: json['total_earnings'] ?? 'Rs. 0',
    );
  }
}
