import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class LoadReviews extends ReviewEvent {
  final String businessId;

  const LoadReviews(this.businessId);

  @override
  List<Object> get props => [businessId];
}

class AddReview extends ReviewEvent {
  final String businessId;
  final String userId;
  final double rating;
  final String comment;

  const AddReview({
    required this.businessId,
    required this.userId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object> get props => [businessId, userId, rating, comment];
}
