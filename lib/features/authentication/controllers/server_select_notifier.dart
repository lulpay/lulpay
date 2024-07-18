import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/servers.dart';
import '../../common/services/db_access.dart';
import '../../common/services/http/kabbee_http.dart';

class ServerSelectNotifier extends Notifier<String> {
  @override
  build() {
    serverOptionsMap = {
      for (final server in ServerType.allServers())
        _serverInitialNameExtract(server).capitalize!: server,
    };

    return serverOptionsMap.entries
        .firstWhere((element) => element.value == KabbeeHttp.url)
        .key;
  }

  late final Map<String, String> serverOptionsMap;

  List<String> get serverOptions => serverOptionsMap.keys.toList();

  void setServer(String? newServer) {
    if (newServer == null) return;

    KabbeeHttp.url = serverOptionsMap[state = newServer]!;

    // log('Newly changed server: ${KabbeeHttp.url}');

    DbAccess.writeData('serverType', KabbeeHttp.url);
  }

  String _serverInitialNameExtract(String server) =>
      server.split('//').last.split('.').first;
}
