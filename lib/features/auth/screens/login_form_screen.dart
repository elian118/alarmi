import 'package:alarmi/common/consts/enums/breakpoint.dart';
import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/cst_text_form_field.dart';
import 'package:alarmi/common/widgets/web_container.dart';
import 'package:alarmi/features/auth/widgets/form_button.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginFormScreen> createState() => _LoginFormScreenState();
}

// 다수의 입력 필드들을 하나의 폼에서 제어하려면, 폼 접근자를 활용해야 효율적이다.
class _LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  // 폼 접근자 선언 -> 리액트 useRef 접근자 역할 동일
  // stateful widget instance
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {}; // 서버로 전송할 폼 데이터

  // 실행 시점의 Form stateful 위젯 인스턴스 내 모든 TextFormField -> validator 콜백 실행
  // validator 중 하나라도 반환 문자열이 있으면, validate() => false -> 유효성 위반 처리
  void _onSubmitTap() {
    // nullable currentState 사용 방식도 useRef 와 동일
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        // 입력값 모두 유효하면, 폼 안에 위치한 모든 TextFormField -> onSaved 실행
        _formKey.currentState?.save();
        // ref.read(loginProvider.notifier).login(
        //       formData['email']!,
        //       formData['password']!,
        //       context,
        //       mounted,
        //     );
      }
    }
  }

  void _onSavedFn(String field, String? newValue) {
    if (newValue != null) formData[field] = newValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusout(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: WebContainer(
          padding: const EdgeInsets.all(Sizes.size36),
          alignment: Alignment.center,
          maxWidth: Breakpoint.sm,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CstTextFormField(
                  hintText: 'Email',
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please write your email";
                    }
                    return null;
                  },
                  onSaved: (newValue) => _onSavedFn('email', newValue),
                ),
                Gaps.v16,
                CstTextFormField(
                  hintText: 'Password',
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please write password';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _onSavedFn('password', newValue),
                ),
                Gaps.v28,
                GestureDetector(
                  onTap: _onSubmitTap,
                  child: FormButton(
                    disabled: false,
                    // ref
                    //     .watch(loginProvider) // 화면에 비활성 상태 반영되려면 watch 사용
                    //     .isLoading,
                    text: 'Log in',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
