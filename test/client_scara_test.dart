@Timeout(Duration(seconds: 60))
library;

import 'dart:math';
import 'dart:io';

import 'package:dart_resymot_client/client_scara.dart';
import 'package:test/test.dart';

void main() {
  late ResymotSCARA scara;
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
    scara = ResymotSCARA(pClient: proxy, pMachineId: 1);
  });

  dynamic Function() wrap(Function f) {
    return () async {
      await scara.powerOn().then((value) {
        expect(value, equals(true));
      });
      await f();
      await scara.powerOff().then((value) {
        expect(value, equals(true));
      });
    };
  }

  Future<void> waitComplete(ResymotSCARA scara) async {
    await scara.waitComplete().then((value) {
      expect(value, equals(true));
    });
  }

  Future<void> sendSquarePattern(ResymotSCARA scara) async {
    await scara
        .straightMoveTo(
          endPt: [0.3, 0.2, 0.1, pi],
          feedRate: feedRate,
          corrId: 0,
        )
        .then((value) {
          expect(value, equals(true));
        });
    await scara
        .straightMoveTo(
          endPt: [0.5, 0.2, 0.1, pi],
          feedRate: feedRate,
          corrId: 0,
        )
        .then((value) {
          expect(value, equals(true));
        });
    await scara
        .straightMoveTo(
          endPt: [0.5, 0.0, 0.1, pi],
          feedRate: feedRate,
          corrId: 0,
        )
        .then((value) {
          expect(value, equals(true));
        });
    await scara
        .straightMoveTo(
          endPt: [0.3, 0.0, 0.1, pi],
          feedRate: feedRate,
          corrId: 0,
        )
        .then((value) {
          expect(value, equals(true));
        });
  }

  Future<void> sendPattern(ResymotSCARA scara) async {
    await scara
        .straightMoveTo(
          endPt: [0.3, 0.2, 0.15, pi],
          feedRate: feedRate,
          corrId: 0,
        )
        .then((value) {
          expect(value, equals(true));
        });
    List<double> normal = [0.0, 0.0, 1.0];
    await scara
        .arcMoveTo(
          centerPt: [0.4, 0.2, 0.0],
          normal: normal,
          angle: pi,
          endOrient: [pi],
          feedRate: feedRate,
        )
        .then((value) {
          expect(value, equals(true));
        });
    await scara
        .straightMoveTo(
          endPt: [0.5, 0, 0.05, pi],
          feedRate: feedRate,
          corrId: 0,
        )
        .then((value) {
          expect(value, equals(true));
        });
    await scara
        .arcMoveTo(
          centerPt: [0.4, 0.0, 0.1],
          normal: normal,
          angle: -pi,
          endOrient: [pi],
          feedRate: feedRate,
        )
        .then((value) {
          expect(value, equals(true));
        });
  }

  Future<void> sendPattern2(ResymotSCARA scara) async {
    await scara
        .straightMoveTo(
          endPt: [0.4, -0.1, 0.05, pi],
          feedRate: feedRate,
          corrId: 0,
        )
        .then((value) {
          expect(value, equals(true));
        });
    List<double> normal = [1.0, 0.0, 0.0];
    await scara
        .arcMoveTo(
          centerPt: [0.4, 0.0, 0.05],
          normal: normal,
          angle: -pi,
          endOrient: [pi],
          feedRate: feedRate,
        )
        .then((value) {
          expect(value, equals(true));
        });
    await scara
        .straightMoveTo(
          endPt: [0.4, 0.1, 0.0, pi],
          feedRate: feedRate,
          corrId: 0,
        )
        .then((value) {
          expect(value, equals(true));
        });
    await scara
        .arcMoveTo(
          centerPt: [0.4, 0.0, 0.0],
          normal: normal,
          angle: pi,
          endOrient: [pi],
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
    'testCurrState',
    wrap(() async {
      await scara.currState().then((value) {
        expect(value, isA<String>());
      });
    }),
  );

  test(
    'testCurrPos',
    wrap(() async {
      await scara.currPos().then((value) {
        expect(value, isA<List<double>>());
      });
    }),
  );

  test(
    'testWarnErr',
    wrap(() async {
      await scara.warnErr().then((value) {
        expect(value, isA<List<String>>());
      });
    }),
  );

  test(
    'testSendStrtLine',
    wrap(() async {
      await scara
          .straightMoveTo(
            endPt: [0.4, 0.0, 0.1, pi],
            feedRate: feedRate,
            corrId: 0,
          )
          .then((value) {
            expect(value, equals(true));
          });
      await waitComplete(scara);
    }),
  );

  test(
    'testSendArc',
    wrap(() async {
      await scara
          .straightMoveTo(
            endPt: [0.4, 0.1, 0.1, pi],
            feedRate: feedRate,
            corrId: 0,
          )
          .then((value) {
            expect(value, equals(true));
          });
      await scara
          .arcMoveTo(
            centerPt: [0.4, 0.1, 0.1],
            normal: [0.0, 0.0, 1.0],
            angle: 2 * pi,
            endOrient: [pi],
            feedRate: feedRate,
          )
          .then((value) {
            expect(value, equals(true));
          });
      await waitComplete(scara);
    }),
  );

  test(
    'testSendSquare',
    wrap(() async {
      await sendSquarePattern(scara);
      await waitComplete(scara);
    }),
  );

  test(
    'testSendPatten',
    wrap(() async {
      await sendPattern(scara);
      await waitComplete(scara);
    }),
  );

  test(
    'testSendPattern2',
    wrap(() async {
      await sendPattern2(scara);
      await waitComplete(scara);
    }),
  );

  test(
    'testSendPatternExceedBuffer',
    wrap(() async {
      for (int i = 0; i < 6; i++) {
        await sendPattern(scara);
      }
      await waitComplete(scara);
    }),
  );

  test(
    'testSendPattern2ExceedBuffer',
    wrap(() async {
      for (int i = 0; i < 6; i++) {
        await sendPattern2(scara);
      }
      await waitComplete(scara);
    }),
  );

  test(
    'testSendLargePostureInMid',
    wrap(() async {
      await scara
          .straightMoveTo(
            endPt: [0.4, 0.1, 0.05, pi],
            feedRate: feedRate,
            corrId: 0,
          )
          .then((value) {
            expect(value, equals(true));
          });

      await scara
          .straightMoveTo(
            endPt: [0.4, 0.01, 0.05, pi],
            feedRate: feedRate,
            corrId: 0,
          )
          .then((value) {
            expect(value, equals(true));
          });

      // amphimove speed plan should slow down at this point due to large posture change

      await scara
          .straightMoveTo(
            endPt: [0.4, -0.01, 0.05, 0],
            feedRate: feedRate,
            corrId: 0,
          )
          .then((value) {
            expect(value, equals(true));
          });

      await scara
          .straightMoveTo(
            endPt: [0.4, -0.1, 0.05, 0],
            feedRate: feedRate,
            corrId: 0,
          )
          .then((value) {
            expect(value, equals(true));
          });
    }),
  );

  test(
    'testSendLargePurePostureInMid',
    wrap(() async {
      await scara
          .straightMoveTo(
            endPt: [0.4, 0.1, 0.05, pi],
            feedRate: feedRate,
            corrId: 0,
          )
          .then((value) {
            expect(value, equals(true));
          });

      await scara
          .arcMoveTo(
            centerPt: [0.4, 0.0, 0.05],
            normal: [0.0, 0.0, 1.0],
            angle: pi,
            endOrient: [pi],
            feedRate: feedRate,
            corrId: 0,
          )
          .then((value) {
            expect(value, equals(true));
          });

      // amphimove speed plan should slow down at this point due to large posture change

      await scara
          .straightMoveTo(
            endPt: [0.4, 0.0, 0.05, 0],
            feedRate: feedRate,
            corrId: 0,
          )
          .then((value) {
            expect(value, equals(true));
          });

      await scara
          .straightMoveTo(
            endPt: [0.4, -0.1, 0.05, 0],
            feedRate: feedRate,
            corrId: 0,
          )
          .then((value) {
            expect(value, equals(true));
          });

      await waitComplete(scara);
    }),
  );
}
