import 'package:flutter/material.dart';
import 'dart:async';

class TabTimer {
  bool state;

  TabTimer({required this.state});
}

class TabTimerProvider with ChangeNotifier {
  List<TabTimer> tabTimers = [TabTimer(state: true)];
  Timer? _timer;
  int _pressCount = 0;

  List<TabTimer> getTransactions() {
    return tabTimers;
  }

  void updateState(bool data) {
    tabTimers[0].state = data;
    notifyListeners();
  }

  void startTimer() {
    if (_pressCount == 0) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        tabTimers[0].state = false;
        //  print(tabTimers[0].state);
        //  print("Timer stopped ");
        _timer?.cancel();
        notifyListeners();
      });
    }

    _pressCount++;

    if (_pressCount == 2) {
      _pressCount = 0;
      // _timer?.cancel(); // Stop the timer
      tabTimers[0].state = true;
      // print(tabTimers[0].state);

      notifyListeners();
      // print("Timer stopped - TRUE");
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose of the timer when the provider is disposed
    super.dispose();
  }
}
