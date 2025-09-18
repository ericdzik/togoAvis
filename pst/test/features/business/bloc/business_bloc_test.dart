import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pst/features/business/bloc/business_bloc.dart';
import 'package:pst/features/business/bloc/business_event.dart';
import 'package:pst/features/business/bloc/business_state.dart';
import 'package:pst/features/business/data/business_model.dart';
import 'package:pst/features/business/data/business_repository.dart';

class MockBusinessRepository extends Mock implements BusinessRepository {}

void main() {
  late BusinessBloc businessBloc;
  late MockBusinessRepository mockBusinessRepository;

  setUp(() {
    mockBusinessRepository = MockBusinessRepository();
    businessBloc = BusinessBloc(businessRepository: mockBusinessRepository);
  });

  tearDown(() {
    businessBloc.close();
  });

  group('BusinessBloc', () {
    final business1 = BusinessModel(
      id: '1',
      name: 'Business 1',
      category: 'Category 1',
      address: 'Address 1',
      contact: 'Contact 1',
      description: 'Description 1',
    );

    blocTest<BusinessBloc, BusinessState>(
      'emits [BusinessLoading, BusinessLoaded] when LoadBusinesses is added.',
      build: () {
        when(mockBusinessRepository.getBusinesses()).thenAnswer((_) async => [business1]);
        return businessBloc;
      },
      act: (bloc) => bloc.add(LoadBusinesses()),
      expect: () => [
        BusinessLoading(),
        BusinessLoaded([business1]),
      ],
    );

    blocTest<BusinessBloc, BusinessState>(
      'emits [BusinessLoading, BusinessDetailLoaded] when GetBusinessById is added.',
      build: () {
        when(mockBusinessRepository.getBusinessById('1')).thenAnswer((_) async => business1);
        return businessBloc;
      },
      act: (bloc) => bloc.add(GetBusinessById('1')),
      expect: () => [
        BusinessLoading(),
        BusinessDetailLoaded(business1),
      ],
    );

    blocTest<BusinessBloc, BusinessState>(
      'emits [BusinessLoading, BusinessError] when getBusinesses throws an exception.',
      build: () {
        when(mockBusinessRepository.getBusinesses()).thenThrow(Exception('Failed to load'));
        return businessBloc;
      },
      act: (bloc) => bloc.add(LoadBusinesses()),
      expect: () => [
        BusinessLoading(),
        isA<BusinessError>(),
      ],
    );
  });
}
