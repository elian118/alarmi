import 'package:alarmi/features/main/models/noti_type.dart';

class Noti {
  final String notiId;
  final NotiType notiType;
  final String sender;
  final String receiver;
  final String notiDate;
  final bool hasRead;
  final String? teamName;
  final String? senderThumb;

  Noti({
    required this.receiver,
    required this.sender,
    required this.notiDate,
    required this.notiId,
    required this.notiType,
    required this.hasRead,
    required this.teamName,
    required this.senderThumb,
  });
}
