import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';

final String storageUrl = '$baseUrl2/storage';

String getImageUrl(String path) {
  print('getImageUrl input: "$path"');
  if (path.isEmpty) return '';
  if (path.startsWith('http')) return path;
  return '$storageUrl/$path';
}

String fixImageUrl(String url) {
  // Replace localhost with your machine's LAN IP during development
  return url.replaceFirst('http://localhost', baseUrl2);
}
