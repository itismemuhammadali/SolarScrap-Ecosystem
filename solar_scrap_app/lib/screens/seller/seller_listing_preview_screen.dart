import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/listing_draft.dart';
import '../../services/listing_service.dart';
import 'seller_listing_submitted_screen.dart';
import 'seller_new_listing_screen.dart';

class SellerListingPreviewScreen extends StatefulWidget {
  final ListingDraft? draft;

  const SellerListingPreviewScreen({
    this.draft,
    super.key,
  });

  @override
  State<SellerListingPreviewScreen> createState() =>
      _SellerListingPreviewScreenState();
}

class _SellerListingPreviewScreenState
    extends State<SellerListingPreviewScreen> {
  bool _isSubmitting = false;

  Future<void> _submitListing() async {
    final draft = widget.draft;
    if (draft == null) return;

    setState(() {
      _isSubmitting = true;
    });

    final created = await ListingService.instance.createListing(draft);

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      if (created != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SellerListingSubmittedScreen(
              listingId: created.id,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit listing. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Widget> _buildDynamicDetails(ListingDraft draft) {
    final List<Widget> rows = [];
    final specs = draft.specs;

    if (draft.category == 'Solar Panels') {
      if (specs['panels_count'] != null) rows.add(_buildDetailRow('Number of Panels', '${specs['panels_count']}'));
      if (specs['watts_per_panel'] != null) rows.add(_buildDetailRow('Watts per Panel', '${specs['watts_per_panel']} W'));
      if (specs['panel_condition'] != null) rows.add(_buildDetailRow('Condition', '${specs['panel_condition']}'));
    } else if (draft.category == 'Batteries') {
      if (specs['battery_type'] != null) rows.add(_buildDetailRow('Battery Type', '${specs['battery_type']}'));
      if (specs['battery_count'] != null) rows.add(_buildDetailRow('Quantity', '${specs['battery_count']}'));
      if (specs['battery_capacity'] != null) rows.add(_buildDetailRow('Capacity', '${specs['battery_capacity']}'));
      if (specs['battery_brand'] != null) rows.add(_buildDetailRow('Brand', '${specs['battery_brand']}'));
      if (specs['battery_condition'] != null) rows.add(_buildDetailRow('Condition', '${specs['battery_condition']}'));
    } else if (draft.category == 'Inverters') {
      if (specs['inverter_type'] != null) rows.add(_buildDetailRow('Inverter Type', '${specs['inverter_type']}'));
      if (specs['rated_power'] != null) rows.add(_buildDetailRow('Rated Power', '${specs['rated_power']}'));
      if (specs['inverter_brand'] != null) rows.add(_buildDetailRow('Brand', '${specs['inverter_brand']}'));
      if (specs['inverter_condition'] != null) rows.add(_buildDetailRow('Condition', '${specs['inverter_condition']}'));
    } else if (draft.category == 'Cables') {
      if (specs['cable_type'] != null) rows.add(_buildDetailRow('Cable Type', '${specs['cable_type']}'));
      if (specs['cable_conductor'] != null) rows.add(_buildDetailRow('Conductor', '${specs['cable_conductor']}'));
      if (specs['insulation_type'] != null) rows.add(_buildDetailRow('Insulation', '${specs['insulation_type']}'));
      if (specs['cable_size'] != null) rows.add(_buildDetailRow('Cable Size', '${specs['cable_size']}'));
    } else if (draft.category == 'Structure') {
      if (specs['structure_type'] != null) rows.add(_buildDetailRow('Structure Type', '${specs['structure_type']}'));
      if (specs['structure_metal'] != null) rows.add(_buildDetailRow('Metal', '${specs['structure_metal']}'));
    } else if (draft.category == 'Complete Solar System') {
      if (specs['panels_count'] != null) rows.add(_buildDetailRow('Panels', '${specs['panels_count']}x (${specs['watts_per_panel']}W)'));
      if (specs['battery_type'] != null) rows.add(_buildDetailRow('Batteries', '${specs['battery_count']}x ${specs['battery_type']}'));
      if (specs['inverter_type'] != null) rows.add(_buildDetailRow('Inverter', '${specs['inverter_type']} ${specs['rated_power'] ?? ''}'));
      if (specs['structure_type'] != null) rows.add(_buildDetailRow('Structure', '${specs['structure_type']} (${specs['structure_metal'] ?? ''})'));
    }

    if (draft.priceDemand != null && draft.priceDemand! > 0) {
      final formattedPrice = draft.priceDemand! >= 100000
          ? 'Rs. ${(draft.priceDemand! / 100000).toStringAsFixed(1)}L (${draft.priceDemand!.toStringAsFixed(0)})'
          : 'Rs. ${draft.priceDemand!.toStringAsFixed(0)}';
      rows.add(_buildDetailRow('Price Demand', formattedPrice));
    }

    return rows;
  }

  Widget _buildImageItem(String pathOrUrl) {
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://') || pathOrUrl.startsWith('/api/')) {
      final fullUrl = ListingService.instance.getFullImageUrl(pathOrUrl);
      return Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            fullUrl ?? pathOrUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
          ),
        ),
      );
    } else if (File(pathOrUrl).existsSync()) {
      return Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(pathOrUrl),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
          ),
        ),
      );
    } else {
      return Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            pathOrUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft ?? ListingDraft();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 18,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Listing Preview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    Builder(
                      builder: (context) {
                        final bool isComplete = widget.draft?.category == 'Complete Solar System';
                        final int totalSteps = isComplete ? 4 : 6;
                        final String stepText = isComplete
                            ? 'Listing Details · Step 4 of 4 (Preview)'
                            : 'Step 6 of 6';

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  stepText,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF71717A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  '100%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF00A63E),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(totalSteps, (index) {
                                return Expanded(
                                  child: Container(
                                    height: 4,
                                    margin: EdgeInsets.only(
                                        right: index < totalSteps - 1 ? 6 : 0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00A63E),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Main Listing Preview Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      draft.displayTitle,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF18181B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      draft.displaySubtitle,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF71717A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Preview',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1, color: Color(0xFFF3F4F6)),
                          const SizedBox(height: 12),

                          // Dynamic Details
                          ..._buildDynamicDetails(draft),
                          const SizedBox(height: 16),

                          // Images section
                          Text(
                            'Images (${draft.imageUrls.length})',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF18181B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (draft.imageUrls.isNotEmpty)
                            Row(
                              children: draft.imageUrls.take(3).map((img) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _buildImageItem(img),
                                  ),
                                );
                              }).toList(),
                            )
                          else
                            const Text(
                              'No photos uploaded',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          const SizedBox(height: 16),

                          // Location & Contact
                          const Text(
                            'Location & Contact',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF18181B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: Color(0xFF00A63E),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  draft.pickupAddress != null && draft.pickupAddress!.isNotEmpty
                                      ? '${draft.pickupAddress}, ${draft.pickupCity ?? ''}'
                                      : '${draft.pickupArea != null ? '${draft.pickupArea}, ' : ''}${draft.pickupCity ?? 'Not specified'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Color(0xFF00A63E),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${draft.contactName ?? 'Seller'} (${draft.contactPhone ?? 'No phone'})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Create Another Listing button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SellerNewListingScreen(),
                          ),
                          (route) => route.isFirst,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(
                          color: Color(0xFF00A63E),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Start Over',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00A63E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Edit and Submit Listing buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            side: const BorderSide(
                              color: Color(0xFF00A63E),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Color(0xFF00A63E),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF00A63E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF00A63E),
                                Color(0xFF007D2E),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitListing,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Submit Listing',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF71717A),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF18181B),
            ),
          ),
        ],
      ),
    );
  }
}
