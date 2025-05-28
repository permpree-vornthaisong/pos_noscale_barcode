Future<int> LENGHT_DATA_THAI(String DATA) async {
  int L = DATA.length;
  int out_L = L;

  for (int i = 0; i < L; i++) {
    if (DATA[i] == "่") {
      //ไม่เอก

      out_L--;
    } else if (DATA[i] == "้") {
      //ไม่โท

      out_L--;
    } else if (DATA[i] == "๊") {
      //ไม่ตรี

      out_L--;
    } else if (DATA[i] == "๋") {
      //ไม่จัตวา

      out_L--;
    } else if (DATA[i] == "ุ") {
// สระระอุ
      out_L--;
    } else if (DATA[i] == "ู") {
// สระระอู

      out_L--;
    } else if (DATA[i] == "ั") {
//  ไม่หันะกาท

      out_L--;
    } else if (DATA[i] == "ิ") {
      // ิ

      out_L--;
    } else if (DATA[i] == "ี") {
      // ี

      out_L--;
    } else if (DATA[i] == "ื") {
      //  ื

      out_L--;
    } else if (DATA[i] == "ึ") {
      //  ึ

      out_L--;
    } else if (DATA[i] == "็") {
      //  ็

      out_L--;
    }
  }

  return out_L;
}
