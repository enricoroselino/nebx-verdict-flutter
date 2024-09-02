import 'package:flutter_test/flutter_test.dart';
import 'package:nebx_verdict/nebx_verdict.dart';

class SomeClass {}

void main() {
  late IVerdict<SomeClass> sut;
  final data = SomeClass();

  group('Verdict successful', () {
    setUp(() {
      sut = Verdict<SomeClass>.successful(data);
    });

    test("Verdict.isSuccess should return true", () {
      expect(sut.isSuccess, true);
    });

    test("Verdict.isFailure should return false", () {
      expect(sut.isFailure, false);
    });

    test("Verdict.data should return same type", () {
      expect(sut.data.runtimeType, SomeClass);
    });

    test("Verdict.issue should be Issue.none()", () {
      final none = Issue.none();

      expect(sut.issue, none);
      expect(sut.issue.issueLayer, none.issueLayer);
      expect(sut.issue.issueType, none.issueType);
      expect(sut.issue.statusCode, none.statusCode);
      expect(sut.issue.message, none.message);
    });
  });

  group("Verdict failed", () {
    setUp(() {
      sut = Verdict<SomeClass>.failed(Issue.server());
    });

    test("Verdict.isSuccess should return false", () {
      expect(sut.isSuccess, false);
    });

    test("Verdict.isFailure should return true", () {
      expect(sut.isFailure, true);
    });

    test("Verdict.data should return null", () {
      expect(sut.data.runtimeType, Null);
    });
  });
}