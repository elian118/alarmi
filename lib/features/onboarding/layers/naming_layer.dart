import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/widgets/cst_rounded_elevated_btn.dart';
import 'package:alarmi/common/widgets/cst_text_form_field.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NamingLayer extends ConsumerStatefulWidget {
  const NamingLayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NamingLayerState();
}

class _NamingLayerState extends ConsumerState<NamingLayer> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String? _errorMessage;
  final RegExp _allowedCharsRegExp = RegExp(r'^[a-zA-Z0-9가-힣\s]*$');

  @override
  void initState() {
    _nameController = TextEditingController(
      text: ref.read(onboardViewProvider).name,
    );
    _errorMessage = null;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _runValidation(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력해주세요.';
    }
    if (!_allowedCharsRegExp.hasMatch(value)) {
      return '특수문자는 사용할 수 없습니다.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    return onboardState.stage == 3
        ? Stack(
          children: [
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black87.withValues(alpha: 0.5),
                ),
              ),
            ),
            Positioned(
              child: Container(
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 150,
                      left: 60,
                      right: 60,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: CstTextFormField(
                            initialValue: onboardState.name,
                            hintText: '눌러서 이름 입력하기',
                            validator: null, // 기본 에러 폼 사용 안 함
                            maxLength: 12,
                            onChanged: (value) {
                              onboardNotifier.setName(value);
                              // 기본 에러 폼 사용 안 함
                              // _formKey.currentState?.validate();
                              setState(() {
                                _errorMessage = _runValidation(value);
                              });
                            },
                            onSaved: (value) {},
                          ),
                        ),
                        if (_errorMessage != null)
                          SizedBox(
                            width: getWinWidth(context),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Gaps.v72,
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              child: CstRoundedElevatedBtn(
                label: '완료',
                height: 58,
                onPressed:
                    onboardState.name.isNotEmpty
                        ? () => onboardNotifier.setStage(onboardState.stage + 1)
                        : null,
              ),
            ),
          ],
        )
        : Container();
  }
}
