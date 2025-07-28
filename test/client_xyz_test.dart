@Timeout(Duration(seconds: 60))
library;

import 'dart:math';
import 'dart:io';

import 'package:dart_resymot_client/client_xyz.dart';
import 'package:test/test.dart';

void main() {
  late ResymotXYZ xyz;
  dynamic proxy;
  late double feedRate;

  final Map defaultEnvs = {
    "RESYMOT_SERVER":
        Platform.environment['RESYMOT_SERVER'], //http://127.0.0.1:8383/
    "FEED_RATE": double.tryParse(Platform.environment['FEED_RATE'] ?? ''),
  };

  setUp(() {
    proxy = ServerProxy(defaultEnvs["RESYMOT_SERVER"]);
    feedRate = defaultEnvs["FEED_RATE"];
    xyz = ResymotXYZ(pClient: proxy, pMachineId: 1);
  });

  dynamic Function() wrap(Function f) {
    return () async {
      await xyz.setToAutoMode().then((value) {
        expect(value, equals(true));
      });
      await f();
      await xyz.powerOff().then((value) {
        expect(value, equals(true));
      });
    };
  }

  Future<void> waitComplete(ResymotXYZ xyz) async {
    await xyz.waitComplete().then((value) {
      expect(value, equals(true));
    });
  }

  Future<void> sendSquarePattern(ResymotXYZ xyz) async {
    await xyz
        .straightMoveTo(endPt: [0, 0.2, 0], feedRate: feedRate, corrId: 0)
        .then((value) {
          expect(value, equals(true));
        });
    await xyz
        .straightMoveTo(endPt: [0.2, 0.2, 0], feedRate: feedRate, corrId: 0)
        .then((value) {
          expect(value, equals(true));
        });
    await xyz
        .straightMoveTo(endPt: [0.2, 0, 0], feedRate: feedRate, corrId: 0)
        .then((value) {
          expect(value, equals(true));
        });
    await xyz
        .straightMoveTo(endPt: [0, 0, 0], feedRate: feedRate, corrId: 0)
        .then((value) {
          expect(value, equals(true));
        });
  }

  Future<void> sendPattern(ResymotXYZ xyz) async {
    await xyz
        .straightMoveTo(endPt: [0.3, 0.2, 0.15], feedRate: feedRate, corrId: 0)
        .then((value) {
          expect(value, equals(true));
        });
    List<double> normal = [0.0, 0.0, 1.0];
    await xyz
        .arcMoveTo(
          centerPt: [0.4, 0.2, 0.0],
          normal: normal,
          angle: pi,
          feedRate: feedRate,
        )
        .then((value) {
          expect(value, equals(true));
        });
    await xyz
        .straightMoveTo(endPt: [0.5, 0, 0.05], feedRate: feedRate, corrId: 0)
        .then((value) {
          expect(value, equals(true));
        });
    await xyz
        .arcMoveTo(
          centerPt: [0.4, 0.0, 0.1],
          normal: normal,
          angle: -pi,
          feedRate: feedRate,
        )
        .then((value) {
          expect(value, equals(true));
        });
  }

  Future<void> sendPattern2(ResymotXYZ xyz) async {
    await xyz
        .straightMoveTo(endPt: [0.4, -0.1, 0.05], feedRate: feedRate, corrId: 0)
        .then((value) {
          expect(value, equals(true));
        });
    List<double> normal = [1.0, 0.0, 0.0];
    await xyz
        .arcMoveTo(
          centerPt: [0.4, 0.0, 0.05],
          normal: normal,
          angle: -pi,
          feedRate: feedRate,
        )
        .then((value) {
          expect(value, equals(true));
        });
    await xyz
        .straightMoveTo(endPt: [0.4, 0.1, 0.0], feedRate: feedRate, corrId: 0)
        .then((value) {
          expect(value, equals(true));
        });
    await xyz
        .arcMoveTo(
          centerPt: [0.4, 0.0, 0.0],
          normal: normal,
          angle: pi,
          feedRate: feedRate,
        )
        .then((value) {
          expect(value, equals(true));
        });
  }

  test(
    'test_pw',
    wrap(() async {
      await Future.delayed(Duration(milliseconds: 500));
    }),
  );

  test(
    'testSendStrtLine',
    wrap(() async {
      await xyz
          .straightMoveTo(endPt: [0, 0, 0], feedRate: feedRate, corrId: 0)
          .then((value) {
            expect(value, equals(true));
          });
      await waitComplete(xyz);
    }),
  );

  Future<void> setStrtLine(ResymotXYZ xyz) async {
    await xyz
        .straightMoveTo(endPt: [0, 0, 0], feedRate: feedRate, corrId: 0)
        .then((value) {
          expect(value, equals(true));
        });
  }

  test(
    'testSendSquare',
    wrap(() async {
      await sendSquarePattern(xyz);
      await waitComplete(xyz);
    }),
  );

  test(
    'testSendPatten',
    wrap(() async {
      await sendPattern(xyz);
      await waitComplete(xyz);
    }),
  );

  test(
    'testSendPatternExceedBuffer',
    wrap(() async {
      for (int i = 0; i < 6; i++) {
        await sendPattern(xyz);
      }
      await waitComplete(xyz);
    }),
  );

  test(
    'testSendPattern2',
    wrap(() async {
      await sendPattern2(xyz);
      await waitComplete(xyz);
    }),
  );

  test(
    'testSendPattern2ExceedBuffer',
    wrap(() async {
      for (int i = 0; i < 6; i++) {
        await sendPattern2(xyz);
      }
      await waitComplete(xyz);
    }),
  );

  test('testSendDualPattern', () async {
    ResymotXYZ xyz1 = ResymotXYZ(pClient: proxy, pMachineId: 1);
    ResymotXYZ xyz2 = ResymotXYZ(pClient: proxy, pMachineId: 2);
    await xyz1.powerOn().then((value) {
      expect(value, equals(true));
    });
    await xyz2.powerOn().then((value) {
      expect(value, equals(true));
    });

    // xyz1 send pattern then wait complete
    Future<void> xyz1Block() async {
      await setStrtLine(xyz1);
      await sendSquarePattern(xyz1);
      await waitComplete(xyz1);
      return;
    }

    Future<void> xyz2Block() async {
      await setStrtLine(xyz2);
      await sendSquarePattern(xyz2);
      await waitComplete(xyz2);
      return;
    }

    await Future.wait([xyz1Block(), xyz2Block()]);

    await xyz1.powerOff().then((value) {
      expect(value, equals(true));
    });
    await xyz2.powerOff().then((value) {
      expect(value, equals(true));
    });
  });

  test(
    'testJog',
    wrap(() async {
      await setStrtLine(xyz);
      await waitComplete(xyz);
      await Future.delayed(Duration(milliseconds: 100));

      await xyz.powerOff().then((value) {
        expect(value, equals(true));
      });
      await xyz.setToJogMode().then((value) {
        expect(value, equals(true));
      });
      List<double> targetPos = [0.4, 0.0, 0.1];

      double step = 0.1;
      //smulate human jog cmd
      for (int i = 0; i < 10; i++) {
        targetPos[0] += step;
        await xyz.setTargetPos(endPt: targetPos).then((value) {
          expect(value, equals(true));
        });
        await Future.delayed(Duration(milliseconds: 100));
      }

      for (int i = 0; i < 10; i++) {
        targetPos[0] -= step;
        await xyz.setTargetPos(endPt: targetPos).then((value) {
          expect(value, equals(true));
        });
        await Future.delayed(Duration(milliseconds: 100));
      }

      await Future.delayed(Duration(milliseconds: 500));
    }),
  );

  test(
    'testHome',
    wrap(() async {
      await xyz.powerOff().then((value) {
        expect(value, equals(true));
      });
      await xyz.setToHomeMode().then((value) {
        expect(value, equals(true));
      });
      await xyz.startToHoming().then((value) {
        expect(value, equals(true));
      });
    }),
  );
}
