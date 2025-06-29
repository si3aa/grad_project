import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/favorite_cubit.dart';
import 'package:Herfa/features/get_user_fav/views/show_user_fav_dialog.dart';

class FavoriteButton extends StatefulWidget {
  final String productId;

  const FavoriteButton({
    super.key,
    required this.productId,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleFavoriteTap() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await _controller.forward();
      await _controller.reverse();

      final cubit = context.read<FavoriteCubit>();
      final isFavorite = cubit.isProductFavorite(widget.productId);

      if (isFavorite) {
        // Show confirmation dialog before removing
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Remove from Favorites'),
              content: const Text(
                  'Are you sure you want to remove this item from your favorites?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Remove'),
                ),
              ],
            );
          },
        );

        if (confirmed == true && mounted) {
          await cubit.toggleFavorite(widget.productId);
          _showSuccessMessage('Removed from favorites');
        }
      } else {
        // Add to favorites directly
        await cubit.toggleFavorite(widget.productId);
        _showSuccessMessage('Added to favorites');
      }
    } catch (e) {
      _showErrorMessage('Failed to update favorites. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleLongPress() {
    // Show users who favorited this product
    ShowUserFavDialog.show(context, widget.productId);
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _handleFavoriteTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        final isFavorite =
            context.read<FavoriteCubit>().isProductFavorite(widget.productId);

        return ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleFavoriteTap,
            onLongPress: _handleLongPress,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 22,
                    ),
            ),
          ),
        );
      },
    );
  }
}
