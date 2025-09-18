import 'package:equatable/equatable.dart';

class BusinessModel extends Equatable {
  final String id;
  final String name;
  final String address;

  const BusinessModel({
    required this.id,
    required this.name,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, address];

  // Permet de créer une copie du modèle en modifiant certains champs
  BusinessModel copyWith({
    String? id,
    String? name,
    String? address,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }

  // Conversion depuis un document Firestore (Map)
  factory BusinessModel.fromMap(String id, Map<String, dynamic> map) {
    return BusinessModel(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
    );
  }

  // Conversion vers une Map pour l'écriture dans Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
    };
  }
}
