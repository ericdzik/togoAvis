import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pst/features/business/data/business_model.dart';

class BusinessRepository {
  final FirebaseFirestore _firestore;

  BusinessRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Récupère la liste des entreprises depuis la collection 'businesses' de Firestore.
  Future<List<BusinessModel>> getBusinesses() async {
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
  }
}
