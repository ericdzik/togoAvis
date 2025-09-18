import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pst/features/business/data/business_model.dart';
import 'package:pst/features/business/data/business_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late BusinessRepository businessRepository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    businessRepository = BusinessRepository(firestore: fakeFirestore);
  });

  group('BusinessRepository', () {
    final business1 = BusinessModel(
      id: '1',
      name: 'Business 1',
      category: 'Category 1',
      address: 'Address 1',
      contact: 'Contact 1',
      description: 'Description 1',
    );
    final business2 = BusinessModel(
      id: '2',
      name: 'Business 2',
      category: 'Category 2',
      address: 'Address 2',
      contact: 'Contact 2',
      description: 'Description 2',
    );

    group('getBusinesses', () {
      test('returns a list of businesses when the collection is not empty', () async {
        await fakeFirestore.collection('businesses').add(business1.toMap());
        await fakeFirestore.collection('businesses').add(business2.toMap());

        final businesses = await businessRepository.getBusinesses();

        expect(businesses.length, 2);
        expect(businesses.first.name, business1.name);
      });

      test('returns an empty list when the collection is empty', () async {
        final businesses = await businessRepository.getBusinesses();

        expect(businesses.isEmpty, true);
      });
    });

    group('getBusinessById', () {
      test('returns a business when the document exists', () async {
        await fakeFirestore.collection('businesses').doc('1').set(business1.toMap());

        final business = await businessRepository.getBusinessById('1');

        expect(business.name, business1.name);
      });

      test('throws an exception when the document does not exist', () async {
        expect(
          () async => await businessRepository.getBusinessById('1'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
