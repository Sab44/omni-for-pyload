import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omni_for_pyload/core/polling/poller.dart';

void main() {
  group('Poller', () {
    late int fetchCount;
    late List<int> results;
    late Poller<int> poller;

    setUp(() {
      fetchCount = 0;
      results = [];
      poller = Poller<int>(
        interval: const Duration(seconds: 2),
        fetch: () async => ++fetchCount,
        onData: results.add,
        onError: (_, _) {},
      );
    });

    test('fetches right away, then every interval', () {
      fakeAsync((async) {
        poller.start();
        async.flushMicrotasks();
        expect(results, [1]);

        async.elapse(const Duration(seconds: 2));
        expect(results, [1, 2]);

        async.elapse(const Duration(seconds: 4));
        expect(results, [1, 2, 3, 4]);
      });
    });

    test('pausing stops fetching', () {
      fakeAsync((async) {
        poller.start();
        async.flushMicrotasks();

        poller.pause();
        async.elapse(const Duration(seconds: 10));

        expect(fetchCount, 1);
      });
    });

    test('pausing during a fetch drops its result and stops fetching', () {
      fakeAsync((async) {
        final slow = Poller<int>(
          interval: const Duration(seconds: 2),
          fetch: () async {
            await Future.delayed(const Duration(seconds: 1));
            return ++fetchCount;
          },
          onData: results.add,
          onError: (_, _) {},
        );

        slow.start();
        slow.pause();
        async.elapse(const Duration(seconds: 10));

        expect(fetchCount, 1);
        expect(results, isEmpty);
      });
    });

    test('resuming fetches right away, then every interval', () {
      fakeAsync((async) {
        poller.start();
        async.flushMicrotasks();
        poller.pause();
        async.elapse(const Duration(seconds: 5));

        poller.resume();
        async.flushMicrotasks();
        expect(results, [1, 2]);

        async.elapse(const Duration(seconds: 2));
        expect(results, [1, 2, 3]);
      });
    });

    test('starting while paused waits for resume', () {
      fakeAsync((async) {
        poller.pause();
        poller.start();
        async.elapse(const Duration(seconds: 5));
        expect(fetchCount, 0);

        poller.resume();
        async.flushMicrotasks();
        expect(results, [1]);
      });
    });

    test('resuming a stopped poller does not fetch', () {
      fakeAsync((async) {
        poller.start();
        async.flushMicrotasks();
        poller.stop();
        poller.pause();
        poller.resume();
        async.elapse(const Duration(seconds: 5));

        expect(fetchCount, 1);
      });
    });

    test('refreshing fetches right away and restarts the interval', () {
      fakeAsync((async) {
        poller.start();
        async.elapse(const Duration(seconds: 1));

        poller.refresh();
        async.flushMicrotasks();
        expect(results, [1, 2]);

        async.elapse(const Duration(seconds: 1));
        expect(results, [1, 2]);
        async.elapse(const Duration(seconds: 1));
        expect(results, [1, 2, 3]);
      });
    });

    test('refreshing a paused or stopped poller does not fetch', () {
      fakeAsync((async) {
        poller.refresh();
        poller.start();
        async.flushMicrotasks();
        poller.pause();
        poller.refresh();
        async.elapse(const Duration(seconds: 5));

        expect(fetchCount, 1);
      });
    });

    test('never delivers data after dispose', () {
      fakeAsync((async) {
        var delivered = 0;
        final slow = Poller<int>(
          interval: const Duration(seconds: 2),
          fetch: () async {
            await Future.delayed(const Duration(seconds: 1));
            return ++fetchCount;
          },
          onData: (_) => delivered++,
          onError: (_, _) => delivered++,
        );

        slow.start();
        slow.dispose();
        slow.start();
        slow.resume();
        slow.refresh();
        async.elapse(const Duration(seconds: 10));

        expect(fetchCount, 1);
        expect(delivered, 0);
      });
    });

    group('failures', () {
      late List<Object> errors;

      Poller<int> failingPoller({bool Function(Object error)? retryNowOn}) =>
          Poller<int>(
            interval: const Duration(seconds: 2),
            fetch: () async {
              fetchCount++;
              await Future.delayed(const Duration(seconds: 1));
              throw fetchCount.isOdd ? 'timeout' : 'offline';
            },
            onData: results.add,
            onError: (error, _) => errors.add(error),
            retryNowOn: retryNowOn,
          );

      setUp(() => errors = []);

      test('are reported and polling continues after the interval', () {
        fakeAsync((async) {
          failingPoller().start();

          async.elapse(const Duration(seconds: 1));
          expect(errors, ['timeout']);

          async.elapse(const Duration(seconds: 3));
          expect(errors, ['timeout', 'offline']);
          expect(results, isEmpty);
        });
      });

      test('matching retryNowOn fetch again without waiting', () {
        fakeAsync((async) {
          failingPoller(retryNowOn: (error) => error == 'timeout').start();

          // timeout at 1 s, retried right away, offline at 2 s
          async.elapse(const Duration(seconds: 2));
          expect(errors, ['timeout', 'offline']);

          // waits the interval after offline
          async.elapse(const Duration(seconds: 1));
          expect(fetchCount, 2);
          async.elapse(const Duration(seconds: 1));
          expect(fetchCount, 3);
        });
      });
    });
  });
}
