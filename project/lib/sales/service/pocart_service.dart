import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../mains/utils/logger.dart';

class POCartService extends ChangeNotifier {
  // ignore: non_constant_identifier_names
  final String _LISTS_POCART_KEY = 'LISTS_POCART';

  List<String> _listsPOCART = [];
  List<String> get listsPOCART => _listsPOCART;

  Future<void> getInstance() async {}

  Future<List<String>?> getPOCARTFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? response = prefs.getStringList(_LISTS_POCART_KEY);
    if (response != null) {
      _listsPOCART = response;
    }
    notifyListeners();

    return _listsPOCART;
  }

  Future<bool> incrementPOCART(int id, int counter) async {
    'incrementPOCART called...'.log();
    'id : $id --- counter : $counter'.log();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      for (int i = 0; i < _listsPOCART.length; i++) {
        if (_listsPOCART[i].indexOf('$id||') > -1) {
          _listsPOCART[i] = '$id||$counter';
        }
      }

      '_listsPOCART : $_listsPOCART'.log();
      return await prefs.setStringList(_LISTS_POCART_KEY, _listsPOCART);
    } catch (e) {
      'incrementPOCART exception : $e'.log();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> decrementPOCART(int id, int counter) async {
    'decrementPOCART called...'.log();
    'id : $id --- counter : $counter'.log();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      for (int i = 0; i < _listsPOCART.length; i++) {
        if (_listsPOCART[i].indexOf('$id||') > -1) {
          _listsPOCART[i] = '$id||$counter';
        }
      }

      '_listsPOCART : $_listsPOCART'.log();
      return await prefs.setStringList(_LISTS_POCART_KEY, _listsPOCART);
    } catch (e) {
      'decrementPOCART exception : $e'.log();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> savePOCARTTOLocal(Set<String> listsPOCART) async {
    'savePOCARTTOLocal called ...'.log();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _listsPOCART = listsPOCART.toList();
      return await prefs.setStringList(_LISTS_POCART_KEY, _listsPOCART);
    } catch (e) {
      'savePOCARTTOLocal exception : $e'.log();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> removePOCARTFromLocal() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_LISTS_POCART_KEY);
    } catch (e) {
      'removePOCARTFromLocal exception : $e'.log();
      return false;
    } finally {
      notifyListeners();
    }
  }

  // Future<bool> updatePOCART() async {}
}
