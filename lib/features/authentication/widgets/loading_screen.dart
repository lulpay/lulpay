import 'dart:async';

import 'package:flutter/material.dart';
import '../../../constants/padding.dart';
import '../../common/widgets/kabbee_progress_indicator.dart';
import '../../common/widgets/kabbee_text.dart';
import '../../../theme/colors_utility.dart';

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}

class LoadingScreen {
  LoadingScreen._sharedInstance();

  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String message,
  }) {
    if (controller?.update(message) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        message: message,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String message,
  }) {
    final textController = StreamController<String>();
    textController.add(message);

    final state = Overlay.of(context);

    if (state == null) {
      return null;
    }
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: backgroundColor(context).withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * .8,
                maxHeight: size.height * .8,
                minHeight: 45,
                minWidth: size.width * .5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder(
                      stream: textController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return KabbeeText(
                            snapshot.data as String,
                            textAlign: TextAlign.center,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const KabbeeProgressIndicator(
                      maxHeight: 44,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textController.add(text);
        return true;
      },
    );
  }
}
