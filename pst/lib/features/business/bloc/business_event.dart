import 'package:equatable/equatable.dart';

abstract class BusinessEvent extends Equatable {
  const BusinessEvent();

  @override
  List<Object> get props => [];
}

class LoadBusinesses extends BusinessEvent {}

class GetBusinessById extends BusinessEvent {
  final String id;

  const GetBusinessById(this.id);

  @override
  List<Object> get props => [id];
}
