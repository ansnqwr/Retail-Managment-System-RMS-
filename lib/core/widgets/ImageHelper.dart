import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';

String getImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.trim().isEmpty) {
    return '';
  }
  final cleanPath =
      imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
  return '$baseUrl2/storage/$cleanPath';
}
