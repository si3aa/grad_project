# Get User Favorites Feature

This feature allows you to get a list of users who favorited a specific product. It follows the MVVM (Model-View-ViewModel) architecture pattern.

## Features

- Fetch users who favorited a product using the API endpoint `/favourites/{productId}`
- Display users in a beautiful dialog with profile pictures and names
- Handle loading, error, and empty states
- Long press on favorite button to show the dialog

## API Endpoint

```
GET https://zygotic-marys-herfa-c2dd67a8.koyeb.app/favourites/{productId}
```

### Response Format

```json
{
    "success": true,
    "message": "Users who favorited this product fetched successfully!",
    "data": [
        {
            "id": 3,
            "username": "msaid99",
            "email": "mahmoud22said22@gmail.com",
            "firstName": "Mahmoud ",
            "lastName": "said",
            "role": "MERCHANT",
            "verified": true,
            "profile": {
                "id": 2,
                "firstName": "Mohamed ",
                "lastName": "fathy",
                "phone": "01080545643",
                "address": "gizaaa",
                "bio": "everything will be ok ",
                "profilePictureUrl": "https://res.cloudinary.com/dcwnj8pxv/image/upload/v1750278034/profile/merchant_3/w5funn7vtsex8mgvdrao.jpg"
            },
            "loyaltyPoints": 0,
            "walletBalance": 5000000,
            "reservedBalance": 0
        }
    ]
}
```

## Usage

### 1. Show Dialog Programmatically

```dart
import 'package:Herfa/features/get_user_fav/views/show_user_fav_dialog.dart';

// Show the dialog
ShowUserFavDialog.show(context, productId);
```

### 2. Use with Favorite Button (Long Press)

The `FavoriteButton` widget has been updated to support long press functionality. When a user long presses on the favorite button, it will show the dialog with users who favorited that product.

```dart
import 'package:Herfa/features/favorites/views/widgets/favorite_button.dart';

FavoriteButton(
  productId: product.id.toString(),
)
```

### 3. Use Cubit Directly

```dart
import 'package:Herfa/features/get_user_fav/viewmodels/user_fav_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Create cubit
final cubit = UserFavCubit();

// Fetch users
await cubit.getUsersWhoFavoritedProduct(productId);

// Listen to state changes
BlocBuilder<UserFavCubit, UserFavState>(
  builder: (context, state) {
    if (state is UserFavLoading) {
      return CircularProgressIndicator();
    } else if (state is UserFavLoaded) {
      return ListView.builder(
        itemCount: state.users.length,
        itemBuilder: (context, index) {
          final user = state.users[index];
          return ListTile(
            title: Text(user.fullName),
            subtitle: Text(user.username),
          );
        },
      );
    } else if (state is UserFavError) {
      return Text('Error: ${state.message}');
    }
    return SizedBox.shrink();
  },
)
```

## File Structure

```
lib/features/get_user_fav/
├── data/
│   ├── models/
│   │   └── user_fav_model.dart
│   └── repository/
│       └── user_fav_repository.dart
├── viewmodels/
│   └── user_fav_cubit.dart
├── views/
│   ├── widgets/
│   │   └── user_fav_dialog.dart
│   └── show_user_fav_dialog.dart
├── index.dart
└── README.md
```

## Models

### UserFavModel

Represents a user who favorited a product.

- `id`: User ID
- `username`: Username
- `email`: Email address
- `firstName`: First name
- `lastName`: Last name
- `role`: User role
- `verified`: Whether the user is verified
- `profile`: User profile information
- `loyaltyPoints`: Loyalty points
- `walletBalance`: Wallet balance
- `reservedBalance`: Reserved balance
- `fullName`: Computed property for full name

### ProfileModel

Represents user profile information.

- `id`: Profile ID
- `firstName`: First name
- `lastName`: Last name
- `phone`: Phone number
- `address`: Address
- `bio`: Bio
- `profilePictureUrl`: Profile picture URL
- `fullName`: Computed property for full name

## States

- `UserFavInitial`: Initial state
- `UserFavLoading`: Loading state
- `UserFavLoaded`: Success state with list of users
- `UserFavError`: Error state with error message

## Dependencies

- `flutter_bloc`: State management
- `equatable`: Value equality
- `dio`: HTTP client
- `shared_preferences`: Local storage for authentication 