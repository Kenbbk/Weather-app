
<img src="https://github.com/Kenbbk/Weather-app/assets/75235447/9f340bca-f8dc-440f-9582-25aacb7b022b.png" width="87">

# 🌤️ My Weather
### 개인 과제 심화
<br><br>

## 📋 프로젝트 소개

#### My Weather App은 Apple의 날씨 App을 참조하여 현재 위치의 날씨를 확인하는 App이다. 
#### 1. 현재 위치를 파악
#### 2. 현재 위치에 대한 날씨 표시 (3시간 간격으로 업데이트)
#### 3. 현재 위치에서 5일간의 날씨 표시
#### 4. 지도에서 현재 위치한 날씨의 정보를 표시 

<br><br>
- - -
## 🛠️ 사용한 기술 스택 (Tech Stack)
<img src="https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=Swift&logoColor=white">
<img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white">
<img src="https://img.shields.io/badge/Figma-4A154B?style=for-the-badge&logo=figma&logoColor=white">
- - -

<br><br>
- - -
## 🗓️ 개발 기간
* 2023-09-25(월) ~ 2023-10-06(금)
- - -
<br><br>

## 🤲 화면 별 설명
* 		메인 화면
  1. 화면 상단 View
      * 현재 위치에 대한 날씨를 표시해준다.
      * 표시되는 정보는 위치, 현재 온도, 날씨, 최고 온도, 최저 온도
      * CollectionView가 올라갈수록 View의 정보가 위치, 현재온도 | 날씨로 View가 줄어든다.
  2. 3시간대별 날씨 표시 Collection View
      * 현재 시간으로부터 3시간 간격의 날씨를 표시해준다,
      * (시간 / 날씨 icon / 기온)을 표시해준다.
      * 16개의 날씨를 표시해준다. (하루가 지날 경우 다음 날짜의 날씨를 표시)
  3. 일간 날씨 표시 Collection View
      * (현재 날짜 / 날씨 icon / 최저 온도 ~ 최고 온도)를 표시해준다.
      * 최저 온도와 최고 온도가 표시되는 Color Bar의 경우 모든 날 중에서 최저 온도와 최고온도를 기준으로 Bar의 범위를 설정해준다.
      * 각 일간의 최저온도와 최고온도는 Color Bar에서 color로 표시해준다.
  4. 현재 위치의 지도 표시
      * 현재 위치를 지도를 이용하여 표시한다.
      * 현재 위치에 대한 기온을 표시해준다.
      * <img src="" width="300">
* 		일일 날씨 표시 화면
    * 일일의 날씨 정보들을 표시한다.
    * 현재 날짜와 앞으로의 날짜들을 표시한다.
    * 현재 온도와 최고온도, 최저 온도를 표시한다.
    * 일일에 대한 온도를 Line Chart를 이용하여 표시해준다.
    * 일기 예보를 이용하여 오늘 날씨 정보를 안내해준다.
    * <img src="" width="300">
* 		지도 화면
    * 우리나라의 지도를 표시한다.
    * 현재 위치의 기온을 표시해준다.
    * 우측 상단의 버튼 리스트
        1. 지도에서 현재 위치로 이동한다.
        2. 미리 입력한 위치의 정보를 얻을 수 있다.
        3. 표시되는 항목을 바꿀 수 있다. (기온 / 기압 / 습도)
    * <img src="" width="300">
  <br><br>
  - - -
