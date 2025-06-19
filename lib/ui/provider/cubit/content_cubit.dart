import 'package:flutter_bloc/flutter_bloc.dart';

enum ContentFilter { home, gifts, saved, add,cart }
class ContentCubit extends Cubit<ContentState> {
  ContentCubit() : super(ContentState(filter: ContentFilter.home, content: []));

  void filterContent(ContentFilter filter) {
    List<String> content;
    switch (filter) {
      case ContentFilter.home:
        content = ["Home Item 1", "Home Item 2", "Home Item 3"];
        break;
      case ContentFilter.gifts:
        content = ["Gift Item 1", "Gift Item 2", "Gift Item 3"];
        break;
      case ContentFilter.saved:
        content = ["Saved Item 1", "Saved Item 2", "Saved Item 3"];
        break;
      case ContentFilter.add:
        content = ["Add Item 1", "Add Item 2", "Add Item 3"];
        break;
      case ContentFilter.cart:
        content = ["Cart Item 1", "Cart Item 2", "Cart Item 3"];
        break;
    }
    emit(ContentState(filter: filter, content: content));
  }
}

class ContentState {
  final ContentFilter filter;
  final List<String> content;

  ContentState({required this.filter, required this.content});
}