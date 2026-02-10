library digia_ui_clevertap;

import 'dart:async';
import 'dart:convert';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:digia_ui/digia_ui.dart';
import 'package:digiaclevertap/action_event.dart';

export 'dart:async';
export 'dart:convert';
export 'package:clevertap_plugin/clevertap_plugin.dart';
export 'package:flutter/material.dart';

class DigiaClevertapManager {
  DigiaClevertapManager._();

  static final DigiaClevertapManager instance = DigiaClevertapManager._();

  final CleverTapPlugin _cleverTapPlugin = CleverTapPlugin();

  final StreamController<UIActionEvent> _actionController =
      StreamController.broadcast();

  Stream<UIActionEvent> get actions => _actionController.stream;

  bool _disposed = false;

  void init() {
    _disposed = false;
    _cleverTapPlugin.setCleverTapDisplayUnitsLoadedHandler(
      _onDisplayUnitsLoaded,
    );
  }

  void dispose() {
    _disposed = true;
    _cleverTapPlugin.setCleverTapDisplayUnitsLoadedHandler(_noOpHandler);
  }

  void _noOpHandler(List<dynamic>? _) {}

  void _onDisplayUnitsLoaded(List<dynamic>? units) {
    if (_disposed || units == null || units.isEmpty) return;

    for (var unit in units) {
      final customExtras = unit["custom_kv"];
      if (customExtras == null) continue;

      final command = customExtras["command"];
      final viewId = customExtras["viewId"];

      if (command == null || viewId == null) continue;

      UIActionType? actionType;
      try {
        actionType = UIActionType.fromString(command.toString().toUpperCase());
      } catch (_) {
        continue;
      }

      Map<String, dynamic> argsMap = {};
      final argsRaw = customExtras["args"];

      if (argsRaw is String) {
        try {
          argsMap = jsonDecode(argsRaw);
        } catch (_) {}
      } else if (argsRaw is Map) {
        argsMap = Map<String, dynamic>.from(argsRaw);
      }

      if (actionType != null) {
        _actionController.add(
          UIActionEvent(
            actionType: actionType,
            viewId: viewId.toString(),
            args: argsMap,
          ),
        );
      }
    }
  }
}
