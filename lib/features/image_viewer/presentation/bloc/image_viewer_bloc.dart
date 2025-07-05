import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/download_image_usecase.dart';
import 'image_viewer_event.dart';
import 'image_viewer_state.dart';

class ImageViewerBloc extends Bloc<ImageViewerEvent, ImageViewerState> {
  final DownloadImageUseCase _downloadImageUseCase;

  ImageViewerBloc({required DownloadImageUseCase downloadImageUseCase})
    : _downloadImageUseCase = downloadImageUseCase,
      super(ImageViewerInitial()) {
    on<DownloadImage>(_onDownloadImage);
  }

  Future<void> _onDownloadImage(
    DownloadImage event,
    Emitter<ImageViewerState> emit,
  ) async {
    emit(ImageViewerLoading());

    try {
      final filePath = await _downloadImageUseCase.execute(event.imageUrl);

      // show a snackbar to the user
      emit(ImageViewerDownloaded(filePath));
    } catch (e) {
      emit(ImageViewerError(e.toString()));
    }
  }
}
