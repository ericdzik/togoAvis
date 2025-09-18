import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pst/features/business/bloc/business_event.dart';
import 'package:pst/features/business/bloc/business_state.dart';
import 'package:pst/features/business/data/business_repository.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final BusinessRepository _businessRepository;

  BusinessBloc({required BusinessRepository businessRepository})
      : _businessRepository = businessRepository,
        super(BusinessInitial()) {
    on<LoadBusinesses>(_onLoadBusinesses);
  }

  Future<void> _onLoadBusinesses(
    LoadBusinesses event,
    Emitter<BusinessState> emit,
  ) async {
    emit(BusinessLoading());
    try {
      final businesses = await _businessRepository.getBusinesses();
      emit(BusinessLoaded(businesses));
    } catch (e) {
      emit(BusinessError(e.toString()));
    }
  }
}
