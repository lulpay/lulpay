import 'package:hooks_riverpod/hooks_riverpod.dart';

final alreadyRegisteredEmailsProvider =
    StateProvider.autoDispose<Set<String>>((ref) => {});
