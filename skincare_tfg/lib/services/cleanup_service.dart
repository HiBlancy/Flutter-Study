import 'product_service.dart';

class CleanupService {
  final ProductService _productService = ProductService();

  // Ejecutar al iniciar la app o al cambiar de mes
  Future<void> cleanupOldUsedProducts() async {
    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    
    // Obtener todos los productos terminados
    final response = await _productService.getProducts(
      page: 1,
      limit: 100,
      listType: 'used',
    );
    
    if (response != null) {
      for (final product in response.products) {
        if (product.finishedDate != null &&
            product.finishedDate!.isBefore(firstDayOfCurrentMonth)) {
          // Mover a historial o archivar (dependiendo de tu lógica)
          await _productService.updateProduct(product.id!, {
            'listType': 'archived', // O eliminar si prefieres
          });
        }
      }
    }
  }
}