
import 'package:flutter/material.dart';
import '../models/beauty_product.dart';

class ProductCard extends StatefulWidget {
  final BeautyProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDelete;
  final VoidCallback? onMove;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onLongPress,
    this.onDelete,
    this.onMove,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _scaleController.forward().then((_) => _scaleController.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    final subtleBg = theme.colorScheme.onSurface.withValues(alpha: 0.05);
    final subtleIcon = theme.colorScheme.onSurface.withValues(alpha: 0.4);
    final borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.1);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: theme.colorScheme.surface,
        elevation: isDark ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor),
        ),
        child: InkWell(
          onTap: _handleTap,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                _buildProductImage(theme, subtleBg, subtleIcon),

                const SizedBox(width: 14),


                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (widget.product.brand != null && widget.product.brand!.isNotEmpty)
                            ? widget.product.brand!
                            : 'Sin marca',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),


                Icon(
                  Icons.chevron_right,
                  color: subtleIcon,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(ThemeData theme, Color bg, Color iconColor) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bg,
      ),
      child: widget.product.imageUrl != null && widget.product.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported_outlined, color: iconColor, size: 28),
              ),
            )
          : Icon(Icons.spa_outlined, color: iconColor, size: 28),
    );
  }
}