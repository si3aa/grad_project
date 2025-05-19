import 'dart:io';
import 'package:image_picker/image_picker.dart' as img_picker;
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';

class ImagePickerWidget extends StatelessWidget {
  final List<String> images;
  final Function(String) onAddImage;
  final Function(String)? onDeleteImage; // Make sure this is properly defined
  final int maxImages;

  const ImagePickerWidget({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onDeleteImage, // Make this required to ensure it's always provided
    this.maxImages = 1,
  });

  Future<void> _requestPermission(BuildContext context, img_picker.ImageSource source) async {
    if (source == img_picker.ImageSource.camera) {
      // For camera, we need to request camera permission
      final status = await permission.Permission.camera.request();

      if (status.isGranted) {
        _getImage(context, source);
      } else if (status.isDenied) {
        _showPermissionDeniedDialog(context, source);
      } else if (status.isPermanentlyDenied) {
        _showOpenSettingsDialog(context, source);
      } else {
        _getImage(context, source);
      }
    } else {
      // For gallery access, we'll use a different approach
      // The image_picker package handles permissions internally on newer Android versions

      // First show an explanation dialog
      _showGalleryPermissionExplanation(context);
    }
  }

  void _showGalleryPermissionExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gallery Access'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To select photos from your gallery, we need your permission.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Please tap "Continue" and grant permission when prompted.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
                // Directly try to pick image - image_picker will handle permission requests
                _directPickImage(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _directPickImage(BuildContext context) async {
    try {
      final picker = img_picker.ImagePicker();
      final pickedFile = await picker.pickImage(
        source: img_picker.ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        onAddImage(pickedFile.path);
      }
    } catch (e) {
      // If there's an error, show the settings dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to access your gallery. Please check your permissions.'),
          duration: Duration(seconds: 3),
        ),
      );

      _showGallerySettingsDialog(context);
    }
  }

  void _showGallerySettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gallery Permission Required'),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We need permission to access your photos.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('Please follow these steps:'),
                SizedBox(height: 8),
                Text('1. Tap "Open Settings" below'),
                Text('2. Tap "Permissions"'),
                Text('3. Find "Photos" or "Storage"'),
                Text('4. Enable the permission'),
                Text('5. Return to the app and try again'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                permission.openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImage(BuildContext context, img_picker.ImageSource source) async {
    try {
      final picker = img_picker.ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        onAddImage(pickedFile.path);
      } else {
        // User canceled - no need to show permission dialog
        // as this is likely just a user cancellation
      }
    } catch (e) {
      // If there's an error during image picking (often permission related)
      String permissionType = source == img_picker.ImageSource.camera ? 'Camera' : 'Gallery';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to access your $permissionType. Please check your permissions.'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              permission.openAppSettings();
            },
          ),
        ),
      );

      // Show the appropriate permission dialog
      if (source == img_picker.ImageSource.gallery) {
        _showGallerySettingsDialog(context);
      } else {
        _showOpenSettingsDialog(context, source);
      }
    }
  }

  void _showPermissionDeniedDialog(BuildContext context, img_picker.ImageSource source) {
    final String permissionType = source == img_picker.ImageSource.camera ? 'Camera' : 'Gallery';
    final String explanation = source == img_picker.ImageSource.camera
        ? 'To take photos with your camera, we need your permission to access the camera.'
        : 'To select images from your gallery, we need your permission to access your photos.';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permissionType Access Needed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(explanation),
              const SizedBox(height: 8),
              const Text(
                'This permission is only used to select images for your profile or posts.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Not Now'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Grant Permission'),
              onPressed: () {
                Navigator.of(context).pop();
                _requestPermission(context, source);
              },
            ),
          ],
        );
      },
    );
  }

  void _showOpenSettingsDialog(BuildContext context, img_picker.ImageSource source) {
    final String permissionType = source == img_picker.ImageSource.camera ? 'Camera' : 'Gallery';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permissionType Permission Required'),
          content: Text(
            'To select images from your $permissionType, you need to grant permission in your device settings. '
            'Please tap "Open Settings" and enable the permission.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                permission.openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    // Check if we've reached the maximum number of images
    if (images.length >= maxImages) {
      _showMaxImagesReachedDialog(context);
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _requestPermission(context, img_picker.ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _requestPermission(context, img_picker.ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMaxImagesReachedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Maximum Images Reached'),
          content: Text(
            'You can only upload a maximum of $maxImages images. Please delete an existing image before adding a new one.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
              onPressed: () {
                // Call the onDeleteImage callback
                onDeleteImage!(image); // Use non-null assertion since we made it required
                
                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image deleted successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
                
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: images.isEmpty
          ? [
              // Show add button when there are no images
              GestureDetector(
                onTap: () => _showImageSourceDialog(context),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 30,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ]
          : [
              // Show the image with delete button when there is an image
              ...images.map((image) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: image.startsWith('assets/')
                                  ? AssetImage(image) as ImageProvider
                                  : FileImage(File(image)),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // Always show delete button
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showDeleteConfirmationDialog(context, image),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
    );
  }
}
