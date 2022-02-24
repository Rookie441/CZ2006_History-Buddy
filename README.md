# CZ2006_History-Buddy
CZ2006 Software Engineering Project by "APIHunter"

## Changelog
Version 1.1:
- Added error popup messages for registration and login errors
- Added success popup upon successfully registering account
- Fixed a bug causing users to be able to register without username and name
- Created separate google account for firebase, updated google-services.json
- Moved button decoration to constants.dart
- Refactored button decorations in mainmenu.dart with the help of constants.dart
https://user-images.githubusercontent.com/68913871/155537787-899eba25-506b-4693-8695-aa214b14ae9e.mp4

Version 1.0:
- MainMenu with registration and login buttons
- Basic Registration
- Basic Login
- Basic Logout
- Logout with popup confirmation
- Fix pixel overflow when keyboard appears in mainmenu and register
https://user-images.githubusercontent.com/68913871/154505441-5dfd1a7d-1333-4f89-ad86-692fbb61f49d.mp4

To-do:
- Implement Modal Progress HUD Spinner
- Login by username
    username/password sign-in is not supported natively in Firebase Auth at this moment.
    [workaround](https://stackoverflow.com/questions/37467492/how-to-provide-user-login-with-a-username-and-not-an-email)
- Consider changing functional requirements for: Password requirements/Character limit [firebase_auth-password-strength](https://stackoverflow.com/questions/49183858/is-there-a-way-to-set-a-password-strength-for-firebase)
- Homepage, show username, information etc. (from cloud_firestore)
- Friends page
- Friends functionality (add, remove, request, accept)
- Leaderboard page
- Adaptive leaderboard based on calories and datetime
