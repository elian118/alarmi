import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/web_container.dart';
import 'package:alarmi/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerWidget {
  static const String routeName = "signUp";
  static const String routeURL = "/";

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: WebContainer(
          padding: EdgeInsets.all(Sizes.size36),
          maxWidth: 800,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.v80,
              Text(
                '알리미 회원가입',
                // AppLocalizations.of(context)!.signUpTitle("TikTok"),
                // S.of(context).signUpTitle("TikTok"),
                style: Theme.of(context).textTheme.headlineSmall,
                // headlineSmall 테마 스타일의 특정 속성만 변경해 사용하려면, copyWith 사용
                // style: Theme.of(context)
                //     .textTheme
                //     .headlineSmall!
                //     .copyWith(color: Colors.red),
              ),
              Gaps.v20,
              Opacity(
                opacity: 0.7, // 텍스트는 불투명도 설정이 테마별 색상을 직접 입력하는 방법보다 더 간편
                child: Text(
                  '13994',
                  // S.of(context).signUpSubtitle(13944),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.v40,
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        // color: isDarkMode(context)
        //     ? null // null -> 기본 다크테마 지정컬러 적용
        //     : Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.size32,
            bottom: Sizes.size64,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('이미 계정이 있습니다.'),
              // Text(S.of(context).alreadyHaveAnAccount),
              Gaps.h5,
              GestureDetector(
                onTap: () => context.pushNamed(LoginScreen.routeName),
                child: Text(
                  'X',
                  // S.of(context).logIn('x'),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
