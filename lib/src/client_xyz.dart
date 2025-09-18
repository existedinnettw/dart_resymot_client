export 'package:dart_resymot_client/src/jsonrpc_client.dart' show ServerProxy;
import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:dart_resymot_client/src/jsonrpc_client.dart';

class ResymotXYZ {
  late int machineId;
  late String prefix;
  late ServerProxy client;

  ResymotXYZ({required ServerProxy pClient, int pMachineId = 1}) {
    client = pClient;
    machineId = pMachineId;
    prefix = 'XYZ/$machineId/XYZ';
  }

  Future<bool> powerOn() async {
    var result = await client.call('${prefix}_pw_on');
    return result == true;
  }

  Future<bool> powerOff() async {
    var result = await client.call('${prefix}_pw_off');
    return result == true;
  }

  Future<bool> reset() async {
    var result = await client.call('${prefix}_reset');
    return result == true;
  }

  Future<bool> setToAutoMode() async {
    var result = await client.call('${prefix}_to_auto_mode');
    return result == true;
  }

  Future<bool> setToHomeMode() async {
    var result = await client.call('${prefix}_to_home_mode');
    return result == true;
  }

  Future<bool> startToHoming({
    dynamic xHomeMethod = 17,
    dynamic yHomeMethod = 18,
    dynamic zHomeMethod = 18,
  }) async {
    var result = await client.call('${prefix}_start_homing', {
      'x_home_method': xHomeMethod,
      'y_home_method': yHomeMethod,
      'z_home_method': zHomeMethod,
    });
    return result == true;
  }

  Future<bool> setToJogMode() async {
    var result = await client.call('${prefix}_to_jog_mode');
    return result == true;
  }

  Future<bool> setTargetPos({
    List<double> endPt = const [0.0, 0.0, 0.0],
  }) async {
    var result = await client.call('${prefix}_set_target_pos', {
      "end_pt": endPt,
    });
    return result == true;
  }

  Future<bool> straightMoveTo({
    List<double> endPt = const [0.0, 0.0, 0.0],
    double feedRate = 0.1,
    int corrId = 0,
  }) async {
    var result = await client.call('${prefix}_send_strt_line', {
      'end_pt': endPt,
      'feed_rate': feedRate,
      'corr_id': corrId,
    });
    return result == true;
  }

  Future<bool> arcMoveTo({
    List<double> centerPt = const [0.0, 0.1, 0.0],
    List<double> normal = const [0.0, 0.0, 1.0],
    double angle = 2 * pi,
    double feedRate = 0.2,
    int corrId = 0,
  }) async {
    var result = await client.call('${prefix}_send_arc', {
      'centre_pt': centerPt,
      'normal': normal,
      "angle": angle,
      'feed_rate': feedRate,
      'corr_id': corrId,
    });
    return result == true;
  }

  Future<bool> waitComplete() async {
    var result = await client.call('${prefix}_wait_complete');
    return result == true;
  }

  Future<List<double>> getCurrentPos() async {
    var raw = await client.call('${prefix}_curr_pos');
    //List<dynamic> raw = jsonDecode(str);
    List<double> result = raw.map((e) => e.toDouble()).toList().cast<double>();
    // print(result);
    //if (result is List<double>) {
    return result;
    //} else {
    //  throw Exception('Expected List<double>, got $result');
    //}
  }
}
