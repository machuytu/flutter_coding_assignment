import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../home/domain/entities/image_entity.dart';
import '../bloc/image_viewer_bloc.dart';
import '../bloc/image_viewer_event.dart';
import '../bloc/image_viewer_state.dart';
import '../../domain/usecases/download_image_usecase.dart';
import '../../data/repositories/image_repository_impl.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/themes/icons/app_icons.dart';

class ImageViewerScreen extends StatelessWidget {
  final ImageEntity image;

  const ImageViewerScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) {
        final imageRepository = ImageRepositoryImpl();
        final downloadImageUseCase = DownloadImageUseCase(imageRepository);
        return ImageViewerBloc(downloadImageUseCase: downloadImageUseCase);
      },
      child: BlocListener<ImageViewerBloc, ImageViewerState>(
        listener: (context, state) {
          if (state is ImageViewerDownloaded) {
            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.downloadedSuccessfully,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          } else if (state is ImageViewerError) {
            // Show error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<ImageViewerBloc, ImageViewerState>(
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.imageViewerBackground,
                foregroundColor: AppColors.textLight,
                actions: [
                  IconButton(
                    onPressed: () {
                      context.read<ImageViewerBloc>().add(
                        DownloadImage(image.url),
                      );
                    },
                    icon: Image.asset(
                      AppIcons.downloadIcon,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  const SizedBox(width: 19),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Image.asset(
                      AppIcons.closeIcon,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
              body: Container(
                height: double.infinity,
                width: double.infinity,
                color: AppColors.imageViewerBackground,
                child: InteractiveViewer(
                  child: Image.network(
                    image.url,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.imageViewerErrorBackground,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                color: AppColors.imageViewerErrorIcon,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.failedToLoadImage,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.imageViewerErrorText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
