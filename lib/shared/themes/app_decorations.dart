import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  // Card decorations
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration cardDecorationElevated = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowMedium,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Image viewer info section decoration
  static BoxDecoration imageViewerInfoDecoration = BoxDecoration(
    color: AppColors.surface,
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 4,
        offset: const Offset(0, -2),
      ),
    ],
  );

  // Button decorations
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonPrimary,
    foregroundColor: AppColors.buttonText,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle successButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonSuccess,
    foregroundColor: AppColors.buttonText,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle warningButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonWarning,
    foregroundColor: AppColors.buttonText,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle errorButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonError,
    foregroundColor: AppColors.buttonText,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle disabledButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.textSecondary,
    foregroundColor: AppColors.buttonText,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  // Input field decorations
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.textSecondary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.textSecondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  );

  // Snackbar decorations
  static SnackBarThemeData snackBarTheme = SnackBarThemeData(
    backgroundColor: AppColors.textPrimary,
    contentTextStyle: const TextStyle(color: AppColors.textLight),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  // Success snackbar
  static SnackBar successSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Error snackbar
  static SnackBar errorSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Info snackbar
  static SnackBar infoSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: AppColors.info,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
