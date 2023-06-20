import 'dart:developer' as devs show log;

extension Logger on Object {
  // declare extension .log
  void log() => devs.log(toString());
}
