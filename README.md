# preventScreenCapture_Record
### 프로젝트 설명
- #### 앱 화면 스크린샷 캡쳐와 녹화를 방지하는 코드
- #### 녹화는 원천적으로 방지할 수 있어 녹화 시 화면을 숨겨 까만 화면이 녹화되도로 녹화 차단 
- #### 캡쳐는 원천적으로 외부 솔루션을 사용하지 않는다면 코드로만으론 차단할 수 없어 사용자에게 주의를 주고 희망 시 사진을 삭제할 수 있도록 유도
- #### 원천적인 SceneDelegate에서 기능 동작하도록 설계
***
### 실행동작
- #### 화면 캡쳐
![Simulator Screen Recording - iPhone 11 - 2021-08-29 at 09 37 32](https://user-images.githubusercontent.com/72292617/131234420-33e27735-61f3-486d-a85a-621dcd1fb32f.gif)
- #### 화면 녹화
  Xcode 시뮬레이터에서 실제 디바이스의 화면기록과 동일한 기능이 없어 흐름의 순서로 설명
  1. 녹화 시 아래와 같이 화면이 숨겨져 검은 화면 녹화
  2. 녹화 중단 시 얼럿 노출
  3. 실제 앨범에 들어가면 녹화되 파일의 화면이 전부 가려져서 저장
  <img src="https://user-images.githubusercontent.com/72292617/131234686-a1c84c58-6bb5-4e0f-9c50-638510808a33.gif" width="300" height= "600">

