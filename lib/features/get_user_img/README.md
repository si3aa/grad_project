# Get User Image Feature

This feature provides a clean MVVM implementation for fetching and displaying user profile images from the API.

## API Endpoint

- **URL**: `https://zygotic-marys-herfa-c2dd67a8.koyeb.app/profiles/image/user/{userId}`
- **Method**: GET
- **Headers**: Requires Bearer token authentication
- **Response**: 
```json
{
    "success": true,
    "message": "Profile image found successfully",
    "data": "https://res.cloudinary.com/dcwnj8pxv/image/upload/v1750278034/profile/merchant_3/w5funn7vtsex8mgvdrao.jpg"
}
```

## Architecture

The feature follows the MVVM (Model-View-ViewModel) pattern with BLoC state management:

### Models
- `UserImageModel`: Represents the API response structure

### Repository
- `UserImageRepository`: Handles API calls with proper error handling and logging

### ViewModels
- `UserImageCubit`: Manages state (loading, loaded, error) using BLoC pattern

### Views
- `UserImageWidget`: Basic user image widget
- `CachedUserImageWidget`: Advanced widget with better error handling

## Usage

### Basic Usage

```dart
import 'package:Herfa/features/get_user_img/index.dart';

// In your widget
CachedUserImageWidget(
  userId: 3, // The user ID to fetch image for
  radius: 20,
  onTap: () {
    // Handle tap if needed
  },
)
```

### Advanced Usage

```dart
CachedUserImageWidget(
  userId: 3,
  radius: 30,
  shape: BoxShape.circle,
  placeholder: CircularProgressIndicator(),
  errorWidget: Icon(Icons.error),
  onTap: () {
    // Navigate to user profile
  },
)
```

### Manual API Call

```dart
import 'package:Herfa/features/get_user_img/index.dart';

// Create repository and cubit
final repository = UserImageRepository();
final cubit = UserImageCubit(repository: repository);

// Fetch user image
await cubit.getUserImage(3);

// Listen to state changes
BlocBuilder<UserImageCubit, UserImageState>(
  builder: (context, state) {
    if (state is UserImageLoading) {
      return CircularProgressIndicator();
    } else if (state is UserImageLoaded) {
      return Image.network(state.userImage.imageUrl);
    } else if (state is UserImageError) {
      return Text('Error: ${state.message}');
    }
    return SizedBox();
  },
)
```

## Integration with Product Cards

The feature is already integrated into the `ProductCard` widget. The product card now uses `CachedUserImageWidget` to display user profile images fetched from the API.

## Features

- ✅ Clean MVVM architecture
- ✅ BLoC state management
- ✅ Proper error handling
- ✅ Loading states
- ✅ Fallback UI for errors
- ✅ Token-based authentication
- ✅ Logging for debugging
- ✅ Reusable widgets
- ✅ Easy integration

## Error Handling

The feature handles various error scenarios:
- Network errors
- API errors
- Invalid responses
- Missing images

All errors are properly logged and displayed with appropriate fallback UI. 