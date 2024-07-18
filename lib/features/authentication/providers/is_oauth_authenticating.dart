import 'package:hooks_riverpod/hooks_riverpod.dart';

final oauthAuthenticatingProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
