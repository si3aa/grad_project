import 'package:bloc/bloc.dart';
import '../product_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> fetchProducts(int merchantId, String token) async {
    emit(ProductLoading());
    final url = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/products/merchant/$merchantId';
    print('Request: GET $url');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      print('Response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        emit(ProductLoaded(data));
      } else {
        emit(ProductError('Failed to load products'));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
