import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pst/features/reviews/bloc/review_event.dart';
import 'package:pst/features/reviews/bloc/review_state.dart';
import 'package:pst/features/reviews/data/review_model.dart';
import 'package:pst/features/reviews/data/review_repository.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewBloc({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository,
        super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<AddReview>(_onAddReview);
  }

  Future<void> _onLoadReviews(
    LoadReviews event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final reviews = await _reviewRepository.getReviewsForBusiness(event.businessId);
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onAddReview(
    AddReview event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      final newReview = ReviewModel(
        id: '', // Firestore will generate an ID
        businessId: event.businessId,
        userId: event.userId,
        rating: event.rating,
        comment: event.comment,
        createdAt: DateTime.now(),
      );
      await _reviewRepository.addReview(newReview);
      emit(ReviewAdded());
      // Refresh the list of reviews after adding a new one
      add(LoadReviews(event.businessId));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
