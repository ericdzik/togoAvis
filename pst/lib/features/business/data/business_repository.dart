import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pst/features/business/data/business_model.dart';
import 'package:pst/features/business/data/mock_business_repository.dart';

class BusinessRepository {
  final FirebaseFirestore _firestore;

  BusinessRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Récupère la liste des entreprises.
  /// NOTE: Actuellement configuré pour utiliser des données mockées pour le développement de l'UI.
  Future<List<BusinessModel>> getBusinesses() async {
    // Simule une latence réseau et retourne la liste mockée.
    return Future.delayed(const Duration(seconds: 1), () => mockBusinesses);

    /* --- Implémentation originale avec Firestore ---
    try {
      final snapshot = await _firestore.collection('businesses').get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        return BusinessModel.fromMap(doc.id, doc.data());
      }).toList();
    } on FirebaseException catch (e) {
      // Gérer les erreurs spécifiques à Firebase (ex: permission-denied)
      throw Exception('Failed to get businesses: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred while fetching businesses.');
    }
    */
  }

  /// Récupère une entreprise spécifique par son ID depuis Firestore.
  Future<BusinessModel> getBusinessById(String id) async {
    try {
      final doc = await _firestore.collection('businesses').doc(id).get();

      if (!doc.exists) {
        throw Exception('Business with ID $id not found.');
      }

      return BusinessModel.fromMap(doc.id, doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get business: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred while fetching the business.');
    }
  }
}
