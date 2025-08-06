import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/main/models/noti.dart';
import 'package:alarmi/features/main/models/noti_type.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:flutter/material.dart';

class NotiTile extends StatefulWidget {
  final Noti noti;

  const NotiTile({super.key, required this.noti});

  @override
  State<NotiTile> createState() => _NotiTileState();
}

class _NotiTileState extends State<NotiTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Gaps.h6,
                  Text(
                    widget.noti.sender == 'admin' ? '알림' : widget.noti.sender,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Text(
                formatDate(widget.noti.notiDate, 'yyyy년 M월 d일'),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Gaps.v8,
          Text(
            widget.noti.notiType.getNotiMsg(
              widget.noti.sender,
              widget.noti.receiver,
              widget.noti.teamName,
            ),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          widget.noti.notiType == NotiType.InviteMemberToMe ||
                  widget.noti.notiType == NotiType.ReceiveFriendReq
              ? Column(
                children: [
                  Gaps.v24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            backgroundColor: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Container(
                            child: Center(
                              child: Text('거절', style: TextStyle(fontSize: 14)),
                            ),
                          ),
                        ),
                      ),
                      Gaps.h16,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: SizedBox(
                            height: 44,
                            child: Center(
                              child: Text('수락', style: TextStyle(fontSize: 14)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
              : Container(),
        ],
      ),
    );
  }
}
