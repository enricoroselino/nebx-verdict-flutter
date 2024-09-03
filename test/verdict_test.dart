import 'package:flutter_test/flutter_test.dart';
import 'package:nebx_verdict/nebx_verdict.dart';

class VerdictTestData {}

void main() {
  late IVerdict<VerdictTestData> sut;

  final applicationIssues = [
    Issue.parsing(),
    Issue.other(""),
  ];

  final requestIssues = [
    Issue.authorization(),
    Issue.badRequest(),
    Issue.forbidden(),
    Issue.requestCancelled(),
    Issue.server(),
    Issue.timeout(),
    Issue.other("", layer: IssueLayer.request, statusCode: 418),
  ];

  final issues = [...requestIssues, ...applicationIssues];

  group("Verdict Success", () {
    setUp(() {
      final data = VerdictTestData();
      sut = Verdict.successful(data);
    });

    test("shouldn't have issues", () {
      final none = Issue.none();
      expect(issues.contains(sut.issue), false);
      expect(sut.issue == none, true);
      expect(sut.issue.issueLayer, none.issueLayer);
      expect(sut.issue.issueType, none.issueType);
      expect(sut.issue.statusCode, 0);
    });

    test("Verdict is success", () {
      expect(sut.isSuccess, true);
      expect(sut.isFailure, false);
    });

    test("Returned data type should match if supplied", () {
      expect(sut.data.runtimeType, VerdictTestData);
      expect(sut.data != null, true);
    });
  });

  group("Verdict Failed", () {
    final List<IVerdict> applicationVerdict =
        applicationIssues.map((i) => Verdict.failed(i)).toList();
    final List<IVerdict> requestVerdict =
        requestIssues.map((i) => Verdict.failed(i)).toList();

    final failedVerdict = [...applicationVerdict, ...requestVerdict];

    test("Verdict is failed", () {
      for (var i in failedVerdict) {
        expect(i.isSuccess, false);
        expect(i.isFailure, true);
      }
    });

    test("Data Value must be null", () {
      for (var i in failedVerdict) {
        expect(i.data.runtimeType, Null);
        expect(i.data == null, true);
      }
    });

    test("Failed application verdict shouldn't have status code", () {
      for (var i in applicationVerdict) {
        expect(i.issue.statusCode == 0, true);
      }
    });

    test("Failed request verdict should have status code", () {
      for (var i in requestVerdict) {
        expect(i.issue.statusCode != 0, true);
      }
    });

    test("Application issues should have application layer", () {
      for (var i in applicationVerdict) {
        expect(i.issue.issueLayer == IssueLayer.app, true);
      }
    });

    test("Request issues should have request layer", () {
      for (var i in requestVerdict) {
        expect(i.issue.issueLayer == IssueLayer.request, true);
      }
    });
  });
}
