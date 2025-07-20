import 'package:alarmi/common/widgets/cst_rounded_elevated_btn.dart';
import 'package:alarmi/common/widgets/cst_text_form_field.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
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

  final RegExp _allowedCharsRegExp = RegExp(r'^[a-zA-Z0-9가-힣\s]*$');

  @override
  void initState() {
    _nameController = TextEditingController(
      text: ref.read(onboardViewProvider).name,
    );
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    String? _nameValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '이름을 입력해주세요.';
      }
      if (!_allowedCharsRegExp.hasMatch(value)) {
        return '특수문자는 사용할 수 없습니다.';
      }
      return null;
    }

    return onboardState.stage == 3
        ? Stack(
          children: [
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black87.withValues(alpha: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: CstTextFormField(
                      hintText: '눌러서 이름 입력하기',
                      validator: _nameValidator,
                      onChanged: (value) {
                        onboardNotifier.setName(value);
                        _formKey.currentState?.validate();
                      },
                      onSaved: (value) {},
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
