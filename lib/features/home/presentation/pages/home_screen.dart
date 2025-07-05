import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../image_viewer/presentation/pages/image_viewer_screen.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import '../../data/repositories/api_repository_impl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider<HomeBloc>(
      create:
          (_) => HomeBloc(
            getHomeDataUseCase: GetHomeDataUseCase(ApiRepositoryImpl()),
          ),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial) {
              context.read<HomeBloc>().add(LoadHomeData());
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.errorMessage(state.message),
                      style: AppTextStyles.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(LoadHomeData());
                      },
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              );
            }
            if (state is HomeLoaded) {
              return _buildLoadedContent(context, state.images, state.weather);
            }
            return Center(child: Text(l10n.unknownState));
          },
        ),
      ),
    );
  }

  Widget _buildLoadedContent(
    BuildContext context,
    List<ImageEntity> images,
    WeatherEntity weather,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Weather Section
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.weatherInCity(weather.city),
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.temperature(weather.temperature),
                  style: AppTextStyles.bodyLargeBold,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Images Section
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 11,
                mainAxisSpacing: 18,
                childAspectRatio: 1.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return _buildImageCard(context, image);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, ImageEntity image) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewerScreen(image: image),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: image.url,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder:
              (context, url) =>
                  const Center(child: CircularProgressIndicator()),
          errorWidget:
              (context, url, error) => Container(
                color: AppColors.textSecondary,
                child: Icon(Icons.error, color: AppColors.error, size: 48),
              ),
        ),
      ),
    );
  }
}
