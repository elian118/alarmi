import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

String getCurrentPath(BuildContext context) =>
    GoRouterState.of(context).uri.toString();

// 스크린 이동
void goRoutePush(BuildContext context, String location, {Object? extra}) =>
    context.push(location, extra: extra);

// 명명된 스크린으로 이동
void goRoutePushNamed(BuildContext context, String location, {Object? extra}) =>
    context.pushNamed(location, extra: extra);

// 명명된 스크린으로 이동. 해당 스크린의 뒤로가기 방지
void goRoutePushReplacementNamed(
  BuildContext context,
  String location, {
  Object? extra,
}) => context.pushReplacementNamed(location, extra: extra);

// 스크린 이동. 단, 사용 시 기존 스크린 스택 모두 초기화(모바일은 하단 뒤로가기 버튼 사용 불가)
// 홈과 같은 시작점 스크린으로 돌아갈 때 적합
void goRouteGo(BuildContext context, String location) => context.go(location);

// 명명된 스크린으로 이동. 단, 사용 시 기존 스크린 스택 모두 초기화(모바일은 뒤로가기 버튼 사용 불가)
// 홈과 같은 시작점 스크린으로 돌아갈 때 적합
void goRouteNamed(BuildContext context, String location) =>
    context.goNamed(location);

// 뒤로 가기. goRoutePush()로 이동된 스크린에서 사용 가능
void goRoutePop(BuildContext context) => context.pop();

void navPush(
  BuildContext context,
  Widget widget, [
  bool? isFullScreenDialog,
]) async {
  final result = await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => widget,
      fullscreenDialog: isFullScreenDialog ?? false,
    ),
  );
  debugPrint(result);
}

CustomTransitionPage<void> goRouteOpacityPageBuilder(
  BuildContext context,
  GoRouterState state,
  Widget target,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: target,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
    transitionDuration: 300.ms,
    reverseTransitionDuration: 300.ms,
  );
}

CustomTransitionPage<void> goRouteSlidePageBuilder(
  BuildContext context,
  GoRouterState state, {
  required Widget target,
  Offset? begin,
  Offset? end,
  Duration? duration,
  bool? barrierDismissible,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: target,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      begin = begin ?? Offset(0.0, 1.0);
      end = end ?? Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: duration ?? 0.4.seconds,
    reverseTransitionDuration: duration ?? 0.4.seconds,
    // 배경 탭으로 닫히지 않도록 (다이얼로그처럼 사용 시)
    barrierDismissible: barrierDismissible ?? false,
  );
}

// 일반 슬라이드 페이지 라우트
PageRouteBuilder slidePageRoute({
  required Widget page,
  Offset? begin,
  Offset? end,
  Curve? curve,
  Duration? duration,
  bool? barrierDismissible,
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 기본: 오른쪽에서 왼쪽으로 슬라이드
      var tween = Tween(
        begin: begin ?? Offset(1.0, 0.0),
        end: end ?? Offset.zero,
      ).chain(CurveTween(curve: curve ?? Curves.easeOut));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: duration ?? 0.4.seconds,
    reverseTransitionDuration: duration ?? 0.4.seconds,
    opaque: false,
    // 배경 탭으로 닫히지 않도록 (다이얼로그처럼 사용 시)
    barrierDismissible: barrierDismissible ?? false,
  );
}

// 스크린 적용(애니메이션 전환 옵션 추가)
void navPagePush(
  BuildContext context,
  Widget widget, [
  bool? isFullScreenDialog,
]) async {
  final result = await Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 200),
      reverseTransitionDuration: Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween(
          begin: Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);
        final opacityAnimation = Tween(begin: 0.5, end: 1.0).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: opacityAnimation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      fullscreenDialog: isFullScreenDialog ?? false,
    ),
  );
  debugPrint(result);
}
