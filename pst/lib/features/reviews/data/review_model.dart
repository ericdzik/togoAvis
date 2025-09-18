import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String id;
  final String businessId;
  final String userId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.businessId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, businessId, userId, rating, comment, createdAt];

  // Convertit un document Firestore en un ReviewModel
  factory ReviewModel.fromMap(String id, Map<String, dynamic> map) {
    return ReviewModel(
      id: id,
      businessId: map['businessId'] as String,
      userId: map['userId'] as String,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convertit un ReviewModel en une map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'businessId': businessId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
