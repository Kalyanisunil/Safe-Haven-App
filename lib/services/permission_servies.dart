import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestPermissions() async {
    await Permission.microphone.request();
    await Permission.sms.request();
    await Permission.location.request();
  }
}
