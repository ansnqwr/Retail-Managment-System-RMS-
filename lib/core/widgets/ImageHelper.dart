import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';

String getImageUrl(String path) {
  if (path.isEmpty) return '';
  if (path.startsWith('http')) return path;
  return '$baseUrl2/$path';
}
