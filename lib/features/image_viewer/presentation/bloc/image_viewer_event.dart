import 'package:equatable/equatable.dart';

abstract class ImageViewerEvent extends Equatable {
  const ImageViewerEvent();

  @override
  List<Object?> get props => [];
}

class DownloadImage extends ImageViewerEvent {
  final String imageUrl;

  const DownloadImage(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}
