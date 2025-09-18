import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pst/features/reviews/bloc/review_bloc.dart';
import 'package:pst/features/reviews/bloc/review_event.dart';
import 'package:pst/features/reviews/bloc/review_state.dart';
import 'package:pst/features/reviews/data/review_model.dart';
import 'package:pst/features/reviews/data/review_repository.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late ReviewBloc reviewBloc;
  late MockReviewRepository mockReviewRepository;

  setUp(() {
    mockReviewRepository = MockReviewRepository();
    reviewBloc = ReviewBloc(reviewRepository: mockReviewRepository);
  });

  tearDown(() {
    reviewBloc.close();
  });

  group('ReviewBloc', () {
    final review1 = ReviewModel(
      id: '1',
      businessId: 'business1',
      userId: 'user1',
      rating: 4.5,
      comment: 'Great place!',
      createdAt: DateTime.now(),
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits [ReviewLoading, ReviewLoaded] when LoadReviews is added.',
      build: () {
        when(mockReviewRepository.getReviewsForBusiness('business1')).thenAnswer((_) async => [review1]);
        return reviewBloc;
      },
      act: (bloc) => bloc.add(LoadReviews('business1')),
      expect: () => [
        ReviewLoading(),
        ReviewLoaded([review1]),
      ],
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits [ReviewAdded, ReviewLoading, ReviewLoaded] when AddReview is added successfully.',
      build: () {
        when(mockReviewRepository.addReview(any)).thenAnswer((_) async => Future.value());
        when(mockReviewRepository.getReviewsForBusiness('business1')).thenAnswer((_) async => [review1]);
        return reviewBloc;
      },
      act: (bloc) => bloc.add(AddReview(
        businessId: 'business1',
        userId: 'user1',
        rating: 4.5,
        comment: 'Great place!',
      )),
      expect: () => [
        isA<ReviewAdded>(),
        ReviewLoading(),
        ReviewLoaded([review1]),
      ],
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits [ReviewLoading, ReviewError] when getReviewsForBusiness throws an exception.',
      build: () {
        when(mockReviewRepository.getReviewsForBusiness('business1')).thenThrow(Exception('Failed to load'));
        return reviewBloc;
      },
      act: (bloc) => bloc.add(LoadReviews('business1')),
      expect: () => [
        ReviewLoading(),
        isA<ReviewError>(),
      ],
    );
  });
}
