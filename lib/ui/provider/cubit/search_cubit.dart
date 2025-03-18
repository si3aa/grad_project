import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState.initial());

  void updateQuery(String query) {
    List<String> allSuggestions = [
      "Face Scrub",
      "Nail Polish",
      "Lip Balm",
      "Eyeliner",
      "Jewelry Set",
      "Clothing Dress",
      "Home Decor Lamp",
    ];

    List<String> filteredSuggestions = query.isEmpty
        ? []
        : allSuggestions
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    emit(SearchState(
      query: query,
      suggestions: filteredSuggestions,
      isSearchFinished: false,
    ));
  }

  void finishSearch() {
    emit(SearchState(
      query: state.query,
      suggestions: [],
      isSearchFinished: true, 
    ));
  }

  void clearSuggestions() {
    emit(SearchState(
      query: "",
      suggestions: [],
      isSearchFinished: false,
    ));
  }
}

class SearchState {
  final String query;
  final List<String> suggestions;
  final bool isSearchFinished;

  SearchState({
    required this.query,
    required this.suggestions,
    required this.isSearchFinished,
  });

  factory SearchState.initial() => SearchState(
        query: "",
        suggestions: [],
        isSearchFinished: false,
      );
}