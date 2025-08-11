# alarm

alarm application 가칭 그리팅(Griting)

## 환경설정
1. 개발환경
   - flutter SDK: 3.32.8
   - Android 15.0(VanillaIceCream)
     - Pixel 5 - API 35
   - iOS 18.4
     - iPhone 16 Pro Max

2. 구조
   - 본 프로젝트는 MVVM 패턴으로 설계됐으며,<br/> 
     `flutter_riverpod`으로 특정 스크린에서 사용하는 모든 상태를<br/>
     뷰 모델(view model)로 선언해 부모부터 자식까지 모든 위젯이 같은 VM을 바라보도록 구성<br/>
   - `features`
     - 위 설계에 따른 `/lib/features` 이하 기능별 폴더 구성은 아래와 같다.
       - [M]constants: 상수 코드 수록. consts로 명명된 폴더도 있다. 나중에 통일할 것.
       - [M]models: riverpod에서 관리할 대상 상태를 선언한 모델 위치.<br/>외부 DB와 통신을 담당하는 repository 코드까지 존재한다면 여기서 사용하는 entity 역할도 한다.
       - [M]repos: DB와 통신을 담당하는 repository 계층 코드 위치<br/>쿼리 코드가 대부분의 비중 차지
       - [V]screens: go_router와 직접적으로 연결된 최상위 부모 위젯
       - [V]layers: screen을 목적에 따라 여러 레이어로 나눈 자식 위젯 위치<br/>복잡하게 구성된 화면일수록 이 계층 또한 증가
       - [V]widgets: view 단에서 재사용 가능한 가장 작은 단위의 위젯
       - [VM]vms: view models의 줄임말로, <br/>
          화면에 보여줄 변수를 어떤 조건과 상황에서 변경할 지 로직을 선언한 코드 수록<br/>
          유지보수 편의를 위해 하나의 view model은 하나의 model과 쌍을 이뤄 선언<br/>
          view model이 존재하지 않는 곳에서는 services가 이 역할을 대신하기도 한다.
       - [VM+]services: repository 계층과 직접 상호작용하는 코드가 위치<br/>
          VM보다는 더 repository에 가까운 계층이며, VM의 역할이 모호한 기능에서 주로 등장<br/>
          SharedPreferences를 제어하는 코드가 대부분 여기에 속함
   - `common`
     - 특정 기능이나 영역에 속하지 않고 애플리케이션 전반에서 사용되는 코드 위치
       - 구성은 `configs`를 제외하고 `features`와 동일
     - 위 `features`에 사용된 MVVM 패턴 구성은<br/>
       종종 개발 도중 다른 기능에서도 재사용될 수 있는 코드가 작성되기도 한다.<br/>
       이 코드들은 따로 `/common` 아래 같은 규칙으로 명명된 폴더 아래에<br/>
       그 성격에 따라 재배치시킬 것을 권한다.
     - `configs`: 애플리케이션 주요 기능 사용을 위한 초기화 및 제어자 코드가 위치
   - `utils`
     - 반복되는 함수 계산식 또는 가공 패턴 코드를 유틸화해 유형별로 선언한 곳
     - 유틸 함수들은 그 수가 많지 않음을 전제로 작성됨
     - 선언하는 유틸이 너무 많아질 경우, 이름이 겹쳐 혼란이 발생할 우려가 있으므로<br/>
       추후 정적 클래스로 선언해 핼퍼함수로 사용하는 방식도 권함.
3. 의존성 패키지 설명
    - [go_router](https://pub.dev/packages/go_router): 마치 웹페이지 이동처럼, 지정된 주소 또는 이름으로 스크린 이동 지원
      - 설정: `router.dart`
      - 유틸: `route_utils.dart`
        - goRouteOpacityPageBuilder: 전환 시 시크린의 투명도 애니메이션 커스더마이징 지원
        - goRouteSlidePageBuilder: 전환 시 스크린의 이동 에니메이션 커스더마이징 지원
    - [flutter_riverpod](https://pub.dev/packages/flutter_riverpod): 상태관리 패키지. 리액트의 Context API와 사용법 유사
      - 선언하려는 상태가 동기/비동기 여부에 따라 Notifier/AsyncNotifier 상속
    - [shared_preferences](https://pub.dev/packages/shared_preferences)
      - key-value 기반 내부 저장소 사용을 위한 패키지. 플랫폼마다 적합한 내부 저장소 자동 매핑
      - 사용자 아이디, 패스워드, 앱 환경설정 등 개인화 데이터 관리에 적합
      - 사용처
        - 기상미션 완료여부 서비스: `/lib/feature/missions/services/mission_status_service.dart`
        - 고양이(캐릭터) 서비스: `/lib/feature/onboarding/services/character_service.dart`
    - [permission_handler](https://pub.dev/packages/permission_handler)
      - 개발에 필요한 권한 설정 편의를 돕는 패키지
      - 현 단계에서 필요한지 여부는 재검토 필요
    - [awesome_notifications](https://pub.dev/packages/awesome_notifications)
      - 알림 기능 구현을 위해 채택한 패키지
      - 장점
        - 주기적 반복 알림 설정 가능
        - iOS(불안정), aOS 모두 지원
        - 메시지 알림 커스더마이징 자유도 높음
      - 단점
        - 알람음 에셋을 플랫폼 별로 복제해 각각 파일 위치
          - assets 폴더에 있는 파일 사용 불가
          - <b>플랫폼별 알람음 파일 경로</b>
            - iOS: `/ios/` - Xcode 에셋 삽입 기능으로 파일 주입 및 포맷 변경 권함
            - aOS: `/android/app/src/main/src/res/raw/`
        - aOS인 경우 반드시 파일명 앞에 `res_` 접두사 붙여야 인식
        - iOS는 알람음이 한 번만 재생되고 반복 더 안함. 커스덤 진동 기능 미지원
        - 앱 첫 실행 시, 알람음과 진동음 조합별로 알람 채널을 모두 생성해줘야 함
    - (참고) [alarm](https://pub.dev/packages/alarm)
      - awesome_notifications 전에는 alarm 패키지를 적용한 적 있다.(현재 제거됨)
      - 장점
        - 플러터 내 assets/audios 안에 있는 알람음을 그대로 가져다 사용 가능
        - 시스템 부담 덜함(안정적)
      - 단점
        - 커스덤 진동음 설정 불가
        - 주기적 반복 알람 설정 불가
          - 앱 실행마다 재설정하는 방식으로만 개발해야 했음
          - 이는 사용자가 알람을 보고 메시지만 지우거나<br/>
            앱을 전혀 실행하지 않으면 알람이 다신 울리지 않는다는 헛점 존재
    - [flutter_localizations](https://pub.dev/packages/flutter_localization)
      - 플러터에서 로컬 시간대를 추적해 적용할 수 있도록 지원
      - 현재 알람 생성 화면에 표시되는 시간 선택 위젯이 이에 따른 설정을 따르고 있다.
    - [flutter_svg](https://pub.dev/packages/flutter_svg)
      - svg 이미지 파일을 플러터에 띄울 수 있도록 지원
    - [flutter_animate](https://pub.dev/packages/flutter_animate)
      - 플러터에서 애니메이션을 좀 더 쉽게 구현할 수 있도록 간소화된 함수 제공
      - 애니메이션 컨트롤러를 제공해 다른 플러터 애니메이션과 재생주기 싱크를 맞출 수도 있다.
    - [collection](https://pub.dev/packages/collection)
      - 플러터에서 배열의 인덱스까지 사용 가능한 람다 함수 지원
    - [fluttertoast](https://pub.dev/packages/fluttertoast)
      - 어느 플랫폼에서든 어울리는 토스트 기능 구현 지원
      - 등장방식과 내용물, 애니메이션 등 커스더마이징 가능
    - [intl](https://pub.dev/packages/intl)
      - 별도 설치 없이 기본 선언되는 패키지
      - 국제화 설정에 도움을 준다.
    - [just_audio](https://pub.dev/packages/just_audio)
      - assets 폴더에 위치한 오디오 파일 재생 지원
      - 적용
        - 알람 생성/수정 > 알람음 미리듣기
        - 그 외 효과음 재생 적용 가능
    - [vibration](https://pub.dev/packages/vibration)
      - 진동 관련 기능 구현에 사용
      - 이미 상수로 선언된 진동패턴 여럿 제공
      - 진동 패턴 커스더마이징 가능(aOS 전용)
      - 적용
        - 알람 생성/수정 > 미리듣기
        - 조개 흔들기 미션 > 크리티컬 감지 시 즉시 재생
    - [marquee](https://pub.dev/packages/marquee)
      - 문자열이 자연스럽게 지정방향으로 지나가는 효과를 주도록 지원
      - 적용
        - 알람 생성/수정 > 알람음 재생 시 현재 재생되고 있음을 이 효과로 표시
    - [sqflite](https://pub.dev/packages/sqflite)
      - 내부 DB sqlite 관련 기능을 플러터에서 개발하도록 지원
      - awesome_notifications 자체는 오직 등록/삭제만 가능하므로,<br/>
        sqflite과 연동해 피그마와 같은 기능을 구현해야 했음
      - 적용
        - 알람 조회/저장/수정/삭제
    - [shake](https://pub.dev/packages/shake)
      - 기기 흔들림 감지 패키지
      - 본래 기기 흔들림 판정은 여러 복합적 요소를 고려해 기준을 정해야 하지만<br/>
        shake는 이런 기준을 미리 정규화해 빠른 개발을 지원
      - 단, 특정 흔들림 강도 이상이 되어야 하는 등의 커스더마이징 불가
      - 나중에 고도화 필요 시 대체
    - [lottie](https://pub.dev/packages/lottie)
      - 플러터에서 로티 이미지를 띄우기 지원
    - [animated_text_kit](https://pub.dev/packages/animated_text_kit)
      - 문자열 타이핑 애니메이션 효과 지원
      - 적용
        - 캐릭터 말풍선
    - [dotlottie_loader](https://pub.dev/packages/dotlottie_loader)
      - 로티 파일 이미지를 더 압축한 .lottie 파일 띄우기 지원
      - 리즌에서 제공한 .lottie 파일 중 실제 띄우기 가능한 파일은 없었음
    - [google_fonts](https://pub.dev/packages/google_fonts)
      - 구글 웹폰트 지원