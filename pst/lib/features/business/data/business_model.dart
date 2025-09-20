import 'package:equatable/equatable.dart';

class BusinessModel extends Equatable {
  final String id;
  final String name;
  final String category;
  final String address;
  final double averageRating;
  final int reviewCount;
  final String imageUrl;
  final String? contact;
  final String? description;

  const BusinessModel({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.averageRating,
    required this.reviewCount,
    required this.imageUrl,
    this.contact,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        address,
        averageRating,
        reviewCount,
        imageUrl,
        contact,
        description,
      ];

  BusinessModel copyWith({
    String? id,
    String? name,
    String? category,
    String? address,
    double? averageRating,
    int? reviewCount,
    String? imageUrl,
    String? contact,
    String? description,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      contact: contact ?? this.contact,
      description: description ?? this.description,
    );
  }

  factory BusinessModel.fromMap(String id, Map<String, dynamic> map) {
    return BusinessModel(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      address: map['address'] ?? '',
      averageRating: (map['averageRating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      contact: map['contact'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'address': address,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'contact': contact,
      'description': description,
    };
  }
}
