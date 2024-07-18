import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../controllers/server_select_notifier.dart';

final serverSelectProvider =
    NotifierProvider<ServerSelectNotifier, String>(ServerSelectNotifier.new);
