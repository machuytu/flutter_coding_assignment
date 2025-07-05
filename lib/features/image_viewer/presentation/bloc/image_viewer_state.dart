import 'package:equatable/equatable.dart';

abstract class ImageViewerState extends Equatable {
  const ImageViewerState();

  @override
  List<Object?> get props => [];
}

class ImageViewerInitial extends ImageViewerState {}

class ImageViewerLoading extends ImageViewerState {}

class ImageViewerDownloaded extends ImageViewerState {
  final String filePath;

  const ImageViewerDownloaded(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class ImageViewerError extends ImageViewerState {
  final String message;

  const ImageViewerError(this.message);

  @override
  List<Object?> get props => [message];
}
