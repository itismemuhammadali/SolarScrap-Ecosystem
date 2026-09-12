import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      if (context.mounted) {
        _showSettingsDialog(
          context,
          title: 'Camera Permission Required',
          message:
              'Camera access was previously denied. To take photos of your solar equipment, please enable camera access in your device settings.',
        );
      }
      return false;
    }

    final requestResult = await Permission.camera.request();
    if (requestResult.isGranted || requestResult.isLimited) {
      return true;
    }

    if (requestResult.isPermanentlyDenied && context.mounted) {
      _showSettingsDialog(
        context,
        title: 'Camera Permission Required',
        message:
            'Camera access is required to take photos of your solar panels and equipment. Please enable it in Settings.',
      );
    }
    return false;
  }

  static Future<bool> requestPhotosPermission(BuildContext context) async {
    Permission permission = Permission.photos;
    if (Platform.isAndroid) {
      // Android 13+ uses READ_MEDIA_IMAGES (handled by photos permission),
      // earlier versions use storage permission
      final statusPhotos = await Permission.photos.status;
      if (statusPhotos.isGranted || statusPhotos.isLimited) return true;
      final statusStorage = await Permission.storage.status;
      if (statusStorage.isGranted || statusStorage.isLimited) return true;

      // Try photos first, if not applicable check storage
      final reqPhotos = await Permission.photos.request();
      if (reqPhotos.isGranted || reqPhotos.isLimited) return true;

      final reqStorage = await Permission.storage.request();
      if (reqStorage.isGranted || reqStorage.isLimited) return true;

      if ((reqPhotos.isPermanentlyDenied || reqStorage.isPermanentlyDenied) && context.mounted) {
        _showSettingsDialog(
          context,
          title: 'Photo Access Required',
          message:
              'Photo access is needed to select images of your solar equipment. Please enable access in Settings.',
        );
      }
      return false;
    }

    final status = await permission.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      if (context.mounted) {
        _showSettingsDialog(
          context,
          title: 'Photo Access Required',
          message:
              'Photo library access was previously disabled. Please allow access in Settings to choose photos.',
        );
      }
      return false;
    }

    final requestResult = await permission.request();
    if (requestResult.isGranted || requestResult.isLimited) {
      return true;
    }

    if (requestResult.isPermanentlyDenied && context.mounted) {
      _showSettingsDialog(
        context,
        title: 'Photo Access Required',
        message:
            'Photo library access is needed to select equipment photos. Please enable it in Settings.',
      );
    }
    return false;
  }

  static void _showSettingsDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A63E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Open Settings',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showImagePickerModal(
    BuildContext context, {
    required Function(ImageSource source) onSourceSelected,
    VoidCallback? onRemovePhoto,
    bool hasExistingPhoto = false,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Select Image Source',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF151516),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.camera_alt, color: Color(0xFF00A63E), size: 20),
                ),
                title: Text(
                  'Take Photo (Camera)',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final hasPerm = await requestCameraPermission(context);
                  if (hasPerm) {
                    onSourceSelected(ImageSource.camera);
                  }
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.photo_library, color: Color(0xFF00A63E), size: 20),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final hasPerm = await requestPhotosPermission(context);
                  if (hasPerm) {
                    onSourceSelected(ImageSource.gallery);
                  }
                },
              ),
              if (hasExistingPhoto && onRemovePhoto != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  ),
                  title: Text(
                    'Remove Photo',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onRemovePhoto();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
