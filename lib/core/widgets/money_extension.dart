import 'package:intl/intl.dart';

extension MoneyFormat on num {
  String toVND() {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
      decimalDigits: 0,
    ).format(this);
  }
}
