import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/cupertino.dart';

// 현재 기기가 폴더블 기기의 해상도 비율인지 확인
bool isOpenFoldableDevice(BuildContext context) {
  double aspectRatio = getWinWidth(context) / getWinHeight(context);
  return aspectRatio > 0.7;
}

double getRelativeHeight(BuildContext context) =>
    getWinHeight(context) * (isOpenFoldableDevice(context) ? 1 : 0.7);
