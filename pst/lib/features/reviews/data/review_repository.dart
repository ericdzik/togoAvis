import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pst/features/reviews/data/review_model.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore;

  ReviewRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Récupère la liste des avis pour une entreprise spécifique.
  Future<List<ReviewModel>> getReviewsForBusiness(String businessId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('businessId', isEqualTo: businessId)
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        return ReviewModel.fromMap(doc.id, doc.data());
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get reviews: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred while fetching reviews.');
    }
  }

  /// Ajoute un nouvel avis dans Firestore.
  Future<void> addReview(ReviewModel review) async {
    try {
      await _firestore.collection('reviews').add(review.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Failed to add review: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred while adding the review.');
    }
  }
}
