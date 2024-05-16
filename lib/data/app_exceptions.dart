class AppExceptions implements Exception {
  final String? _message;
  final String? _prefix;

  AppExceptions(this._message, this._prefix);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? message]) : super(message, "Invalid Request: ");
}

class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? message])
      : super(message, "Unauthorized Request: ");
}

class InvalidInputException extends AppExceptions {
  InvalidInputException([String? message])
      : super(message, "Unauthorized Input: ");
}
