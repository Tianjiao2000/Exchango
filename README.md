# PetPat

<img width="150" alt="image" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/8b261866-c47d-44b0-9477-42345a4d861d">

Empower your pet's voice—track every tap, capture every moment!

Discover what your pet really wants—analyze button presses and environmental data to connect and communicate more effectively.

<img width="513" alt="image" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/756cc11c-6ac3-4105-9a5b-ad5eaf479278">

## Introduction

PetPat is an innovative app designed to enhance pet care through technology. Inspired by the need to simplify the tracking of pets' needs, PetPat automates the recording of button presses and environmental data to help pet owners understand their pets better. With PetPat, discover which buttons your pet presses the most and under which conditions, allowing for a deeper connection and more tailored care.

## Website
Landing page: [https://wbe2.getresponse.com/lps/b7847547-c55f-44f2-8c66-a91e09c36613/edit/](https://tianjiao2000.github.io/PetPat/)

YouTube demo video: https://www.youtube.com/watch?v=mtMKdf3VJa4

## User Persona

- For people who WFH: Occupied with online meetings, review the button history in PetPat to understand what BunBun needed, ensuring well-cared for without disrupting from working.
- For owner who monitoring pet's weight: monitor FuFu’s feeding requests and analyze patterns with the help of pie charts and history logs. Adjust feeding schedules based on when FuFu feels hungry most often, optimizing their diet.
- Old dog: If Charlie feels unwell during the night, he will press the ‘pain’ button. Upon guardian waking, they can immediately review history in PetPat and take timely action to ensure Charlie’s health and comfort.
- Unpredictable cat: Doris's owner uses PetPat to understand her preferences better. When the light sensor reads high and Doris presses the 'outdoor', she enjoys the sunshine! If a car noise triggers her to press 'noise' and 'pain,’ she prefer quiet.

## Features

### Automated Tracking
- Button Press Recording: Automatically logs every button press so you don’t need to track manually.
- Environmental Sensitivity: Integrates data from environmental sensors to correlate pet behaviour with changes in their surroundings.

<img src="https://github.com/Tianjiao2000/PetPat/assets/73406569/468ca917-db19-412e-b1b8-34f6e3590df2" width="300" height="650">

### Data-Driven Insights
- Detailed Analytics: Utilize analytics to make informed decisions about your pet's diet, schedule, and preferences.
- History Logs and Pie Charts: Review and analyze your pet's activities and patterns over time.

  <img src="https://github.com/Tianjiao2000/PetPat/assets/73406569/7066dedd-1483-44a6-9bfb-68c09412c3b7" width="300" height="650"><img src="https://github.com/Tianjiao2000/PetPat/assets/73406569/fee04db3-1a1b-4b31-9fbb-093ad5b15e9c" width="300" height="650">

### User Interaction
- Personalized Alerts: Receive alerts as if your pet is directly communicating with you.
- Schedules Management: Easily set and manage daily schedules for pet-related activities.

<img width="250" alt="image" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/6d958a26-2b55-4fa8-af88-9e14645206bd"><img width="500" alt="image" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/519992b5-dbca-4944-8a29-633a3895b79a">

<img width="300" height="650" alt="image" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/91c289d3-37e7-4145-ac31-15fe37d12678"><img width="300" height="650" alt="image" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/a15a9e5d-7402-4f1b-9467-91222fbb5bad"><img width="300" height="650" alt="image" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/5fa0a3d4-f646-486d-bcae-5b699f499af8">

### Weather Integration
- Weather and Air Quality Checks: Plan outdoor activities with your pet by checking current weather conditions and forecasts.

<img width="300" height="650" alt="image" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/9e7b1a82-750b-44b0-bf17-df84b802d5aa">

### Account
- Firebase provide user login, signup and find password features with email verification
- Save button history and schedule in local storage

##  Technical Details
- Firebase: Manages user accounts and stores data securely.
- Geolocator and OpenWeatherMap: Fetches geographical location and weather data.
- MQTT Client: receive mqtt message from button and sensors
- Notification API: Manage notifications
- Shared Preferences: Data storage
- intl & timezone; UI/data formatting
- fl_chart: Chart analysis
- permission_handler: Permissions management
- Data Management: Data fetching, logs and updates button details securely using local storage options.

## Getting Started

Prerequisites: Install Flutter and set up your development environment.
- Clone the repository: git clone [https://github.com/your-repo/petpat.git](https://github.com/Tianjiao2000/PetPat.git)
- Navigate to the project directory: cd petpat
- Install dependencies: flutter pub get
- Run app: flutter run for debug and flutter run --release for stable using
- Arduino: please pre-install Arduino IDE and navigate to the Arduino folder to run sensors

## Application Information
### Android
Please see the Release in the left bar and select the newest version to run.
### iOS
iOS version currently hasn't been released yet, please run it on iOS simulator. iOS simulator has exactly the same features as the android version.

<img width="300" alt="Screenshot 2024-04-23 at 14 54 15" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/73317381-f596-432d-b88f-5e1fc73677cc"><img width="300" alt="Screenshot 2024-04-23 at 14 50 19" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/69c3ebda-246c-43cb-956d-1e92a2851915"><img width="300" alt="Screenshot 2024-04-23 at 14 52 44" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/a87d751b-c4a6-450f-b03b-2f6ef660abe6">

## Dependencies
<img width="506" alt="Screenshot 2024-04-23 at 01 06 29" src="https://github.com/Tianjiao2000/PetPat/assets/73406569/a4bf0bf5-e9bb-41f8-aac1-782281d85389">

##  License
This project is licensed under the MIT License.

##  Contact
Feel free to contact me if you have any questions or if you want to contribute to the app.
Email: tianjiao.wang.23@ucl.ac.uk
