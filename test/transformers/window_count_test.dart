import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

void main() {
  test('rx.Observable.windowCount.noSkip', () async {
    const expectedOutput = [
      [1, 2],
      [3, 4]
    ];
    var count = 0;

    final stream =
        Observable.range(1, 4).windowCount(2).asyncMap((s) => s.toList());

    stream.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[count][0], result[0]);
      expect(expectedOutput[count][1], result[1]);
      count++;
    }, count: expectedOutput.length));
  });

  test('rx.Observable.windowCount.noSkip.asWindow', () async {
    const expectedOutput = [
      [1, 2],
      [3, 4]
    ];
    var count = 0;

    final stream =
        Observable.range(1, 4).window(onCount(2)).asyncMap((s) => s.toList());

    stream.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[count][0], result[0]);
      expect(expectedOutput[count][1], result[1]);
      count++;
    }, count: expectedOutput.length));
  });

  test('rx.Observable.windowCount.skip', () async {
    const expectedOutput = [
      [1, 2],
      [2, 3],
      [3, 4]
    ];
    var count = 0;

    final stream =
        Observable.range(1, 4).windowCount(2, 1).asyncMap((s) => s.toList());

    stream.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[count].length, result.length);
      expect(expectedOutput[count][0], result[0]);
      if (expectedOutput[count].length > 1)
        expect(expectedOutput[count][1], result[1]);
      count++;
    }, count: expectedOutput.length));
  });

  test('rx.Observable.windowCount.skip2', () async {
    const expectedOutput = [
      [1, 2, 3],
      [3, 4, 5],
      [5, 6, 7]
    ];
    var count = 0;

    final stream = Observable.range(1, 8).windowCount(3, 2).asyncMap((s) => s.toList());

    bool equalLists(List<int> lA, List<int> lB) {
      for (var i = 0, len = lA.length; i < len; i++) {
        if (lA[i] != lB[i]) return false;
      }

      return true;
    }

    stream.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[count].length, result.length);
      expect(equalLists(expectedOutput[count], result), isTrue);
      count++;
    }, count: expectedOutput.length));
  });

  test('rx.Observable.windowCount.skip3', () async {
    const expectedOutput = [
      [1, 2, 3],
      [5, 6, 7]
    ];
    var count = 0;

    final stream = Observable.range(1, 8).windowCount(3, 4).asyncMap((s) => s.toList());

    bool equalLists(List<int> lA, List<int> lB) {
      for (var i = 0, len = lA.length; i < len; i++) {
        if (lA[i] != lB[i]) return false;
      }

      return true;
    }

    stream.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[count].length, result.length);
      expect(equalLists(expectedOutput[count], result), isTrue);
      count++;
    }, count: expectedOutput.length));
  });

  test('rx.Observable.windowCount.skip.asWindow', () async {
    const expectedOutput = [
      [1, 2],
      [2, 3],
      [3, 4]
    ];
    var count = 0;

    final stream = Observable.range(1, 4)
        .window(onCount(2, 1))
        .asyncMap((s) => s.toList());

    stream.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[count].length, result.length);
      expect(expectedOutput[count][0], result[0]);
      if (expectedOutput[count].length > 1)
        expect(expectedOutput[count][1], result[1]);
      count++;
    }, count: expectedOutput.length));
  });

  test('rx.Observable.windowCount.reusable', () async {
    final transformer = new WindowStreamTransformer<int>(onCount(2));
    const expectedOutput = [
      [1, 2],
      [3, 4]
    ];
    var countA = 0, countB = 0;

    final streamA = new Observable(new Stream.fromIterable(const [1, 2, 3, 4]))
        .transform(transformer)
        .asyncMap((s) => s.toList());

    streamA.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[countA][0], result[0]);
      expect(expectedOutput[countA][1], result[1]);
      countA++;
    }, count: expectedOutput.length));

    final streamB = new Observable(new Stream.fromIterable(const [1, 2, 3, 4]))
        .transform(transformer)
        .asyncMap((s) => s.toList());

    streamB.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[countB][0], result[0]);
      expect(expectedOutput[countB][1], result[1]);
      countB++;
    }, count: expectedOutput.length));
  });

  test('rx.Observable.windowCount.asBroadcastStream', () async {
    final stream = new Observable(new Stream.fromIterable(const [1, 2, 3, 4]))
        .windowCount(2)
        .asyncMap((s) => s.toList())
        .asBroadcastStream();

    // listen twice on same stream
    stream.listen(null);
    stream.listen(null);
    // code should reach here
    await expectLater(true, true);
  });

  test('rx.Observable.windowCount.asBroadcastStream.asWindow', () async {
    final stream = new Observable(new Stream.fromIterable(const [1, 2, 3, 4]))
        .window(onCount(2))
        .asyncMap((s) => s.toList())
        .asBroadcastStream();

    // listen twice on same stream
    stream.listen(null);
    stream.listen(null);
    // code should reach here
    await expectLater(true, true);
  });

  test('rx.Observable.windowCount.error.shouldThrowA', () async {
    final observableWithError =
        new Observable(new ErrorStream<int>(new Exception()))
            .windowCount(2)
            .asyncMap((s) => s.toList());

    observableWithError.listen(null,
        onError: expectAsync2((Exception e, StackTrace s) {
      expect(e, isException);
    }));
  });

  test('rx.Observable.windowCount.error.shouldThrowA.asWindow', () async {
    final observableWithError =
        new Observable(new ErrorStream<int>(new Exception()))
            .window(onCount(2))
            .asyncMap((s) => s.toList());

    observableWithError.listen(null,
        onError: expectAsync2((Exception e, StackTrace s) {
      expect(e, isException);
    }));
  });

  test('rx.Observable.windowCount.skip.shouldThrowB', () {
    new Observable.fromIterable(const [1, 2, 3, 4])
        .windowCount(null)
        .listen(null, onError: expectAsync2((ArgumentError e, StackTrace s) {
      expect(e, isArgumentError);
    }));
  });

  test('rx.Observable.windowCount.skip.shouldThrowB.asWindow', () {
    new Observable.fromIterable(const [1, 2, 3, 4])
        .window(onCount(null))
        .listen(null, onError: expectAsync2((ArgumentError e, StackTrace s) {
      expect(e, isArgumentError);
    }));
  });
}
