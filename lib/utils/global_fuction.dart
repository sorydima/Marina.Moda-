import 'dart:io';

bool activeConnection = true;

Future checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return activeConnection = true;
    }
  } on SocketException catch (_) {
    return activeConnection = false;
  }
  return activeConnection;
}
