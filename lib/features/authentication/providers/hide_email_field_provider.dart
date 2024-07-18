import 'package:hooks_riverpod/hooks_riverpod.dart';

final hideEmailFieldProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});
