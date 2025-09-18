import 'package:equatable/equatable.dart';
import 'package:pst/features/business/data/business_model.dart';

abstract class BusinessState extends Equatable {
  const BusinessState();

  @override
  List<Object> get props => [];
}

class BusinessInitial extends BusinessState {}

class BusinessLoading extends BusinessState {}

class BusinessLoaded extends BusinessState {
  final List<BusinessModel> businesses;

  const BusinessLoaded(this.businesses);

  @override
  List<Object> get props => [businesses];
}

class BusinessDetailLoaded extends BusinessState {
  final BusinessModel business;

  const BusinessDetailLoaded(this.business);

  @override
  List<Object> get props => [business];
}

class BusinessError extends BusinessState {
  final String message;

  const BusinessError(this.message);

  @override
  List<Object> get props => [message];
}
