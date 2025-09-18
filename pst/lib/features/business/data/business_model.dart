import 'package:equatable/equatable.dart';

class BusinessModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final String category;
  final String contact;
  final String description;

  const BusinessModel({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.contact,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, address, category, contact, description];

  // Permet de créer une copie du modèle en modifiant certains champs
  BusinessModel copyWith({
    String? id,
    String? name,
    String? address,
    String? category,
    String? contact,
    String? description,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      category: category ?? this.category,
      contact: contact ?? this.contact,
      description: description ?? this.description,
    );
  }

  // Conversion depuis un document Firestore (Map)
  factory BusinessModel.fromMap(String id, Map<String, dynamic> map) {
    return BusinessModel(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      category: map['category'] ?? '',
      contact: map['contact'] ?? '',
      description: map['description'] ?? '',
    );
  }

  // Conversion vers une Map pour l'écriture dans Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'category': category,
      'contact': contact,
      'description': description,
    };
  }
}
