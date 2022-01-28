import 'command_line_app.dart';

void main() {
  CommandLineApp(
    host: 'http://192.168.2.6:8080',
    bsid: '61da2b54285650ba5034ada4',
    secret: '1234567890',
  ).loginPage();
}
