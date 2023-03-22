
# Fitdle
A real-time exercise form correction app that aims to motivate users to be active and stay safe while exercising. Assigns points to user's based on their workout which they can use to redeem digital goods.

![image](https://user-images.githubusercontent.com/46847766/227063267-1435fee6-7f9b-4eaf-9c05-4a623158f5a4.png)

![image](https://user-images.githubusercontent.com/46847766/227063781-729d6f9b-4d36-4876-9f82-f00f23ebb60f.png)

## Implementation
### App
- Flutter based project that uses MVVM.
- Features a step tracker using Google Maps API and [tflite library](https://pub.dev/packages/tflite_flutter) for pose-estimation.
- Has a dashboard page that displays daily goals which reset each day.
- Has an analytics page to let user see how many calories burned or points earned per week
- Has a rewards page that allows user's to redeem digital goods with points

### Form Correction
- Utilizes [MoveNet Thunder](https://tfhub.dev/google/movenet/singlepose/thunder/4) to generate body keypoints
- Three keypoints are collected to calculate the angle of the user's body part. Whether or not the user has "good form" is determined based on if the angle falls within a pre-determined threshold.
- The app uses a state system to keep track of repetitions. For example, while doing squats, the app looks to see if the user is in a standing up position within the frame, and will then expect to see a squatting position within the frame.
- To increase FPS, the app uses threads to compute the pose-estimation for multiple frames.
- An outline will be drawn on the user's body with two colors. Green indicating this part of the body has good form and red being the opposite.

### Backend
- Running a MySQL database host on DigitalOcean. 
- Node.JS backend for interacting with the database as well as computing small tasks resetting the exercising goals daily and calculating rewards.
- Firebase for user authentication and hosting backend.

## Setup
1. Download Flutter https://docs.flutter.dev/get-started/install and follow their documentation to setup.
2. Install Android Studio https://developer.android.com/studio
3. Install Visual Studio Code https://visualstudio.microsoft.com/downloads/ (Flutter needs this apparently??)
4. Download Android CMD tools https://stackoverflow.com/questions/68236007/i-am-getting-error-cmdline-tools-component-is-missing-after-installing-flutter
5. Download an Android Simulator https://developer.android.com/studio/run/managing-avds (Not sure yet how to run on iOS simulators) 
