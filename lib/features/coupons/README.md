# Coupon Management Feature

This feature allows merchants to create different types of coupons for their products in the Herfa marketplace app.

## Features

- **Three Coupon Types:**
  - **Percentage Coupons**: Apply a percentage discount (e.g., 20% off)
  - **Fixed Price Coupons**: Set a fixed price for the product
  - **Amount Coupons**: Apply a flat discount amount (e.g., $60 off)

- **Coupon Properties:**
  - Coupon code
  - Discount type and value
  - Available quantity
  - Expiry date
  - Minimum order amount (optional)
  - Maximum discount limit (for percentage coupons)
  - Active/inactive status

## Architecture

The feature follows the MVVM pattern with BLoC/Cubit:

```
lib/features/coupons/
├── data/
│   ├── models/
│   │   ├── coupon_model.dart          # Coupon response model
│   │   └── coupon_request.dart        # Coupon request model
│   ├── data_source/
│   │   └── remote/
│   │       └── coupon_remote_data_source.dart
│   └── repository/
│       └── coupon_repository.dart
├── viewmodels/
│   ├── cubit/
│   │   └── coupon_cubit.dart
│   └── states/
│       └── coupon_state.dart
└── views/
    ├── screens/
    │   └── create_coupon_screen.dart
    └── widgets/
        ├── coupon_type_selector.dart
        ├── coupon_form_fields.dart
        └── create_coupon_button.dart
```

## API Endpoint

- **URL**: `https://zygotic-marys-herfa-c2dd67a8.koyeb.app/coupons`
- **Method**: POST
- **Authentication**: Bearer token required

## Usage

### 1. Adding Create Coupon Button to Product Detail Screen

```dart
import 'package:Herfa/features/coupons/views/widgets/create_coupon_button.dart';

// In your product detail screen, add this button for merchants
if (isMerchant) { // Check if current user is the product owner
  CreateCouponButton(
    productId: product.id,
    productName: product.name,
    onCouponCreated: () {
      // Refresh product data or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon created successfully!')),
      );
    },
  ),
}
```

### 2. Navigation to Create Coupon Screen

```dart
// Navigate programmatically
Navigator.pushNamed(
  context,
  Routes.createCouponRoute,
  arguments: {
    'productId': productId,
    'productName': productName,
  },
);
```

### 3. Using the Coupon Cubit

```dart
// Access the cubit
final couponCubit = context.read<CouponCubit>();

// Create a percentage coupon
final request = CouponRequest.percentage(
  code: 'SALE20',
  discount: 20.0,
  maxDiscount: 100.0,
  availableQuantity: 10,
  expiryDate: DateTime.now().add(Duration(days: 30)).toIso8601String(),
  productId: 1,
  minOrderAmount: 200.0,
);

// Create the coupon
couponCubit.createCoupon(request);

// Listen to state changes
BlocBuilder<CouponCubit, CouponState>(
  builder: (context, state) {
    if (state is CouponLoading) {
      return CircularProgressIndicator();
    } else if (state is CouponSuccess) {
      return Text('Coupon created: ${state.response.data?.code}');
    } else if (state is CouponError) {
      return Text('Error: ${state.message}');
    }
    return Container();
  },
);
```

## Coupon Types Examples

### 1. Percentage Coupon
```json
{
  "code": "SALE20",
  "discountType": "PERCENTAGE",
  "discount": 20.0,
  "maxDiscount": 100.0,
  "availableQuantity": 10,
  "expiryDate": "2025-06-30T23:59:59",
  "productId": 1,
  "minOrderAmount": 200.0,
  "isActive": true
}
```

### 2. Fixed Price Coupon
```json
{
  "code": "FIXED299",
  "discountType": "FIXED_PRICE",
  "fixedPrice": 299.0,
  "availableQuantity": 15,
  "expiryDate": "2025-06-30T23:59:59",
  "productId": 1,
  "isActive": true
}
```

### 3. Amount Coupon
```json
{
  "code": "FLAT60",
  "discountType": "AMOUNT",
  "discount": 60.0,
  "availableQuantity": 30,
  "expiryDate": "2025-06-30T23:59:59",
  "minOrderAmount": 100.0,
  "productId": 1,
  "isActive": true
}
```

## Integration Steps

1. **Register the Cubit** (already done in main.dart):
   ```dart
   BlocProvider(
     create: (_) => CouponCubit(repository: couponRepository),
   ),
   ```

2. **Add the route** (already done in route_generator.dart):
   ```dart
   case Routes.createCouponRoute:
     return MaterialPageRoute(
       builder: (_) => CreateCouponScreen(
         productId: arguments?['productId'],
         productName: arguments?['productName'],
       ),
     );
   ```

3. **Add the button to your screens** where merchants can create coupons for their products.

## Features Included

- ✅ Complete MVVM architecture
- ✅ Three coupon types (Percentage, Fixed Price, Amount)
- ✅ Form validation
- ✅ Date picker for expiry date
- ✅ Dynamic form fields based on coupon type
- ✅ Loading states and error handling
- ✅ Success/error notifications
- ✅ Reusable components
- ✅ Route management
- ✅ BLoC/Cubit state management

## Next Steps

To complete the coupon feature, you might want to add:

1. **Coupon List Screen**: View all created coupons
2. **Coupon Edit Screen**: Modify existing coupons
3. **Coupon Delete**: Remove coupons
4. **Coupon Usage Tracking**: Track how many times a coupon is used
5. **Coupon Validation**: Validate coupons when customers apply them
6. **Coupon Analytics**: Show coupon performance metrics 