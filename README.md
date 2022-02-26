# CZ2006_History-Buddy
CZ2006 Software Engineering Project by "APIHunter"

## Changelog
Version 1.2: [Watch Demo](https://user-images.githubusercontent.com/68913871/155840125-cc3da3f2-f93c-44f6-b937-81b8902e43ac.mp4)
- Created database collection "userinfo" with email as documentName and fields: name, username
- Added character limit counter and hint text for input fields in registration.dart
- Added registration error handling when username is taken
- Added login by username functionality
- Implemented keyboard restriction using regular expressions (restrict spaces, symbols etc.)
- Implemented character minimum requirement error handling (not including whitespaces and symbols)
- Homepage now displays user-specific information from database
- Refactored error popup messages to a function in constants.dart
- Improved successful registration alert functionality
- Improved pixel overflow fix from Flexible widgets and <resizeToAvoidBottomInset: false> to SingleChildScrollView widget
- Reduced font size and transparency of hint text
- Fixed error popup messages not showing for certain login errors

![image](https://user-images.githubusercontent.com/68913871/155840185-bfbb4965-1e11-4ae4-b85d-3e7bc40f850c.png)

![image](https://user-images.githubusercontent.com/68913871/155840206-9f653a11-23e3-4916-a1da-ccd62b2a20de.png)

Version 1.1: [Watch Demo](https://user-images.githubusercontent.com/68913871/155537787-899eba25-506b-4693-8695-aa214b14ae9e.mp4)
- Added error popup messages for registration and login errors
- Added success popup upon successfully registering account
- Fixed a bug causing users to be able to register without username and name
- Created separate google account for firebase, updated google-services.json
- Moved button decoration to constants.dart
- Refactored button decorations in mainmenu.dart with the help of constants.dart

Version 1.0: [Watch Demo](https://user-images.githubusercontent.com/68913871/154505441-5dfd1a7d-1333-4f89-ad86-692fbb61f49d.mp4)
- MainMenu with registration and login buttons
- Basic Registration
- Basic Login
- Basic Logout
- Logout with popup confirmation
- Fix pixel overflow when keyboard appears in mainmenu and register

## To-do:
- Implement Modal Progress HUD Spinner
- Friends page
- Friends functionality (add, remove, request, accept)
- Leaderboard page
- Adaptive leaderboard based on calories and datetime

## Improvements/Considerations:
- Consider adding additional functional requirements for: Password strength [firebase_auth-password-strength](https://stackoverflow.com/questions/49183858/is-there-a-way-to-set-a-password-strength-for-firebase)
- Consider changing email sign-in to require legitimate email domain (e.g. google)

## Known issues/bugs:
-