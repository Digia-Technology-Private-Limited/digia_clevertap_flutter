import 'package:digia_ui/digia_ui.dart';
import 'package:digiaclevertap/digia_clevertap_manager.dart';

class DigiaClevertapWidget extends StatefulWidget {
  final Widget child;

  const DigiaClevertapWidget({super.key, required this.child});

  @override
  State<DigiaClevertapWidget> createState() => _DigiaClevertapWidgetState();
}

class _DigiaClevertapWidgetState extends State<DigiaClevertapWidget> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    DigiaClevertapManager.instance.init();

    _subscription = DigiaClevertapManager.instance.actions.listen((event) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DUIFactory().showUIAction(
          event.actionType,
          context,
          event.viewId,
          componentArgs: event.args,
        );
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    DigiaClevertapManager.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
