import 'client.dart';

Future<bool> validateCall(Future<void> Function() call,
    {bool allowRedirect = false}) async {
  try {
    await call();
    return true;
  } on ClientException catch (error) {
    return allowRedirect && error.response?.statusCode == 302;
  }
}
