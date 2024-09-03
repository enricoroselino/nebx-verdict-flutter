import 'package:flutter_test/flutter_test.dart';
import 'package:nebx_verdict/nebx_verdict.dart';

void main() {
  final applicationIssues = [
    Issue.parsing(),
    Issue.other(""),
  ];

  group("Application Issue", () {
    test("should have application layer", () {
      for (var i in applicationIssues) {
        expect(i.issueLayer, IssueLayer.app);
      }
    });

    test("can't have a status code", () {
      for (var i in applicationIssues) {
        expect(i.statusCode, 0);
      }
    });

    test("throw exception if application issue have a status code", () {
      expect(
          () => Issue.other(
                "",
                layer: IssueLayer.app,
                statusCode: 400,
              ),
          throwsArgumentError);
    });

    test("throw exception if request issue doesn't have status code", () {
      expect(() => Issue.other("", layer: IssueLayer.request, statusCode: -60),
          throwsArgumentError);

      expect(() => Issue.other("", layer: IssueLayer.request, statusCode: 0),
          throwsArgumentError);
    });
  });
}
