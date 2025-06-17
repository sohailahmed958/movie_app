


abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);
}

class ServerFailure extends Failure {
  const ServerFailure(String message, [int? statusCode]) : super(message, statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message, [int? statusCode]) : super(message, statusCode);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(String message, [int? statusCode]) : super(message, statusCode);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(String message, [int? statusCode]) : super(message, statusCode);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(String message) : super(message);
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure(String message, [int? statusCode]) : super(message, statusCode);
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure(String message, [int? statusCode]) : super(message, statusCode);
}



/*
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);
}

class ServerFailure extends Failure {
  const ServerFailure(String message, [int? statusCode])
      : super(message, statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(String message) : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(String message) : super(message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(String message) : super(message);
}
*/