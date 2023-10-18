import 'package:get_it/get_it.dart';
import 'package:hearts/services/call_sms.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}
