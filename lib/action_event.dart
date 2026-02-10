import 'package:digia_ui/digia_ui.dart';

class UIActionEvent {
  final UIActionType actionType;
  final String viewId;
  final Map<String, dynamic> args;

  UIActionEvent({
    required this.actionType,
    required this.viewId,
    required this.args,
  });
}
