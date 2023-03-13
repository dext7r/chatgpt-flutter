## ChatGpt Flutter

A Flutter real-time chat app based on the chatbot GPT-3.

### Features

- Users can input their own messages to interact with the chatbot.
- Supports copying messages from chat logs to paste into other applications.

### Installation

1. Clone the repository.

    ```bash
    git clone git@github.com:h7ml/chatgpt-flutter.git
    ```

2. Getting Started

- Install dependencies
   ```bash
   flutter pub get
   ```
- Copy the `.env.example` file, then rename it to `.env`
   ```bash
   cp .env.example .env
   ```
- Add your [OpenAI API key](https://platform.openai.com/account/api-keys) to the `.env` file.
   ```bash
   API_KEY=YOUR_OPENAI_API_KEY
   ```  
   
3. Run the app.
- To run the app on an Web Server:
    ```bash
     flutter run -d web-server --web-renderer html
    ```
- To run the app on an iOS simulator:
    ```bash
    flutter run -d iPhone
    ```
- To run the app on a specific Android emulator:
    ```bash
    flutter run -d emulator-5554
    ```
- To run the app on a connected iOS device:
    ```bash
    flutter run -d device-name
    ```
- To run the app on the web using the Chrome browser:
    ```bash
    flutter run -d chrome
    ```
- To run the app on a macOS desktop:
    ```bash
    flutter run -d macos
    ```
- To run the app on a Windows desktop:
    ```bash
    flutter run -d windows
    ```
- To run the app on a Linux desktop:
    ```bash
    flutter run -d linux
    ```

You can customize the flutter run command with many options to run the app on different platforms and devices. For more information, check out the [Flutter documentation](https://docs.flutter.dev/reference/flutter-cli).
### Author

- Author: [h7ml](https://github.com/h7ml)
- Email: [h7ml@qq.com](mailto:h7ml@qq.com)