import 'package:equatable/equatable.dart';

class KycState extends Equatable {
  @override
  List<Object?> get props => [];
}

class KycInitial extends KycState {}

class KycLoading extends KycState {}

class KycLoaded extends KycState {}

class KycError extends KycState {}
