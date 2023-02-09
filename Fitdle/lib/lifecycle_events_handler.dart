import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? suspendingCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // Basically when the screen is popped off of navigation stack
        // In this case, we want to remove the lifecycle observer:
        // WidgetsBinding.instance?.removeObserver(this); 
        // as the callback
        if (suspendingCallBack != null) {
          await suspendingCallBack!();
        }
        break;
    }
  }
}