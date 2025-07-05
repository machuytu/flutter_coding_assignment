import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/entities/weather_entity.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  bool _hasLoadedData = false;
  List<ImageEntity>? _cachedImages;
  WeatherEntity? _cachedWeather;

  HomeBloc({required GetHomeDataUseCase getHomeDataUseCase})
    : _getHomeDataUseCase = getHomeDataUseCase,
      super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    // Return cached data if available
    if (_hasLoadedData && _cachedImages != null && _cachedWeather != null) {
      emit(HomeLoaded(images: _cachedImages!, weather: _cachedWeather!));
      return;
    }

    emit(HomeLoading());

    try {
      final data = await _getHomeDataUseCase.execute();
      final images = data['images'] as List<ImageEntity>;
      final weather = data['weather'] as WeatherEntity;

      // Cache the data
      _cachedImages = images;
      _cachedWeather = weather;
      _hasLoadedData = true;

      emit(HomeLoaded(images: images, weather: weather));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
