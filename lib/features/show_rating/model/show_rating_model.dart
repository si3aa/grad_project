class ShowRatingModel {
  final double rating;
  ShowRatingModel({required this.rating});

  factory ShowRatingModel.fromJson(Map<String, dynamic> json) {
    return ShowRatingModel(
      rating: (json['data'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
