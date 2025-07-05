import 'package:equatable/equatable.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/entities/weather_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ImageEntity> images;
  final WeatherEntity weather;

  const HomeLoaded({required this.images, required this.weather});

  @override
  List<Object?> get props => [images, weather];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
