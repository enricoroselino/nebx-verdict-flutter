import 'package:flutter_test/flutter_test.dart';
import 'package:nebx_verdict/issue.dart';

void main() {
  late IIssue sut;

  group("Application Issue", () {
    setUp(() {
      sut = Issue.other("", layer: IssueLayer.app, statusCode: 0);
    });

    test("can't have a status code", () {
      expect(sut.issueLayer, IssueLayer.app);
      expect(sut.statusCode == 0,  true);
    });
  });

  group("Request Issue", () {
    setUp(() {
      sut = Issue.other("", layer: IssueLayer.request, statusCode: 418);
    });

    test("should have status code", () {
      expect(sut.statusCode > 0, true);
      expect(sut.issueLayer, IssueLayer.request);
    });
  });
}