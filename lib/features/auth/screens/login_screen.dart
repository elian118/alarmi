import 'package:alarmi/common/consts/enums/breakpoint.dart';
import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/web_container.dart';
import 'package:alarmi/features/auth/screens/login_form_screen.dart';
import 'package:alarmi/features/auth/widgets/auth_button.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends ConsumerWidget {
  static const String routeName = "login";
  static const String routeURL = "/login";

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: WebContainer(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(Sizes.size36),
          maxWidth: Breakpoint.sm,
          child: Column(
            children: [
              Gaps.v80,
              Text(
                'Log in to Alarmi',
                // S.of(context).loginTitle('TikTok'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Gaps.v20,
              Opacity(
                opacity: 0.7,
                child: Text(
                  'Manage your account, check notifications, comment on videos, and more.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.v40,
              GestureDetector(
                // onTap: () => navPush(context, const UsernameScreen()),
                onTap: () => navPush(context, const LoginFormScreen()),
                child: const AuthButton(
                  // font_awesome_flutter 패키지 설치 이후 사용 가능
                  icon: FaIcon(FontAwesomeIcons.user),
                  text: 'Use email & password',
                ),
              ),
              Gaps.v16,
              GestureDetector(
                // onTap:
                //     () => ref
                //         .read(socialAuthProvider.notifier)
                //         .githubSignIn(context, true),
                child: const AuthButton(
                  icon: FaIcon(FontAwesomeIcons.github),
                  text: 'Continue with Github',
                ),
              ),
              Gaps.v16,
              const AuthButton(
                icon: FaIcon(FontAwesomeIcons.apple),
                text: 'Continue with Google',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
