import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FilterInitial extends FilterState {}

class FilterLoading extends FilterState {}

class FilterLoaded extends FilterState {}

class FilterError extends FilterState {}
