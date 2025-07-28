export 'package:dart_resymot_client/jsonrpc_client.dart' show ServerProxy;
import 'dart:async';
import 'dart:math';

import 'package:dart_resymot_client/jsonrpc_client.dart';

class ResymotSCARA {
  late int machineId;
  late String prefix;
  late ServerProxy client;

  ResymotSCARA({required ServerProxy pClient, int pMachineId = 1}) {
    client = pClient;
    machineId = pMachineId;
    prefix = 'SCARA/$machineId/SCARA';
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

  Future<String> currState() async {
    return await client.call('${prefix}_curr_state');
  }

  Future<List<double>> currPos() async {
    var result = await client.call('${prefix}_curr_pos');
    return (result as List).cast<double>();
  }

  Future<List<String>> warnErr() async {
    var result = await client.call('${prefix}_warn_err');
    return (result as List).cast<String>();
  }

  Future<bool> straightMoveTo({
    List<double> endPt = const [0.0, 0.0, 0.0, 3.14159],
    double feedRate = 0.1,
    int corrId = 0,
  }) async {
    /**
     * param List[float] end_pt: in [x, y, z, angle]
     * param float f: feedrate
     */
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
    List<double> endOrient = const [3.14159],
    double feedRate = 0.2,
    int corrId = 0,
  }) async {
    var result = await client.call('${prefix}_send_arc', {
      'centre_pt': centerPt,
      'normal': normal,
      "angle": angle,
      "end_orient": endOrient,
      'feed_rate': feedRate,
      'corr_id': corrId,
    });
    return result == true;
  }

  Future<bool> waitComplete() async {
    var result = await client.call('${prefix}_wait_complete');
    return result == true;
  }

  Future<bool> DO({int channel = 7, bool val = true}) async {
    var result = await client.call('DO', {'channel': channel, 'val': val});
    return result == true;
  }

  Future<bool> curr_DI({int channel = 7}) async {
    var result = await client.call('DI', {'channel': channel});
    return result == true;
  }

  Future<bool> waitSpecificDI({int channel = 7, bool val = true}) async {
    var result = await client.call('wait_specific_DI', {
      'channel': channel,
      'val': val,
    });
    return result == true;
  }

  Future<bool> subscrube(String protocal, String address) async {
    var result = await client.call('subscrube', {
      'protocal': protocal,
      'address': address,
    });
    return result == true;
  }

  Future<bool> unsubscribe(String protocal, String address) async {
    var result = await client.call('unsubscribe', {
      'protocal': protocal,
      'address': address,
    });
    return result == true;
  }
}
