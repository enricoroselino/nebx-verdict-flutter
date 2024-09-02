import 'package:equatable/equatable.dart';

abstract interface class IIssue {
  String get message;

  IssueLayer get issueLayer;

  IssueType get issueType;

  int get statusCode;
}

class Issue extends Equatable implements IIssue {
  @override
  final String message;
  @override
  final IssueLayer issueLayer;
  @override
  final IssueType issueType;
  @override
  final int statusCode;

  Issue._(
    this.message,
    this.issueLayer,
    this.issueType, {
    this.statusCode = 0,
  }) {
    if (issueLayer == IssueLayer.app && statusCode != 0) {
      const message =
          "Invalid Issue: Application Issue can't have a status code";
      throw ArgumentError.value(message);
    }

    if (issueLayer == IssueLayer.request && statusCode <= 0) {
      const message = "Invalid Issue: Request Issue should have a status code";
      throw ArgumentError.value(message);
    }
  }

  factory Issue.none() => Issue._("", IssueLayer.none, IssueType.none);

  factory Issue.other(
    String error, {
    IssueLayer layer = IssueLayer.app,
    int statusCode = 0,
  }) =>
      Issue._(
        error,
        layer,
        IssueType.other,
        statusCode: statusCode,
      );

  factory Issue.parsing([String? objectName]) {
    final message = "Parsing ${(objectName ?? "data").trim()} failed";

    return Issue._(
      message,
      IssueLayer.app,
      IssueType.parsing,
    );
  }

  factory Issue.forbidden() {
    const forbidden = 403;

    return Issue._(
      "[$forbidden] Forbidden",
      IssueLayer.request,
      IssueType.forbidden,
      statusCode: forbidden,
    );
  }

  factory Issue.authorization() {
    const unauthorized = 401;

    return Issue._(
      "[$unauthorized] Unauthorized",
      IssueLayer.request,
      IssueType.authorization,
      statusCode: unauthorized,
    );
  }

  factory Issue.timeout([int? statusCode]) {
    const requestTimeout = 408;

    return Issue._(
      "[${statusCode ?? requestTimeout}] Timeout",
      IssueLayer.request,
      IssueType.timeout,
      statusCode: statusCode ?? requestTimeout,
    );
  }

  factory Issue.server() {
    const internalServerError = 500;

    return Issue._(
      "[$internalServerError] Server error",
      IssueLayer.request,
      IssueType.server,
      statusCode: internalServerError,
    );
  }

  factory Issue.badRequest([String? error]) {
    const badRequest = 400;
    const defaultMessage = "[$badRequest] Bad request";
    final message = (error ?? defaultMessage);

    return Issue._(
      message,
      IssueLayer.request,
      IssueType.badRequest,
      statusCode: badRequest,
    );
  }

  factory Issue.requestCancelled() {
    const clientClosedRequest = 499;

    return Issue._(
      "[$clientClosedRequest] Request cancelled",
      IssueLayer.request,
      IssueType.cancel,
      statusCode: clientClosedRequest,
    );
  }

  @override
  List<Object?> get props => [message, issueLayer, issueType, statusCode];
}

enum IssueType {
  cancel,
  parsing,
  authorization,
  forbidden,
  timeout,
  badRequest,
  server,
  other,
  none,
}

enum IssueLayer { request, app, none }
