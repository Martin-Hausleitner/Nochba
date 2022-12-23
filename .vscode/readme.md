# README

This VS code tasks requires the following tools to be installed:

- Flutter: a mobile app development framework (https://flutter.dev/docs/get-started/install)
- Firebase tools: a command-line interface for Firebase (install with `npm install -g firebase-tools`)
- TypeScript: a programming language that is a superset of JavaScript (install with `npm install -g typescript`)

To set up the TypeScript environment variable, run the following command:

```cmd
set PATH=%PATH%;C:\Users\%USERNAME%\AppData\Roaming\npm\node_modules\typescript\bin

```

This VS code tasks includes the following tasks in its `tasks.json` file:

- tsc: watch - functions/tsconfig.json: runs the TypeScript compiler in watch mode, using the configuration file at functions/tsconfig.json
- flutter: run: runs the Flutter app in the Chrome browser
- firebase emulators: start: starts the Firebase emulators for functions
- Open Firbase Emulator UI: opens the URL http://127.0.0.1:4002/functions in the default browser
- Open Firebase Console: opens the URL https://console.firebase.google.com/u/0/project/nochba-dev/firestore/data in the default browser
- Firebase Function Enviroment Setup: runs all of the above tasks in the specified order

To run the "Firebase Function Enviroment Setup" task from the Command Palette in Visual Studio Code:

1. Open the Command Palette by pressing Ctrl+Shift+P
2. Type run task and select the Tasks: Run Task option from the list
3. Select the run all task from the list of available tasks
