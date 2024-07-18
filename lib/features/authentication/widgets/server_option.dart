import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/services/http/kabbee_http.dart';
import '../../common/widgets/kabbee_text.dart';
import '../providers/server_selected_provider.dart';

class ServerOption extends StatelessWidget {
  const ServerOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!KabbeeHttp.isOnProductionServer || true) {
      return Consumer(
        builder: (context, ref, child) {
          var selectedServer = ref.watch(serverSelectProvider);

          return Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: DropdownButton<String>(
              value: selectedServer,
              style: Theme.of(context).textTheme.titleMedium,
              underline: Container(
                height: 2,
                color: Theme.of(context).textTheme.titleMedium!.color,
              ),
              alignment: Alignment.center,
              onChanged: ref.read(serverSelectProvider.notifier).setServer,
              items: [
                for (final option
                    in ref.read(serverSelectProvider.notifier).serverOptions)
                  DropdownMenuItem<String>(
                    value: option,
                    child: KabbeeText.subtitle1(option),
                  )
              ],
            ),
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
