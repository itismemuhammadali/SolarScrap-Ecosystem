class BuyerStats {
  final int totalBids;
  final int wonAuctions;
  final int activeBids;

  BuyerStats({
    this.totalBids = 0,
    this.wonAuctions = 0,
    this.activeBids = 0,
  });

  factory BuyerStats.fromJson(Map<String, dynamic> json) {
    return BuyerStats(
      totalBids: json['total_bids'] is int
          ? json['total_bids']
          : int.tryParse(json['total_bids']?.toString() ?? '0') ?? 0,
      wonAuctions: json['won_auctions'] is int
          ? json['won_auctions']
          : int.tryParse(json['won_auctions']?.toString() ?? '0') ?? 0,
      activeBids: json['active_bids'] is int
          ? json['active_bids']
          : int.tryParse(json['active_bids']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_bids': totalBids,
      'won_auctions': wonAuctions,
      'active_bids': activeBids,
    };
  }
}
