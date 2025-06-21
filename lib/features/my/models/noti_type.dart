enum NotiType {
  FriendRequest(template: '친구 신청을 보냈어요', type: 'general'),
  ReceiveFriendRequest(
    template: '|sender|님이 친구를 신청했어요. 수락하시겠습니까?',
    type: 'invitation',
  ),
  AcceptFriendship(template: '|receiver|님이 친구 신청을 수락했어요.', type: 'accept'),
  ReceiverWakeUp(template: '내가 깨운 알림에 |receiver|님이 일어났어요!', type: 'general'),
  WeekAccomplished(template: '주간 기상 목표를 달성했어요. 보상을 확인하세요!', type: 'general'),
  MemberInviteSomeoneToTeam(
    template: '|sender|님이 잠수함에 |receiver|님을 초대했어요.',
    type: 'general',
  ),
  BeInvitedToTeam(
    template: '|teamName| 잠수함에 초대받았어요! 탑승하시겠어요?',
    type: 'invitation',
  ),
  AcceptTeamInvitation(
    template: '|receiver|님이 |teamName| 잠수함에 탑승했어요.',
    type: 'accept',
  );

  final String template;
  final String type;

  const NotiType({required this.template, required this.type});

  String getNotiMsg(String sender, String? receiver, String? teamName) =>
      template
          .replaceAll('|sender|', sender)
          .replaceAll('|receiver|', receiver ?? '')
          .replaceAll('|teamName|', teamName ?? '');
}
