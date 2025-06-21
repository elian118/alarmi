import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/cst_text_btn.dart';
import 'package:alarmi/features/my/widgets/feed_dialog.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyCatLayer extends StatefulWidget {
  const MyCatLayer({super.key});

  @override
  State<MyCatLayer> createState() => _MyCatLayerState();
}

class _MyCatLayerState extends State<MyCatLayer> {
  bool _isLight = false;
  String _message = '좋은 아침!';

  void _toggleLight() {
    setState(() {
      _isLight = !_isLight;
    });
  }

  void _setMessage(newMsg) {
    setState(() {
      _message = newMsg;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _message = '좋은 아침!';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: getWinHeight(context) * 0.22,
          child: Container(
            alignment: Alignment.center,
            width: getWinWidth(context),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _isLight ? 0 : 1,
              curve: Curves.easeInOut,
              child: Container(
                height: 43,
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.size18,
                  vertical: Sizes.size8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _message,
                  style: TextStyle(
                    fontSize: Sizes.size18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: getWinHeight(context) * 0.22,
          child: Container(
            alignment: Alignment.center,
            width: getWinWidth(context),
            child: IgnorePointer(
              ignoring: true,
              child: Image.asset('assets/images/eclipse.png'),
            ),
          ),
        ),
        Positioned(
          top: getWinHeight(context) * 0.3,
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 32),
            child: GestureDetector(
              onTap: () => {if (_isLight == false) _toggleLight()},
              child: Image.asset('assets/images/character.png'),
            ),
          ),
        ),
        Positioned(
          top: getWinHeight(context) * 0.22,
          child: Container(
            alignment: Alignment.center,
            width: getWinWidth(context),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _isLight ? 1 : 0,
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CstTextBtn(
                        imgIconSrc: 'assets/images/feed_icon.png',
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: Sizes.size24,
                        ),
                        label: '밥주기',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w600,
                        ),
                        onPressed:
                            () => showModalBottomSheet(
                              context: context,
                              builder:
                                  (context) => FeedDialog(
                                    toggleLight: _toggleLight,
                                    setMessage: _setMessage,
                                  ),
                              isScrollControlled: true,
                            ),
                      ),
                      Gaps.h36,
                      CstTextBtn(
                        imgIconSrc: 'assets/images/fishing_rod_icon.png',
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: Sizes.size24,
                        ),
                        label: '낚시하기',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w600,
                        ),
                        onPressed:
                            () => Fluttertoast.showToast(
                              msg: "낚시하기 클릭",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black54, // 배경색
                              textColor: Colors.white,
                              fontSize: 16.0, // 폰트 크기
                            ),
                      ),
                    ],
                  ),
                  Gaps.v4,
                  Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Color(0xFF424242),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: _toggleLight,
                      icon: Icon(Icons.close),
                      color: Color(0xFFDBDBDB),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
