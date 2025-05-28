import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/threme_state.dart';

class threme_state_provider with ChangeNotifier {
  List<threme_state> threme_states = [threme_state(state: true)];

  List<threme_state> gettranscation() {
    return threme_states;
  }

  void update_state(bool data) {
    threme_states[0].state = data;
    notifyListeners();
  }
}
