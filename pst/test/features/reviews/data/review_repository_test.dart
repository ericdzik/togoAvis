import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pst/features/reviews/data/review_model.dart';
import 'package:pst/features/reviews/data/review_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ReviewRepository reviewRepository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    reviewRepository = ReviewRepository(firestore: fakeFirestore);
  });

  group('ReviewRepository', () {
    final review1 = ReviewModel(
      id: '1',
      businessId: 'business1',
      userId: 'user1',
      rating: 4.5,
      comment: 'Great place!',
      createdAt: DateTime.now(),
    );
    final review2 = ReviewModel(
      id: '2',
      businessId: 'business1',
      userId: 'user2',
      rating: 3.5,
      comment: 'Good, but could be better.',
      createdAt: DateTime.now(),
    );
    final review3 = ReviewModel(
      id: '3',
      businessId: 'business2',
      userId: 'user3',
      rating: 5.0,
      comment: 'Excellent!',
      createdAt: DateTime.now(),
    );

    group('getReviewsForBusiness', () {
      test('returns a list of reviews for a specific business', () async {
        await fakeFirestore.collection('reviews').add(review1.toMap());
        await fakeFirestore.collection('reviews').add(review2.toMap());
        await fakeFirestore.collection('reviews').add(review3.toMap());

        final reviews = await reviewRepository.getReviewsForBusiness('business1');

        expect(reviews.length, 2);
        expect(reviews.any((r) => r.comment == review1.comment), true);
        expect(reviews.any((r) => r.comment == review2.comment), true);
      });

      test('returns an empty list when there are no reviews for a business', () async {
        final reviews = await reviewRepository.getReviewsForBusiness('business1');

        expect(reviews.isEmpty, true);
      });
    });

    group('addReview', () {
      test('adds a review to the collection', () async {
        await reviewRepository.addReview(review1);

        final snapshot = await fakeFirestore.collection('reviews').get();

        expect(snapshot.docs.length, 1);
        expect(snapshot.docs.first.data()['comment'], review1.comment);
      });
    });
  });
}
