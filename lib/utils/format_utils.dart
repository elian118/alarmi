import 'package:intl/intl.dart';

String getNumberFormat(double value, {int? decimalDigits}) {
  String pattern;
  if (decimalDigits == null) {
    // 소수점 자릿수를 지정하지 않으면 (null), 소수점 이하를 제거
    pattern = '###,###,##0';
  } else if (decimalDigits == 0) {
    // decimalDigits가 0이면 소수점 이하를 제거 (명시적)
    pattern = '###,###,##0';
  } else {
    // decimalDigits가 있으면 해당 자릿수만큼 소수점 이하를 표시
    final String decimalPattern =
        '0' * decimalDigits; // 예: 2 -> '00', 3 -> '000'
    pattern = '###,###,##0.$decimalPattern';
  }

  final numberFormat = NumberFormat(pattern, 'ko_KR');
  return numberFormat.format((value).abs());
}
