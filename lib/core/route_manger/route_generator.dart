import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/features/add_new_product/views/screens/edit_product_screen.dart';
import 'package:Herfa/features/add_new_product/views/screens/new_post_screen.dart';
import 'package:Herfa/features/add_new_product/views/screens/new_post_view.dart';
import 'package:Herfa/features/add_new_product/viewmodels/cubit/new_post_viewmodel.dart';
import 'package:Herfa/features/auth/forget_pass.dart';
import 'package:Herfa/features/auth/guest.dart';
import 'package:Herfa/features/auth/reset_pass.dart';
import 'package:Herfa/features/auth/splash.dart';
import 'package:Herfa/features/auth/success_screen.dart';
import 'package:Herfa/features/auth/views/screens/login_screen.dart';
import 'package:Herfa/features/auth/views/screens/register_screen.dart';
import 'package:Herfa/features/auth/views/screens/verify_otp_screen.dart';
import 'package:Herfa/features/auth/welcom.dart';
import 'package:Herfa/features/change_role/views/change_role_screen.dart';
import 'package:Herfa/features/comments/views/product_comments_screen.dart';
import 'package:Herfa/features/event/views/screens/events_screen.dart';
import 'package:Herfa/features/event/views/screens/event_products_screen.dart';
import 'package:Herfa/features/event/views/event_comments_screen.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:Herfa/features/get_product/views/product_detail_screen.dart';
import 'package:Herfa/ui/screens/home/views/cart_screen.dart';
import 'package:Herfa/ui/screens/home/views/home_screen.dart';
import 'package:Herfa/ui/screens/home/views/notification_sc.dart';
import 'package:Herfa/features/saved_products/views/screens/saved_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/features/comments/viewmodels/comment_cubit.dart';
import 'package:Herfa/features/comments/data/repository/comment_repository.dart';
import 'package:Herfa/features/show_bundels/views/bundle_screen_wrapper.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.welcomeRoute:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case Routes.guestRoute:
        return MaterialPageRoute(builder: (_) => const GuestScreen());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.forgetPassRoute:
        return MaterialPageRoute(builder: (_) => const ForgetPass());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.verifyRoute:
        return MaterialPageRoute(
          builder: (_) => VerifyOTPScreen.fromArguments(arguments ?? {}),
        );
      case Routes.resetPassRoute:
        return MaterialPageRoute(builder: (_) => const ResetPass());
      case Routes.successRoute:
        return MaterialPageRoute(
          builder: (_) => SuccessScreen(
            title: arguments?['title'] as String? ?? 'Success',
          ),
        );
      case Routes.notificationRoute:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case Routes.newPostRoute:
        return MaterialPageRoute(builder: (_) => const NewPostScreen());
      case Routes.changeRoleRoute:
        return MaterialPageRoute(builder: (_) => const ChangeRoleScreen());
      case Routes.settingsRoute:
        return MaterialPageRoute(
            builder: (_) =>
                const NotificationScreen()); // Placeholder for settings
      case Routes.addProductRoute:
        final isEditMode = arguments?['isEditMode'] ?? false;
        final product = arguments?['product'];
        final productId = arguments?['productId'];

        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) {
              final cubit = NewPostCubit();
              // Initialize with product data if in edit mode
              if (isEditMode && product != null) {
                cubit.initWithProductData(product);
              }
              return cubit;
            },
            child: NewPostView(
              isEditMode: isEditMode,
              product: product,
              productId: productId,
            ),
          ),
        );
      case Routes.editProductRoute:
        final product = arguments?['product'] as Product?;
        if (product != null) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) {
                final cubit = NewPostCubit();
                cubit.initWithProductData(product);
                return cubit;
              },
              child: EditProductScreen(product: product),
            ),
          );
        }
        return _undefinedRoute();
      case Routes.savedRoute:
        return MaterialPageRoute(
          builder: (_) => const SavedScreenWrapper(),
        );
      case Routes.eventsRoute:
        return MaterialPageRoute(builder: (_) => const EventsScreen());
      case Routes.cartRoute:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case Routes.productDetailRoute:
        final product = arguments?['product'] as Product?;
        if (product != null) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => CommentCubit(CommentRepository()),
              child: ProductDetailScreen(product: product),
            ),
          );
        }
        return _undefinedRoute();
      case Routes.commentsRoute:
        final productId = arguments?['productId'] as String?;
        if (productId != null) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) {
                final cubit = CommentCubit(CommentRepository());
                cubit.fetchComments(productId);
                return cubit;
              },
              child: ProductCommentsScreen(productId: productId),
            ),
          );
        }
        return _undefinedRoute();
      case Routes.eventCommentsRoute:
        final eventId = arguments?['eventId'] as String?;
        if (eventId != null) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) {
                final cubit = CommentCubit(
                  CommentRepository(),
                );
                cubit.fetchComments(eventId);
                return cubit;
              },
              child: EventCommentsScreen(eventId: eventId),
            ),
          );
        }
        return _undefinedRoute();
      case Routes.eventProductsRoute:
        final eventId = arguments?['eventId'] as String?;
        if (eventId != null) {
          return MaterialPageRoute(
            builder: (_) => EventProductsScreen(eventId: eventId),
          );
        }
        return _undefinedRoute();
      case Routes.bundleRoute:
        return MaterialPageRoute(builder: (_) => const BundleScreenWrapper());
      default:
        return _undefinedRoute();
    }
  }

  static Route<dynamic> _undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: kPrimaryColor,
        ),
        body: const Center(
          child: Text('Route not found'),
        ),
      ),
    );
  }
}
